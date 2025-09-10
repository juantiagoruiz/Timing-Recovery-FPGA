module TED_ML #(
  parameter NB_INPUT   = 9, //! NB of input
  parameter NBF_INPUT  = 7, //! NBF of input
  parameter NB_OUTPUT  = 20, //! NB of output
  parameter NBF_OUTPUT = 15 //! NBF of output
 )
 (
  output signed [NB_INPUT-1:0]            o_data       ,
  output signed [(NB_INPUT+1+NB_INPUT)-1:0] o_ted      ,
  output                                   enable_out  ,
  input  signed [NB_INPUT -1:0]           rx_output    ,
  input  signed [NB_INPUT -1:0]           phase_behind ,
  input  signed [NB_INPUT -1:0]           phase_forward,
  input                        rst_n, //! Reset
  input                        clk, 
  input                        enable_ted  //! Enable
  );

  wire signed [(NB_INPUT+1)-1:0] suma_senales;
  reg signed [(NB_INPUT+1+NB_INPUT)-1:0] o_ted_r;
  reg signed [NB_INPUT-1:0] o_data_r;
  reg enable_out_r;
  

  // Resta para aproximacion de derivada
  assign suma_senales = phase_forward-phase_behind;
  
    
  always@(posedge clk) begin
    if (rst_n) begin
      o_data_r <= 0;
      o_ted_r <= 0;
      enable_out_r <= 0;
      end
    else if (enable_ted) begin
      o_ted_r <= rx_output*suma_senales; // Multiplicacion por simbolo identificado (fase correcta)
      o_data_r <= rx_output;
      enable_out_r <= 1;
      end
    else begin
      o_data_r <= o_data_r;
      o_ted_r <= 0;
      enable_out_r <= 0;
      end
    end
    
  assign enable_out = enable_out_r;  
  assign o_ted = o_ted_r;
  assign o_data = o_data_r;
endmodule
