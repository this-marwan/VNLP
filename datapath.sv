module Processing_Unit (NORM2, DONE_i, LEN, address1, address2, mem_word1, mem_word2, Load_Add_R, Load_I_R, sel_A1, inc_len,clk, rst);

  output DONE_i;
  output [6:0] LEN;
  output [46:0]NORM2; //38 for mantissa; 9 for the exponent
  output [8:0] address1, address2;

  input Load_Add_R, Load_I_R, sel_A1, inc_len;
  input [23:0] mem_word1, mem_word2;
  input clk, rst;

  wire [8:0] address_out;
  wire [23:0] R0_out, R1_out;

  wire [38:0] R2_out, R3_out;
  wire [38:0] M0_out,M1_out; //the result of squaring

  wire [39:0] N0_out;

  wire [46:0] R4_out;
  wire [46:0] P0_out;
  //General Format
  //Register_Unit R# (output, input, load, clk, rst);

  //registers that will store the memory read
  Register_Unit_24 R0 (R0_out, mem_word1, Load_I_R, clk, rst); //X
  Register_Unit_24 R1 (R1_out, mem_word2, Load_I_R, clk, rst); //Y

  Address_Register A1 (address_out, mem_word1[8:0], Load_Add_R, clk, rst);
  Multiplexer_2ch Mux_1 (address1, address_out, address_out+2, sel_A1); //to choose if address1 is base or base+2
  assign address2 = address_out + 3;

  Link_Len L1 (LEN,inc_len, clk, rst); //indicates how many links we've traversed
  D_flop D1 (DONE_i,~|mem_word1[8:0],Load_Add_R,rst); //indicates if the list has been exhausted  -the next address is 0

  //squaring of X and Y (stored in R2 and R3 respectively)
  square_float_15_8 M0 (M0_out,R0_out);
  square_float_15_8 M1 (M1_out,R1_out);


  Register_Unit_39 R2 (R2_out, M0_out, Load_I_R, clk, rst); //X^2
  Register_Unit_39 R3 (R3_out, M1_out, Load_I_R, clk, rst); //Y^2


  //addition of two numbers
  add_30_9 N0 (N0_out,R2_out,R3_out);

  //accumulate the results

  accumulate P0 (P0_out, R4_out, N0_out);
  Register_Unit_47 R4 (R4_out, P0_out, Load_I_R, clk, rst);
  assign NORM2 = R4_out; //final answer

endmodule // Processing_Unit

module Register_Unit_24 (data_out, data_in, load, clk, rst);
  parameter word_size = 24;
  output [word_size-1: 0] data_out;
  input [word_size-1: 0] data_in;
  input load, clk, rst;
  reg [word_size-1: 0] data_out;
  always @ (posedge clk or negedge rst)
  if (rst == 0) data_out <= 0; else if (load == 1) data_out <= data_in;
endmodule
module Register_Unit_39 (data_out, data_in, load, clk, rst);
  parameter word_size = 39;
  output [word_size-1: 0] data_out;
  input [word_size-1: 0] data_in;
  input load, clk, rst;
  reg [word_size-1: 0] data_out;
  always @ (posedge clk or negedge rst)
  if (rst == 0) data_out <= 0; else if (load == 1) data_out <= data_in;
endmodule
module Register_Unit_47 (data_out, data_in, load, clk, rst);
  parameter word_size = 47;
  output [word_size-1: 0] data_out;
  input [word_size-1: 0] data_in;
  input load, clk, rst;
  reg [word_size-1: 0] data_out;
  always @ (posedge clk or negedge rst)
  if (rst == 0) data_out <= 0; else if (load == 1) data_out <= data_in;
endmodule

module D_flop (data_out, data_in, clk, rst);
  output data_out;
  input data_in;
  input clk, rst;
  reg data_out;
  always @ (posedge clk or negedge rst)
    if (rst == 0) data_out <= 0; else data_out <= data_in;
endmodule //mainly used to indicate operation is done -
module Address_Register (data_out, data_in, load, clk, rst);//holds value of current/next base
  parameter word_size = 9;
  output [word_size-1: 0] data_out;
  input [word_size-1: 0] data_in;
  input load, clk, rst;
  reg [word_size-1: 0] data_out;
  always @ (posedge clk or negedge rst)
    if (rst == 0) data_out <= 0; else if (load) data_out <= data_in;
endmodule
module Link_Len (count, inc_len, clk, rst); //incrementer for number of links
  parameter word_size = 7; //max size of linked list is 128 nodes
  input inc_len, clk, rst;
  output reg [word_size-1: 0] count;

  always @ (posedge clk or negedge rst)
    begin if (rst == 0) count <= 0; else if (inc_len) count <= count +1;
  end

