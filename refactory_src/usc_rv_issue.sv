module usc_rv_issue #(
) (
  input wire clk,
  input wire reset_n,

  output wire stall_de,

  input wire op0_dec_v_o,
  input wire [`USC_RV_OP_CTL_W] op0_dec_ctl_o,

  input wire op1_dec_v_o,
  input wire [`USC_RV_OP_CTL_W] op1_dec_ctl_o

  output wire alu_op_vld_o, 
  output wire [`USC_ALU_ISS_OP_CTL] alu_op_ctl_o,
  output wire [31:0] alu_op_src0_o,
  output wire [31:0] alu_op_src1_o,

  output wire mc_op_vld_o, 
  output wire [`USC_ALU_ISS_MC_CTL] mc_op_ctl_o,
  output wire [31:0] mc_op_src0_o,
  output wire [31:0] mc_op_src1_o,

  output wire sys_op_vld_o, 
  output wire [`USC_ALU_ISS_SYS_CTL] sys_op_ctl_o,
  output wire [31:0] sys_op_src0_o,
  output wire [31:0] sys_op_src1_o,

  output wire mc_ls_vld_o, 
  output wire [`USC_ALU_ISS_LS_CTL] mc_ls_ctl_o,
  output wire [31:0] mc_ls_src0_o,
  output wire [31:0] mc_ls_src1_o,
  output wire [31:0] mc_ls_src2_o,


);


// ----------------------------------
// op queue 

  assign iss_byp_op0_is_alu = 
  assign iss_byp_op0_is_mc = 
  assign iss_byp_op0_is_ls = 
  assign iss_byp_op0_is_sys = 


// ----------------------------------
// op issue 
  assign iss0_sel_byp_i1 = op_queue_empty;
  assign iss1_sel_byp_i1 = op_queue_one_left;

  assign iss0_vld_i1 = op0_i1_vld_raw | op0_dec_v_o;
  assign iss1_vld_i1 = op1_i1_vld_raw | 
                       op0_i1_vld_raw & op_queue_one_left | 
                       op_queue_empty & op1_dec_v_o;

// ----------------------------------
// int rf 

  //-----------------------------------------------------------------
  usc_rv_int_rf #(
  ) (

      ,input           clk_i
      ,input           rst_i
      ,input  [  4:0]  rd0_i
      ,input  [  4:0]  rd1_i
      ,input  [ 31:0]  rd0_value_i
      ,input  [ 31:0]  rd1_value_i
      ,input  [  4:0]  ra0_i
      ,input  [  4:0]  rb0_i
      ,input  [  4:0]  ra1_i
      ,input  [  4:0]  rb1_i

      // Outputs
      ,output [ 31:0]  ra0_value_o
      ,output [ 31:0]  rb0_value_o
      ,output [ 31:0]  ra1_value_o
      ,output [ 31:0]  rb1_value_o
  );


endmodule 