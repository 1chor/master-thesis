----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2021 09:14:39 PM
-- Design Name: 
-- Module Name: AXI_user_logic_tb - bench
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
use IEEE.NUMERIC_STD.ALL;


entity AXI_user_logic_tb is
generic
(
    C_S_AXI_DATA_WIDTH             : integer              := 64;
    C_S_AXI_ADDR_WIDTH             : integer              := 2
);

end AXI_user_logic_tb;

architecture bench of AXI_user_logic_tb is

    -- component declaration
	component user_logic is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 64;
		C_S_AXI_ADDR_WIDTH	: integer	:= 2
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component user_logic;
    
    -- constant declaration
    constant SIZE : positive := 128;
    constant INPUT_WIDTH : positive := 32;
    constant CLK_PERIOD : time := 10 ns;
    constant stop_clock : boolean := false;
    constant ZERO_PADDING : std_logic_vector(INPUT_WIDTH - 1 downto 0) := (others => '0');
            
    signal S_AXI_ACLK                     :  std_logic;
    signal S_AXI_ARESETN                  :  std_logic;
    signal S_AXI_AWADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_AWVALID                  :  std_logic;
    signal S_AXI_WDATA                    :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_WSTRB                    :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    signal S_AXI_WVALID                   :  std_logic;
    signal S_AXI_BREADY                   :  std_logic;
    signal S_AXI_ARADDR                   :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal S_AXI_ARVALID                  :  std_logic;
    signal S_AXI_RREADY                   :  std_logic;
    signal S_AXI_ARREADY                  : std_logic;
    signal S_AXI_RDATA                    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal S_AXI_RRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_RVALID                   : std_logic;
    signal S_AXI_WREADY                   : std_logic;
    signal S_AXI_BRESP                    : std_logic_vector(1 downto 0);
    signal S_AXI_BVALID                   : std_logic;
    signal S_AXI_AWREADY                  : std_logic;
    signal S_AXI_AWPROT                   : std_logic_vector(2 downto 0);
    signal S_AXI_ARPROT                   : std_logic_vector(2 downto 0);
        
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    signal readIt : std_logic := '0';

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    uut : user_logic
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
        S_AXI_ACLK    => S_AXI_ACLK,
		S_AXI_ARESETN => S_AXI_ARESETN,
		S_AXI_AWADDR  => S_AXI_AWADDR,
		S_AXI_AWPROT  => S_AXI_AWPROT,
		S_AXI_AWVALID => S_AXI_AWVALID,
		S_AXI_AWREADY => S_AXI_AWREADY,
		S_AXI_WDATA	  => S_AXI_WDATA,
		S_AXI_WSTRB   => S_AXI_WSTRB,
		S_AXI_WVALID  => S_AXI_WVALID,
		S_AXI_WREADY  => S_AXI_WREADY,
		S_AXI_BRESP	  => S_AXI_BRESP,
		S_AXI_BVALID  => S_AXI_BVALID,
		S_AXI_BREADY  => S_AXI_BREADY,
		S_AXI_ARADDR  => S_AXI_ARADDR,
		S_AXI_ARPROT  => S_AXI_ARPROT,
		S_AXI_ARVALID => S_AXI_ARVALID,
		S_AXI_ARREADY => S_AXI_ARREADY,
		S_AXI_RDATA	  => S_AXI_RDATA,
		S_AXI_RRESP   => S_AXI_RRESP,
		S_AXI_RVALID  => S_AXI_RVALID,
		S_AXI_RREADY  => S_AXI_RREADY
	);
    
    -- clock generator process
    generate_clk : process
    begin
        while not stop_clock loop
            S_AXI_ACLK <= '0', '1' after CLK_PERIOD / 2;
            wait for CLK_PERIOD;
        end loop;
        wait;            
    end process;

    -- Initiate process which simulates a master wanting to write.
    -- This process is blocked on a "Send Flag" (sendIt).
    -- When the flag goes to 1, the process exits the wait state and
    -- execute a write transaction.
    send : process
    begin
        S_AXI_AWVALID <= '0';
        S_AXI_WVALID <= '0';
        S_AXI_BREADY <= '0';
        loop
            wait until sendIt = '1';
            wait until S_AXI_ACLK = '0';
            S_AXI_AWVALID <= '1';
            S_AXI_WVALID <= '1';
            wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';  --Client ready to read address/data        
            S_AXI_BREADY <= '1';
            wait until S_AXI_BVALID = '1';  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data not written" severity failure;
            S_AXI_AWVALID <= '0';
            S_AXI_WVALID <= '0';
            S_AXI_BREADY <= '1';
            wait until S_AXI_BVALID = '0';  -- All finished
            S_AXI_BREADY <= '0';
        end loop;
    end process send;

    -- Initiate process which simulates a master wanting to read.
    -- This process is blocked on a "Read Flag" (readIt).
    -- When the flag goes to 1, the process exits the wait state and
    -- execute a read transaction.
    read : process
    begin
        S_AXI_ARVALID<='0';
        S_AXI_RREADY<='0';
        loop
            wait until readIt = '1';
            wait until S_AXI_ACLK = '0';
            S_AXI_ARVALID <= '1';
            S_AXI_RREADY <= '1';
            wait until (S_AXI_RVALID and S_AXI_ARREADY) = '1';  --Client provided data
            assert S_AXI_RRESP = "00" report "AXI data not written" severity failure;
            S_AXI_ARVALID <= '0';
            S_AXI_RREADY <= '0';
        end loop;
    end process read;

    -- 
    tb : process
    begin
        S_AXI_ARESETN <= '0';
        sendIt <= '0';
        wait for 15 ns;
        S_AXI_ARESETN <= '1';
        
        for i in 0 to SIZE-1 loop
            S_AXI_AWADDR <= b"00";
            S_AXI_WDATA <= ZERO_PADDING & x"3f800000";
            S_AXI_WSTRB <= b"11111111";
            sendIt <= '1';                --Start AXI Write to Slave
            wait for 1 ns; sendIt <= '0'; --Clear Start Send Flag
            wait until S_AXI_BVALID = '1';
            wait until S_AXI_BVALID = '0';  --AXI Write finished
            S_AXI_WSTRB <= (others => '0');
        end loop;
        
