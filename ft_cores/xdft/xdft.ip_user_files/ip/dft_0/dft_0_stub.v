// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Sat Jan  9 14:21:35 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/soc/Volume/master-thesis/ft_cores/xdft/xdft.srcs/sources_1/ip/dft_0/dft_0_stub.v
// Design      : dft_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dft_v4_0_15,Vivado 2018.1" *)
module dft_0(CLK, SCLR, XN_RE, XN_IM, FD_IN, FWD_INV, SIZE, RFFD, 
  XK_RE, XK_IM, BLK_EXP, FD_OUT, DATA_VALID)
/* synthesis syn_black_box black_box_pad_pin="CLK,SCLR,XN_RE[15:0],XN_IM[15:0],FD_IN,FWD_INV,SIZE[5:0],RFFD,XK_RE[15:0],XK_IM[15:0],BLK_EXP[3:0],FD_OUT,DATA_VALID" */;
  input CLK;
  input SCLR;
  input [15:0]XN_RE;
  input [15:0]XN_IM;
  input FD_IN;
  input FWD_INV;
  input [5:0]SIZE;
  output RFFD;
  output [15:0]XK_RE;
  output [15:0]XK_IM;
  output [3:0]BLK_EXP;
  output FD_OUT;
  output DATA_VALID;
endmodule
