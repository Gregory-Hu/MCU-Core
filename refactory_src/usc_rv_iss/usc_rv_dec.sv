
module usc_rv_dec #(
) (
  input wire [1:0] inst_vld_f2,
  output wire [1:0] inst_rdy_f2,
  input wire [31:0] inst_data_f2[1:0],
  input wire [`USC_RV_FETCH_INFO_W-1:0] inst_info_f2, // 1. 2 bits pred info 1 bit fault 1 bit page fault
  input wire [31:0] inst_pc_f2, 

  input wire core_flush,

  input wire [1:0] stall_de,
  
  output wire op0_dec_v_o,
  output wire [`USC_RV_OP_CTL_W] op0_dec_ctl_o,

  output wire op1_dec_v_o,
  output wire [`USC_RV_OP_CTL_W] op1_dec_ctl_o


);

// ------------------------------
// Decode Hierarchy 
// 
//  Memory Data ------> inst buffer --(optional align & crack)--> Op Dec -----> Issue Queue (Dual Wr Port Monopoly)
// ($/Interface)   |--> inst buffer --(optional align & crack)--> Op Dec -----> Issue Byp

// ----------------------------
// inst fetch buffer

  assign inst_rdy_f2[0] = ~inst_de0_vld_q[0] | inst_buf_consume[0];
  assign inst_rdy_f2[1] = ~inst_de0_vld_q[1] | inst_buf_consume[1];

  // inst0 buffer entry
  assign inst_buf_vld_en[0] = inst_de0_vld_q[0] | inst_vld_f2[0] | core_flush;

  assign inst_buf_vld_din[0] = inst_vld_f2[0] | 
                               inst_de0_vld_q[0] & ~(inst_buf_consume[0] | core_flush);

  always_ff @(posedge clk or negedge reset_n) begin 
    if (~reset_n)
      inst_buf_vld_q[0] <= 1'b0;
    else if (inst_buf_vld_en[0]) 
      inst_buf_vld_q[0] <= inst_buf_vld_din[0];
  end 

  assign inst_buf_wr[0] = inst_vld_f2[0] & (~inst_de0_vld_q[0] | inst_buf_consume[0]);

  always_ff @(posedge clk or negedge reset_n) begin 
    if (inst_buf_wr[0]) 
      inst_buf_opc_q[0][31:0] <= inst_data_f2[0][31:0];
  end 

  // inst1 buffer entry
  assign inst_buf_vld_en[1] = inst_de0_vld_q[1] | inst_vld_f2[1];

  assign inst_buf_vld_din[1] = inst_vld_f2[1] | 
                               inst_de0_vld_q[1] & (~inst_buf_consume[1] | core_flush);

  always_ff @(posedge clk or negedge reset_n) begin 
    if (~reset_n)
      inst_buf_vld_q[1] <= 1'b0;
    else if (inst_buf_vld_en[1]) 
      inst_buf_vld_q[1] <= inst_buf_vld_din[1];
  end 

  // save fe flt info 
  assign save_inst_info_f2 = inst_buf_wr[1] | inst_buf_wr[0];

  always_ff @(posedge clk or negedge reset_n) begin 
    if (save_inst_info_f2) 
      inst_buf_info_q[`USC_RV_FETCH_INFO_W-1:0]  <= inst_info_f2[31:0];
  end 


// ---------------------------------------------
// inst buffer read and inst crack/align

  assign inst_buf_consume[0] = ~stall_de[0];
  assign inst_buf_consume[1] = ~stall_de[1];

  assign ib0_rv_opc[31:0] = inst_buf_opc_q[0][31:0];
  assign ib1_rv_opc[31:0] = inst_buf_opc_q[1][31:0];

  assign ib0_vld = inst_buf_vld_q[0];
  assign ib1_vld = inst_buf_vld_q[1];
  
  assign ib0_access_flt = inst_buf_info_q[`USC_RV_FETCH_INFO_ACC_FLT];
  assign ib1_access_flt = inst_buf_info_q[`USC_RV_FETCH_INFO_ACC_FLT];

  assign ib0_page_flt = inst_buf_info_q[`USC_RV_FETCH_INFO_PAGE_FLT];
  assign ib1_page_flt = inst_buf_info_q[`USC_RV_FETCH_INFO_PAGE_FLT];

// ---------------------------------------------
// decode lane

  usc_rv_dec_lane #(
  ) u_dec0 (
    .ib_vld_i(ib0_vld),
    .ib_access_flt_i(ib0_access_flt),
    .ib_page_flt_i(ib0_page_flt),
    .ib_opc_i(ib0_rv_opc[31]),

    .op_ctl_o(rv_op_ctl_dec0[`USC_RV_OP_CTL_W])
  );

  usc_rv_dec_lane #(
  ) u_dec1 (
    .ib_vld_i(ib1_vld),
    .ib_access_flt_i(ib1_access_flt),
    .ib_page_flt_i(ib1_page_flt),
    .ib_opc_i(ib1_rv_opc[31]),

    .op_ctl_o(rv_op_ctl_dec1[`USC_RV_OP_CTL_W])
  );

  assign op0_dec_v_o = ib0_vld;
  assign op1_dec_v_o = ib1_vld;

  assign op0_dec_ctl_o = rv_op_ctl_dec0[`USC_RV_OP_CTL_W];
  assign op1_dec_ctl_o = rv_op_ctl_dec1[`USC_RV_OP_CTL_W];

endmodule
