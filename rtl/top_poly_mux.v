
//! @title Symbol Recovery FPGA
//! @file top_poly_mux.v
//! @author Advance Digital Design - Juan Tiago Ruiz
//! @date 

module top_poly #(
  parameter NB_INPUT   = 8, //! NB of input
  parameter NBF_INPUT  = 7, //! NBF of input
  parameter NB_OUTPUT  = 9, //! NB of output
  parameter NBF_OUTPUT = 7 //! NBF of output
 )
 (
   ////////////////////////////////////////////////////////////
   // COMMENT TO IMPLEMENT IN FPGA
   ////////////////////////////////////////////////////////////
  
  
  output signed [NB_OUTPUT-1:0] o_data,
  input [5:0] phase,
  input                        i_en, //! Enable
  input                        rst_n, //! Reset
  input                        rst2, //! Clock input symbol */ // no se usa
  //////////////////////////////////////////////////////////
  input                        clk   //! Clock 
  );

  ////////////////////////////////////////////////////////////
  //// UNCOMMENT TO IMPLEMENT IN FPGA
  ////////////////////////////////////////////////////////////
   /*
    wire [NB_OUTPUT -1:0]  o_data;            //! Merge data from RAM
    wire                               i_en;              //! Enable PRBS
    wire [5 : 0 ]    phase;      //! Address for Read Memory
    wire                               rst_n;               //! Reset
    wire                               rst2;               //! Reset
  */
  ////////////////////////////////////////////////////////////



  wire signed [NB_OUTPUT-1:0] yn_1,yn_2,yn_Q;
  reg signed [NB_OUTPUT-1:0] yn_I;
  wire signed [NB_OUTPUT-1:0] yn_0,ted_data_out;
  reg signed [NB_OUTPUT-1:0] phase_selected,phase_delay,phase_forward;
  wire signed [18:0] ted_to_loop;
  wire signed [26:0] loop_to_controller;
  reg signed [NB_OUTPUT-1:0] yn_sampled,yn_sampled2,rx_input;
  wire [5:0] phase2;
  reg clk_symbol;
  reg clk_sample;
  wire prbs_out;
  
reg signed [NB_INPUT-1:0] x_reg_prbs;
reg signed [NB_INPUT-1:0] x_prbs;
wire [3:0] sel;
reg [5:0] sel2; // 6-bit select signal for the 1-to-64 MUX

  // define el desfase de clock del TX

  assign phase2 = phase+32;
  
  //! Instance of Polyphase FIR RX, 16 phases

  polyphase_matched_filter_mux #(
    .NB_INPUT   (9), 
    .NBF_INPUT  (7), 
    .NB_OUTPUT  (9), 
    .NBF_OUTPUT (7), 
    .NB_COEFF   (13), 
    .NBF_COEFF  (12)
    )
    u_polyphase_matched_filter_RX (
       .clk        (clk),
       .i_srst     (rst_n),
       .i_en       (clk_sample),
       .i_is_data  (rx_input),
       .o_os_data  (yn_0),
       .coeff_sel  (sel)
       );
       
    //! Instance of Polyphase FIR TX, 64 phases   
    polyphase_matched_filter_mux_64 #(
    .NB_INPUT   (8), 
    .NBF_INPUT  (7), 
    .NB_OUTPUT  (9), 
    .NBF_OUTPUT (7), 
    .NB_COEFF   (13), 
    .NBF_COEFF  (12)
    )
    u_polyphase_matched_filter_mux_64(
       .clk        (clk),
       .i_srst     (rst_n),
       .i_en       (clk_symbol),
       .i_is_data  (x_reg_prbs),
       .o_os_data  (yn_1),
       .coeff_sel  (sel2)
       );
       
    prbs5 #(
    )
    u_prbs5 (
    .clk(clk),
    .i_en (clk_symbol),
    .rst(rst_n),
    .prbs_out(prbs_out)
    );

// PRBS Upsampling process
always@(*) begin
x_prbs = prbs_out   ? 8'b0111_1111
                    : 8'b1000_0000;
