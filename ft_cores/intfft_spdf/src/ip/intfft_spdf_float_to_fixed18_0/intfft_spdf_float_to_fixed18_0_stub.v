// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Sun Mar 14 20:12:33 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/soc/Volume/master-thesis/ft_cores/intfft_spdf/intfft_spdf.srcs/sources_1/ip/intfft_spdf_float_to_fixed18_0/intfft_spdf_float_to_fixed18_0_stub.v
// Design      : intfft_spdf_float_to_fixed18_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *)
module intfft_spdf_float_to_fixed18_0(aclk, s_axis_a_tvalid, s_axis_a_tdata, 
  m_axis_result_tvalid, m_axis_result_tdata, m_axis_result_tuser)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_a_tvalid,s_axis_a_tdata[31:0],m_axis_result_tvalid,m_axis_result_tdata[23:0],m_axis_result_tuser[0:0]" */;
  input aclk;
  input s_axis_a_tvalid;
  input [31:0]s_axis_a_tdata;
  output m_axis_result_tvalid;
  output [23:0]m_axis_result_tdata;
  output [0:0]m_axis_result_tuser;
endmodule
