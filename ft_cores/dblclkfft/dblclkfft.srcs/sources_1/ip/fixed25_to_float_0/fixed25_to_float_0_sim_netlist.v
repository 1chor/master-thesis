// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Feb 22 21:22:12 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/soc/Volume/master-thesis/ft_cores/dblclkfft/dblclkfft.srcs/sources_1/ip/fixed25_to_float_0/fixed25_to_float_0_sim_netlist.v
// Design      : fixed25_to_float_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "fixed25_to_float_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module fixed25_to_float_0
   (aclk,
    s_axis_a_tvalid,
    s_axis_a_tdata,
    m_axis_result_tvalid,
    m_axis_result_tdata);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_OPERATION:M_AXIS_RESULT:S_AXIS_C:S_AXIS_B:S_AXIS_A, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 10000000, PHASE 0.000" *) input aclk;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_A, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) input s_axis_a_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TDATA" *) input [31:0]s_axis_a_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_RESULT, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) output m_axis_result_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TDATA" *) output [31:0]m_axis_result_tdata;

  wire aclk;
  wire [31:0]m_axis_result_tdata;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_U0_m_axis_result_tlast_UNCONNECTED;
  wire NLW_U0_s_axis_a_tready_UNCONNECTED;
  wire NLW_U0_s_axis_b_tready_UNCONNECTED;
  wire NLW_U0_s_axis_c_tready_UNCONNECTED;
  wire NLW_U0_s_axis_operation_tready_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_result_tuser_UNCONNECTED;

  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "17" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "25" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "17" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "25" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "17" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "25" *) 
  (* C_FIXED_DATA_UNSIGNED = "0" *) 
  (* C_HAS_ABSOLUTE = "0" *) 
  (* C_HAS_ACCUMULATOR_A = "0" *) 
  (* C_HAS_ACCUMULATOR_S = "0" *) 
  (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
  (* C_HAS_ACCUM_OVERFLOW = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ADD = "0" *) 
  (* C_HAS_ARESETN = "0" *) 
  (* C_HAS_A_TLAST = "0" *) 
  (* C_HAS_A_TUSER = "0" *) 
  (* C_HAS_B = "0" *) 
  (* C_HAS_B_TLAST = "0" *) 
  (* C_HAS_B_TUSER = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_COMPARE = "0" *) 
  (* C_HAS_C_TLAST = "0" *) 
  (* C_HAS_C_TUSER = "0" *) 
  (* C_HAS_DIVIDE = "0" *) 
  (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
  (* C_HAS_EXPONENTIAL = "0" *) 
  (* C_HAS_FIX_TO_FLT = "1" *) 
  (* C_HAS_FLT_TO_FIX = "0" *) 
  (* C_HAS_FLT_TO_FLT = "0" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "0" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "24" *) 
  (* C_RESULT_TDATA_WIDTH = "32" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "32" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  fixed25_to_float_0_floating_point_v7_1_6 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(1'b1),
        .m_axis_result_tdata(m_axis_result_tdata),
        .m_axis_result_tlast(NLW_U0_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(NLW_U0_m_axis_result_tuser_UNCONNECTED[0]),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_U0_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(s_axis_a_tvalid),
        .s_axis_b_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_b_tlast(1'b0),
        .s_axis_b_tready(NLW_U0_s_axis_b_tready_UNCONNECTED),
        .s_axis_b_tuser(1'b0),
        .s_axis_b_tvalid(1'b0),
        .s_axis_c_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_c_tlast(1'b0),
        .s_axis_c_tready(NLW_U0_s_axis_c_tready_UNCONNECTED),
        .s_axis_c_tuser(1'b0),
        .s_axis_c_tvalid(1'b0),
        .s_axis_operation_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_operation_tlast(1'b0),
        .s_axis_operation_tready(NLW_U0_s_axis_operation_tready_UNCONNECTED),
        .s_axis_operation_tuser(1'b0),
        .s_axis_operation_tvalid(1'b0));
endmodule

(* C_ACCUM_INPUT_MSB = "32" *) (* C_ACCUM_LSB = "-31" *) (* C_ACCUM_MSB = "32" *) 
(* C_A_FRACTION_WIDTH = "17" *) (* C_A_TDATA_WIDTH = "32" *) (* C_A_TUSER_WIDTH = "1" *) 
(* C_A_WIDTH = "25" *) (* C_BRAM_USAGE = "0" *) (* C_B_FRACTION_WIDTH = "17" *) 
(* C_B_TDATA_WIDTH = "32" *) (* C_B_TUSER_WIDTH = "1" *) (* C_B_WIDTH = "25" *) 
(* C_COMPARE_OPERATION = "8" *) (* C_C_FRACTION_WIDTH = "17" *) (* C_C_TDATA_WIDTH = "32" *) 
(* C_C_TUSER_WIDTH = "1" *) (* C_C_WIDTH = "25" *) (* C_FIXED_DATA_UNSIGNED = "0" *) 
(* C_HAS_ABSOLUTE = "0" *) (* C_HAS_ACCUMULATOR_A = "0" *) (* C_HAS_ACCUMULATOR_S = "0" *) 
(* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) (* C_HAS_ACCUM_OVERFLOW = "0" *) (* C_HAS_ACLKEN = "0" *) 
(* C_HAS_ADD = "0" *) (* C_HAS_ARESETN = "0" *) (* C_HAS_A_TLAST = "0" *) 
(* C_HAS_A_TUSER = "0" *) (* C_HAS_B = "0" *) (* C_HAS_B_TLAST = "0" *) 
(* C_HAS_B_TUSER = "0" *) (* C_HAS_C = "0" *) (* C_HAS_COMPARE = "0" *) 
(* C_HAS_C_TLAST = "0" *) (* C_HAS_C_TUSER = "0" *) (* C_HAS_DIVIDE = "0" *) 
(* C_HAS_DIVIDE_BY_ZERO = "0" *) (* C_HAS_EXPONENTIAL = "0" *) (* C_HAS_FIX_TO_FLT = "1" *) 
(* C_HAS_FLT_TO_FIX = "0" *) (* C_HAS_FLT_TO_FLT = "0" *) (* C_HAS_FMA = "0" *) 
(* C_HAS_FMS = "0" *) (* C_HAS_INVALID_OP = "0" *) (* C_HAS_LOGARITHM = "0" *) 
(* C_HAS_MULTIPLY = "0" *) (* C_HAS_OPERATION = "0" *) (* C_HAS_OPERATION_TLAST = "0" *) 
(* C_HAS_OPERATION_TUSER = "0" *) (* C_HAS_OVERFLOW = "0" *) (* C_HAS_RECIP = "0" *) 
(* C_HAS_RECIP_SQRT = "0" *) (* C_HAS_RESULT_TLAST = "0" *) (* C_HAS_RESULT_TUSER = "0" *) 
(* C_HAS_SQRT = "0" *) (* C_HAS_SUBTRACT = "0" *) (* C_HAS_UNDERFLOW = "0" *) 
(* C_LATENCY = "1" *) (* C_MULT_USAGE = "0" *) (* C_OPERATION_TDATA_WIDTH = "8" *) 
(* C_OPERATION_TUSER_WIDTH = "1" *) (* C_OPTIMIZATION = "1" *) (* C_RATE = "1" *) 
(* C_RESULT_FRACTION_WIDTH = "24" *) (* C_RESULT_TDATA_WIDTH = "32" *) (* C_RESULT_TUSER_WIDTH = "1" *) 
(* C_RESULT_WIDTH = "32" *) (* C_THROTTLE_SCHEME = "3" *) (* C_TLAST_RESOLUTION = "0" *) 
(* C_XDEVICEFAMILY = "zynquplus" *) (* ORIG_REF_NAME = "floating_point_v7_1_6" *) (* downgradeipidentifiedwarnings = "yes" *) 
module fixed25_to_float_0_floating_point_v7_1_6
   (aclk,
    aclken,
    aresetn,
    s_axis_a_tvalid,
    s_axis_a_tready,
    s_axis_a_tdata,
    s_axis_a_tuser,
    s_axis_a_tlast,
    s_axis_b_tvalid,
    s_axis_b_tready,
    s_axis_b_tdata,
    s_axis_b_tuser,
    s_axis_b_tlast,
    s_axis_c_tvalid,
    s_axis_c_tready,
    s_axis_c_tdata,
    s_axis_c_tuser,
    s_axis_c_tlast,
    s_axis_operation_tvalid,
    s_axis_operation_tready,
    s_axis_operation_tdata,
    s_axis_operation_tuser,
    s_axis_operation_tlast,
    m_axis_result_tvalid,
    m_axis_result_tready,
    m_axis_result_tdata,
    m_axis_result_tuser,
    m_axis_result_tlast);
  input aclk;
  input aclken;
  input aresetn;
  input s_axis_a_tvalid;
  output s_axis_a_tready;
  input [31:0]s_axis_a_tdata;
  input [0:0]s_axis_a_tuser;
  input s_axis_a_tlast;
  input s_axis_b_tvalid;
  output s_axis_b_tready;
  input [31:0]s_axis_b_tdata;
  input [0:0]s_axis_b_tuser;
  input s_axis_b_tlast;
  input s_axis_c_tvalid;
  output s_axis_c_tready;
  input [31:0]s_axis_c_tdata;
  input [0:0]s_axis_c_tuser;
  input s_axis_c_tlast;
  input s_axis_operation_tvalid;
  output s_axis_operation_tready;
  input [7:0]s_axis_operation_tdata;
  input [0:0]s_axis_operation_tuser;
  input s_axis_operation_tlast;
  output m_axis_result_tvalid;
  input m_axis_result_tready;
  output [31:0]m_axis_result_tdata;
  output [0:0]m_axis_result_tuser;
  output m_axis_result_tlast;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire [31:0]\^m_axis_result_tdata ;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_i_synth_m_axis_result_tlast_UNCONNECTED;
  wire NLW_i_synth_s_axis_a_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_b_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_c_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_operation_tready_UNCONNECTED;
  wire [28:28]NLW_i_synth_m_axis_result_tdata_UNCONNECTED;
  wire [0:0]NLW_i_synth_m_axis_result_tuser_UNCONNECTED;

  assign m_axis_result_tdata[31:30] = \^m_axis_result_tdata [31:30];
  assign m_axis_result_tdata[29] = \^m_axis_result_tdata [28];
  assign m_axis_result_tdata[28:0] = \^m_axis_result_tdata [28:0];
  assign m_axis_result_tlast = \<const0> ;
  assign m_axis_result_tuser[0] = \<const0> ;
  assign s_axis_a_tready = \<const1> ;
  assign s_axis_b_tready = \<const1> ;
  assign s_axis_c_tready = \<const1> ;
  assign s_axis_operation_tready = \<const1> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "17" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "25" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "17" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "25" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "17" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "25" *) 
  (* C_FIXED_DATA_UNSIGNED = "0" *) 
  (* C_HAS_ABSOLUTE = "0" *) 
  (* C_HAS_ACCUMULATOR_A = "0" *) 
  (* C_HAS_ACCUMULATOR_S = "0" *) 
  (* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) 
  (* C_HAS_ACCUM_OVERFLOW = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ADD = "0" *) 
  (* C_HAS_ARESETN = "0" *) 
  (* C_HAS_A_TLAST = "0" *) 
  (* C_HAS_A_TUSER = "0" *) 
  (* C_HAS_B = "0" *) 
  (* C_HAS_B_TLAST = "0" *) 
  (* C_HAS_B_TUSER = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_COMPARE = "0" *) 
  (* C_HAS_C_TLAST = "0" *) 
  (* C_HAS_C_TUSER = "0" *) 
  (* C_HAS_DIVIDE = "0" *) 
  (* C_HAS_DIVIDE_BY_ZERO = "0" *) 
  (* C_HAS_EXPONENTIAL = "0" *) 
  (* C_HAS_FIX_TO_FLT = "1" *) 
  (* C_HAS_FLT_TO_FIX = "0" *) 
  (* C_HAS_FLT_TO_FLT = "0" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "0" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "24" *) 
  (* C_RESULT_TDATA_WIDTH = "32" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "32" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  fixed25_to_float_0_floating_point_v7_1_6_viv i_synth
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(1'b0),
        .m_axis_result_tdata({\^m_axis_result_tdata [31:30],\^m_axis_result_tdata [28],NLW_i_synth_m_axis_result_tdata_UNCONNECTED[28],\^m_axis_result_tdata [27:0]}),
        .m_axis_result_tlast(NLW_i_synth_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(NLW_i_synth_m_axis_result_tuser_UNCONNECTED[0]),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axis_a_tdata[24:0]}),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_i_synth_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(s_axis_a_tvalid),
        .s_axis_b_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_b_tlast(1'b0),
        .s_axis_b_tready(NLW_i_synth_s_axis_b_tready_UNCONNECTED),
        .s_axis_b_tuser(1'b0),
        .s_axis_b_tvalid(1'b0),
        .s_axis_c_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_c_tlast(1'b0),
        .s_axis_c_tready(NLW_i_synth_s_axis_c_tready_UNCONNECTED),
        .s_axis_c_tuser(1'b0),
        .s_axis_c_tvalid(1'b0),
        .s_axis_operation_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_operation_tlast(1'b0),
        .s_axis_operation_tready(NLW_i_synth_s_axis_operation_tready_UNCONNECTED),
        .s_axis_operation_tuser(1'b0),
        .s_axis_operation_tvalid(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
WHF/kh9y9tT9sDHC8k0aIWpXtVxJpejnegadXiKDxzj1ZpZscTsFrNjJ3M2zdT6N8lRlLaEbU3Ir
sd6JWi12RQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
eRkNROo42V2K5E4JfYF62/p/6QFaEKQZsl2HYmf+HyzbjxnwfIhaOZMS7w5z1FmrEhGTPEQXOTwS
fUJyNviKRjzk30qdr0Yew33y991KShPixxUP/KFCmilOWclSfzC2mMZi5A6s7TEXM2B367nOSwku
KbCuJUSPzJJiaRAEpHw=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GhwF2G4GbuqIHxWUWgBx0yPwdmNZ0sLyQJTMH4bwYKTbELScCA6EQkrJ4LapY1SKMdidLy0df9Pj
CeHsgFntAIlj8KuHN6h9HPYEotyX/9Te6p2a8H+tpR6etf9y3xzaH6/qz7e2E3W2wL9LuPh3z8Kn
5T+250hGoB5SSDPb7R05Zo+kHWjV9XC3aRiW9eiKTO0sAnFP/Xf8UWiiU0mvm6CTueEPy8/AnvMV
dPcmGyX5GGCUh3IBfT901OoOtkZpVw2dWvcYBoo1tSBuu3xGcTdaBuVS71QLrMbcvo6xCJ99jpPE
3H7PKS09CeMNVi10e/zBs++GDmsaS5rxE+w5Gg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I91fAAhC09jTkrCVQQKnv0Drtx83idNynnaPdxzs4zKqz4snQtRWtaDP7qrMK+YX6HCjez12kPAx
yLp1XP7K1JI7GUxNhPr9dSmesuLlDqqX4QEdfnAmMyUmPVQWSSZ9iXhWNXE8XPBp1o7UtDG4SdOU
oLd+7leUR5ZahFSn01YF9tvyutpIdfHwAgTGHPyUKLyaVJJMheLAmg20JLv466nUEdDWX+9zR4st
NNyxbvPltgG4KByKfkbPEF55b+do5GgM1IruezGAg5Cht50nLVJovpCF+1QjXvzP3gWi8MXzxNTn
+LUk001USmyrukzhKUHtZ2Lx3ypo8praZ9iT/w==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
sdKBEhuD8P/HOZq5y6ViCxtvmfIs4OA3Fl9CcnL0gANdgkf/OMqz3GzME7Eykqeko1lzgWyz2a3N
1Kva5z4REP7xz3uPmHgCnQX7egSGFgBmV3wpxg1cd5eGmXf49vvA5iC5z0D34PNKpnze05e3kqB/
n3qL2S8inYBeWrMhHwr4Gd/rqA8sF/sa+jeyQ9m6XCotd1PCak14zkr94tS+KSqEGIuGxen3TYAk
bpGCwyYOxM/SHSiRCrLpe44V1yYGZjLID9Krg+DskkGTabtrO6qcMeC3kfu64S/g9jhDxbECZV+1
zn/FdC+r0anpk/BAKoY8FYWgWh8U8LiOcG0xFA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
JByDpNd2N6MI6uzyvl2J3XP025cmH51m7bQhUMWOW17sbD6UUiaRaTSkW8vK0PlFR5J0KybIC67n
htWLpYKc7g3a6pq48qNnOGcwq5e7OGpXvLhZg820KWc4yZJJcW4UA8EpmFevvWP+jKXU6YlDKhzQ
vjSGtMaWFZ6XSBQtS2Y=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bWwaaT9gdiVlK1xRvfTjbBxGsGfnsafgkdPhmGoxAHpjXWhtxHhS+yoTrjdRxE9mWI/4GOvH9xc0
hIYqovqMOknaZe86xRCTn3EYQaKzqfT1A1mnmMZ3JbRYTeMtRQ7NncbCX9fNIQfEzfdDYYq+xInE
8vF7Alg0BGr4hPHj34Pe7VlNMxPGGOsKrEorFLdjAzbNkRmVryjwI0fdzyouOybBBue3gOx14GhD
FhfS4G8ynr1TOUHIGLjJ1kwyRSv73bET09nHcarBXJYE9P8AArk5MrbA3bYF0J6OZyEKixw+tSye
VZ5zN7wE8OdMoUedJ0t3fw/KWmQ8pgzPh2WxiA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ct31Wso+tmhpDBlVGeTDgxU48AZbFEQc1GDzc5VLsaVfW5swu/C1YVxPcFPo4cvNpQwp4t/DfzYs
L0XLblQNovLUx6LkRq2YzauMYdbLsgz7Wjwborq/2yWjCdAa77T0TPdNnG2zbZ9IOr8AZQ/U2Rbc
tjFyBOqIptTXMW39cUpz66FzYQNzZcbNrX/bW4vyDa/Jajje/nUhUwjwb61KJP1/qBv7f74lKxPj
mM3Cl32r3M3J3+vEQOyyag540VnKFigIJ7qwoPc86Q4k8srXYg21P1w5kwhI++aKbppffYT0rHYy
5OLN8Eb4B4R9IXk43RdBhXlR1bDuKPmzKMbFPQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dPkff37wmDDku5pln1vQTgxGcb7Rtu6mGsV9qFjpvUvrlzZq1dhsQ45F9mMjJYIMzJWKkfGsgr6R
BnNk8roEG9M97fnbeFBUX+PEbWWlmqYrj2/i5reTLkSecD4tmyu1jPBvdr3ReU3IHeIsAUBEjxul
jVX4Mb/4x35sRVTR1fdzAAC+mxZPWpHJwi9hofWrsXkh75yDy0tShUfZ/30iL9pieNa2Ko7LfOPn
nIbf2EM5N5zWFbdzYVgX4p3e+EiHkRrYgGZEjoS5TV59DGp4Vd34Ai/EM0japcPLFUqWPCy/DxAB
B6BOeAc1jMR/bQsm9I4ueosXmye1rKlk/wUF6A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 76896)
`pragma protect data_block
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
0gA+
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
