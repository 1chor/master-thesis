----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2021 08:42:32 PM
-- Design Name: 
-- Module Name: user_logic - IMP
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: User logic.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Interrupt                    -- High-active interrupt to PS
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
    generic
    (
        -- Bus protocol parameters, do not add to or delete
        C_NUM_REG                      : integer              := 2;
        C_SLV_DWIDTH                   : integer              := 64
    );
    port
    (
        Bus2IP_Clk                     : in  std_logic;
        Bus2IP_Resetn                  : in  std_logic;
        Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
        Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
        Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
        Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
        IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
        IP2Bus_RdAck                   : out std_logic;
        IP2Bus_WrAck                   : out std_logic;
        IP2Bus_Error                   : out std_logic
    );
    
    attribute MAX_FANOUT : string;
    attribute SIGIS : string;
    
    attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
    attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

    --USER signal declarations added here, as needed for user logic
    signal data_in              : std_logic_vector(63 downto 0);
    signal in_valid             : std_logic;
    signal in_ready             : std_logic;
    
    signal data_out             : std_logic_vector(63 downto 0);
    signal out_valid            : std_logic;
    
    ------------------------------------------
    -- Signals for user logic slave model s/w accessible register example
    ------------------------------------------
    signal input_reg            : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal output_reg           : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_reg_write_sel    : std_logic_vector(1 downto 0);
    signal slv_reg_read_sel     : std_logic_vector(1 downto 0);
    signal slv_ip2bus_data      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    signal slv_read_ack         : std_logic;
    signal slv_write_ack        : std_logic;
    
    signal Bus2IP_Reset         : std_logic;
    
    --
    -- States for the state machine
    --
    type state_type is (
        STATE_READY,                        --Ready to start hashing
        STATE_PREPARE_KEY,                  --message_len received, start hashing by passing the key
        STATE_WAIT_SUBCHUNK,                --Wait for the software to send a subchunk
        STATE_WAIT_COMPRESS_READY,          --Wait until the entity is ready to receive the new chunk
        STATE_HASH_CHUNK,                   --Hash that chunk
        STATE_WAIT_DONE                     --Wait until the hash is ready
    );
    signal state: state_type;
    
    component ft_wrapper is
    --Due to the partial reconfiguration,no generic parameters may be used      
--    generic (
--        SIZE : positive := 128; -- default 128
--        C_S_AXI_DATA_WIDTH : positive := 64
--    );
    port (
        clk           : in std_logic;
        reset         : in std_logic;
        
        -- streaming sink (input)
        stin_data     : in std_logic_vector(63 downto 0);
        stin_valid    : in std_logic;
        stin_ready    : out std_logic;
        
        -- streaming source (ouput)
        stout_data    : out std_logic_vector(63 downto 0);
        stout_valid   : out std_logic
        --stout_ready : in std_logic        
    );
    end component ft_wrapper;
    
begin
    
    --USER logic implementation added here
    
    Bus2IP_Reset <= not Bus2IP_Resetn;
      
    -- Component instantiation.
    ft_wrapper_0: ft_wrapper
      --Due to the partial reconfiguration,no generic parameters may be used
      --generic map(
--        SIZE : positive := 128; -- default 128
--        C_S_AXI_DATA_WIDTH : positive := 64
      --)
      port map (
          clk         => Bus2IP_Clk,
          reset       => Bus2IP_Reset,
          
          -- streaming sink (input)
          stin_data   => data_in,
          stin_valid  => in_valid,
          stin_ready  => in_ready,
          
          -- streaming source (ouput)
          stout_data  => data_out,
          stout_valid => out_valid
          --stout_ready
      );
    
    ------------------------------------------
    -- Example code to read/write user logic slave model s/w accessible registers
    -- 
    -- Note:
    -- The example code presented here is to show you one way of reading/writing
    -- software accessible registers implemented in the user logic slave model.
    -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
    -- to one software accessible register by the top level template. For example,
    -- if you have four 32 bit software accessible registers in the user logic,
    -- you are basically operating on the following memory mapped registers:
    -- 
    --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
    --                     "1000"   C_BASEADDR + 0x0
    --                     "0100"   C_BASEADDR + 0x4
    --                     "0010"   C_BASEADDR + 0x8
    --                     "0001"   C_BASEADDR + 0xC
    -- 
    ------------------------------------------
    slv_reg_write_sel <= Bus2IP_WrCE(1 downto 0);
    slv_reg_read_sel  <= Bus2IP_RdCE(1 downto 0);
    slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1);
    slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1);
    
    -- implement slave model software accessible register(s)
    SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
    begin
    
        if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
            if Bus2IP_Resetn = '0' then
                input_reg <= (others => '0');
                output_reg <= (others => '0');
                
                data_in <= (others => '0');
                in_valid <= '0';
                
            else
                --default values to prevent latches                                
                data_in <= (others => '0');
                in_valid <= '0';
                --
                -- Writes from Software to Logic
                --
                case slv_reg_write_sel is
                    when "10" =>
                        for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
                            if ( Bus2IP_BE(byte_index) = '1' ) then
                                if (in_ready = '1') then
                                    data_in(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
                                    in_valid <= '1';
                                end if;
                            end if;
                        end loop;
                        
                    --Register 01 is not writable from software!
--                    when "01" =>
--                        for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--                            if ( Bus2IP_BE(byte_index) = '1' ) then
--                                output_reg(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--                            end if;
--                        end loop;
                        
                    when others =>
                        null;
                end case;
            end if;
        end if;
    
    end process SLAVE_REG_WRITE_PROC;
    
    -- implement slave model software accessible register(s) read mux
    SLAVE_REG_READ_PROC : process( slv_reg_read_sel, input_reg, data_out ) is
    begin    
        --
        -- Software reads Logic registers
        --
        case slv_reg_read_sel is
            when "10" => 
                slv_ip2bus_data <= input_reg;
            when "01" => 
                if (out_valid = '1') then
                    slv_ip2bus_data <= data_out;
                end if;
            when others => 
                slv_ip2bus_data <= (others => '0');
        end case;
    
    end process SLAVE_REG_READ_PROC;
    
    ------------------------------------------
    -- Example code to drive IP to Bus signals
    ------------------------------------------
    IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                    (others => '0');
    
    IP2Bus_WrAck <= slv_write_ack;
    IP2Bus_RdAck <= slv_read_ack;
    IP2Bus_Error <= '0';

end IMP;
