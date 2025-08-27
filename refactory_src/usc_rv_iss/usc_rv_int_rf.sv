module usc_rv_int_rf #(
) (
  input wire clk, 
  input wire reset_n,

  input wire rd0_vld,
  input wire rd1_vld,
  input wire rd3_vld,
  input wire rd4_vld,

  input wire [4:0] rd0_atag,
  input wire [4:0] rd1_atag,
  input wire [4:0] rd2_atag,
  input wire [4:0] rd3_atag,

  output wire [31:0] rd0_data,
  output wire [31:0] rd1_data,
  output wire [31:0] rd2_data,
  output wire [31:0] rd3_data,

);

  always_comb begin
    rd0_data[31:0] = 32'b0;
    for (integer i=0;i<32;i=i+1)
      rd0_data[31:0] = rd0_data[31:0] | {32{rd0_atag_dec[i]}} & rf_entry_q[i][31:0]; 
  end 

  always_comb begin
    rd1_data[31:0] = 32'b0;
    for (integer i=0;i<32;i=i+1)
      rd1_data[31:0] = rd1_data[31:0] | {32{rd1_atag_dec[i]}} & rf_entry_q[i][31:0]; 
  end 

  always_comb begin
    rd2_data[31:0] = 32'b0;
    for (integer i=0;i<32;i=i+1)
      rd2_data[31:0] = rd2_data[31:0] | {32{rd2_atag_dec[i]}} & rf_entry_q[i][31:0]; 
  end 

  always_comb begin
    rd3_data[31:0] = 32'b0;
    for (integer i=0;i<32;i=i+1)
      rd3_data[31:0] = rd3_data[31:0] | {32{rd3_atag_dec[i]}} & rf_entry_q[i][31:0]; 
  end 

endmodule 