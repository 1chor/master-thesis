----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2021 11:09:04 PM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
        stout_valid : out std_logic
        --stout_ready : in std_logic        
    );
begin
    -- check if SIZE is valid    
    check :
    assert ((SIZE = 8) or (SIZE = 16) or (SIZE = 32) or (SIZE = 64) or (SIZE = 128) or (SIZE = 256) or (SIZE = 512) or (SIZE = 1024) 
                or (SIZE = 2048) or (SIZE = 4096) or (SIZE = 8192) or (SIZE = 16384) or (SIZE = 32768) or (SIZE = 65536))
    report ("The selected transform size (" & integer'image(SIZE) & ") is not supported!") severity failure;
end ft_wrapper;

architecture arch of ft_wrapper is

    -- constant declaration
    
    -- signal declaration
    -- FFT signals
    
    
    
    signal size_s   : positive := SIZE;
    signal fft_size : std_logic_vector(4 downto 0);

    -- component for FFT IP core
    component fft_0 is
        port (
        -- Global signals
        aclk : in std_logic;                                                    -- clock
        aresetn : in std_logic;                                                 -- syncronous clear (reset)
        -- AXI4-Stream slave configuration channel
        s_axis_config_tdata : in std_logic_vector(15 DOWNTO 0);                 -- configuration data
        s_axis_config_tvalid : in std_logic;                                    -- configuration data valid
        s_axis_config_tready : out std_logic;                                   -- configuration data ready
        -- AXI4-Stream slave data input channel
        s_axis_data_tdata : in std_logic_vector(C_S_AXI_DATA_WIDTH DOWNTO 0);   -- input data (imaginary, real)
        s_axis_data_tvalid : in std_logic;                                      -- input data valid
        s_axis_data_tready : out std_logic;                                     -- input data ready        
        s_axis_data_tlast : in std_logic;                                       -- last data in
        -- AXI4-Stream master data output channel
        m_axis_data_tdata : out std_logic_vector(C_S_AXI_DATA_WIDTH DOWNTO 0);  -- output data (imaginary, real)
        m_axis_data_tvalid : out std_logic;                                     -- output data valid
        m_axis_data_tready : in std_logic;                                      -- output data ready
        m_axis_data_tlast : out std_logic;                                      -- last data out
        -- Event signals
        event_frame_started : out std_logic;                                    -- event: new frame
        event_tlast_unexpected : out std_logic;                                 -- event: unexpected last data in
        event_tlast_missing : out std_logic;                                    -- event: missing last data in
        event_status_channel_halt : out std_logic;                              -- event: cannot write status
        event_data_in_channel_halt : out std_logic;                             -- event: no data input available
        event_data_out_channel_halt : out std_logic                             -- event: cannot write data output
      );
  end component fft_0;

begin

    -- implement DFT unit
--    dft_inst : component dft_0
--    port map (
--        CLK         => clk,
--        SCLR        => reset,
--        XN_RE       => in_real, -- real input without imaginary part
--        XN_IM       => zeros,   -- constant 0
--        FD_IN       => first_in,
--        FWD_INV     => FWD,
--        SIZE        => fft_size,
--        RFFD        => first_ready_in,
--        XK_RE       => out_real,
--        XK_IM       => out_imag,
--        BLK_EXP     => blk_exp(3 downto 0),
--        FD_OUT      => first_out,
--        DATA_VALID  => s_out_valid
--    );
    
    -----------------------------------------------------------------------
    
    --SIZE = 8) or (SIZE = 16) or (SIZE = 32) or (SIZE = 64) or (SIZE = 128) or (SIZE = 256) or (SIZE = 512) or (SIZE = 1024) 
    --or (SIZE = 2048) or (SIZE = 4096) or (SIZE = 8192) or (SIZE = 16384) or (SIZE = 32768) or (SIZE = 65536))
    
    -- process to get the binary encoding for the transform size
    get_size_proc: process (size_s)
    begin
        case size_s is
            when      8  => fft_size <= "00011";
            when     16  => fft_size <= "00100";
            when     32  => fft_size <= "00101";
            when     64  => fft_size <= "00110";
            when    128  => fft_size <= "00111";
            when    256  => fft_size <= "01000";
            when    512  => fft_size <= "01001";
            when   1024  => fft_size <= "01010";
            when   2048  => fft_size <= "01011";
            when   4096  => fft_size <= "01100";
            when   8192  => fft_size <= "01101";
            when  16384  => fft_size <= "01110";
            when  32768  => fft_size <= "01111";
            when  65536  => fft_size <= "10000";            
            when others  => fft_size <= "00111"; -- default 128
        end case;
    end process get_size_proc;
    
    -----------------------------------------------------------------------

end arch;
