// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Feb 22 21:12:07 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim -rename_top dblclkfft_float_to_fixed21_0 -prefix
//               dblclkfft_float_to_fixed21_0_ float_to_fixed21_0_sim_netlist.v
// Design      : float_to_fixed21_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "float_to_fixed21_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module dblclkfft_float_to_fixed21_0
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
  (* C_RESULT_FRACTION_WIDTH = "20" *) 
  (* C_RESULT_TDATA_WIDTH = "24" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "21" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  dblclkfft_float_to_fixed21_0_floating_point_v7_1_6 U0
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
(* C_RESULT_FRACTION_WIDTH = "20" *) (* C_RESULT_TDATA_WIDTH = "24" *) (* C_RESULT_TUSER_WIDTH = "1" *) 
(* C_RESULT_WIDTH = "21" *) (* C_THROTTLE_SCHEME = "3" *) (* C_TLAST_RESOLUTION = "0" *) 
(* C_XDEVICEFAMILY = "zynquplus" *) (* downgradeipidentifiedwarnings = "yes" *) 
module dblclkfft_float_to_fixed21_0_floating_point_v7_1_6
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
  wire [20:0]\^m_axis_result_tdata ;
  wire [0:0]m_axis_result_tuser;
  wire m_axis_result_tvalid;
  wire [31:0]s_axis_a_tdata;
  wire s_axis_a_tvalid;
  wire NLW_i_synth_m_axis_result_tlast_UNCONNECTED;
  wire NLW_i_synth_s_axis_a_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_b_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_c_tready_UNCONNECTED;
  wire NLW_i_synth_s_axis_operation_tready_UNCONNECTED;
  wire [22:20]NLW_i_synth_m_axis_result_tdata_UNCONNECTED;

  assign m_axis_result_tdata[23] = \^m_axis_result_tdata [20];
  assign m_axis_result_tdata[22] = \^m_axis_result_tdata [20];
  assign m_axis_result_tdata[21] = \^m_axis_result_tdata [20];
  assign m_axis_result_tdata[20:0] = \^m_axis_result_tdata [20:0];
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
  (* C_RESULT_FRACTION_WIDTH = "20" *) 
  (* C_RESULT_TDATA_WIDTH = "24" *) 
  (* C_RESULT_TUSER_WIDTH = "1" *) 
  (* C_RESULT_WIDTH = "21" *) 
  (* C_THROTTLE_SCHEME = "3" *) 
  (* C_TLAST_RESOLUTION = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  dblclkfft_float_to_fixed21_0_floating_point_v7_1_6_viv i_synth
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(1'b0),
        .m_axis_result_tdata({\^m_axis_result_tdata [20],NLW_i_synth_m_axis_result_tdata_UNCONNECTED[22:20],\^m_axis_result_tdata [19:0]}),
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
dmkADwxIfqzdkEAGt2VZX+LoQoAa5MG/hPAN3iIZRsY6vSWWlyBbQWrRIoYfo4SS6tvesLRI5Aaq
u5+C+xtKNH3fFlEHnyKAZRzkbXCmI80xYUrXnkzkV60aFWWEdsH9Uwp4DS11jhSr+MqTM9aon822
G9HYDxrDyXYC7Bp55ekDCU7jKoqfkd6TY9K3XWj1hRF3K/BTHM2woYmpEzU1/KTdyPjHfYh4ilqg
XShMDVk6/jOXHPU6oi4CX9HytgbnqBnAhn0NvQvuf8RCtlJkYjIhsSxG410dEnDEDxNpHBWas9Ub
U74D+zPlMkf/j3+V+EqGmy/lvr/D7CTVNPXSvQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
heF/c1/+sy3ZIUdzkcEroVZX7sr5ZLHgxV26UpNnQX+hppFZPWeYv/IvVQpfkZbNeOe2oTqpY3Bk
Dwg9H+Jkg/+DK5OwS98MuyLAqWvfPonvUmvciqw/nyPB6eEXYjpKmTo3fpAKx0dBTtsFVW74GFJv
HyMO3IalNO6vaYDCMMEJriwsk9hlm6AthKyh8pjW/GI9urgDjVOnxcQC+OBwg5xHsG4GC0RrfMeE
odrci0FWfb4OyOpdpQZq4/Q/g6/paOAPnotvlb4SCLjRGDZq9ctHghNOiy7eSomY2czIa/2RmY0W
AVcPDNgpg4EijsufOVI0ZQzsQxarn2QVoo/JNQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 68976)
`pragma protect data_block
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
cCPJ/B0O3JX2xPr+3rC/9tg=
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
