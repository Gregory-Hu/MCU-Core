module biriscv_decode

// Params
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter EXTRA_DECODE_STAGE = 0
)

// Ports
(
  input wire clk_i,
  input wire rstn_i,

);



module biriscv_decode

// Params
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter EXTRA_DECODE_STAGE = 0
)

// Ports
(
    // Inputs
  input wire [1:0] inst_vld_f2,
  input wire [31:0] inst_data_f2[1:0],
  input wire [`USC_RV_FETCH_INFO_W-1:0] inst_info_f2,
  input wire [31:0] inst_pc_f2, 
  

);



    reg [100:0] fetch_buffer_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        fetch_buffer_q <= 101'b0;
    else if (branch_request_i)
        fetch_buffer_q <= 101'b0;
    else if (!fetch_in_valid_w || fetch_in_accept_o)
        fetch_buffer_q <= {fetch_in_fault_page_i, fetch_in_fault_fetch_i, fetch_in_pred_branch_i, fetch_in_instr_i, fetch_in_pc_i, fetch_in_valid_i};

    assign {fetch_in_fault_page_w, 
            fetch_in_fault_fetch_w, 
            fetch_in_pred_branch_w, 
            fetch_in_instr_raw_w, 
            fetch_in_pc_w, 
            fetch_in_valid_w} = fetch_buffer_q;

    assign fetch_in_instr_w = (fetch_in_fault_page_w | fetch_in_fault_fetch_w) ? 64'b0 : fetch_in_instr_raw_w;

    wire [7:0] info0_in_w;
    wire [9:0] info0_out_w;
    wire [7:0] info1_in_w;
    wire [9:0] info1_out_w;


    biriscv_decoder
    u_dec0
    (
         .valid_i(fetch_in_valid_w)
        ,.fetch_fault_i(fetch_in_fault_fetch_w | fetch_in_fault_page_w)
        ,.enable_muldiv_i(enable_muldiv_w)
        ,.opcode_i(fetch_in_instr_w[31:0])

        ,.invalid_o(info0_in_w[7])
        ,.exec_o(info0_in_w[6])
        ,.lsu_o(info0_in_w[5])
        ,.branch_o(info0_in_w[4])
        ,.mul_o(info0_in_w[3])
        ,.div_o(info0_in_w[2])
        ,.csr_o(info0_in_w[1])
        ,.rd_valid_o(info0_in_w[0])
    );

    biriscv_decoder
    u_dec1
    (
         .valid_i(fetch_in_valid_w)
        ,.fetch_fault_i(fetch_in_fault_fetch_w | fetch_in_fault_page_w)
        ,.enable_muldiv_i(enable_muldiv_w)
        ,.opcode_i(fetch_in_instr_w[63:32])

        ,.invalid_o(info1_in_w[7])
        ,.exec_o(info1_in_w[6])
        ,.lsu_o(info1_in_w[5])
        ,.branch_o(info1_in_w[4])
        ,.mul_o(info1_in_w[3])
        ,.div_o(info1_in_w[2])
        ,.csr_o(info1_in_w[1])
        ,.rd_valid_o(info1_in_w[0])
    );

    fetch_fifo
    #( .OPC_INFO_W(10) )
    u_fifo
    (
         .clk_i(clk_i)
        ,.rst_i(rst_i)

        ,.flush_i(branch_request_i)

        // Input side
        ,.push_i(fetch_in_valid_w)
        ,.pc_in_i(fetch_in_pc_w)
        ,.pred_in_i(fetch_in_pred_branch_w)
        ,.data_in_i(fetch_in_instr_w)
        ,.info0_in_i({info0_in_w, fetch_in_fault_page_w, fetch_in_fault_fetch_w})
        ,.info1_in_i({info1_in_w, fetch_in_fault_page_w, fetch_in_fault_fetch_w})
        ,.accept_o(fetch_in_accept_o)

        // Outputs
        ,.valid0_o(fetch_out0_valid_o)
        ,.pc0_out_o(fetch_out0_pc_o)
        ,.data0_out_o(fetch_out0_instr_o)
        ,.info0_out_o({fetch_out0_instr_invalid_o, fetch_out0_instr_exec_o,
                       fetch_out0_instr_lsu_o,     fetch_out0_instr_branch_o,
                       fetch_out0_instr_mul_o,     fetch_out0_instr_div_o,
                       fetch_out0_instr_csr_o,     fetch_out0_instr_rd_valid_o,
                       fetch_out0_fault_page_o,    fetch_out0_fault_fetch_o})
        ,.pop0_i(fetch_out0_accept_i)

        ,.valid1_o(fetch_out1_valid_o)
        ,.pc1_out_o(fetch_out1_pc_o)
        ,.data1_out_o(fetch_out1_instr_o)
        ,.info1_out_o({fetch_out1_instr_invalid_o, fetch_out1_instr_exec_o,
                       fetch_out1_instr_lsu_o,     fetch_out1_instr_branch_o,
                       fetch_out1_instr_mul_o,     fetch_out1_instr_div_o,
                       fetch_out1_instr_csr_o,     fetch_out1_instr_rd_valid_o,
                       fetch_out1_fault_page_o,    fetch_out1_fault_fetch_o})
        ,.pop1_i(fetch_out1_accept_i)
    );
end

endgenerate

endmodule
