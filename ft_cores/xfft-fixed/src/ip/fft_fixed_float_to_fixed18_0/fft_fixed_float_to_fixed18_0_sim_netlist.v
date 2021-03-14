// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Sun Feb 14 13:45:20 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim -rename_top fft_fixed_float_to_fixed18_0 -prefix
//               fft_fixed_float_to_fixed18_0_ float_to_fixed18_0_sim_netlist.v
// Design      : float_to_fixed18_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "float_to_fixed18_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module fft_fixed_float_to_fixed18_0
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
  fft_fixed_float_to_fixed18_0_floating_point_v7_1_6 U0
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
(* C_XDEVICEFAMILY = "zynquplus" *) (* downgradeipidentifiedwarnings = "yes" *) 
module fft_fixed_float_to_fixed18_0_floating_point_v7_1_6
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
  fft_fixed_float_to_fixed18_0_floating_point_v7_1_6_viv i_synth
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
Si22jN7eEG9ywlKlEZK1c4z4fUXzdUhKN6WeQLFgM2VmRk5ZRtzR5GkKWyh/zwdpGYpcSPBy+nfs
VJhoMv+RQHbM5TswxpYk7+KDLrK6YsSKTjgEjTEc64pleorhN9ADqgPRoJxfMvVyxIFwO+bfYm9n
qL+KSm4K5CBvuPZKXS+A8fVUdMbMB1v/Lz8+PzjTluQqiarGbZ+O6CoJ59QkHyWKdCMsO5qOmhd3
TwRf+VOJgd4WkYw2gqDHGQYEkTCeCKRkDYAgN+pu6OszAr93aguxuinNxM3SJQprwSOike3X2h6D
xI1YZXpB6YPCIMH2ZoZFNk1L0TEtPfcWc/Qdcg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
etVLFaI0hwQ7eR+yK8wvdhjT0f8d8SHFn+ExsaoNS83OxqpSy4qKn7/40U5Sou4BLCtJaHLXiniP
GoPkZfX4xSnFrWwvfCdZ9ZXVACzgJORvlMtyeVgMbjbkgsuErZdPW2bPSL2E0FVV+ibQ791BvD4F
CEZhtlNHyt93Tkb6oRI+yskF0YXMvF3HUm6LhT6iLJqkBiW1KolN7UEpW/1ITf2uZdh9Q6k2Euw4
DVhjPv71lslbOtCXOWeDrsmJ5yC2ARyG19Lw22i5U7BDaq1RGrjH0hgIRBny5y6GdL7TZsXxDSTL
s19lvvjRrKzLzeBl0hELnX6X3a/VhcTIJVER3A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 63232)
`pragma protect data_block
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
8VUl8XkNdOgXFQL1qTA=
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
