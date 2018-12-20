module Memory_Unit (data_out1, data_out2, address1, address2, clk);

  parameter word_size = 24;
  parameter memory_size = 512;

  input clk;
  input [8: 0] address1, address2;
  output [word_size-1: 0] data_out1, data_out2;

  reg [word_size-1: 0] memory [memory_size-1: 0];

  assign data_out1 = memory[address1];
  assign data_out2 = memory[address2];

endmodule
