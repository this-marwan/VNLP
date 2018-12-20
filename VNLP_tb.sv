//testbench for the VNLP design
//temporarily replaced forward pointer of link7 to out of bounds
module VNLP_tb;
  reg DONE, START, clk;
  reg [46:0]NORM2;
  reg [6:0]LEN;

  VNLP P1 (DONE, NORM2, LEN, START, clk);

    initial begin
      clk = 0;
      START = 0;

//Link1
      VNLP_tb.P1.M2_MEM.memory[0] = 49;
      VNLP_tb.P1.M2_MEM.memory[1] = 34;
      VNLP_tb.P1.M2_MEM.memory[2] = 24'b1_100001001000000_00000110;//-33.125;
      VNLP_tb.P1.M2_MEM.memory[3] = 24'b0_101111100000000_00000101;//23.75;
//link2
      VNLP_tb.P1.M2_MEM.memory[5] = 17;
      VNLP_tb.P1.M2_MEM.memory[6] = 40;
      VNLP_tb.P1.M2_MEM.memory[7] = 24'b0_100110000100000_00000101;//19.03125;
      VNLP_tb.P1.M2_MEM.memory[8] = 24'b0_110011000000000_00000111;//102.0;
//link3
      VNLP_tb.P1.M2_MEM.memory[11] = 22;
      VNLP_tb.P1.M2_MEM.memory[12] = 18;
      VNLP_tb.P1.M2_MEM.memory[13] = 24'b0_110011000000000_00000101;//25.5;
      VNLP_tb.P1.M2_MEM.memory[14] = 24'b1_101110100100000_00000111;//-93.125;
//link4
      VNLP_tb.P1.M2_MEM.memory[17] = 11;
      VNLP_tb.P1.M2_MEM.memory[18] = 6;
      VNLP_tb.P1.M2_MEM.memory[19] = 24'b0_100000100000000_00000100;//8.125;
      VNLP_tb.P1.M2_MEM.memory[20] = 24'b0_101101000011000_00000111;//90.09375;
//link5
      VNLP_tb.P1.M2_MEM.memory[22] = 33;
      VNLP_tb.P1.M2_MEM.memory[23] = 12;
      VNLP_tb.P1.M2_MEM.memory[24] = 24'b0_111110100100000_00000101;//31.28125;
      VNLP_tb.P1.M2_MEM.memory[25] = 24'b0_100000010110000_00000110;//32.34375;
//Link6
      VNLP_tb.P1.M2_MEM.memory[28] = 102;
      VNLP_tb.P1.M2_MEM.memory[29] = 240;
      VNLP_tb.P1.M2_MEM.memory[30] = 24'b0_101111000100000_00000110;//47.0625;
      VNLP_tb.P1.M2_MEM.memory[31] = 24'b1_101101111000000_00000100;//-11.46875;
//link7
      VNLP_tb.P1.M2_MEM.memory[33] = 0;
      VNLP_tb.P1.M2_MEM.memory[34] = 23;
      VNLP_tb.P1.M2_MEM.memory[35] = 24'b0_110011100000000_00000101;//25.75;
      VNLP_tb.P1.M2_MEM.memory[36] = 24'b0_101100000100000_00000111;//88.125;
//link8
      VNLP_tb.P1.M2_MEM.memory[39] = 5;
      VNLP_tb.P1.M2_MEM.memory[40] = 50;
      VNLP_tb.P1.M2_MEM.memory[41] = 24'b0_111000100110000_00000110;//56.59375;
      VNLP_tb.P1.M2_MEM.memory[42] = 24'b0_110000101010000_00000110;//48.65625;
//link9
      VNLP_tb.P1.M2_MEM.memory[44] = 56;
      VNLP_tb.P1.M2_MEM.memory[45] = 88;
      VNLP_tb.P1.M2_MEM.memory[46] = 24'b0_111000010111000_00000111;//112.71875;
      VNLP_tb.P1.M2_MEM.memory[47] = 24'b0_100010111001000_00000111;//69.78125;
//link10
      VNLP_tb.P1.M2_MEM.memory[49] = 39;
      VNLP_tb.P1.M2_MEM.memory[50] = 1;
      VNLP_tb.P1.M2_MEM.memory[51] = 24'b0_110010111111000_00000111;//101.96875;
      VNLP_tb.P1.M2_MEM.memory[52] = 24'b0_111111010000000_00000110;//63.25;

      //Start machine operations
      #11 START = 1;
    end

    always
       #5  clk =  ! clk;


  endmodule