end

reg prbs_sample_en;

always @ (posedge clk) begin 
    if (rst_n == 1) begin
        prbs_sample_en <= 0;
    end 
    else if (sel2 == 63) begin // revisar los delays para que coincida con el inicio
        prbs_sample_en <= 1;       
    end else
    prbs_sample_en <= 0;
end    


always @(posedge clk) begin
    if (rst_n) begin
      x_reg_prbs <= 8'b00000000;
      clk_symbol <= 1'b0;
    end else begin
      if (prbs_sample_en) begin
        x_reg_prbs <= x_prbs;
        clk_symbol <= 1'b1;
      end 
      else begin
        x_reg_prbs <= 8'b00000000;
        clk_symbol <= 1'b0;
      end
    end
  end

// contador rapido para filtro polifasico transmisor
always @(posedge clk) begin
    if (rst_n) begin
        sel2 <= 6'd0; // Reset 'sel' to 0, empieza en 15 asi el primero es 0
    end
    else begin
        sel2 <= sel2 + 6'd1;
    end
end


assign sel = sel2[4:1];


// registra la salida del polifasico
always @ (posedge clk) begin 
    if (rst_n) begin
        yn_I <= 0;
    end 
    else begin
        yn_I <= yn_1;       
    end
end

reg TX_sample_en;
always @ (posedge clk) begin 
    if (rst_n == 1) begin
        TX_sample_en <= 0;
    end 
    else if ((sel2 == phase-1) | (sel2 == phase2-1)) begin // sel2 == phase-1 debido a que hay 1 registro de latencia con el filtro polifasico
        TX_sample_en <= 1;       
    end else
    TX_sample_en <= 0;
end    

// sample and hold de salida para seleccionar salida de filtro con fase corrida
always @(posedge clk) begin
    if (rst_n)
        yn_sampled2 <= 0; // Reset 'sel' to 0, empieza en 15 asi el primero es 0
    else if (TX_sample_en)
        yn_sampled2 <= yn_I;
    else
        yn_sampled2 <= yn_sampled2;
end


  reg [6:0] pulse_counter;       // for 1-cycle pulse every 16 fast clocks


  reg RX_sample_en;
always @ (posedge clk) begin 
    if (rst_n == 1) begin
        RX_sample_en <= 0;
    end 
    else if ((sel2[4:0] == 5'b00000)) begin
        RX_sample_en <= 1;       
    end else
    RX_sample_en <= 0;
end    

  // Pulse generation: 1 for 1 cycle, then 0 for 31 cycles
  always @(posedge clk) begin
    if (rst_n) begin
      pulse_counter <= 0;
      rx_input <= 0;
      clk_sample <= 0;

    end else begin
      if (RX_sample_en) begin
        rx_input <= yn_sampled2;
        pulse_counter <= 7'd31;
        clk_sample <= 1;
      end
      else begin
        rx_input <= 0;
        pulse_counter <= pulse_counter - 1;
        clk_sample <= 0;
      end
    end
  end

assign o_data = ted_data_out;



reg enable_delay,enable_selected,enable_forward,enable_ted,enable_flag;
reg sample_sel;
reg odd_even;
wire enable_ted2,enable_ted3;

TED_ML #(
  .NB_INPUT    (9 ), //! NB of input
  .NBF_INPUT   (7 ), //! NBF of input
  .NB_OUTPUT   (20), //! NB of output
  .NBF_OUTPUT  (15) //! NBF of output
 )
 u_ted_ML(
  .o_data        (ted_data_out),//output 
  .o_ted         (ted_to_loop),//output
  .rx_output     (phase_selected),//input
  .phase_behind  (phase_delay),   //input
  .phase_forward (yn_0), //input
  .rst_n         (rst_n),//input //! Reset
  .enable_ted    (enable_ted),
  .enable_out     (enable_ted2),
  .clk           (clk) //input
  );

pi_loop_filter #(
  .NB_INPUT   (19), //! NB of input
  .NBF_INPUT  (14), //! NBF of input
  .NB_OUTPUT  (27), //! NB of output
  .NBF_OUTPUT (22) //! NBF of output
 )
