// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Fri Feb 12 18:57:03 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/soc/Volume/master-thesis/ft_cores/intfftk/intfftk.srcs/sources_1/ip/float_to_fixed18_0/float_to_fixed18_0_sim_netlist.v
// Design      : float_to_fixed18_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "float_to_fixed18_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module float_to_fixed18_0
   (aclk,
    s_axis_a_tvalid,
    s_axis_a_tdata,
    m_axis_result_tvalid,
    m_axis_result_tdata,
    m_axis_result_tuser);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF S_AXIS_OPERATION:M_AXIS_RESULT:S_AXIS_C:S_AXIS_B:S_AXIS_A, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 10000000, PHASE 0.000" *) input aclk;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_A, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) input s_axis_a_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_A TDATA" *) input [31:0]s_axis_a_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_RESULT, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) output m_axis_result_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TDATA" *) output [23:0]m_axis_result_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_RESULT TUSER" *) output [0:0]m_axis_result_tuser;

  wire aclk;
  wire [23:0]m_axis_result_tdata;
  wire [0:0]m_axis_result_tuser;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_U0_m_axis_result_tlast_UNCONNECTED;
  wire NLW_U0_s_axis_a_tready_UNCONNECTED;
  wire NLW_U0_s_axis_b_tready_UNCONNECTED;
  wire NLW_U0_s_axis_c_tready_UNCONNECTED;
  wire NLW_U0_s_axis_operation_tready_UNCONNECTED;

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
  (* C_LATENCY = "1" *) 
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
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(1'b1),
        .m_axis_result_tdata(m_axis_result_tdata),
        .m_axis_result_tlast(NLW_U0_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(m_axis_result_tuser),
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
(* C_LATENCY = "1" *) (* C_MULT_USAGE = "0" *) (* C_OPERATION_TDATA_WIDTH = "8" *) 
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
  wire \<const1> ;
  wire aclk;
  wire [17:0]\^m_axis_result_tdata ;
  wire [0:0]m_axis_result_tuser;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_i_synth_m_axis_result_tlast_UNCONNECTED;
  wire NLW_i_synth_s_axis_a_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_b_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_c_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_operation_tready_UNCONNECTED;
  wire [22:17]NLW_i_synth_m_axis_result_tdata_UNCONNECTED;

  assign m_axis_result_tdata[23] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[22] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[21] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[20] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[19] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[18] = \^m_axis_result_tdata [17];
  assign m_axis_result_tdata[17:0] = \^m_axis_result_tdata [17:0];
  assign m_axis_result_tlast = \<const0> ;
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
  (* C_LATENCY = "1" *) 
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
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(1'b0),
        .m_axis_result_tdata({\^m_axis_result_tdata [17],NLW_i_synth_m_axis_result_tdata_UNCONNECTED[22:17],\^m_axis_result_tdata [16:0]}),
        .m_axis_result_tlast(NLW_i_synth_m_axis_result_tlast_UNCONNECTED),
        .m_axis_result_tready(1'b0),
        .m_axis_result_tuser(m_axis_result_tuser),
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .s_axis_a_tdata(s_axis_a_tdata),
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
KkOTSAqAsYoEgQgeoaXUFdjYhAD3BLzaWcptlpXy88rt1QIpNHfMOXynpzAsC+dcCHUcPAK7A8GX
kmCWiv6EGvpyvaWBvabMrYbymFbps/A0tjGB7TGfXY9AfybpURygp5K3OUpFA4J6gUkT1K7g0QU0
ZfrTLi+5wQE3+F4KVpGYucTTnNhqzNDj7KhOqgaPQiwRs531MdSQoKOYbkDh7DIHa+EDd4R6kZdw
xwjxwJgPyZiTZTzsT+6BXXhEZ5cIKs4seYCrJPGicd+K6n+3czmv/x5Nts59sCIRh63jLWGRWdwG
YSEiWD+QyUzkgMJaBhkX5p5PaPlivsdFhHebcA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wVtoPYFG775EIFsLtNpw3bIpmNHFuOr1N81aVUeCShB3bSe6qE6EqnxLPl5e+espGuTyX1s425d/
ttVsrru1HVNLDtZANJK6SzINlhsSTrvHKDdwndKmQm6NAmpQPzNthBLmOUbYHQEpudV2/UwBotAo
VBqSH5cFkQhVJ3u+MFCRV5XLOXtsGmjjD1RzeTLLTL4o9Y7bGFRvTH2gjWw84+wjMZoiCId1o+MX
PIEBXFPzRvQ/UfAyWgZ1LySY5GPyiCF7ThwjpYU6Q9F0NBsH7+e0sU9T2mxDGMfeCHmaC13iJcon
E+hOxDSNSp1Kn3GVejmlObNv4MI8X0a2+J0K4w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 63104)
`pragma protect data_block
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
fCIXn/Q=
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
