// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Sat Jan  9 15:38:57 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/soc/Volume/master-thesis/ft_cores/xdft/xdft.srcs/sources_1/ip/float_to_fixed18_0/float_to_fixed18_0_sim_netlist.v
// Design      : float_to_fixed18_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "float_to_fixed18_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module float_to_fixed18_0
   (s_axis_a_tvalid,
    s_axis_a_tdata,
    m_axis_result_tvalid,
    m_axis_result_tdata,
    m_axis_result_tuser);
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_A, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) input s_axis_a_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TDATA" *) input [31:0]s_axis_a_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_RESULT, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) output m_axis_result_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TDATA" *) output [23:0]m_axis_result_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TUSER" *) output [0:0]m_axis_result_tuser;

  wire [17:0]\^m_axis_result_tdata ;
  wire [0:0]m_axis_result_tuser;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_U0_m_axis_result_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_result_tvalid_UNCONNECTED;
  wire NLW_U0_s_axis_a_tready_UNCONNECTED;
  wire NLW_U0_s_axis_b_tready_UNCONNECTED;
  wire NLW_U0_s_axis_c_tready_UNCONNECTED;
  wire NLW_U0_s_axis_operation_tready_UNCONNECTED;
  wire [22:17]NLW_U0_m_axis_result_tdata_UNCONNECTED;

  assign m_axis_result_tdata[23] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[22] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[21] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[20] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[19] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[18] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[17:0] = \^m_axis_result_tdata [17:0];
  assign m_axis_result_tvalid = s_axis_a_tvalid;
  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "24" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "24" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "24" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "32" *) 
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
  (* C_HAS_FIX_TO_FLT = "0" *) 
  (* C_HAS_FLT_TO_FIX = "1" *) 
  (* C_HAS_FLT_TO_FLT = "0" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "1" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "1" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "17" *) 
  (* C_RESULT_TDATA_WIDTH = "24" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "18" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  float_to_fixed18_0_floating_point_v7_1_6 U0
       (.aclk(1'b0),
        .aclken(1'b1),
        .aresetn(1'b1),
        .m_axis_result_tdata({\^m_axis_result_tdata [17],NLW_U0_m_axis_result_tdata_UNCONNECTED[22:17],\^m_axis_result_tdata [16:0]}),
        .m_axis_result_tlast(NLW_U0_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(m_axis_result_tuser),
        .m_axis_result_tvalid(NLW_U0_m_axis_result_tvalid_UNCONNECTED),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_U0_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(1'b0),
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
(* C_A_FRACTION_WIDTH = "24" *) (* C_A_TDATA_WIDTH = "32" *) (* C_A_TUSER_WIDTH = "1" *) 
(* C_A_WIDTH = "32" *) (* C_BRAM_USAGE = "0" *) (* C_B_FRACTION_WIDTH = "24" *) 
(* C_B_TDATA_WIDTH = "32" *) (* C_B_TUSER_WIDTH = "1" *) (* C_B_WIDTH = "32" *) 
(* C_COMPARE_OPERATION = "8" *) (* C_C_FRACTION_WIDTH = "24" *) (* C_C_TDATA_WIDTH = "32" *) 
(* C_C_TUSER_WIDTH = "1" *) (* C_C_WIDTH = "32" *) (* C_FIXED_DATA_UNSIGNED = "0" *) 
(* C_HAS_ABSOLUTE = "0" *) (* C_HAS_ACCUMULATOR_A = "0" *) (* C_HAS_ACCUMULATOR_S = "0" *) 
(* C_HAS_ACCUM_INPUT_OVERFLOW = "0" *) (* C_HAS_ACCUM_OVERFLOW = "0" *) (* C_HAS_ACLKEN = "0" *) 
(* C_HAS_ADD = "0" *) (* C_HAS_ARESETN = "0" *) (* C_HAS_A_TLAST = "0" *) 
(* C_HAS_A_TUSER = "0" *) (* C_HAS_B = "0" *) (* C_HAS_B_TLAST = "0" *) 
(* C_HAS_B_TUSER = "0" *) (* C_HAS_C = "0" *) (* C_HAS_COMPARE = "0" *) 
(* C_HAS_C_TLAST = "0" *) (* C_HAS_C_TUSER = "0" *) (* C_HAS_DIVIDE = "0" *) 
(* C_HAS_DIVIDE_BY_ZERO = "0" *) (* C_HAS_EXPONENTIAL = "0" *) (* C_HAS_FIX_TO_FLT = "0" *) 
(* C_HAS_FLT_TO_FIX = "1" *) (* C_HAS_FLT_TO_FLT = "0" *) (* C_HAS_FMA = "0" *) 
(* C_HAS_FMS = "0" *) (* C_HAS_INVALID_OP = "0" *) (* C_HAS_LOGARITHM = "0" *) 
(* C_HAS_MULTIPLY = "0" *) (* C_HAS_OPERATION = "0" *) (* C_HAS_OPERATION_TLAST = "0" *) 
(* C_HAS_OPERATION_TUSER = "0" *) (* C_HAS_OVERFLOW = "1" *) (* C_HAS_RECIP = "0" *) 
(* C_HAS_RECIP_SQRT = "0" *) (* C_HAS_RESULT_TLAST = "0" *) (* C_HAS_RESULT_TUSER = "1" *) 
(* C_HAS_SQRT = "0" *) (* C_HAS_SUBTRACT = "0" *) (* C_HAS_UNDERFLOW = "0" *) 
(* C_LATENCY = "0" *) (* C_MULT_USAGE = "0" *) (* C_OPERATION_TDATA_WIDTH = "8" *) 
(* C_OPERATION_TUSER_WIDTH = "1" *) (* C_OPTIMIZATION = "1" *) (* C_RATE = "1" *) 
(* C_RESULT_FRACTION_WIDTH = "17" *) (* C_RESULT_TDATA_WIDTH = "24" *) (* C_RESULT_TUSER_WIDTH = "1" *) 
(* C_RESULT_WIDTH = "18" *) (* C_THROTTLE_SCHEME = "3" *) (* C_TLAST_RESOLUTION = "0" *) 
(* C_XDEVICEFAMILY = "zynquplus" *) (* ORIG_REF_NAME = "floating_point_v7_1_6" *) (* downgradeipidentifiedwarnings = "yes" *) 
module float_to_fixed18_0_floating_point_v7_1_6
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
  output [23:0]m_axis_result_tdata;
  output [0:0]m_axis_result_tuser;
  output m_axis_result_tlast;

  wire \<const0> ;
  wire [23:0]\^m_axis_result_tdata ;
  wire [0:0]m_axis_result_tuser;
  wire [31:0]s_axis_a_tdata;
  wire NLW_i_synth_m_axis_result_tlast_UNCONNECTED;
  wire NLW_i_synth_m_axis_result_tvalid_UNCONNECTED;
  wire NLW_i_synth_s_axis_a_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_b_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_c_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_operation_tready_UNCONNECTED;
  wire [22:17]NLW_i_synth_m_axis_result_tdata_UNCONNECTED;

  assign m_axis_result_tdata[23] = \^m_axis_result_tdata [23];
  assign m_axis_result_tdata[22] = \<const0> ;
  assign m_axis_result_tdata[21] = \<const0> ;
  assign m_axis_result_tdata[20] = \<const0> ;
  assign m_axis_result_tdata[19] = \<const0> ;
  assign m_axis_result_tdata[18] = \<const0> ;
  assign m_axis_result_tdata[17] = \<const0> ;
  assign m_axis_result_tdata[16:0] = \^m_axis_result_tdata [16:0];
  assign m_axis_result_tlast = \<const0> ;
  assign m_axis_result_tvalid = \<const0> ;
  assign s_axis_a_tready = \<const0> ;
  assign s_axis_b_tready = \<const0> ;
  assign s_axis_c_tready = \<const0> ;
  assign s_axis_operation_tready = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_ACCUM_INPUT_MSB = "32" *) 
  (* C_ACCUM_LSB = "-31" *) 
  (* C_ACCUM_MSB = "32" *) 
  (* C_A_FRACTION_WIDTH = "24" *) 
  (* C_A_TDATA_WIDTH = "32" *) 
  (* C_A_TUSER_WIDTH = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_BRAM_USAGE = "0" *) 
  (* C_B_FRACTION_WIDTH = "24" *) 
  (* C_B_TDATA_WIDTH = "32" *) 
  (* C_B_TUSER_WIDTH = "1" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_COMPARE_OPERATION = "8" *) 
  (* C_C_FRACTION_WIDTH = "24" *) 
  (* C_C_TDATA_WIDTH = "32" *) 
  (* C_C_TUSER_WIDTH = "1" *) 
  (* C_C_WIDTH = "32" *) 
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
  (* C_HAS_FIX_TO_FLT = "0" *) 
  (* C_HAS_FLT_TO_FIX = "1" *) 
  (* C_HAS_FLT_TO_FLT = "0" *) 
  (* C_HAS_FMA = "0" *) 
  (* C_HAS_FMS = "0" *) 
  (* C_HAS_INVALID_OP = "0" *) 
  (* C_HAS_LOGARITHM = "0" *) 
  (* C_HAS_MULTIPLY = "0" *) 
  (* C_HAS_OPERATION = "0" *) 
  (* C_HAS_OPERATION_TLAST = "0" *) 
  (* C_HAS_OPERATION_TUSER = "0" *) 
  (* C_HAS_OVERFLOW = "1" *) 
  (* C_HAS_RECIP = "0" *) 
  (* C_HAS_RECIP_SQRT = "0" *) 
  (* C_HAS_RESULT_TLAST = "0" *) 
  (* C_HAS_RESULT_TUSER = "1" *) 
  (* C_HAS_SQRT = "0" *) 
  (* C_HAS_SUBTRACT = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MULT_USAGE = "0" *) 
  (* C_OPERATION_TDATA_WIDTH = "8" *) 
  (* C_OPERATION_TUSER_WIDTH = "1" *) 
  (* C_OPTIMIZATION = "1" *) 
  (* C_RATE = "1" *) 
  (* C_RESULT_FRACTION_WIDTH = "17" *) 
  (* C_RESULT_TDATA_WIDTH = "24" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "18" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  float_to_fixed18_0_floating_point_v7_1_6_viv i_synth
       (.aclk(1'b0),
        .aclken(1'b0),
        .aresetn(1'b0),
        .m_axis_result_tdata(\^m_axis_result_tdata ),
        .m_axis_result_tlast(NLW_i_synth_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(m_axis_result_tuser),
        .m_axis_result_tvalid(NLW_i_synth_m_axis_result_tvalid_UNCONNECTED),
        .s_axis_a_tdata(s_axis_a_tdata),
        .s_axis_a_tlast(1'b0),
        .s_axis_a_tready(NLW_i_synth_s_axis_a_tready_UNCONNECTED),
        .s_axis_a_tuser(1'b0),
        .s_axis_a_tvalid(1'b0),
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
T8euhOKjM52in8Hz68pEd7Mb7Tjg6p14eOR1H3Htl/qGkPamf3pmlMq83bMUT32IlfJV1yM7n6yT
SvrGATD99Yq3///YBn1Y0KsAoM0meb8s3KOyaBAPwxQuGhOsd7vSXvzDWbHneus0hHW2PmJFC226
McIYnS8ceod4/Az+oX8+l1fF0p5YpAzdOx4nfXGLeCZMQV5Y/p+S26hDDPvo6i/56kfmrPEoCtl5
lOj1yaZ93ZShE3/Y2kZHjkc8Nx8z0PeoJ2jx0TF6Q4+jRvKC1YxLi1teSoD6QFLyErjgl+RImFPC
yob5AWpFzmRJt1klgSxDJCC/JF1GAHfPXk5Oyg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PMG/Ar3Kh3ppfMyjZzKNvXx0KjJ+grkc3ALGUFbwHY/M8mxCsjRYNZZNymJSq9SW2ESIZKlXkfnb
vbzKao7J4eQX1LoigEPEFY8Jkj+IpTuqyICJHAIagxHLdQsO4QHtJJIC5PmmLtI7/gb0pyJn8hP9
jjL/9EeQ45z9OSHR1vt1C8JtvVnoGrLbqX8tLMY3WulsrzbdbpraKETmwgdgWrfFUKLskadWbG9h
fLQ3XLN7Sg9KobbFt1rsCkz2U0KOTbD1hpuqKOt4BtGnomjFLDZstWnqmfjYbWVtG86+y/VeuGDq
uUWmverTezV0azPqKhP0Sv6UVGXXKMVajCgW7g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 59664)
`pragma protect data_block
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
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