--        S_AXI_AWADDR <= b"00";
--        S_AXI_WDATA <= ZERO_PADDING & x"00000001";
--        S_AXI_WSTRB <= b"11111111";
--        sendIt <= '1';                --Start AXI Write to Slave
--        wait for 1 ns; sendIt <= '0'; --Clear Start Send Flag
--        wait until S_AXI_BVALID = '1';
--        wait until S_AXI_BVALID = '0';  --AXI Write finished
--        S_AXI_WSTRB <= (others => '0');
        
--        S_AXI_AWADDR <= b"00";
--        S_AXI_WDATA <= ZERO_PADDING & x"00000002";
--        S_AXI_WSTRB <= b"11111111";
--        sendIt <= '1';                --Start AXI Write to Slave
--        wait for 1 ns; sendIt <= '0'; --Clear Start Send Flag
--        wait until S_AXI_BVALID = '1';
--        wait until S_AXI_BVALID = '0';  --AXI Write finished
--        S_AXI_WSTRB <= (others => '0');
        
--        S_AXI_AWADDR <= b"01";
--        S_AXI_WDATA <= ZERO_PADDING & x"A5A5A5A5";
--        S_AXI_WSTRB <= b"11111111";
--        sendIt <= '1';                --Start AXI Write to Slave
--        wait for 1 ns; sendIt <= '0'; --Clear Start Send Flag
--        wait until S_AXI_BVALID = '1';
--        wait until S_AXI_BVALID = '0';  --AXI Write finished
--        S_AXI_WSTRB <= (others => '0');
        
        S_AXI_ARADDR <= b"00";
        readIt <= '1';                --Start AXI Read from Slave
        wait for 1 ns; readIt <= '0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';
        
        S_AXI_ARADDR <= b"01";
        readIt <= '1';                --Start AXI Read from Slave
        wait for 1 ns; readIt <= '0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';
        
        -- End of simulation
        report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
        wait; -- will wait forever
    end process tb;

end bench;