u_loop_filter (
  .o_data    (loop_to_controller)   ,
  .ted_output(ted_to_loop)   ,
  .i_en      (enable_ted2)   , //! Enable
  .o_enable   (enable_ted3),
  .rst_n     (rst_n)   , //! Reset
  .clk       (clk)      
  );

// diseño de flag para habilitar el sample a symbol rate; odd_even toma el overflow de mu para pasar a la siguiente/anterior muestra
// debido a la latencia entre la fase actual de entrada y la fase correspondiente de output del filtro, se desplaza la se�al sample_sel para que coincida con los momentos correctos de tomar la muestra
parameter FILTER_LATENCY = 6;

reg [FILTER_LATENCY-1:0] sample_sel_pipe;

always @(posedge clk) begin
  if (rst_n) begin
    sample_sel_pipe <= 0;
  end else begin
    sample_sel_pipe <= {sample_sel_pipe[FILTER_LATENCY-2:0], sample_sel};
  end
end

wire sample_sel_aligned = sample_sel_pipe[FILTER_LATENCY-1];


    
always@(*) begin
    if (odd_even) begin
      if (sel2 <= 31) // sample correcto es el primero
        sample_sel = 1'b1;
      else 
        sample_sel = 1'b0;
    end
    else begin
      if (sel2 > 31) // sample correcto es el segundo
        sample_sel = 1'b1;
      else 
        sample_sel = 1'b0;
    end
end

reg signed [21:0] mu;
reg signed [22:0] mu_flag;
reg signed [3:0] mu_index;


always @(posedge clk) begin
    if (rst_n) begin  
    mu <= 21'b0000000000000000000;
    mu_flag <= 22'b00000000000000000000;
    mu_index <= 4'b0000;
    odd_even <= 1'b0;
    end
    else if (enable_ted3) begin
    mu <= mu+loop_to_controller[21:0];
    mu_flag <= mu_flag+loop_to_controller[22:0];
    mu_index <= mu[21:18];
    odd_even <= mu_flag[22];
    end
    else begin
    mu <= mu;
     mu_flag <= mu_flag;
    mu_index <= mu[21:18];
    odd_even <= mu_flag[22];
    end
end       

always @(posedge clk) begin 
if (rst_n) begin
    phase_forward <= 0;
    phase_selected <= 0;
    phase_delay <= 0;
    enable_ted <= 0;
    enable_flag <= 0;
end
else begin
    phase_forward <= yn_0;
    phase_selected <= phase_forward;
    phase_delay <= phase_selected;

    if (sel == mu_index+4'b0011 && sample_sel_aligned && !enable_flag) begin
    enable_ted <= 1;
    enable_flag <= 1;
    end
    else begin
    enable_ted <= 0;
    enable_flag <= 0;
    end
    end
end

  ////////////////////////////////////////////////////////////
  // UNCOMMENT TO IMPLEMENT IN FPGA
  ////////////////////////////////////////////////////////////
  
//// VIO Instance
 /*
 vio
  u_vio
    (
      .probe_out0_0 (phase),           // Control phase input
      .probe_out1_0 (rst_n),          // Control reset input
      .probe_out2_0 (rst2),           // Control reset input for symbol clock
      .probe_out3_0 (i_en),          // Control reset input
      .clk_0        (clk)              // Debug clock
    );

// ILA Instance
ila
  u_ila
    (
      .probe0_0 (o_data),              // TED output
      .probe1_0 (yn_I),                // Polyphase TX output
      .probe2_0 (phase_forward),       // Polyphase RX output
      .probe3_0 (mu),                  // Mu value 
      .probe4_0 (mu_index),            // Mu index value (polyphase filter index)
      .clk_0    (clk)                  // Debug clock
    );
*/

   
endmodule

