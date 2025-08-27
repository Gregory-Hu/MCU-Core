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

  input wire [63:0] alu0_res_data,
  input wire [63:0] alu1_res_data,
  input wire [63:0] mc_res_data,
  input wire mc_div_done,

  input wire ld_res_vld,
  input wire [4:0] ld_res_atag,
  input wire [63:0] ld_res_data,

  input wire sys_nonpipe_res_vld,
  input wire [63:0] sys_res_data,


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

  assign iss0_vld_i1_raw = op0_i1_vld_raw | op0_dec_v_o;
  assign iss1_vld_i1_raw = op1_i1_vld_raw | 
                           op0_i1_vld_raw & op_queue_one_left | 
                           op_queue_empty & op1_dec_v_o;

  assign iss0_vld_i1 = iss0_vld_i1_raw & iss0_no_dep;
  assign iss1_vld_i1 = iss1_vld_i1_raw & iss1_no_dep;


  assign iss0_is_alu = & iss0_no_dep

  assign iss0_is_mc

  assign iss0_is_sys 

  assign iss0_is_sys


// ----------------------------------
// int rf 

  usc_rv_int_rf #(
  ) u_rv_int_rf (
    
  );

  usc_rv_iss_fwd #(
  ) u_rv_iss_fwd (


    .alu0_res_data           (alu0_res_data[63:0]),
    .alu1_res_data           (alu1_res_data[63:0]),
    .ld_res_data             (ld_res_data[63:0]),   
    .mc_res_data             (mc_res_data[63:0]),
    .sys_res_data            (sys_res_data[63:0]),
    
    .iss0_imme_data          (iss0_imme_data[63:0]),
    .iss1_imme_data          (iss1_imme_data[63:0]),

    .iss0_src0_fwd_sel       (iss0_src0_fwd_sel[5:0]),
    .iss0_src1_fwd_sel       (iss0_src1_fwd_sel[5:0]),
    .iss1_src0_fwd_sel       (iss0_src0_fwd_sel[5:0]),
    .iss1_src1_fwd_sel       (iss0_src1_fwd_sel[5:0]),

    .int_rf_rd0_data         (int_rf_rd0_data[63:0]),
    .int_rf_rd1_data         (int_rf_rd0_data[63:0]),
    .int_rf_rd2_data         (int_rf_rd0_data[63:0]),
    .int_rf_rd3_data         (int_rf_rd0_data[63:0]),

    .iss0_src0_data          (iss0_src0_data[63:0]),
    .iss0_src1_data          (iss0_src1_data[63:0]),
    .iss1_src0_data          (iss1_src0_data[63:0]),
    .iss1_src0_data          (iss1_src1_data[63:0]),

  );

  usc_rv_iss_dep #(
  ) u_rv_iss_dep (
    
    .iss0_no_dep        ()
    .iss1_no_dep        ()
    
    .iss0_src0_fwd_sel       (iss0_src0_fwd_sel[5:0]),
    .iss0_src1_fwd_sel       (iss0_src1_fwd_sel[5:0]),
    .iss1_src0_fwd_sel       (iss0_src0_fwd_sel[5:0]),
    .iss1_src1_fwd_sel       (iss0_src1_fwd_sel[5:0]),



  );


endmodule 