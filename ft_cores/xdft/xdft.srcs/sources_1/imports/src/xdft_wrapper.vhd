----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2020 09:51:34 PM
-- Design Name: 
-- Module Name: xdft_wrapper - arch
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xdft_wrapper is
    generic (
        SIZE : positive := 108; -- default 108
        C_S_AXI_DATA_WIDTH : positive := 32
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
        stout_valid : out std_logic
        --stout_ready : in std_logic        
    );
begin
    -- check if SIZE is valid    
    check :
    assert ((SIZE = 12) or (SIZE = 24) or (SIZE = 36) or (SIZE = 48) or (SIZE = 60) or (SIZE = 72) or (SIZE = 96) or (SIZE = 108) 
                or (SIZE = 120) or (SIZE = 144) or (SIZE = 180) or (SIZE = 192) or (SIZE = 216) or (SIZE = 240) or (SIZE = 288)
                or (SIZE = 300) or (SIZE = 324) or (SIZE = 360) or (SIZE = 384) or (SIZE = 432) or (SIZE = 480) or (SIZE = 540)
                or (SIZE = 576) or (SIZE = 600) or (SIZE = 648) or (SIZE = 720) or (SIZE = 768) or (SIZE = 864) or (SIZE = 900)
                or (SIZE = 960) or (SIZE = 972) or (SIZE = 1080) or (SIZE = 1152) or (SIZE = 1200) or (SIZE = 1296))
    report ("The selected transform size (" & integer'image(SIZE) & ") is not supported!") severity failure;
    
end xdft_wrapper;

architecture arch of xdft_wrapper is

    -- constant declaration
    constant FWD : std_logic := '1'; -- use forward transformation
    constant DATA_WIDTH : positive := 31;
    constant DFT_DATA_WIDTH : positive := 17;
    constant zeros : std_logic_vector(DFT_DATA_WIDTH downto 0) := (others => '0');
    
    -- signal declaration
    --DFT signals
    signal in_real                  : std_logic_vector(DFT_DATA_WIDTH downto 0);
    signal first_in                 : std_logic;
    signal first_ready_in           : std_logic;
    
    signal out_real                 : std_logic_vector(DFT_DATA_WIDTH downto 0);
    signal out_imag                 : std_logic_vector(DFT_DATA_WIDTH downto 0);
    signal first_out                : std_logic;
    signal s_out_valid              : std_logic;
    signal exp                      : std_logic_vector(3 downto 0);
    
    signal size_s                   : positive := SIZE;
    signal dft_size                 : std_logic_vector(5 downto 0);
    
    signal index                    : natural range 0 to SIZE := 0;
    signal index_next               : natural range 0 to SIZE := 0;
    
    signal receive_index            : natural range 0 to SIZE := 0;
    signal receive_index_next       : natural range 0 to SIZE := 0;
    
    -- signals for float_to_fixed18
    signal float2fixed_in_tvalid    : std_logic := '0'; -- payload is valid
    signal float2fixed_in_tdata     : std_logic_vector(31 downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tvalid   : std_logic := '0';
    signal float2fixed_out_tdata    : std_logic_vector(23 downto 0) := (others => '0'); -- data payload
    signal float2fixed_out_tuser    : std_logic_vector(0 downto 0) := (others => '0'); -- exceptions and user-defined payload
        
    -- signals for fixed32_to_float
    signal fixed2float_in_tvalid     : std_logic := '0'; -- payload is valid
    signal fixed2float_in_tdata      : std_logic_vector(31 downto 0) := (others => '0'); -- data payload
    signal fixed2float_out_tvalid    : std_logic := '0';
    signal fixed2float_out_tdata     : std_logic_vector(31 downto 0) := (others => '0'); -- data payload
    
    -- type declaration
    type state_type is (
        TRANSFER_TO_FFT,
        OUTPUT_DATA
    );
    signal state, state_next : state_type := TRANSFER_TO_FFT;
    
    type input_state_type is (
        INPUT_IDLE,
        PRE_CONVERT,
        FIRST_FRAME,
        OTHER_FRAMES,
        LAST_FRAME
    );
    signal input_state, input_state_next : input_state_type := INPUT_IDLE;
    
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
            m_axis_result_tdata : out std_logic_vector(23 downto 0);
            m_axis_result_tuser :out std_logic_vector(0 downto 0)
        );
    end component float_to_fixed18_0;
    
    --component for fixed32_to_float converter
    component fixed32_to_float_0 is
        port (
            -- Global signals
            aclk : IN STD_LOGIC;
            -- AXI4-Stream slave channel for operand A
            s_axis_a_tvalid : in std_logic;
            s_axis_a_tdata : in std_logic_vector(DATA_WIDTH DOWNTO 0);
            -- AXI4-Stream master channel for output result
            m_axis_result_tvalid : out std_logic;
            m_axis_result_tdata : out std_logic_vector(DATA_WIDTH DOWNTO 0)
      );
    end component fixed32_to_float_0;
  
    -- component for DFT IP core
    component dft_0 is
        port (
            CLK : in std_logic;                             -- clock
            SCLR : in std_logic;                            -- syncronous clear (reset)
            XN_RE : in std_logic_vector(DFT_DATA_WIDTH downto 0);       -- real data input
            XN_IM : in std_logic_vector(DFT_DATA_WIDTH downto 0);       -- imaginary data input
            FD_IN : in std_logic;                           -- first data in
            FWD_INV : in std_logic;                         -- transform direction
            SIZE : in std_logic_vector(5 downto 0);         -- size of transform to be performed
            RFFD : out std_logic;                           -- ready for first data
            XK_RE : out std_logic_vector(DFT_DATA_WIDTH downto 0);      -- real data output
            XK_IM : out std_logic_vector(DFT_DATA_WIDTH downto 0);      -- imaginary data output
            BLK_EXP : out std_logic_vector(3 downto 0);     -- block exponent
            FD_OUT : out std_logic;                         -- first data out
            DATA_VALID : out std_logic                      -- data valid
        );
    end component dft_0;

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
    
    -- implement fixed32_to_float unit
    fixed32_to_float_inst : component fixed32_to_float_0
    port map (
        -- Global signals
        aclk => clk,
        -- AXI4-Stream slave channel for operand A
        s_axis_a_tvalid => fixed2float_in_tvalid,
        s_axis_a_tdata => fixed2float_in_tdata,
        -- AXI4-Stream master channel for output result
        m_axis_result_tvalid => fixed2float_out_tvalid,
        m_axis_result_tdata => fixed2float_out_tdata
    );

    -- implement DFT unit
    dft_inst : component dft_0
    port map (
        CLK         => clk,
        SCLR        => reset,
        XN_RE       => in_real, -- real input without imaginary part
        XN_IM       => zeros,   -- constant 0
        FD_IN       => first_in,
        FWD_INV     => FWD,
        SIZE        => dft_size,
        RFFD        => first_ready_in,
        XK_RE       => out_real,
        XK_IM       => out_imag,
        BLK_EXP     => exp,
        FD_OUT      => first_out,
        DATA_VALID  => s_out_valid
    );
    
    -----------------------------------------------------------------------
    
    -- process to get the binary encoding for the transform size
    get_size_proc: process (size_s)
    begin
        case size_s is
            when 12     => dft_size <= "000000";
            when 24     => dft_size <= "000001";
            when 36     => dft_size <= "000010";
            when 48     => dft_size <= "000011";
            when 60     => dft_size <= "000100";
            when 72     => dft_size <= "000101";
            when 96     => dft_size <= "000110";
            when 108    => dft_size <= "000111";
            when 120    => dft_size <= "001000";
            when 144    => dft_size <= "001001";
            when 180    => dft_size <= "001010";
            when 192    => dft_size <= "001011";
            when 216    => dft_size <= "001100";
            when 240    => dft_size <= "001101";
            when 288    => dft_size <= "001110";
            when 300    => dft_size <= "001111";
            when 324    => dft_size <= "010000";
            when 360    => dft_size <= "010001";
            when 384    => dft_size <= "010010";
            when 432    => dft_size <= "010011";
            when 480    => dft_size <= "010100";
            when 540    => dft_size <= "010101";
            when 576    => dft_size <= "010110";
            when 600    => dft_size <= "010111";
            when 648    => dft_size <= "011000";
            when 720    => dft_size <= "011001";
            when 768    => dft_size <= "011010";
            when 864    => dft_size <= "011011";
            when 900    => dft_size <= "011100";
            when 960    => dft_size <= "011101";
            when 972    => dft_size <= "011110";
            when 1080   => dft_size <= "011111";
            when 1152   => dft_size <= "100000";
            when 1200   => dft_size <= "100001";
            when 1296   => dft_size <= "100010";
            when others => dft_size <= "000111"; -- default 108
        end case;
    end process get_size_proc;
    
    -----------------------------------------------------------------------
    
    --syncronous process
    sync_state_proc: process (reset, clk)
    begin
        if reset = '1' then --Reset signals
            state <= TRANSFER_TO_FFT;
            input_state <= INPUT_IDLE;
            index <= 0;
            receive_index <= 0;
            
        elsif rising_edge(clk) then
            state <= state_next;
            input_state <= input_state_next;
            index <= index_next;
            receive_index <= receive_index_next;
        end if;
        
    end process sync_state_proc;
    
    -----------------------------------------------------------------------
        
    --process to feed the DFT
    input_proc: process (input_state, index, state, first_ready_in, stin_valid, stin_data, float2fixed_out_tvalid)
    begin
        --default values to prevent latches
        input_state_next <= input_state;
        index_next <= index;
        first_in <= '0';
        stin_ready <= '0';
        float2fixed_in_tvalid <= '0';
        
        in_real <= (others => '0');
        
        case input_state is
        
            when INPUT_IDLE =>
                if (state = TRANSFER_TO_FFT) and (first_ready_in = '1') then --forward back pressure
                    stin_ready <= '1';
                    input_state_next <= PRE_CONVERT;
                end if;
                
            when PRE_CONVERT =>
                stin_ready <= '1';
                
                if (stin_valid = '1') then
                    --convert first input data
                    float2fixed_in_tdata <= stin_data; --convert float to fixed18
                    float2fixed_in_tvalid <= '1';
                    
                    input_state_next <= FIRST_FRAME;
                end if;
        
            when FIRST_FRAME =>
                stin_ready <= '1';
                
                if (state = TRANSFER_TO_FFT) and (first_ready_in = '1') and (stin_valid = '1') and (float2fixed_out_tvalid = '1') then --check if DFT is ready to process data and data_in is valid
                    --convert next input
                    float2fixed_in_tdata <= stin_data; --convert float to fixed18
                    float2fixed_in_tvalid <= '1';
                                        
                    --set real data input
                    in_real <= float2fixed_out_tdata(DFT_DATA_WIDTH downto 0); --fixed18 format
                    
                    --set flag for first data input
                    first_in <= '1'; 
                                        
                    --increase index
                    index_next <= index + 1;
                    
                    input_state_next <= OTHER_FRAMES;                    
                end if;
            
            when OTHER_FRAMES => 
                stin_ready <= '1';
                   
                if (state = TRANSFER_TO_FFT) and (stin_valid = '1') and (float2fixed_out_tvalid = '1') then --check if DFT is ready to process data and data_in is valid
                    --convert next input
                    float2fixed_in_tdata <= stin_data; --convert float to fixed18
                    float2fixed_in_tvalid <= '1';
                                        
                    --set real data input
                    in_real <= float2fixed_out_tdata(DFT_DATA_WIDTH downto 0); --fixed18 format
                      
                    --increase index
                    index_next <= index + 1;
                    
                    if (index = SIZE-2) then
                        input_state_next <= LAST_FRAME;
                    end if;
                end if;
                
            when LAST_FRAME =>    
                if index = SIZE then --independent of valid signals
                    stin_ready <= '0';
                    index_next <= 0; --reset counter
                    input_state_next <= INPUT_IDLE;
                    
                elsif (state = TRANSFER_TO_FFT) and (float2fixed_out_tvalid = '1') then --check if DFT is ready to process data and data_in is valid
                    stin_ready <= '1';
                                                            
                    --set real data input
                    in_real <= float2fixed_out_tdata(DFT_DATA_WIDTH downto 0); --fixed18 format
                    
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
    
    --process to get output of the DFT
    output_proc: process (receive_index, state, s_out_valid, out_real, out_imag)
    begin
        --default values to prevent latches
        receive_index_next <= receive_index;
        stout_valid <= '0';
        
        if receive_index = SIZE then --independent of valid signals
            receive_index_next <= 0; --reset counter
            
        elsif (state = OUTPUT_DATA) and (s_out_valid = '1') then --check if the output data of the DFT is valid
            stout_valid <= '1';
            
            --get data outputs
            --stout_data(C_S_AXI_DATA_WIDTH / 2 -1 downto 0) <= out_real;
            --stout_data(C_S_AXI_DATA_WIDTH -1 downto C_S_AXI_DATA_WIDTH / 2) <= out_imag;
                                    
            --increase index
            receive_index_next <= receive_index + 1;
            
        end if;
    
    end process output_proc;
    
end arch;