endmodule
module Multiplexer_2ch (mux_out, data_a, data_b, sel);// for selecting address1 (whether to load value of X or the next base)
  parameter word_size = 9;
  output [word_size-1: 0] mux_out;
  input [word_size-1: 0] data_a, data_b;
  input sel;
  assign mux_out = (sel == 0) ? data_a:
    (sel == 1) ? data_b:'bx;
endmodule

//need review
module square_float_15_8 (product,data_in);
  input [23:0] data_in;
  //we're squaring mantissa (result is 15x2 bits) and adding exponents (result is 8+1 bits)
  //we're ignoring the sign bit
  output [38:0] product;

  assign product[38:9] = data_in[22:8]*data_in[22:8];
  assign product[8:0] = data_in[7:0] + data_in[7:0];
endmodule
module add_30_9(result,data_in1,data_in2);//self-explanatory
  parameter word_size = 39;
  output [word_size:0] result;
  input [word_size-1:0] data_in1,data_in2;

  wire comparator;//tells us which exponenet is smaller
  assign comparator = (data_in1[8:0] <= data_in2[8:0]) ? 1: 0;

  wire [8:0] dif1 = data_in2[8:0] - data_in1[8:0]; //amount we have to shift if data_in2 is bigger
  wire [8:0] dif2 = data_in1[8:0] - data_in2[8:0]; //amount we have to shift if data_in1 is bigger

  wire [30:0] data_in1_shifted, data_in2_shifted;
  assign data_in1_shifted = data_in1[38:9]>>dif1;
  assign data_in2_shifted = data_in2[38:9]>>dif2;

  assign result [39:9] = comparator ? //check exponent size
                  (data_in1_shifted + data_in2[word_size-1:9]) :
                  (data_in2_shifted + data_in1[word_size-1:9]);

  //the exponent will be the largest of the two + 1 (the one is added since the result has an extra bit MSB that needs to be accounted for)
  assign result[8:0] =  (data_in1[8:0] <= data_in2[8:0]) ? //check exponent size
                  data_in2[8:0]+1:
                  (data_in1[8:0] > data_in2[8:0]) ?
                  data_in1[8:0]+1:
                  'bx;

endmodule
// A note about adding; If you choose to add by matching the lowest exponent, you'll have to left shift
// the number with the highest exponenet. In the case there is no room for shifting, you'll lose the MSB and
// and the math won't make sense
// Solution: add more space for right-shifting - not so practical
//
// If you choose to add by matching the highest exponent; you'll have to right shift
// the number with lowest exponenet. In this case you'll lose the LSB and hence some precision
// this implementation is less precise but simpler to execute.
//
// Adding a one to the exponent might seem to present a problem as the output is accumulate before
// real data is available, this is will NOT affect us in any way since the mantissa is still 0

module accumulate(result,data_in1,data_in2_i);//result is: mantissa is 38-bits; exponenet remains 9
  parameter word_size = 47;
  output [word_size-1:0] result;
  input [word_size-1:0] data_in1;
  input [39:0] data_in2_i;
  wire [word_size-1:0] data_in2 = {data_in2_i[39:9],7'b0000000,data_in2_i[8:0]};
  wire comparator;//tells us which exponenet is smaller
  assign comparator = (data_in1[8:0] <= data_in2[8:0]) ? 1: 0;

  wire [8:0] dif1 = data_in2[8:0] - data_in1[8:0] + 1; //amount we have to shift if data_in2 is bigger
  wire [8:0] dif2 = data_in1[8:0] - data_in2[8:0] + 1; //amount we have to shift if data_in1 is bigger

  wire [word_size-1:9] data_in1_shifted, data_in2_shifted;
  assign data_in1_shifted = data_in1[46:9]>>dif1;
  assign data_in2_shifted = data_in2[46:9]>>dif2;

  assign result [46:9] = comparator ? //check exponent size
                  (data_in1_shifted + (data_in2[word_size-1:9]>>1)) :
                  (data_in2_shifted + (data_in1[word_size-1:9]>>1));

  //the exponent will be the largest of the two (the one is added since the result has an extra bit MSB that needs to be accounted for)
  assign result[8:0] =  (data_in1[8:0] <= data_in2[8:0]) ? //check exponent size
                  data_in2[8:0] + result[46] + 1:
                  (data_in1[8:0] > data_in2[8:0]) ?
                  data_in1[8:0] + result[46] + 1:
                  'bx;

endmodule
