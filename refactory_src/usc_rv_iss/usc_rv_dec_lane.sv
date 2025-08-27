
module usc_rv_dec_lane #(
  parameters
) (
  input wire ib_vld_i,
  input wire ib_access_flt_i,
  input wire ib_page_flt_i,
  input wire [31:0] ib_opc_i,

  output wire [`USC_RV_OP_CTL_W] op_ctl_o
);


  assign pla_in_fe_flt = ib_page_flt_i | ib_access_flt_i;
  assign pla_in_opc[31:0] = ib_opc_i[31:0];

  assign op_ctl_o[`USC_RV_OP_CTL_SRC0_V]    = op_src0_v;
  assign op_ctl_o[`USC_RV_OP_CTL_SRC0_ATAG] = op_src0_atag;
  assign op_ctl_o[`USC_RV_OP_CTL_SRC1_V]    = op_src1_v;
  assign op_ctl_o[`USC_RV_OP_CTL_SRC1_ATAG] = op_src_atag;
  assign op_ctl_o[`USC_RV_OP_CTL_DST_V]     = op_dst_v;
  assign op_ctl_o[`USC_RV_OP_CTL_DST_ATAG]  = op_dst_atag;

  assign op_ctl_o[`USC_RV_OP_FU_LS]         = op_type_ls;
  assign op_ctl_o[`USC_RV_OP_FU_ALU]        = op_type_alu;
  assign op_ctl_o[`USC_RV_OP_FU_MULT_CYCLE] = op_type_mc;
  assign op_ctl_o[`USC_RV_OP_FU_SYS]        = op_type_sys;

  /*
  assign op_ctl_o[`USC_RV_OP_FU_FP]         = 1'b0;    
  assign op_ctl_o[`USC_RV_OP_FU_RVV]        = 1'b0;  
  assign op_ctl_o[`USC_RV_OP_FU_DSA]        = 1'b0;
  */

  assign op_ctl_o[`USC_RV_OP_FU_OP_CTL]     = op_fu_op_ctl;

  assign op_ctl_o[`USC_RV_OP_IMME]          = op_imme;



  // espresso pla code gen 



endmodule 