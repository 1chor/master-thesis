----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2021 09:22:26 PM
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
    constant DFT_DATA_WIDTH : positive := 21;
    constant DFT_OUT_WIDTH : positive := 25;
    constant zeros : std_logic_vector(DFT_DATA_WIDTH-1 downto 0) := (others => '0');
    
    -- signal declaration
    -- GPP-FFT signals
    signal clk_en                   : std_logic;
    signal clk_en_i                 : std_logic;
    signal clk_en_o                 : std_logic;
    signal fft_in                   : std_logic_vector(2*DFT_DATA_WIDTH-1 downto 0);
    
    signal fft_out                  : std_logic_vector(2*DFT_OUT_WIDTH-1 downto 0);
    signal first_out                : std_logic;
    
    signal index                    : natural range 0 to SIZE := 0;
    signal index_next               : natural range 0 to SIZE := 0;
    
    signal receive_index            : natural range 0 to SIZE := 0;
    signal receive_index_next       : natural range 0 to SIZE := 0;
        
    -- signals for float_to_fixed21
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
    
    signal temp_real_float      : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
    signal temp_real_float_next : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
    
    signal temp_imag_float      : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');
    signal temp_imag_float_next : std_logic_vector(DATA_WIDTH downto 0) := (others => '0');    
    
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
        OUTPUT_CONVERT_FIRST,
        OUTPUT_DELAY,
        OUTPUT_DATA
    );
    signal output_state, output_state_next : output_state_type := OUTPUT_IDLE;
    
    -- component for float_to_fixed21 converter
    component dblclkfft_float_to_fixed21_0 is
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
    end component dblclkfft_float_to_fixed21_0;
    
    --component for fixed25_to_float converter
    component dblclkfft_fixed25_to_float_0 is
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
    end component dblclkfft_fixed25_to_float_0;
    
    -- component for dblclkfft IP core
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

    -- implement float_to_fixed21 unit
    float_to_fixed21_inst : component dblclkfft_float_to_fixed21_0
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
    fixed25_to_float_inst_real : component dblclkfft_fixed25_to_float_0
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
    fixed25_to_float_inst_imag : component dblclkfft_fixed25_to_float_0
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
    
    -- implement dblclkfft unit
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
            temp_real_float <= (others => '0');
            temp_imag_float <= (others => '0');
            
        elsif rising_edge(clk) then
            state <= state_next;
            input_state <= input_state_next;
            output_state <= output_state_next;
            index <= index_next;
            receive_index <= receive_index_next;
            temp_real_float <= temp_real_float_next;
            temp_imag_float <= temp_imag_float_next;
        end if;
        
    end process sync_state_proc;

