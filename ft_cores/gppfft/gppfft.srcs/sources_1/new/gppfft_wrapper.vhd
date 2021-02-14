----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2021 08:22:58 PM
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

entity ft_wrapper is
    generic (
        --SIZE : positive := 128; -- default 128
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
    constant SIZE : positive := 128;
    constant DATA_WIDTH : positive := 31;
    constant DFT_DATA_WIDTH : positive := 26;
    constant DFT_OUT_WIDTH : positive := 30;
    constant zeros : std_logic_vector(DFT_DATA_WIDTH-1 downto 0) := (others => '0');
    
    -- signal declaration
    -- GPP-FFT signals
    signal clk_en                   : std_logic;
    signal fft_in                   : std_logic_vector(2*DFT_DATA_WIDTH-1 downto 0);
    
    signal fft_out                  : std_logic_vector(2*DFT_OUT_WIDTH-1 downto 0);
    signal first_out                : std_logic;
    
    signal index                    : natural range 0 to SIZE := 0;
    signal index_next               : natural range 0 to SIZE := 0;
    
    signal receive_index            : natural range 0 to SIZE := 0;
    signal receive_index_next       : natural range 0 to SIZE := 0;
    
    --signal fifo_i_index             : natural range 0 to SIZE := 0;
    --signal fifo_i_index_next        : natural range 0 to SIZE := 0;
    
    --signal fifo_o_index             : natural range 0 to SIZE := 0;
    --signal fifo_o_index_next        : natural range 0 to SIZE := 0;
    
    -- signals for float_to_fixed18
    signal float2fixed_in_tvalid    : std_logic := '0'; -- payload is valid
    signal float2fixed_in_tdata     : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tvalid   : std_logic := '0';
    signal float2fixed_out_tdata    : std_logic_vector(DATA_WIDTH downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tuser    : std_logic_vector(0 downto 0) := (others => '0'); -- exceptions and user-defined payload
        
    -- signals for fixed18_to_float
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
--    signal wr_rst_busy_i : std_logic; -- not used
--    signal rd_rst_busy_i : std_logic; -- not used
--    signal wr_en_i       : std_logic; -- write enable
--    signal rd_en_i       : std_logic; -- read enable
--    signal full_i        : std_logic; -- FIFO full
--    signal empty_i       : std_logic; -- FIFO empty
--    signal fifo_in_i     : std_logic_vector(17 DOWNTO 0); -- FIFO input data
--    signal fifo_out_i    : std_logic_vector(17 DOWNTO 0); -- FIFO output data
    
    -- signals for output FIFO
--    signal wr_rst_busy_o : std_logic; -- not used
--    signal rd_rst_busy_o : std_logic; -- not used
--    signal wr_en_o       : std_logic; -- write enable
--    signal rd_en_o       : std_logic; -- read enable
--    signal full_o        : std_logic; -- FIFO full
--    signal empty_o       : std_logic; -- FIFO empty
--    signal fifo_in_o     : std_logic_vector(63 DOWNTO 0); -- FIFO input data
    
    -- range declaration for IEEE 754 single presicion format
    constant SIGN_BIT : natural := 31;
    constant EXPONENT_UPPER_BOUND : natural := 30;
    constant EXPONENT_LOWER_BOUND : natural := 23;
    constant MANTISSA_UPPER_BOUND : natural := 22;
    constant MANTISSA_LOWER_BOUND : natural := 0;
    
    subtype exponent_range is std_logic_vector(EXPONENT_UPPER_BOUND downto EXPONENT_LOWER_BOUND);
    subtype mantissa_range is std_logic_vector(MANTISSA_UPPER_BOUND downto MANTISSA_LOWER_BOUND);
    
    --range declaration for stout_data
    constant STOUT_SIGN_BIT_REAL : natural := C_S_AXI_DATA_WIDTH / 2 - 1;
    constant STOUT_SIGN_BIT_IMAG : natural := C_S_AXI_DATA_WIDTH - 1;
    
    --real range
    subtype stout_exponent_real_range is std_logic_vector(C_S_AXI_DATA_WIDTH / 2 - 2 downto C_S_AXI_DATA_WIDTH / 2 - 9);
    subtype stout_mantissa_real_range is std_logic_vector(C_S_AXI_DATA_WIDTH / 2 - 10 downto 0);
    --imag range
    subtype stout_exponent_imag_range is std_logic_vector(C_S_AXI_DATA_WIDTH - 2 downto C_S_AXI_DATA_WIDTH - 9);
    subtype stout_mantissa_imag_range is std_logic_vector(C_S_AXI_DATA_WIDTH - 10 downto C_S_AXI_DATA_WIDTH / 2);
                
    -- type declaration
    type state_type is (
        TRANSFER_TO_FFT,
        OUTPUT_DATA
    );
    signal state, state_next : state_type := TRANSFER_TO_FFT;
        
    type input_state_type is (
        INPUT_IDLE,
        INPUT_SEND
    );
    signal input_state, input_state_next : input_state_type := INPUT_IDLE;
    
    type output_state_type is (
        OUTPUT_IDLE,
        STORE,
        OUTPUT_DATA
    );
    signal output_state, output_state_next : output_state_type := OUTPUT_IDLE;
    
    -- component for float_to_fixed18 converter
    component float_to_fixed18_0 is
        port (
            -- Global signals
            aclk : IN STD_LOGIC;
            -- AXI4-Stream slave channel for operand A
            s_axis_a_tvalid : in std_logic;
            s_axis_a_tdata : in std_logic_vector(DATA_WIDTH downto 0);
            -- AXI4-Stream master channel for output result
            m_axis_result_tvalid : out std_logic;
            m_axis_result_tdata : out std_logic_vector(DATA_WIDTH downto 0);
            m_axis_result_tuser :out std_logic_vector(0 downto 0)
        );
    end component float_to_fixed18_0;
    
    --component for fixed18_to_float converter
    component fixed18_to_float_0 is
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
    end component fixed18_to_float_0;
  
    -- component for input FIFO (delay line)
--    component fifo_in_0
--    port (
--        clk : in std_logic;
--        srst : in std_logic;
--        din : in std_logic_vector(17 DOWNTO 0);
--        wr_en : in std_logic;
--        rd_en : in std_logic;
--        dout : out std_logic_vector(17 DOWNTO 0);
--        full : out std_logic;
--        empty : out std_logic;
--        wr_rst_busy : out std_logic;
--        rd_rst_busy : out std_logic
--    );
--    end component fifo_in_0;
        
    -- component for output FIFO (delay line)
--    component fifo_out_0
--    port (
--        clk : in std_logic;
--        srst : in std_logic;
--        din : in std_logic_vector(63 DOWNTO 0);
--        wr_en : in std_logic;
--        rd_en : in std_logic;
--        dout : out std_logic_vector(63 DOWNTO 0);
--        full : out std_logic;
--        empty : out std_logic;
--        wr_rst_busy : out std_logic;
--        rd_rst_busy : out std_logic
--    );
--    end component fifo_out_0;
    
    -- component for GPP-FFT IP core
    component fftmain is
        port (
            i_clk : in std_logic;   -- clock
            i_reset : in std_logic; -- syncronous clear (reset)
            i_ce : in std_logic;    -- clock enable
            i_sample : in std_logic_vector(2*DFT_DATA_WIDTH-1 downto 0);    -- data input, [real, imaginary]
            o_result : out std_logic_vector(2*DFT_OUT_WIDTH-1 downto 0);   -- data output, [real, imaginary]
            o_sync : out std_logic -- first data out
        );
    end component fftmain;

begin

    -- implement float_to_fixed18 unit
    float_to_fixed18_inst : component float_to_fixed18_0
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
    
    -- implement fixed18_to_float unit for real output
    fixed18_to_float_inst_real : component fixed18_to_float_0
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
    
    -- implement fixed18_to_float unit for imaginary output
    fixed18_to_float_inst_imag : component fixed18_to_float_0
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
--    fifo_in_inst : fifo_in_0
--    port map (
--        clk => clk,
--        srst => reset,
--        din => fifo_in_i,
--        wr_en => wr_en_i,
--        rd_en => rd_en_i,
--        dout => fifo_out_i,
--        full => full_i,
--        empty => empty_i,
--        wr_rst_busy => wr_rst_busy_i,
--        rd_rst_busy => rd_rst_busy_i
--    );
    
    -- implement FIFO for output (delay line)
--    fifo_out_inst : fifo_out_0
--    port map (
--        clk => clk,
--        srst => reset,
--        din => fifo_in_o,
--        wr_en => wr_en_o,
--        rd_en => rd_en_o,
--        dout => stout_data,
--        full => full_o,
--        empty => empty_o,
--        wr_rst_busy => wr_rst_busy_o,
--        rd_rst_busy => rd_rst_busy_o
--    );
      
    -- implement GPP-FFT unit
    gppfft_inst : component fftmain
    port map (
        i_clk       => clk,
        i_reset     => reset,
        i_ce        => clk_en,
        i_sample    => fft_in, 
        o_result    => fft_out,
        o_sync      => first_out        
    );
    
   
    -----------------------------------------------------------------------
            
    --syncronous process
    sync_state_proc: process (reset, clk)
    begin
        if reset = '1' then --Reset signals
            state <= TRANSFER_TO_FFT;
            input_state <= INPUT_IDLE;
            output_state <= OUTPUT_IDLE;
            index <= 0;
            receive_index <= 0;
            --fifo_i_index <= 0;
            --fifo_o_index <= 0;
            
        elsif rising_edge(clk) then
            state <= state_next;
            input_state <= input_state_next;
            output_state <= output_state_next;
            index <= index_next;
            receive_index <= receive_index_next;
            --fifo_i_index <= fifo_i_index_next;
            --fifo_o_index <= fifo_o_index_next;
        end if;
        
    end process sync_state_proc;
    
    -----------------------------------------------------------------------
      
    --signal is set outside the process due to delay    
    fft_in <= float2fixed_out_tdata(DFT_DATA_WIDTH-1 downto 0) & zeros when float2fixed_out_tvalid = '1'; -- set FFT input data
    --fifo_in_i <= float2fixed_out_tdata(DFT_DATA_WIDTH-1 downto 0) when float2fixed_out_tvalid = '1'; -- set FIFO input data
    --wr_en_i <= float2fixed_out_tvalid; -- set FIFO write enable
        
    --process to feed the GPP-FFT
    --input_proc: process (input_state, index, fifo_i_index, state, empty_i, first_ready_in, stin_valid, stin_data)
    input_proc: process (input_state, index, state, float2fixed_out_tvalid, stin_valid, stin_data)
    begin
        --default values to prevent latches
        input_state_next <= input_state;
        index_next <= index;
        --fifo_i_index_next <= fifo_i_index;
        --first_in <= '0';
        stin_ready <= '0';
        float2fixed_in_tvalid <= '0';
        --rd_en_i <= '0';
        --clk_en <= '1'; -- GPP-FFT runs
        
        float2fixed_in_tdata <= (others => '0');
        
        case input_state is
        
            when INPUT_IDLE =>
                if (state = TRANSFER_TO_FFT) then --forward back pressure
                    clk_en <= '1'; -- GPP-FFT runs
                    stin_ready <= '1';
                    input_state_next <= INPUT_SEND;
                end if;
                
            when INPUT_SEND => 
                stin_ready <= '1';
                clk_en <= float2fixed_out_tvalid; -- GPP-FFT halted
                
                if index = SIZE then --independent of valid signals
                    stin_ready <= '0';
                    index_next <= 0; --reset counter
                    clk_en <= '1'; -- GPP-FFT runs
                    input_state_next <= INPUT_IDLE;
                    
                elsif (state = TRANSFER_TO_FFT) and (stin_valid = '1') then --check if input value is valid
                    --convert input data
                    float2fixed_in_tdata <= stin_data(DATA_WIDTH downto 0); --convert float to fixed18
                    float2fixed_in_tvalid <= '1';  
                    
                    --clk_en <= '1'; -- GPP-FFT runs
                                  
                    --increase index
                    index_next <= index + 1;
                end if;
                           
            when others =>
                input_state_next <= INPUT_IDLE; 
        end case;
    
    end process input_proc;   

    -----------------------------------------------------------------------
        
    --process to feed the DFT
    dft_proc: process (state, index, receive_index)
    begin
        --default values to prevent latches
        state_next <= state;
        
        case state is
        
            when TRANSFER_TO_FFT =>
                if index = SIZE then
                    state_next <= OUTPUT_DATA;
               end if;
               
            when OUTPUT_DATA =>
                if receive_index = SIZE then                    
                    state_next <= TRANSFER_TO_FFT;
                end if;
                
            when others =>
                state_next <= TRANSFER_TO_FFT;
        end case;
                
    end process dft_proc;
    
    
    -----------------------------------------------------------------------
        
    --signal is set outside the process due to delay
    --temporary save float values
    temp_real_float <= real_fixed2float_out_tdata when real_fixed2float_out_tvalid = '1';
    temp_imag_float <= imag_fixed2float_out_tdata when imag_fixed2float_out_tvalid = '1';
    
    --process to get output of the DFT
    output_proc: process (output_state, receive_index, state, first_out, fft_out, temp_real_float, temp_imag_float, stout_ready)
    begin
        --default values to prevent latches
        output_state_next <= output_state;
        receive_index_next <= receive_index;
        stout_valid <= '0';
        real_fixed2float_in_tvalid <= '0';
        imag_fixed2float_in_tvalid <= '0';
        
        real_fixed2float_in_tdata <= (others => '0');
        imag_fixed2float_in_tdata <= (others => '0');
        
        case output_state is
                
            when OUTPUT_IDLE =>
                
                if (state = OUTPUT_DATA) and (first_out = '1') then --check if the output data of the GPP-FFT is valid
                    --convert first output data
                    --real part
                    real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert float to fixed18
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert float to fixed18
                    imag_fixed2float_in_tvalid <= '1';
                    
                    output_state_next <= OUTPUT_DATA;
                end if;               
            
--            when STORE =>
            
--                if (fifo_o_index = SIZE) then -- all input values are stored in the FIFO and master is ready to read data                    
--                    --write last data to FIFO
--                    --real part
--                    --sign bit
--                    fifo_in_o(STOUT_SIGN_BIT_REAL) <= temp_real_float(SIGN_BIT);
--                    --exponent with applied shifts from DFT
--                    fifo_in_o(stout_exponent_real_range'range) <= shifted_exp_real;
--                    --mantissa                    
--                    fifo_in_o(stout_mantissa_real_range'range) <= temp_real_float(mantissa_range'range);
                    
--                    --imaginary part
--                    --sign bit
--                    fifo_in_o(STOUT_SIGN_BIT_IMAG) <= temp_imag_float(SIGN_BIT);
--                    --exponent with applied shifts from DFT
--                    fifo_in_o(stout_exponent_imag_range'range) <= shifted_exp_imag;
--                    --mantissa                    
--                    fifo_in_o(stout_mantissa_imag_range'range) <= temp_imag_float(mantissa_range'range);
                
--                    wr_en_o <= '1';
                    
--                    fifo_o_index_next <= 0; --reset counter
                                            
--                    -- read FIFO data
--                    rd_en_o <= '1';
                    
--                    output_state_next <= OUTPUT_DATA;
                    
--                elsif (state = OUTPUT_DATA) and (s_out_valid = '1') then --check if the output data of the DFT is valid
--                    --write data to FIFO
--                    --real part
--                    --sign bit
--                    fifo_in_o(STOUT_SIGN_BIT_REAL) <= temp_real_float(SIGN_BIT);
--                    --exponent with applied shifts from DFT
--                    fifo_in_o(stout_exponent_real_range'range) <= shifted_exp_real;
--                    --mantissa                    
--                    fifo_in_o(stout_mantissa_real_range'range) <= temp_real_float(mantissa_range'range);
                    
--                    --imaginary part
--                    --sign bit
--                    fifo_in_o(STOUT_SIGN_BIT_IMAG) <= temp_imag_float(SIGN_BIT);
--                    --exponent with applied shifts from DFT
--                    fifo_in_o(stout_exponent_imag_range'range) <= shifted_exp_imag;
--                    --mantissa                    
--                    fifo_in_o(stout_mantissa_imag_range'range) <= temp_imag_float(mantissa_range'range);
                    
--                    wr_en_o <= '1';
                    
--                    --convert next output data
--                    --real part
--                    real_fixed2float_in_tdata(DFT_DATA_WIDTH-1 downto 0) <= out_real; --convert float to fixed18
--                    real_fixed2float_in_tvalid <= '1';
--                    --imaginary part
--                    imag_fixed2float_in_tdata(DFT_DATA_WIDTH-1 downto 0) <= out_imag; --convert float to fixed18
--                    imag_fixed2float_in_tvalid <= '1';
                                   
--                    --increase index
--                    fifo_o_index_next <= fifo_o_index + 1;            
--                end if;              
                        
            when OUTPUT_DATA =>
        
                if (receive_index = SIZE) then --independent of valid signals
                    receive_index_next <= 0; --reset counter
                    output_state_next <= OUTPUT_IDLE;
                    
                elsif (state = OUTPUT_DATA) and (stout_ready = '1') then --check if the master is ready to read
                    --set data outputs
                    stout_data <= temp_imag_float & temp_real_float;
                    stout_valid <= '1';
                    
                    --convert next output data
                    --real part
                    real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert float to fixed18
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert float to fixed18
                    imag_fixed2float_in_tvalid <= '1';
                                   
                    --increase index
                    receive_index_next <= receive_index + 1;            
                end if;            
               
            when others =>
                output_state_next <= OUTPUT_IDLE;
        end case;
    
    end process output_proc;
    
end arch;
