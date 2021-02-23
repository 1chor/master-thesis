--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
--Date        : Tue Sep 29 14:22:07 2020
--Host        : soc running 64-bit Ubuntu 18.04.5 LTS
--Command     : generate_target zcu102_wrapper.bd
--Design      : zcu102_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------

entity zcu102_wrapper is
  port (
    HDMI_TX_CLK_N_OUT : out STD_LOGIC;
    HDMI_TX_CLK_P_OUT : out STD_LOGIC;
    HDMI_TX_DAT_N_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    HDMI_TX_DAT_P_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    SI5324_LOL_IN : in STD_LOGIC;
    SI5324_RST_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    TX_DDC_OUT_scl_io : inout STD_LOGIC;
    TX_DDC_OUT_sda_io : inout STD_LOGIC;
    TX_EN_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    TX_HPD_IN : in STD_LOGIC;
    TX_REFCLK_N_IN : in STD_LOGIC;
    TX_REFCLK_P_IN : in STD_LOGIC;
    fmch_iic_scl_io : inout STD_LOGIC;
    fmch_iic_sda_io : inout STD_LOGIC;
    reset : in STD_LOGIC
  );
end zcu102_wrapper;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture STRUCTURE of zcu102_wrapper is

  ------------------------------------------
  -- declare block diagram instance
  ------------------------------------------
  
  component zcu102 is
  port (
    TX_EN_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    HDMI_TX_CLK_N_OUT : out STD_LOGIC;
    HDMI_TX_CLK_P_OUT : out STD_LOGIC;
    HDMI_TX_DAT_N_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    HDMI_TX_DAT_P_OUT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    TX_HPD_IN : in STD_LOGIC;
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC;
    TX_REFCLK_N_IN : in STD_LOGIC;
    TX_REFCLK_P_IN : in STD_LOGIC;
    SI5324_LOL_IN : in STD_LOGIC;
    SI5324_RST_OUT : out STD_LOGIC_VECTOR ( 0 to 0 );
    fmch_iic_scl_i : in STD_LOGIC;
    fmch_iic_scl_o : out STD_LOGIC;
    fmch_iic_scl_t : out STD_LOGIC;
    fmch_iic_sda_i : in STD_LOGIC;
    fmch_iic_sda_o : out STD_LOGIC;
    fmch_iic_sda_t : out STD_LOGIC;
    TX_DDC_OUT_scl_i : in STD_LOGIC;
    TX_DDC_OUT_scl_o : out STD_LOGIC;
    TX_DDC_OUT_scl_t : out STD_LOGIC;
    TX_DDC_OUT_sda_i : in STD_LOGIC;
    TX_DDC_OUT_sda_o : out STD_LOGIC;
    TX_DDC_OUT_sda_t : out STD_LOGIC;
    -- S_AXI clock and reset
    s_axi_aclk : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    -- S_AXI interface for simple_filter
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_awvalid : out STD_LOGIC;
    M05_AXI_awready : in STD_LOGIC;
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_wvalid : out STD_LOGIC;
    M05_AXI_wready : in STD_LOGIC;
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC;
    M05_AXI_bready : out STD_LOGIC;
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_arvalid : out STD_LOGIC;
    M05_AXI_arready : in STD_LOGIC;
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC;
    M05_AXI_rready : out STD_LOGIC;
    -- S_AXI interface for Fourier transform
    M07_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_awvalid : out STD_LOGIC;
    M07_AXI_awready : in STD_LOGIC;
    M07_AXI_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    M07_AXI_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M07_AXI_wvalid : out STD_LOGIC;
    M07_AXI_wready : in STD_LOGIC;
    M07_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_bvalid : in STD_LOGIC;
    M07_AXI_bready : out STD_LOGIC;
    M07_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_arvalid : out STD_LOGIC;
    M07_AXI_arready : in STD_LOGIC;
    M07_AXI_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    M07_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_rvalid : in STD_LOGIC;
    M07_AXI_rready : out STD_LOGIC
  );
  end component zcu102;
  
  ------------------------------------------
  -- declare IOBUF instance
  ------------------------------------------
  
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  
  ------------------------------------------
  -- declare simple_filter instance
  ------------------------------------------
  
  component simple_filter is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
  
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"98000000";
    C_HIGHADDR                     : std_logic_vector     := X"9800FFFF";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  end component simple_filter;

  ------------------------------------------
  -- declare fourier transform instance
  ------------------------------------------
  
  component fourier_transform_v1_0 is
  generic (
	-- Users to add parameters here
	-- User parameters ends
	-- Do not modify the parameters beyond this line
	-- Parameters of Axi Slave Bus Interface S00_AXI
	C_S00_AXI_DATA_WIDTH	: integer	:= 64;
	C_S00_AXI_ADDR_WIDTH	: integer	:= 1
  );
  port (
	-- Users to add ports here
	-- User ports ends
	-- Do not modify the ports beyond this line
	-- Ports of Axi Slave Bus Interface S00_AXI
	s00_axi_aclk	: in std_logic;
	s00_axi_aresetn	: in std_logic;
	s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
	s00_axi_awprot	: in std_logic_vector(2 downto 0);
	s00_axi_awvalid	: in std_logic;
	s00_axi_awready	: out std_logic;
	s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
	s00_axi_wvalid	: in std_logic;
	s00_axi_wready	: out std_logic;
	s00_axi_bresp	: out std_logic_vector(1 downto 0);
	s00_axi_bvalid	: out std_logic;
	s00_axi_bready	: in std_logic;
	s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
	s00_axi_arprot	: in std_logic_vector(2 downto 0);
	s00_axi_arvalid	: in std_logic;
	s00_axi_arready	: out std_logic;
	s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	s00_axi_rresp	: out std_logic_vector(1 downto 0);
	s00_axi_rvalid	: out std_logic;
    s00_axi_rready	: in std_logic
  );
  end component fourier_transform_v1_0;

  ------------------------------------------
  -- external signal declarations
  ------------------------------------------
  
  signal TX_DDC_OUT_scl_i : STD_LOGIC;
  signal TX_DDC_OUT_scl_o : STD_LOGIC;
  signal TX_DDC_OUT_scl_t : STD_LOGIC;
  signal TX_DDC_OUT_sda_i : STD_LOGIC;
  signal TX_DDC_OUT_sda_o : STD_LOGIC;
  signal TX_DDC_OUT_sda_t : STD_LOGIC;
  signal fmch_iic_scl_i : STD_LOGIC;
  signal fmch_iic_scl_o : STD_LOGIC;
  signal fmch_iic_scl_t : STD_LOGIC;
  signal fmch_iic_sda_i : STD_LOGIC;
  signal fmch_iic_sda_o : STD_LOGIC;
  signal fmch_iic_sda_t : STD_LOGIC;
  
  ------------------------------------------
  -- simple_filter signal declarations
  ------------------------------------------
  
  signal s_axi_aclk : STD_LOGIC;
  signal peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  -- S_AXI interface
  signal M05_AXI_awaddr : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_awprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_awvalid : STD_LOGIC;
  signal M05_AXI_awready : STD_LOGIC;
  signal M05_AXI_wdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_wstrb : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_wvalid : STD_LOGIC;
  signal M05_AXI_wready : STD_LOGIC;
  signal M05_AXI_bresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_bvalid : STD_LOGIC;
  signal M05_AXI_bready : STD_LOGIC;
  signal M05_AXI_araddr : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_arprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_arvalid : STD_LOGIC;
  signal M05_AXI_arready : STD_LOGIC;
  signal M05_AXI_rdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_rresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_rvalid : STD_LOGIC;
  signal M05_AXI_rready : STD_LOGIC;

  ------------------------------------------
  -- fourier transform signal declarations
  ------------------------------------------
  
  signal M07_AXI_awaddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M07_AXI_awprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M07_AXI_awvalid : STD_LOGIC;
  signal M07_AXI_awready : STD_LOGIC;
  signal M07_AXI_wdata : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal M07_AXI_wstrb : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal M07_AXI_wvalid : STD_LOGIC;
  signal M07_AXI_wready : STD_LOGIC;
  signal M07_AXI_bresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M07_AXI_bvalid : STD_LOGIC;
  signal M07_AXI_bready : STD_LOGIC;
  signal M07_AXI_araddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M07_AXI_arprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M07_AXI_arvalid : STD_LOGIC;
  signal M07_AXI_arready : STD_LOGIC;
  signal M07_AXI_rdata : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal M07_AXI_rresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M07_AXI_rvalid : STD_LOGIC;
  signal M07_AXI_rready : STD_LOGIC;    
        
