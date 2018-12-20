module Control_Unit (Load_Add_R, Load_I_R, inc_len, DONE, DONE_i, sel_A1, clk, rst);
  parameter state_size = 2;

  // State Codes
  parameter S_idle = 0, S_fet1 = 1, S_fet2 = 2;
  parameter  S_done = 3;

  // Ports
  output Load_Add_R, Load_I_R, inc_len, sel_A1;
  output DONE;//this is the VNLP output signal that actually says we are done
  input DONE_i; //internal signal to indicate we are done
  input clk, rst;

  // Datapath and State Register Variables
  reg [state_size-1: 0] state, next_state;
  reg Load_Add_R, Load_I_R, inc_len, sel_A1;

  reg DONE_w;
  assign DONE = DONE_w;

  // State machine
  always @ (posedge clk or negedge rst) begin
    if (rst == 0) state <= S_idle; else state <= next_state; end


  always @ (state) begin
    // Initialize to default values
    sel_A1 = 0; Load_I_R = 0; Load_Add_R = 0;
    inc_len = 0; DONE_w = 0;
    next_state = state;


    case (state)

      S_idle: next_state = S_fet1;

      S_fet1: begin //gets the values of X and Y
        next_state = S_fet2;
        sel_A1 = 1;
        Load_I_R = 1;
      end

      S_fet2: begin //gets value of the next Link
        Load_Add_R = 1;
        if (DONE_i == 0) begin
                next_state = S_fet1;
                inc_len = 1;
              end
        else begin
                next_state = S_done;
                Load_I_R = 1;
              end
      end

    S_done: begin
        DONE_w = 1;//set output to 1
        next_state = S_done; //stay here until next reset/start signal
     end

    default: next_state = S_idle;
    endcase //state

  end

endmodule