-----------------------------------------------------------------------
      
    --signal is set outside the process due to delay    
    fft_in <= float2fixed_out_tdata(DFT_DATA_WIDTH-1 downto 0) & zeros when float2fixed_out_tvalid = '1' else (others => '0'); -- set FFT input data
        
    --process to feed the dblclkfft
    input_proc: process (input_state, index, state, float2fixed_out_tvalid, stin_valid, stin_data)
    begin
        --default values to prevent latches
        input_state_next <= input_state;
        index_next <= index;
        stin_ready <= '0';
        float2fixed_in_tvalid <= '0';
        
        float2fixed_in_tdata <= (others => '0');
        
        clk_en_i <= '1'; --FFT runs
        
        case input_state is
        
            when INPUT_IDLE =>
                if (state = TRANSFER_TO_FFT) then --forward back pressure
                    clk_en_i <= '1'; --FFT runs
                    stin_ready <= '1';
                    input_state_next <= INPUT_SEND;
                end if;
                              
            when INPUT_SEND => 
                stin_ready <= '1';
                clk_en_i <= float2fixed_out_tvalid; --FFT halted
                
                if index = SIZE then --independent of valid signals
                    stin_ready <= '0';
                    clk_en_i <= '1'; --FFT runs
                    index_next <= 0; --reset counter
                    input_state_next <= INPUT_IDLE;
                                        
                elsif (state = TRANSFER_TO_FFT) and (stin_valid = '1') then --check if input value is valid
                    --convert input data
                    float2fixed_in_tdata <= stin_data(DATA_WIDTH downto 0); --convert float to fixed21
                    float2fixed_in_tvalid <= '1';  
                                          
                    --increase index
                    index_next <= index + 1;
                end if;
                           
            when others =>
                input_state_next <= INPUT_IDLE; 
        end case;
    
    end process input_proc;   

    -----------------------------------------------------------------------
            
    --process to feed the DFT
    dft_proc: process (state, clk_en_i, index, clk_en_o, receive_index)
    begin
        --default values to prevent latches
        state_next <= state;
        
        case state is
        
            when TRANSFER_TO_FFT =>
                clk_en <= clk_en_i; --route clock enable to intput process
                
                if index = SIZE then
                    state_next <= OUTPUT_DATA;
               end if;
               
            when OUTPUT_DATA =>
                clk_en <= clk_en_o; --route clock enable to output process
                
                if receive_index = SIZE-1 then                    
                    state_next <= TRANSFER_TO_FFT;
                end if;
                
            when others =>
                state_next <= TRANSFER_TO_FFT;
        end case;
                
    end process dft_proc;
        
    -----------------------------------------------------------------------

    --process to get output of the DFT
    output_proc: process (output_state, receive_index, temp_real_float, temp_imag_float, state, first_out, fft_out, stout_ready, real_fixed2float_out_tvalid, imag_fixed2float_out_tvalid, real_fixed2float_out_tdata, imag_fixed2float_out_tdata)
    begin
        --default values to prevent latches
        output_state_next <= output_state;
        receive_index_next <= receive_index;
        temp_real_float_next <= temp_real_float;
        temp_imag_float_next <= temp_imag_float;
        stout_valid <= '0';
        real_fixed2float_in_tvalid <= '0';
        imag_fixed2float_in_tvalid <= '0';
        
        real_fixed2float_in_tdata <= (others => '0');
        imag_fixed2float_in_tdata <= (others => '0');
        
        stout_data <= (others => '0');
        
        clk_en_o <= '1'; --FFT runs
        
        case output_state is
                
            when OUTPUT_IDLE =>
                
                clk_en_o <= '1'; --FFT runs
                
                if (state = OUTPUT_DATA) and (first_out = '1') then --check if the output data of the GPP-FFT is valid
                    clk_en_o <= '0'; --FFT halted
                    
                    -------------------------
                    -- Convert output data --
                    -------------------------
                    
                    --convert first output data
                    --real part
                    real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert fixed25 to float 
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert fixed25 to float
                    imag_fixed2float_in_tvalid <= '1';
                    
                    output_state_next <= OUTPUT_CONVERT_FIRST;
                end if;      
                
            when OUTPUT_CONVERT_FIRST =>
            
                clk_en_o <= '1'; --FFT runs
                
                if (state = OUTPUT_DATA) and (real_fixed2float_out_tvalid = '1') and (imag_fixed2float_out_tvalid = '1') then --check if the output data of the GPP-FFT is valid
                    clk_en_o <= '0'; --FFT halted
                    
                    ---------------------
                    -- Save conversion --
                    ---------------------
                    
                    --temporary save float values
                    temp_real_float_next <= real_fixed2float_out_tdata;
                    temp_imag_float_next <= imag_fixed2float_out_tdata;
                    
                    -------------------------
                    -- Convert output data --
                    -------------------------
                    
                    --convert next output data
                    --real part
                    real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert fixed25 to float 
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert fixed25 to float
                    imag_fixed2float_in_tvalid <= '1';
                    
                    output_state_next <= OUTPUT_DELAY;
                end if;
                    
            when OUTPUT_DELAY =>
                
                clk_en_o <= '1'; --FFT runs
                
                if (real_fixed2float_out_tvalid = '1') and (imag_fixed2float_out_tvalid = '1') then
                    ---------------------
                    -- Save conversion --
                    ---------------------
                    
                    --temporary save float values
                    temp_real_float_next <= real_fixed2float_out_tdata;
                    temp_imag_float_next <= imag_fixed2float_out_tdata;
                end if;
                                    
                if (receive_index = SIZE-2) and (state = OUTPUT_DATA) and (stout_ready = '1') then --check if the master is ready to read
                    clk_en_o <= '0'; --FFT halted
                    
                    -----------------
                    -- Output data --
                    -----------------
                    
                    --set data outputs
                    stout_data <= temp_imag_float & temp_real_float;
                    stout_valid <= '1';
                    
                    --increase index
                    receive_index_next <= receive_index + 1; 
                    
                    output_state_next <= OUTPUT_DATA;
                    
                elsif (state = OUTPUT_DATA) and (stout_ready = '1') then --check if the master is ready to read
                    clk_en_o <= '0'; --FFT halted
                    
                    -----------------
                    -- Output data --
                    -----------------
                    
                    --set data outputs
                    stout_data <= temp_imag_float & temp_real_float;
                    stout_valid <= '1';
                                        
                    -------------------------
                    -- Convert output data --
                    -------------------------
                    
                    --convert next output data
                    --real part
                    real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert fixed25 to float
                    real_fixed2float_in_tvalid <= '1';
                    --imaginary part
                    imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert fixed25 to float
                    imag_fixed2float_in_tvalid <= '1';
                                   
                    --increase index
                    receive_index_next <= receive_index + 1;   
                    
                    output_state_next <= OUTPUT_DATA;
                end if;
                
            when OUTPUT_DATA =>
        
                clk_en_o <= '1'; --FFT runs
                
                if (real_fixed2float_out_tvalid = '1') and (imag_fixed2float_out_tvalid = '1') then
                    ---------------------
                    -- Save conversion --
                    ---------------------
                    
                    --temporary save float values
                    temp_real_float_next <= real_fixed2float_out_tdata;
                    temp_imag_float_next <= imag_fixed2float_out_tdata;
                end if;
                
                if (receive_index = SIZE-1) and (state = TRANSFER_TO_FFT) and (stout_ready = '1') then --check if the master is ready to read
                    clk_en_o <= '0'; --FFT halted
                    
                    -----------------
                    -- Output data --
                    -----------------
                    
                    --set data outputs
                    stout_data <= temp_imag_float & temp_real_float;
                    stout_valid <= '1';
                    
                    receive_index_next <= 0; --reset counter
                    
                    output_state_next <= OUTPUT_IDLE;                    
                    
                elsif (state = OUTPUT_DATA) and (stout_ready = '1') then --check if the master is ready to read
                    clk_en_o <= '0'; --FFT halted
                    
                    -----------------
                    -- Output data --
                    -----------------
                    
                    --set data outputs
                    stout_data <= temp_imag_float & temp_real_float;
                    stout_valid <= '1';
                                        
                    if (receive_index /= SIZE-1) then --skip new output transmission
                        -------------------------
                        -- Convert output data --
                        -------------------------
                        
                        --convert next output data
                        --real part
                        real_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(2*DFT_OUT_WIDTH-1 downto DFT_OUT_WIDTH); --convert fixed25 to float
                        real_fixed2float_in_tvalid <= '1';
                        --imaginary part
                        imag_fixed2float_in_tdata(DFT_OUT_WIDTH-1 downto 0) <= fft_out(DFT_OUT_WIDTH-1 downto 0); --convert fixed25 to float
                        imag_fixed2float_in_tvalid <= '1';
                    end if;
                                   
                    --increase index
                    receive_index_next <= receive_index + 1;     
                    
                    output_state_next <= OUTPUT_DELAY;       
                end if;            
               
            when others =>
                output_state_next <= OUTPUT_IDLE;
        end case;
    
    end process output_proc;
    
end arch;
