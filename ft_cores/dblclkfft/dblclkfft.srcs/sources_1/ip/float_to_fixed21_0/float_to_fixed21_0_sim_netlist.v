// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Feb 22 21:12:09 2021
// Host        : soc running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/soc/Volume/master-thesis/ft_cores/dblclkfft/dblclkfft.srcs/sources_1/ip/float_to_fixed21_0/float_to_fixed21_0_sim_netlist.v
// Design      : float_to_fixed21_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu9eg-ffvb1156-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "float_to_fixed21_0,floating_point_v7_1_6,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "floating_point_v7_1_6,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module float_to_fixed21_0
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
  float_to_fixed21_0_floating_point_v7_1_6 U0
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
(* C_XDEVICEFAMILY = "zynquplus" *) (* ORIG_REF_NAME = "floating_point_v7_1_6" *) (* downgradeipidentifiedwarnings = "yes" *) 
module float_to_fixed21_0_floating_point_v7_1_6
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
  float_to_fixed21_0_floating_point_v7_1_6_viv i_synth
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
DEYfZ9ntEN96qnXfDh98jq+nw6Hvhc3Kp+jUSCi+ylo6zfffB3LZs4k3RaXKMHPjJOc5XIaFwkM5
bRwdNHuUTiEB8cgShJOIkR8sxZRJGqgfc3PtlTH4lJkp4i8XDGARP782M4X1T+UJoLjdJ6tNLzoD
P1iao37t53Eh9Mxay9505OuxRdXe8nxMhAMie8EPHfu3sxZoE8n48XS4esJb4nwfqtqbaLTB++Dp
lWyR6ubdDd2gxRCCkjwXlOa2PYiNiDbMX+izrhLBaOZaLVXCTf1gE7BVcYgG2oqfvfJuclrUU9T1
c0x+K9pv78WrYJfJs26a0kBxZcw4QyfZPVrRgA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ptyq2JDtjXDbfvXecokl/SsJhsmk2JNX861wflEna8NKBcp0lN9AdBZXagQK0pFQKG54RxBQJl/y
fdLLgU1Yu0uyOlV1vrhW620KGuB7IIJdn8eMUXYdaXL3x/4IzNzvuxndeLGIInsa978H46imKsre
7gHLhkCk3RgBiX8/asEjEI/jezn4P7bqCKw2RgXgcP2rtHP+xJfIiUcSYAsOPCIC0VOV3q7r2pZ0
sktSAPwCJgAYb+fjcVaKEfC6IbSwEfSaW4XqbMTYBxp7sxeD5TvoA0p3qgwJriAwabfD8c4qkpd6
PXsm7G72cAXiFhImQ9yjl1feTwae0PXAyzf5iw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 68848)
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
