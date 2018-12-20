module VNLP (DONE, NORM2, LEN, START, clk);

  input START, clk;
  output DONE;
  output [6:0]LEN;
  output [46:0]NORM2;
  // Data Nets
  wire [23: 0] mem_word1, mem_word2; //size of word we'll be reading
  wire [8:0] address1, address2; //9-bit address for 512 memory slots
  wire DONE;
  wire DONE_i; //internal wire to tell controller we returned to link 0

  // Control Nets
  wire inc_len, Load_Add_R, Load_I_R, sel_A1;


  Processing_Unit M0_Processor(NORM2, DONE_i, LEN, address1, address2, mem_word1, mem_word2, Load_Add_R, Load_I_R, sel_A1, inc_len,clk, START);

  Control_Unit M1_Controller  (Load_Add_R, Load_I_R, inc_len, DONE, DONE_i,sel_A1, clk, START);

  Memory_Unit M2_MEM (
    .data_out1 (mem_word1),
    .data_out2 (mem_word2),
    .address1 (address1),
    .address2 (address2),
    .clk (clk));

endmodule // VNLP
