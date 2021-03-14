----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/12/2021 05:03:30 PM
-- Design Name: 
-- Module Name: ft_wrapper - arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.math_pkg."log2c";

entity ft_wrapper is
    generic (
        SIZE : positive := 128; -- default 128
        C_S_AXI_DATA_WIDTH : positive := 64
    );
    port ( 
        clk : in std_logic;
        reset : in std_logic;
        
        -- streaming sink (input)
        stin_data : in std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
        stin_valid : in std_logic;
        stin_ready : out std_logic;
        
        -- streaming source (ouput)
        stout_data : out std_logic_vector(C_S_AXI_DATA_WIDTH -1 downto 0);
        stout_valid : out std_logic;
        stout_ready : in std_logic        
    );
end ft_wrapper;

architecture arch of ft_wrapper is

    -- constant declaration
    constant NFFT : integer := log2c(SIZE);
    constant FLY_FWD : std_logic := '1'; -- use forward butterflies
    constant FORMAT : integer := 1; -- unscaled
    constant RNDMODE : integer := 0; -- Rounding (FORMAT should be = 1)
    constant XSERIES : string:="NEW"; -- UltraScale architecture
    constant USE_MLT : boolean:=FALSE; -- Use Multiplier for calculation M_PI in Twiddle factor 
    constant DATA_WIDTH : positive := 31;
    constant FFT_DATA_WIDTH : positive := 18;
    constant FFT_OUT_WIDTH : positive := (FFT_DATA_WIDTH+FORMAT*NFFT);
    constant zeros : std_logic_vector(FFT_DATA_WIDTH-1 downto 0) := (others => '0');
    
    -- signal declaration
    -- intFFTk signals
    signal in_data                  : std_logic_vector(FFT_DATA_WIDTH-1 downto 0);
    signal in_valid                 : std_logic;
    
    signal out_real                 : std_logic_vector(FFT_OUT_WIDTH-1 downto 0);
    signal out_imag                 : std_logic_vector(FFT_OUT_WIDTH-1 downto 0);
    signal s_out_valid              : std_logic;
            
    signal index                    : natural range 0 to SIZE := 0;
    signal index_next               : natural range 0 to SIZE := 0;
    
    signal receive_index            : natural range 0 to SIZE := 0;
    signal receive_index_next       : natural range 0 to SIZE := 0;
    
    signal fifo_i_index             : natural range 0 to SIZE := 0;
    signal fifo_i_index_next        : natural range 0 to SIZE := 0;
    
    signal flush_index             : natural range 0 to SIZE := 0;
    signal flush_index_next        : natural range 0 to SIZE := 0;
    
    signal fifo_o_index             : natural range 0 to SIZE := 0;
    signal fifo_o_index_next        : natural range 0 to SIZE := 0;
    
    -- signals for float_to_fixed18
    signal float2fixed_in_tvalid    : std_logic := '0'; -- payload is valid
    signal float2fixed_in_tdata     : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tvalid   : std_logic := '0';
    signal float2fixed_out_tdata    : std_logic_vector(23 downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tuser    : std_logic_vector(0 downto 0) := (others => '0'); -- exceptions and user-defined payload
        
    -- signals for fixed25_to_float
    -- for real output
    signal real_fixed2float_in_tvalid     : std_logic := '0'; -- payload is valid
    signal real_fixed2float_in_tdata      : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    signal real_fixed2float_out_tvalid    : std_logic := '0';
    signal real_fixed2float_out_tdata     : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    -- for imaginary output
    signal imag_fixed2float_in_tvalid     : std_logic := '0'; -- payload is valid
    signal imag_fixed2float_in_tdata      : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    signal imag_fixed2float_out_tvalid    : std_logic := '0';
    signal imag_fixed2float_out_tdata     : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    
    signal temp_real_float : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
    signal temp_imag_float : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');    
        
    -- signals for input FIFO
    signal wr_rst_busy_i : std_logic; -- not used
    signal rd_rst_busy_i : std_logic; -- not used
    signal wr_en_i       : std_logic; -- write enable
    signal rd_en_i       : std_logic; -- read enable
    signal full_i        : std_logic; -- FIFO full
    signal empty_i       : std_logic; -- FIFO empty
    signal fifo_in_i     : std_logic_vector(17 DOWNTO 0); -- FIFO input data
    signal fifo_out_i    : std_logic_vector(17 DOWNTO 0); -- FIFO output data
    
    -- signals for output FIFO
    signal wr_rst_busy_o : std_logic; -- not used
    signal rd_rst_busy_o : std_logic; -- not used
    signal wr_en_o       : std_logic; -- write enable
    signal rd_en_o       : std_logic; -- read enable
    signal full_o        : std_logic; -- FIFO full
    signal empty_o       : std_logic; -- FIFO empty
    signal fifo_in_o     : std_logic_vector(63 DOWNTO 0); -- FIFO input data
                    
    -- type declaration
    type state_type is (
        TRANSFER_TO_FFT,
        OUTPUT_DATA
    );
    signal state, state_next : state_type := TRANSFER_TO_FFT;
        
    type input_state_type is (
        INPUT_INIT,
        INPUT_IDLE,
        CONVERT,
        SEND,
        FLUSH
    );
    signal input_state, input_state_next : input_state_type := INPUT_INIT;
    
    type output_state_type is (
        OUTPUT_IDLE,
        OUTPUT_START,
        STORE,
        OUTPUT_DATA
    );
    signal output_state, output_state_next : output_state_type := OUTPUT_IDLE;
    
    -- component for float_to_fixed18 converter
    component intfftk_float_to_fixed18_0 is
        port (
            -- Global signals
            aclk : IN STD_LOGIC;
            -- AXI4-Stream slave channel for operand A
            s_axis_a_tvalid : in std_logic;
            s_axis_a_tdata : in std_logic_vector(DATA_WIDTH downto 0);
            -- AXI4-Stream master channel for output result
            m_axis_result_tvalid : out std_logic;
            m_axis_result_tdata : out std_logic_vector(23 downto 0);
            m_axis_result_tuser :out std_logic_vector(0 downto 0)
        );
    end component intfftk_float_to_fixed18_0;
    
    --component for fixed25_to_float converter
    component intfftk_fixed25_to_float_0 is
        port (
            -- Global signals
            aclk : IN STD_LOGIC;
            -- AXI4-Stream slave channel for operand A
            s_axis_a_tvalid : in std_logic;
            s_axis_a_tdata : in std_logic_vector(DATA_WIDTH downto 0);
            -- AXI4-Stream master channel for output result
            m_axis_result_tvalid : out std_logic;
            m_axis_result_tdata : out std_logic_vector(DATA_WIDTH downto 0)
      );
    end component intfftk_fixed25_to_float_0;
  
    -- component for input FIFO (delay line)
    component intfftk_fifo_in_0
        port (
            clk : in std_logic;
            srst : in std_logic;
            din : in std_logic_vector(17 DOWNTO 0);
            wr_en : in std_logic;
            rd_en : in std_logic;
            dout : out std_logic_vector(17 DOWNTO 0);
            full : out std_logic;
            empty : out std_logic;
            wr_rst_busy : out std_logic;
            rd_rst_busy : out std_logic
        );
    end component intfftk_fifo_in_0;
        
    -- component for output FIFO (delay line)
    component intfftk_fifo_out_0
        port (
            clk : in std_logic;
            srst : in std_logic;
            din : in std_logic_vector(63 DOWNTO 0);
            wr_en : in std_logic;
            rd_en : in std_logic;
            dout : out std_logic_vector(63 DOWNTO 0);
            full : out std_logic;
            empty : out std_logic;
            wr_rst_busy : out std_logic;
            rd_rst_busy : out std_logic
        );
    end component intfftk_fifo_out_0;
    
    -- component for intFFTk IP core
    component int_fft_single_path is
        generic (
                NFFT           : integer:=7;         --! Number of FFT stages
                DATA_WIDTH     : integer:=18;        --! Data input width (8-32)
                TWDL_WIDTH     : integer:=18;        --! Data width for twiddle factor
                -- RAMB_TYPE      : string:="CONT";     --! Data stream mode: "CONT" - continuous, "WRAP" - bursting
                -- MODE           : string:="UNSCALED"; --! Unscaled, Rounding, Truncate
                FORMAT         : integer:=1;         --! 1 - Uscaled, 0 - Scaled
                RNDMODE        : integer:=0;         --! 0 - Truncate, 1 - Rounding (FORMAT should be = 1)
                XSERIES        : string:="NEW";      --! FPGA family: for 6/7 series: "OLD"; for ULTRASCALE: "NEW"
                USE_MLT        : boolean:=FALSE      --! Use Multiplier for calculation M_PI in Twiddle factor
        );
        port (
            ---- Common ----
            RESET          : in  std_logic;    --! Global reset
            CLK            : in  std_logic;    --! DSP clock
            ---- Butterflies ----
            FLY_FWD        : in  std_logic;    --! Forward: '1' - use BFLY, '0' -don't use
            ---- Input data ----
            DI_RE          : in  std_logic_vector(DATA_WIDTH-1 downto 0); --! Re data input
            DI_IM          : in  std_logic_vector(DATA_WIDTH-1 downto 0); --! Im data input
            DI_EN          : in  std_logic; --! Data enable
            ---- Output data ----
            DO_RE          : out std_logic_vector(DATA_WIDTH+FORMAT*NFFT-1 downto 0); --! Output data Even
            DO_IM          : out std_logic_vector(DATA_WIDTH+FORMAT*NFFT-1 downto 0); --! Output data Odd
            DO_VL          : out std_logic    --! Output valid data
        );
    end component int_fft_single_path;
    
begin

    -- implement float_to_fixed18 unit
    float_to_fixed18_inst : component intfftk_float_to_fixed18_0
    port map (
        -- Global signals
        aclk => clk,
        -- AXI4-Stream slave channel for operand A
        s_axis_a_tvalid => float2fixed_in_tvalid,
        s_axis_a_tdata => float2fixed_in_tdata,
        -- AXI4-Stream master channel for output result
        m_axis_result_tvalid => float2fixed_out_tvalid,
        m_axis_result_tdata => float2fixed_out_tdata,
        m_axis_result_tuser => float2fixed_out_tuser
    );
    
    -- implement fixed25_to_float unit for real output
    fixed25_to_float_inst_real : component intfftk_fixed25_to_float_0
    port map (
        -- Global signals
        aclk => clk,
        -- AXI4-Stream slave channel for operand A
        s_axis_a_tvalid => real_fixed2float_in_tvalid,
        s_axis_a_tdata => real_fixed2float_in_tdata,
        -- AXI4-Stream master channel for output result
        m_axis_result_tvalid => real_fixed2float_out_tvalid,
        m_axis_result_tdata => real_fixed2float_out_tdata
    );
    
    -- implement fixed25_to_float unit for imaginary output
    fixed25_to_float_inst_imag : component intfftk_fixed25_to_float_0
    port map (
        -- Global signals
        aclk => clk,
        -- AXI4-Stream slave channel for operand A
        s_axis_a_tvalid => imag_fixed2float_in_tvalid,
        s_axis_a_tdata => imag_fixed2float_in_tdata,
        -- AXI4-Stream master channel for output result
        m_axis_result_tvalid => imag_fixed2float_out_tvalid,
        m_axis_result_tdata => imag_fixed2float_out_tdata
    );
    
    -- implement FIFO for input (delay line)
    fifo_in_inst : intfftk_fifo_in_0
    port map (
        clk => clk,
        srst => reset,
        din => fifo_in_i,
        wr_en => wr_en_i,
        rd_en => rd_en_i,
        dout => fifo_out_i,
        full => full_i,
        empty => empty_i,
        wr_rst_busy => wr_rst_busy_i,
        rd_rst_busy => rd_rst_busy_i
    );
    
    -- implement FIFO for output (delay line)
    fifo_out_inst : intfftk_fifo_out_0
    port map (
        clk => clk,
        srst => reset,
        din => fifo_in_o,
        wr_en => wr_en_o,
        rd_en => rd_en_o,
        dout => stout_data,
        full => full_o,
        empty => empty_o,
        wr_rst_busy => wr_rst_busy_o,
        rd_rst_busy => rd_rst_busy_o
    );
      
    -- implement intFFTk unit
    fft_inst : int_fft_single_path
    generic map (
        NFFT           => NFFT,
        DATA_WIDTH     => FFT_DATA_WIDTH,
        TWDL_WIDTH     => FFT_DATA_WIDTH,
        FORMAT         => FORMAT,
        RNDMODE        => RNDMODE,
        XSERIES        => XSERIES,
        USE_MLT        => USE_MLT
    )
    port map (
        ---- Common ----
        RESET          => reset,
        CLK            => clk,
        ---- Butterflies ----
        FLY_FWD        => FLY_FWD,
        ---- Input data ----
        DI_RE          => in_data,
        DI_IM          => zeros,
        DI_EN          => in_valid,
        ---- Output data ----
        DO_RE          => out_real,
        DO_IM          => out_imag,
        DO_VL          => s_out_valid
    );
        
    -----------------------------------------------------------------------
    
    --syncronous process
    sync_state_proc: process (reset, clk)
    begin
        if reset = '1' then --Reset signals
            state <= TRANSFER_TO_FFT;
            input_state <= INPUT_INIT;
            output_state <= OUTPUT_IDLE;
            index <= 0;
            receive_index <= 0;
            fifo_i_index <= 0;
            flush_index <= 0;
            fifo_o_index <= 0;
            
        elsif rising_edge(clk) then
            state <= state_next;
            input_state <= input_state_next;
            output_state <= output_state_next;
            index <= index_next;
            receive_index <= receive_index_next;
            fifo_i_index <= fifo_i_index_next;
            flush_index <= flush_index_next;
            fifo_o_index <= fifo_o_index_next;
        end if;
        
    end process sync_state_proc;
    
    -----------------------------------------------------------------------
      
    --signal is set outside the process due to delay    
--    fifo_in_i <= float2fixed_out_tdata(FFT_DATA_WIDTH-1 downto 0) when float2fixed_out_tvalid = '1'; -- set FIFO input data
--    wr_en_i <= float2fixed_out_tvalid; -- set FIFO write enable
    
    --set intFFTk input
    in_data <= fifo_out_i when index < SIZE else (others => '0');
        
    --process to feed the intFFTk
    input_proc: process (input_state, index, fifo_i_index, flush_index, state, empty_i, stin_valid, stin_data, float2fixed_out_tvalid, float2fixed_out_tdata)
    begin
        --default values to prevent latches
        input_state_next <= input_state;
        index_next <= index;
        fifo_i_index_next <= fifo_i_index;
        flush_index_next <= flush_index;
        stin_ready <= '0';
        float2fixed_in_tvalid <= '0';
        wr_en_i <= '0';
        rd_en_i <= '0';
        in_valid <= '0'; 
        fifo_in_i <= (others => '0');
        
        float2fixed_in_tdata <= (others => '0');
        
        case input_state is
        
            when INPUT_INIT =>
                if index = SIZE then
                    index_next <= 0; --reset counter
                    input_state_next <= INPUT_IDLE;
                
                elsif (state = TRANSFER_TO_FFT) then --check if intFFTk is ready for initialisation
                    --flush input data (send zeros to get results)
                    --set data input valid
                    in_valid <= '1'; 
                    
                    --increase index
                    index_next <= index + 1;
               end if;
            
            when INPUT_IDLE =>
                if (state = TRANSFER_TO_FFT) and (empty_i = '1') then --forward back pressure
                    stin_ready <= '1';
                    input_state_next <= CONVERT;
                end if;
                
            when CONVERT =>
                stin_ready <= '1';
                
                if (fifo_i_index = SIZE-1) and (float2fixed_out_tvalid = '1') then  -- all input values are stored in the FIFO and intFFTk is ready to process data
                    fifo_i_index_next <= 0; --reset counter
                    
                    fifo_in_i <= float2fixed_out_tdata(FFT_DATA_WIDTH-1 downto 0); -- set last FIFO input data
                    wr_en_i <= '1'; -- set FIFO write enable
                    
                    -- read FIFO data
                    rd_en_i <= '1';
                    
                    input_state_next <= SEND;
                    
                elsif (state = TRANSFER_TO_FFT) and (stin_valid = '1') and (float2fixed_out_tvalid = '1') then
                    --convert input data
                    float2fixed_in_tdata <= stin_data(DATA_WIDTH downto 0); --convert float to fixed18
                    float2fixed_in_tvalid <= '1';   
                    
                    fifo_in_i <= float2fixed_out_tdata(FFT_DATA_WIDTH-1 downto 0); -- set last FIFO input data
                    wr_en_i <= '1'; -- set FIFO write enable
                    
                    --increase index
                    fifo_i_index_next <= fifo_i_index + 1;
                    
                elsif (state = TRANSFER_TO_FFT) and (stin_valid = '1') and (empty_i = '1') then
                    --convert first input data
                    float2fixed_in_tdata <= stin_data(DATA_WIDTH downto 0); --convert float to fixed18
                    float2fixed_in_tvalid <= '1';                                
                end if;
            
            when SEND => 
                if index = SIZE then --independent of valid signals
                    input_state_next <= FLUSH;
                    
                elsif (index = SIZE-1) and (state = TRANSFER_TO_FFT) then
                    --set data input valid
                    in_valid <= '1'; 
                    
                    --increase index
                    index_next <= index + 1;
                    
                elsif (state = TRANSFER_TO_FFT) then --check if intFFTk is ready to process data
                    --set data input valid
                    in_valid <= '1'; 
                    
                    -- read FIFO data
                    rd_en_i <= '1';
                                          
                    --increase index
                    index_next <= index + 1;
                end if;
                
            when FLUSH => 
                if flush_index = SIZE then
                    index_next <= 0; --reset counter
                    flush_index_next <= 0; --reset counter
                    input_state_next <= INPUT_IDLE;
                
                elsif (state = TRANSFER_TO_FFT) then --check if intFFTk is ready to process data
                    --flush input data (send zeros to get results)
                    --set data input valid
                    in_valid <= '1'; 
                    
                    --increase index
                    flush_index_next <= flush_index + 1;
               end if;
               
            when others =>
                input_state_next <= INPUT_IDLE; 
        end case;
    
    end process input_proc;   

    -----------------------------------------------------------------------
        
    --process to feed the intFFTk
    fft_proc: process (state, flush_index, receive_index)
    begin
        --default values to prevent latches
        state_next <= state;
        
        case state is
        
            when TRANSFER_TO_FFT =>
                if flush_index = SIZE then
                    state_next <= OUTPUT_DATA;
               end if;
               
            when OUTPUT_DATA =>
                if receive_index = SIZE then                    
                    state_next <= TRANSFER_TO_FFT;
                end if;
                
            when others =>
                state_next <= TRANSFER_TO_FFT;
        end case;
                
    end process fft_proc;
    
    
    -----------------------------------------------------------------------
        
    --signal is set outside the process due to delay
    --temporary save float values
    temp_real_float <= real_fixed2float_out_tdata when real_fixed2float_out_tvalid = '1' else (others => '0');
    temp_imag_float <= imag_fixed2float_out_tdata when imag_fixed2float_out_tvalid = '1' else (others => '0');
    
    --process to get output of the intFFTk
    output_proc: process (output_state, fifo_o_index, receive_index, state, s_out_valid, out_real, out_imag, temp_real_float, temp_imag_float, stout_ready)
    begin
        --default values to prevent latches
        output_state_next <= output_state;
        fifo_o_index_next <= fifo_o_index;
        receive_index_next <= receive_index;
        stout_valid <= '0';
        real_fixed2float_in_tvalid <= '0';
        imag_fixed2float_in_tvalid <= '0';
        wr_en_o <= '0';
        rd_en_o <= '0';
        
        real_fixed2float_in_tdata <= (others => '0');
        imag_fixed2float_in_tdata <= (others => '0');
        fifo_in_o <= (others => '0');
        
        case output_state is
                
            when OUTPUT_IDLE =>
            
                if fifo_o_index = SIZE-6 then --does not need full SIZE as output starts earlier
                    fifo_o_index_next <= 0; --reset counter
                    output_state_next <= OUTPUT_START;
                
                elsif (state = OUTPUT_DATA) and (s_out_valid = '1') then --check if the output data of the intFFTk is valid
                    --flush output data (ignore results)
                                        
                    --increase index
                    fifo_o_index_next <= fifo_o_index + 1;
               end if;
               
            when OUTPUT_START =>
                            
                if (state = OUTPUT_DATA) and (s_out_valid = '1') then --check if the output data of the intFFTk is valid
                    -------------------------
                    -- Convert output data --
                    -------------------------
                
                    --convert first output data
                    --real part
                    real_fixed2float_in_tdata(FFT_OUT_WIDTH-1 downto 0) <= out_real; --convert fixed25 to float
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(FFT_OUT_WIDTH-1 downto 0) <= out_imag; --convert fixed25 to float
                    imag_fixed2float_in_tvalid <= '1';
                    
                    --increase index
                    fifo_o_index_next <= fifo_o_index + 1; 
                                        
                    output_state_next <= STORE;
                end if;               
            
            when STORE =>
            
                if (fifo_o_index = SIZE) then -- all input values are stored in the FIFO and master is ready to read data                    
                    -------------------
                    -- Store in FIFO --
                    -------------------
                    
                    --write last data to FIFO
                    fifo_in_o <= temp_imag_float & temp_real_float;
                                   
                    wr_en_o <= '1';
                    
                    fifo_o_index_next <= 0; --reset counter
                                            
                    -- read FIFO data
                    rd_en_o <= '1';
                    
                    output_state_next <= OUTPUT_DATA;
                    
                elsif (state = OUTPUT_DATA) and (s_out_valid = '1') then --check if the output data of the intFFTk is valid
                    -------------------
                    -- Store in FIFO --
                    -------------------
                    
                    --write data to FIFO
                    fifo_in_o <= temp_imag_float & temp_real_float;
                    
                    wr_en_o <= '1';
                    
                    -------------------------
                    -- Convert output data --
                    -------------------------
                    
                    --convert next output data
                    --real part
                    real_fixed2float_in_tdata(FFT_OUT_WIDTH-1 downto 0) <= out_real; --convert fixed25 to float
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(FFT_OUT_WIDTH-1 downto 0) <= out_imag; --convert fixed25 to float
                    imag_fixed2float_in_tvalid <= '1';
                                   
                    --increase index
                    fifo_o_index_next <= fifo_o_index + 1;            
                end if;              
                        
            when OUTPUT_DATA =>
        
                if (receive_index = SIZE) then --independent of valid signals
                    receive_index_next <= 0; --reset counter
                    output_state_next <= OUTPUT_IDLE;
                    
                elsif (state = OUTPUT_DATA) and (stout_ready = '1') then --check if the master is ready to read
                    --set data outputs
                    stout_valid <= '1';
                    
                    -- read FIFO data
                    rd_en_o <= '1';
                                   
                    --increase index
                    receive_index_next <= receive_index + 1;            
                end if;            
               
            when others =>
                output_state_next <= OUTPUT_IDLE;
        end case;
    
    end process output_proc;
    
end arch;
