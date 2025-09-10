module pi_loop_filter #(
  parameter NB_INPUT   = 19, //! NB of input
  parameter NBF_INPUT  = 14, //! NBF of input
  parameter NB_OUTPUT  = 23, //! NB of output
  parameter NBF_OUTPUT = 18 //! NBF of output
 )
 (
  output signed [NB_OUTPUT-1:0]            o_data       ,
  output                                   o_enable     ,
  input  signed [NB_INPUT -1:0]           ted_output    ,
  input                        rst_n, //! Reset
  input                        i_en, //! Enable
  input                        clk   
  );

  localparam NB_TEMP     = NB_INPUT + NB_OUTPUT;        // = 46


  // Internal signals
  wire signed [NB_TEMP-1:0] Kp_temp,Ki_temp;
  wire signed [NB_OUTPUT-1:0] Kp_term,Ki_term;
  wire signed [(NB_INPUT+1)-1:0] suma_senales;
  reg signed [(NB_INPUT+1)-1:0] suma_senales_r;
  reg  signed [NB_OUTPUT-1:0] reg_int,kp_r;
  reg enable_delay,enable_delay_delay;
  
    // Coeficientes
  //localparam signed [NB_OUTPUT-1:0] Kp = 27'h020000; // 0.5 in Q5.18
  
  localparam signed [NB_OUTPUT-1:0] Kp = 27'h013333; // 0.3 in S(27,18)

  localparam signed [NB_OUTPUT-1:0] Ki = 27'h000106; // 0.001 in Q5.18
  
  //assign Kp = 23'h003333;// 0.05
  //assign Kp = 23'h006666;// 0.1
  //assign Kp = 23'h00cccd;// 0.2
  //assign Kp = 27'h00013333; //
  //assign Kp = 23'h020000; // 0.5
  //assign Ki = 23'h000a3d;// 0.01
  //assign Ki = 23'h000106;// 0.001
  //assign Ki = 23'h000000;// 0.00
  //assign Ki = 23'h003333;// 0.05

  // Multiplicaciones
  assign Kp_temp = Kp * ted_output;  // S(19+23, ...) S(42,32)
  assign Ki_temp = Ki * ted_output;

  // Calculo de termino proporcional

  assign Kp_term = Kp_temp[37:10]; // De los S(42,32) se truncan los S(23,18) relevantes
  assign Ki_term = Ki_temp[37:10];
  
  // Acumulacion en registro de integracion y delay de enable
  always @(posedge clk) begin
    if (rst_n) begin
        reg_int <= 0; 
        enable_delay <= 0;
        kp_r <= 0;
        end
    else begin
        enable_delay <= i_en;
        if (i_en) begin
            reg_int <= reg_int+Ki_term;
            kp_r <= Kp_term; 
        end else begin
            reg_int <= reg_int;
            kp_r <= kp_r;
            end
        end
  end


always @(posedge clk) begin
    if (rst_n) begin
        suma_senales_r <= 0;
        enable_delay_delay <= 0;
        end
    else begin
        enable_delay_delay <= enable_delay;
        if (enable_delay)
            suma_senales_r <= kp_r+reg_int;
        else
            suma_senales_r <= suma_senales_r;
        end
end


  // Asignacion a salida de suma de ambos terminos
  assign o_enable = enable_delay_delay;
  assign o_data = suma_senales_r;
  
endmodule
