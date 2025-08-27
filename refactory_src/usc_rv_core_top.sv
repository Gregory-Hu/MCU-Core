




  usc_rv_dec #(
  ) u_rv_dec (
    .inst_vld_f2      (inst_vld_f2[1:0]),
    .inst_rdy_f2      (inst_rdy_f2[1:0]),
    .inst_data_f2     (inst_data_f2[31:0]),
    .inst_info_f2     (inst_info_f2[`USC_RV_FETCH_INFO_W-1:0]), // 1. 2 bits pred info 1 bit fault 1 bit page fault
    .inst_pc_f2       (inst_pc_f2[31:0]), 

    .core_flush       (core_flush),

    .stall_de         (stall_de[1:0]),

    .op0_dec_v_o      (op0_dec_v_o),
    .op0_dec_ctl_o    (op0_dec_ctl_o[`USC_RV_OP_CTL_W]),

    .op1_dec_v_o      (op1_dec_v_o),
    .op1_dec_ctl_o    (op1_dec_ctl_o[`USC_RV_OP_CTL_W]) 
  );


  usc_rv_issue #(
  ) u_rv_issue (

  );

  usc_rv_alu #();

  usc_rv_ls #();

  usc_rv_sys #();