begin

  ------------------------------------------
  -- instantiate IOBUF for TX_DDC_OUT_scl
  ------------------------------------------
  
  TX_DDC_OUT_scl_iobuf: component IOBUF
    port map (
      I => TX_DDC_OUT_scl_o,
      IO => TX_DDC_OUT_scl_io,
      O => TX_DDC_OUT_scl_i,
      T => TX_DDC_OUT_scl_t
    );
    
  ------------------------------------------
  -- instantiate IOBUF for TX_DDC_OUT_sda
  ------------------------------------------
  
  TX_DDC_OUT_sda_iobuf: component IOBUF
    port map (
      I => TX_DDC_OUT_sda_o,
      IO => TX_DDC_OUT_sda_io,
      O => TX_DDC_OUT_sda_i,
      T => TX_DDC_OUT_sda_t
    );
    
  ------------------------------------------
  -- instantiate IOBUF for fmch_iic_scl
  ------------------------------------------
    
  fmch_iic_scl_iobuf: component IOBUF
    port map (
      I => fmch_iic_scl_o,
      IO => fmch_iic_scl_io,
      O => fmch_iic_scl_i,
      T => fmch_iic_scl_t
    );

  ------------------------------------------
  -- instantiate IOBUF for fmch_iic_sda
  ------------------------------------------
  
  fmch_iic_sda_iobuf: component IOBUF
    port map (
      I => fmch_iic_sda_o,
      IO => fmch_iic_sda_io,
      O => fmch_iic_sda_i,
      T => fmch_iic_sda_t
    );

  ------------------------------------------
  -- instantiate block diagram instance
  ------------------------------------------

  zcu102_i: component zcu102
    port map (
      HDMI_TX_CLK_N_OUT => HDMI_TX_CLK_N_OUT,
      HDMI_TX_CLK_P_OUT => HDMI_TX_CLK_P_OUT,
      HDMI_TX_DAT_N_OUT(2 downto 0) => HDMI_TX_DAT_N_OUT(2 downto 0),
      HDMI_TX_DAT_P_OUT(2 downto 0) => HDMI_TX_DAT_P_OUT(2 downto 0),
      LED(7 downto 0) => LED(7 downto 0),
      M05_AXI_araddr(31 downto 0) => M05_AXI_araddr(31 downto 0),
      M05_AXI_arprot(2 downto 0) => M05_AXI_arprot(2 downto 0),
      M05_AXI_arready => M05_AXI_arready,
      M05_AXI_arvalid => M05_AXI_arvalid,
      M05_AXI_awaddr(31 downto 0) => M05_AXI_awaddr(31 downto 0),
      M05_AXI_awprot(2 downto 0) => M05_AXI_awprot(2 downto 0),
      M05_AXI_awready => M05_AXI_awready,
      M05_AXI_awvalid => M05_AXI_awvalid,
      M05_AXI_bready => M05_AXI_bready,
      M05_AXI_bresp(1 downto 0) => M05_AXI_bresp(1 downto 0),
      M05_AXI_bvalid => M05_AXI_bvalid,
      M05_AXI_rdata(31 downto 0) => M05_AXI_rdata(31 downto 0),
      M05_AXI_rready => M05_AXI_rready,
      M05_AXI_rresp(1 downto 0) => M05_AXI_rresp(1 downto 0),
      M05_AXI_rvalid => M05_AXI_rvalid,
      M05_AXI_wdata(31 downto 0) => M05_AXI_wdata(31 downto 0),
      M05_AXI_wready => M05_AXI_wready,
      M05_AXI_wstrb(3 downto 0) => M05_AXI_wstrb(3 downto 0),
      M05_AXI_wvalid => M05_AXI_wvalid,
      M07_AXI_araddr(39 downto 0) => M07_AXI_araddr(39 downto 0),
      M07_AXI_arprot(2 downto 0) => M07_AXI_arprot(2 downto 0),
      M07_AXI_arready => M07_AXI_arready,
      M07_AXI_arvalid => M07_AXI_arvalid,
      M07_AXI_awaddr(39 downto 0) => M07_AXI_awaddr(39 downto 0),
      M07_AXI_awprot(2 downto 0) => M07_AXI_awprot(2 downto 0),
      M07_AXI_awready => M07_AXI_awready,
      M07_AXI_awvalid => M07_AXI_awvalid,
      M07_AXI_bready => M07_AXI_bready,
      M07_AXI_bresp(1 downto 0) => M07_AXI_bresp(1 downto 0),
      M07_AXI_bvalid => M07_AXI_bvalid,
      M07_AXI_rdata(63 downto 0) => M07_AXI_rdata(63 downto 0),
      M07_AXI_rready => M07_AXI_rready,
      M07_AXI_rresp(1 downto 0) => M07_AXI_rresp(1 downto 0),
      M07_AXI_rvalid => M07_AXI_rvalid,
      M07_AXI_wdata(63 downto 0) => M07_AXI_wdata(63 downto 0),
      M07_AXI_wready => M07_AXI_wready,
      M07_AXI_wstrb(7 downto 0) => M07_AXI_wstrb(7 downto 0),
      M07_AXI_wvalid => M07_AXI_wvalid,
      SI5324_LOL_IN => SI5324_LOL_IN,
      SI5324_RST_OUT(0) => SI5324_RST_OUT(0),
      TX_DDC_OUT_scl_i => TX_DDC_OUT_scl_i,
      TX_DDC_OUT_scl_o => TX_DDC_OUT_scl_o,
      TX_DDC_OUT_scl_t => TX_DDC_OUT_scl_t,
      TX_DDC_OUT_sda_i => TX_DDC_OUT_sda_i,
      TX_DDC_OUT_sda_o => TX_DDC_OUT_sda_o,
      TX_DDC_OUT_sda_t => TX_DDC_OUT_sda_t,
      TX_EN_OUT(0) => TX_EN_OUT(0),
      TX_HPD_IN => TX_HPD_IN,
      TX_REFCLK_N_IN => TX_REFCLK_N_IN,
      TX_REFCLK_P_IN => TX_REFCLK_P_IN,
      fmch_iic_scl_i => fmch_iic_scl_i,
      fmch_iic_scl_o => fmch_iic_scl_o,
      fmch_iic_scl_t => fmch_iic_scl_t,
      fmch_iic_sda_i => fmch_iic_sda_i,
      fmch_iic_sda_o => fmch_iic_sda_o,
      fmch_iic_sda_t => fmch_iic_sda_t,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      reset => reset,
      s_axi_aclk => s_axi_aclk
    );
    
  ------------------------------------------
  -- instantiate simple_filter instance
  ------------------------------------------
  
  simple_filter_0: component simple_filter
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001FF",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"98000000",
      C_HIGHADDR => X"9800FFFF",
      C_FAMILY => "virtex6",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      S_AXI_ACLK => s_axi_aclk,
      S_AXI_ARESETN => peripheral_aresetn(0),
      S_AXI_AWADDR(31 downto 0) => M05_AXI_awaddr(31 downto 0),
      S_AXI_AWVALID => M05_AXI_awvalid,
      S_AXI_WDATA(31 downto 0) => M05_AXI_wdata(31 downto 0),
      S_AXI_WSTRB(3 downto 0) => M05_AXI_wstrb(3 downto 0),
      S_AXI_WVALID => M05_AXI_wvalid,
      S_AXI_BREADY => M05_AXI_bready, 
      S_AXI_ARADDR(31 downto 0) => M05_AXI_araddr(31 downto 0),                   
      S_AXI_ARVALID => M05_AXI_arvalid,                 
      S_AXI_RREADY => M05_AXI_rready,                  
      S_AXI_ARREADY => M05_AXI_arready,                 
      S_AXI_RDATA(31 downto 0) => M05_AXI_rdata(31 downto 0),                   
      S_AXI_RRESP(1 downto 0) => M05_AXI_rresp(1 downto 0),                    
      S_AXI_RVALID => M05_AXI_rvalid,            
      S_AXI_WREADY => M05_AXI_wready,               
      S_AXI_BRESP(1 downto 0) => M05_AXI_bresp(1 downto 0),                    
      S_AXI_BVALID => M05_AXI_bvalid,                  
      S_AXI_AWREADY => M05_AXI_awready
    );
    
  ------------------------------------------
  -- instantiate fourier transform instance
  ------------------------------------------
    
  fourier_transform_0: component fourier_transform_v1_0
    generic map(	  
	  C_S00_AXI_DATA_WIDTH => 64,
	  C_S00_AXI_ADDR_WIDTH => 1
	)
	port map (
	  s00_axi_aclk => s_axi_aclk,
	  s00_axi_aresetn => peripheral_aresetn(0),
	  s00_axi_awaddr => M07_AXI_awaddr(0 downto 0),
	  s00_axi_awprot => M07_AXI_awprot(2 downto 0),
	  s00_axi_awvalid => M07_AXI_awvalid,
	  s00_axi_awready => M07_AXI_awready,
	  s00_axi_wdata => M07_AXI_wdata(63 downto 0),
	  s00_axi_wstrb => M07_AXI_wstrb(7 downto 0),
	  s00_axi_wvalid => M07_AXI_wvalid,
	  s00_axi_wready => M07_AXI_wready,
	  s00_axi_bresp => M07_AXI_bresp(1 downto 0),
	  s00_axi_bvalid => M07_AXI_bvalid,
	  s00_axi_bready => M07_AXI_bready,
	  s00_axi_araddr => M07_AXI_araddr(0 downto 0),
	  s00_axi_arprot => M07_AXI_arprot(2 downto 0),
	  s00_axi_arvalid => M07_AXI_arvalid,
	  s00_axi_arready => M07_AXI_arready,
	  s00_axi_rdata => M07_AXI_rdata(63 downto 0),
	  s00_axi_rresp => M07_AXI_rresp(1 downto 0),
	  s00_axi_rvalid => M07_AXI_rvalid,
	  s00_axi_rready => M07_AXI_rready
	);
		
end STRUCTURE;
