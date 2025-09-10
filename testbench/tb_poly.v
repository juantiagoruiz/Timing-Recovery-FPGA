

`timescale 1ns/1ps

module tb_poly ();


  reg             clkg = 0;
  reg             clks2 = 0;
  reg             rst_n = 0;
  reg             rst2 = 0;
  reg [7:0]       x_reg = 0,x_reg1 = 0,y_reg = 0;
  reg [7:0] x_out = 0;
  reg [7:0] Q_out = 0;      // Output after upsampling
  reg [5:0] phase;
  wire signed [9-1:0] yn;
  reg val;
  wire valid;
  
integer i;
reg [6:0] phase_list [0:21];  // Enough for values 0-13

  //! Instance of FIR
  top_poly
    u_poly
    (
       .rst_n     (~rst_n),
       .rst2       (~rst2),
       .phase(phase),
       .i_en       (1'b1),
       //.x_reg     (x_reg),
       //.x_reg1    (x_out),
       //.Q_reg     (Q_out),
       .o_data     (yn),
       .clk         (clkg)
       );
  // Clock
 always #5 clkg = ~clkg; // clock rapido de funcionamiento de bit, 100 mhz
 //always #20 clkg = ~clkg; //25 mhz
 // always #10 clkg = ~clkg; //50 mhz
 // always #40 clkg = ~clkg; //12.5 mhz
 //always #320 clks2 = ~clks2; // clock lento de sample
 
  // Reset and stimulus
  initial begin
    rst_n = 0;
    rst2 = 0;
    phase = 17;
    #100;
    rst_n = 1;
    clkg = 1;
 //   #30;
    clks2 = 1;
    

    // Wait for reset to take effect
    repeat (64) @(negedge clkg);
    rst2 = 1;
    repeat (80000) @(negedge clkg);

    phase_list[0] = 13;
    phase_list[1] = 11;
    phase_list[2] = 10;
    phase_list[3] = 8;
    phase_list[4] = 6;
    phase_list[5] = 4;
    phase_list[6] = 2;
    phase_list[7] = 4;
    phase_list[8] = 6;
    phase_list[9] = 8;
    phase_list[10] = 10;
    phase_list[11] = 10;
    phase_list[12] = 12;
    phase_list[13] = 14;
    phase_list[14] = 16;
    phase_list[15] = 18;
    phase_list[16] = 20;
    phase_list[17] = 22;
    phase_list[18] = 24;
    phase_list[19] = 26;
    phase_list[20] = 28;
    phase_list[21] = 30;
    phase_list[22] = 31;
    phase_list[23] = 0;
    phase_list[24] = 2;

    for (i = 0; i < 24; i = i + 1) begin
        phase = phase_list[i];
        repeat (80000) @(negedge clkg);
    end



    // Stop simulation
    @(negedge clkg);
    $stop;
  end
/*
  // Upsampling process
  reg [5:0] upsample_cnt = 0;
  reg [7:0] sample_hold = 0;
  reg [7:0] sample_hold_Q = 0;

  always @(posedge clkg or negedge rst_n) begin
    if (!rst_n) begin
      upsample_cnt <= 0;
      x_out <= 0;
      sample_hold <= 0;
      Q_out <= 0;
    end else begin
      if (upsample_cnt == 0) begin
        sample_hold <= x_reg;
        x_out <= x_reg;
        Q_out <= 8'd0;
      end else if (upsample_cnt == 6'd32) begin
        sample_hold <= x_reg;
        x_out <= 8'd0;
        Q_out <= y_reg;
      end else begin
        x_out <= 8'd0;
        Q_out <= 8'd0;
      end

      upsample_cnt <= (upsample_cnt == 6'd63) ? 0 : upsample_cnt + 1;
    end
  end
*/
endmodule
