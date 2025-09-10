module polyphase_matched_filter_mux #(
//! - Fir polyphase filter with 192 coefficients in 16 phases of 12 coefficients
//! - **i_srst** is the system sync reset.
//! - **i_en** controls the enable (1) of the filter.

    parameter NB_INPUT   = 8, //! NB of input
    parameter NBF_INPUT  = 7, //! NBF of input
    parameter NB_OUTPUT  = 9, //! NB of output
    parameter NBF_OUTPUT = 7, //! NBF of output
    parameter NB_COEFF   = 13, //! NB of Coefficients
    parameter NBF_COEFF  = 12  //! NBF of Coefficients
  ) 
  (
    output signed [NB_OUTPUT-1:0] o_os_data, //! Output Sample
    input  signed [NB_INPUT -1:0] i_is_data, //! Input Sample
    input         [3          :0] coeff_sel, //! Coefficient Selector
    input                         i_en     , //! Enable
    input                         i_srst   , //! Reset
    input                         clk        //! Clock
  );
  localparam NB_ADD     = NB_COEFF  + NB_INPUT + 4; // 12 taps son 4 bits mas (log2(num_taps))
  localparam NBF_ADD    = NBF_COEFF + NBF_INPUT;
  localparam NBI_ADD    = NB_ADD    - NBF_ADD;
  localparam NBI_OUTPUT = NB_OUTPUT - NBF_OUTPUT;
  localparam NB_SAT     = (NBI_ADD) - (NBI_OUTPUT);
  
    //! Internal Signals
  reg  signed [NB_INPUT         -1:0] register [11:0]; //! Matrix for registers
  reg signed  [         NB_COEFF-1:0] coeff    [11:0]; //! Matrix for Coefficients
  wire signed [NB_INPUT+NB_COEFF-1:0] prod     [11:0]; //! Partial Products

  wire signed [         NB_COEFF-1:0] coeff_phase0    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase1    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase2    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase3    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase4    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase5    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase6    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase7    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase8    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase9    [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase10   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase11   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase12   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase13   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase14   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase15   [11:0]; //! Matrix for Coefficients

// Definicion de Coeficientes S(13,12), 16 fases de 12 coeficientes


assign coeff_phase0[0] = 13'h0000;
assign coeff_phase0[1] = 13'h0000;
assign coeff_phase0[2] = 13'h0000;
assign coeff_phase0[3] = 13'h0000;
assign coeff_phase0[4] = 13'h0000;
assign coeff_phase0[5] = 13'h0000;
assign coeff_phase0[6] = 13'h0FFF;
assign coeff_phase0[7] = 13'h0000;
assign coeff_phase0[8] = 13'h0000;
assign coeff_phase0[9] = 13'h0000;
assign coeff_phase0[10] = 13'h0000;
assign coeff_phase0[11] = 13'h0000;
assign coeff_phase1[0] = 13'h1FFF;
assign coeff_phase1[1] = 13'h0000;
assign coeff_phase1[2] = 13'h0004;
assign coeff_phase1[3] = 13'h0001;
assign coeff_phase1[4] = 13'h1FD1;
assign coeff_phase1[5] = 13'h00DB;
assign coeff_phase1[6] = 13'h0FE2;
assign coeff_phase1[7] = 13'h1F4A;
assign coeff_phase1[8] = 13'h0025;
assign coeff_phase1[9] = 13'h0000;
assign coeff_phase1[10] = 13'h1FFC;
assign coeff_phase1[11] = 13'h0000;
assign coeff_phase2[0] = 13'h1FFE;
assign coeff_phase2[1] = 13'h0000;
assign coeff_phase2[2] = 13'h0009;
assign coeff_phase2[3] = 13'h0004;
assign coeff_phase2[4] = 13'h1F99;
assign coeff_phase2[5] = 13'h01DA;
assign coeff_phase2[6] = 13'h0F88;
assign coeff_phase2[7] = 13'h1EBB;
assign coeff_phase2[8] = 13'h0041;
assign coeff_phase2[9] = 13'h0003;
assign coeff_phase2[10] = 13'h1FF9;
assign coeff_phase2[11] = 13'h0000;
assign coeff_phase3[0] = 13'h1FFD;
assign coeff_phase3[1] = 13'h1FFF;
assign coeff_phase3[2] = 13'h000D;
assign coeff_phase3[3] = 13'h000A;
assign coeff_phase3[4] = 13'h1F59;
assign coeff_phase3[5] = 13'h02F9;
assign coeff_phase3[6] = 13'h0EF7;
assign coeff_phase3[7] = 13'h1E51;
assign coeff_phase3[8] = 13'h0053;
assign coeff_phase3[9] = 13'h0007;
assign coeff_phase3[10] = 13'h1FF6;
assign coeff_phase3[11] = 13'h1FFF;
assign coeff_phase4[0] = 13'h1FFC;
assign coeff_phase4[1] = 13'h1FFD;
assign coeff_phase4[2] = 13'h0011;
assign coeff_phase4[3] = 13'h0013;
assign coeff_phase4[4] = 13'h1F15;
assign coeff_phase4[5] = 13'h0433;
assign coeff_phase4[6] = 13'h0E32;
assign coeff_phase4[7] = 13'h1E0B;
assign coeff_phase4[8] = 13'h005D;
assign coeff_phase4[9] = 13'h000B;
assign coeff_phase4[10] = 13'h1FF5;
assign coeff_phase4[11] = 13'h1FFE;
assign coeff_phase5[0] = 13'h1FFB;
assign coeff_phase5[1] = 13'h1FFB;
assign coeff_phase5[2] = 13'h0014;
assign coeff_phase5[3] = 13'h001E;
assign coeff_phase5[4] = 13'h1ECE;
assign coeff_phase5[5] = 13'h0581;
assign coeff_phase5[6] = 13'h0D3E;
assign coeff_phase5[7] = 13'h1DE6;
assign coeff_phase5[8] = 13'h005F;
assign coeff_phase5[9] = 13'h000F;
assign coeff_phase5[10] = 13'h1FF4;
assign coeff_phase5[11] = 13'h1FFD;
assign coeff_phase6[0] = 13'h1FFB;
assign coeff_phase6[1] = 13'h1FF9;
assign coeff_phase6[2] = 13'h0016;
assign coeff_phase6[3] = 13'h002B;
assign coeff_phase6[4] = 13'h1E89;
assign coeff_phase6[5] = 13'h06DD;
assign coeff_phase6[6] = 13'h0C23;
assign coeff_phase6[7] = 13'h1DDE;
assign coeff_phase6[8] = 13'h005A;
assign coeff_phase6[9] = 13'h0013;
assign coeff_phase6[10] = 13'h1FF4;
assign coeff_phase6[11] = 13'h1FFC;
assign coeff_phase7[0] = 13'h1FFB;
assign coeff_phase7[1] = 13'h1FF8;
assign coeff_phase7[2] = 13'h0017;
assign coeff_phase7[3] = 13'h0038;
assign coeff_phase7[4] = 13'h1E4A;
assign coeff_phase7[5] = 13'h083D;
assign coeff_phase7[6] = 13'h0AEA;
assign coeff_phase7[7] = 13'h1DEF;
assign coeff_phase7[8] = 13'h0052;
assign coeff_phase7[9] = 13'h0015;
assign coeff_phase7[10] = 13'h1FF5;
assign coeff_phase7[11] = 13'h1FFB;
assign coeff_phase8[0] = 13'h1FFB;
assign coeff_phase8[1] = 13'h1FF6;
assign coeff_phase8[2] = 13'h0017;
assign coeff_phase8[3] = 13'h0046;
assign coeff_phase8[4] = 13'h1E15;
assign coeff_phase8[5] = 13'h099A;
assign coeff_phase8[6] = 13'h099A;
assign coeff_phase8[7] = 13'h1E15;
assign coeff_phase8[8] = 13'h0046;
assign coeff_phase8[9] = 13'h0017;
assign coeff_phase8[10] = 13'h1FF6;
assign coeff_phase8[11] = 13'h1FFB;
assign coeff_phase9[0] = 13'h1FFB;
assign coeff_phase9[1] = 13'h1FF5;
assign coeff_phase9[2] = 13'h0015;
assign coeff_phase9[3] = 13'h0052;
assign coeff_phase9[4] = 13'h1DEF;
assign coeff_phase9[5] = 13'h0AEA;
assign coeff_phase9[6] = 13'h083D;
assign coeff_phase9[7] = 13'h1E4A;
assign coeff_phase9[8] = 13'h0038;
assign coeff_phase9[9] = 13'h0017;
assign coeff_phase9[10] = 13'h1FF8;
assign coeff_phase9[11] = 13'h1FFB;
assign coeff_phase10[0] = 13'h1FFC;
assign coeff_phase10[1] = 13'h1FF4;
assign coeff_phase10[2] = 13'h0013;
assign coeff_phase10[3] = 13'h005A;
assign coeff_phase10[4] = 13'h1DDE;
assign coeff_phase10[5] = 13'h0C23;
assign coeff_phase10[6] = 13'h06DD;
assign coeff_phase10[7] = 13'h1E89;
assign coeff_phase10[8] = 13'h002B;
assign coeff_phase10[9] = 13'h0016;
assign coeff_phase10[10] = 13'h1FF9;
assign coeff_phase10[11] = 13'h1FFB;
assign coeff_phase11[0] = 13'h1FFD;
assign coeff_phase11[1] = 13'h1FF4;
assign coeff_phase11[2] = 13'h000F;
assign coeff_phase11[3] = 13'h005F;
assign coeff_phase11[4] = 13'h1DE6;
assign coeff_phase11[5] = 13'h0D3E;
assign coeff_phase11[6] = 13'h0581;
assign coeff_phase11[7] = 13'h1ECE;
assign coeff_phase11[8] = 13'h001E;
assign coeff_phase11[9] = 13'h0014;
assign coeff_phase11[10] = 13'h1FFB;
assign coeff_phase11[11] = 13'h1FFB;
assign coeff_phase12[0] = 13'h1FFE;
assign coeff_phase12[1] = 13'h1FF5;
assign coeff_phase12[2] = 13'h000B;
assign coeff_phase12[3] = 13'h005D;
assign coeff_phase12[4] = 13'h1E0B;
assign coeff_phase12[5] = 13'h0E32;
assign coeff_phase12[6] = 13'h0433;
assign coeff_phase12[7] = 13'h1F15;
assign coeff_phase12[8] = 13'h0013;
assign coeff_phase12[9] = 13'h0011;
assign coeff_phase12[10] = 13'h1FFD;
assign coeff_phase12[11] = 13'h1FFC;
assign coeff_phase13[0] = 13'h1FFF;
assign coeff_phase13[1] = 13'h1FF6;
assign coeff_phase13[2] = 13'h0007;
assign coeff_phase13[3] = 13'h0053;
assign coeff_phase13[4] = 13'h1E51;
assign coeff_phase13[5] = 13'h0EF7;
assign coeff_phase13[6] = 13'h02F9;
assign coeff_phase13[7] = 13'h1F59;
assign coeff_phase13[8] = 13'h000A;
assign coeff_phase13[9] = 13'h000D;
assign coeff_phase13[10] = 13'h1FFF;
assign coeff_phase13[11] = 13'h1FFD;
assign coeff_phase14[0] = 13'h0000;
assign coeff_phase14[1] = 13'h1FF9;
assign coeff_phase14[2] = 13'h0003;
assign coeff_phase14[3] = 13'h0041;
assign coeff_phase14[4] = 13'h1EBB;
assign coeff_phase14[5] = 13'h0F88;
assign coeff_phase14[6] = 13'h01DA;
assign coeff_phase14[7] = 13'h1F99;
assign coeff_phase14[8] = 13'h0004;
assign coeff_phase14[9] = 13'h0009;
assign coeff_phase14[10] = 13'h0000;
assign coeff_phase14[11] = 13'h1FFE;
assign coeff_phase15[0] = 13'h0000;
assign coeff_phase15[1] = 13'h1FFC;
assign coeff_phase15[2] = 13'h0000;
assign coeff_phase15[3] = 13'h0025;
assign coeff_phase15[4] = 13'h1F4A;
assign coeff_phase15[5] = 13'h0FE2;
assign coeff_phase15[6] = 13'h00DB;
assign coeff_phase15[7] = 13'h1FD1;
assign coeff_phase15[8] = 13'h0001;
assign coeff_phase15[9] = 13'h0004;
assign coeff_phase15[10] = 13'h0000;
assign coeff_phase15[11] = 13'h1FFF;


reg [3:0] coeff_sel_sync,coeff_sel_sync2;

always @(posedge clk) begin
    coeff_sel_sync <= coeff_sel;  // Registro para sincronizacion
end

always @(posedge clk) begin
    coeff_sel_sync2 <= coeff_sel_sync;  // Se agrega segundo registro para sincronizacion completa
end

generate
    genvar ptr_phase;
    for(ptr_phase = 0; ptr_phase<12;ptr_phase = ptr_phase+1) begin
        always @(posedge clk) begin
            case (coeff_sel_sync2)
                4'd0:  coeff[ptr_phase] <= coeff_phase0 [ptr_phase];
                4'd1:  coeff[ptr_phase] <= coeff_phase1 [ptr_phase];
                4'd2:  coeff[ptr_phase] <= coeff_phase2 [ptr_phase];
                4'd3:  coeff[ptr_phase] <= coeff_phase3 [ptr_phase];
                4'd4:  coeff[ptr_phase] <= coeff_phase4 [ptr_phase];
                4'd5:  coeff[ptr_phase] <= coeff_phase5 [ptr_phase];
                4'd6:  coeff[ptr_phase] <= coeff_phase6 [ptr_phase];
                4'd7:  coeff[ptr_phase] <= coeff_phase7 [ptr_phase];
                4'd8:  coeff[ptr_phase] <= coeff_phase8 [ptr_phase];
                4'd9:  coeff[ptr_phase] <= coeff_phase9 [ptr_phase];
                4'd10: coeff[ptr_phase] <= coeff_phase10[ptr_phase];
                4'd11: coeff[ptr_phase] <= coeff_phase11[ptr_phase];
                4'd12: coeff[ptr_phase] <= coeff_phase12[ptr_phase];
                4'd13: coeff[ptr_phase] <= coeff_phase13[ptr_phase];
                4'd14: coeff[ptr_phase] <= coeff_phase14[ptr_phase];
                default: coeff[ptr_phase] <= coeff_phase15[ptr_phase];
            endcase
        end
    end
endgenerate 


/*------- Shift Register ----------*/
  //////////////////////////////////////////
  
  //! ShiftRegister model
  always @(posedge clk) begin:shiftRegister
    if (i_srst == 1'b1) begin
      register[0] <= {NB_INPUT{1'b0}};
      register[1] <= {NB_INPUT{1'b0}};
      register[2] <= {NB_INPUT{1'b0}};
      register[3] <= {NB_INPUT{1'b0}};
      register[4] <= {NB_INPUT{1'b0}};
      register[5] <= {NB_INPUT{1'b0}};
      register[6] <= {NB_INPUT{1'b0}};
      register[7] <= {NB_INPUT{1'b0}};
      register[8] <= {NB_INPUT{1'b0}};
      register[9] <= {NB_INPUT{1'b0}};
      register[10] <= {NB_INPUT{1'b0}};
      register[11] <= {NB_INPUT{1'b0}};

    end else begin
      if (i_en == 1'b1) begin
        register[0] <= i_is_data;
        register[1] <= register[0];
        register[2] <= register[1];
        register[3] <= register[2];
        register[4] <= register[3];
        register[5] <= register[4];
        register[6] <= register[5];
        register[7] <= register[6];
        register[8] <= register[7];
        register[9] <= register[8];
        register[10] <= register[9];
        register[11] <= register[10];

      end
    end
  end

 
  /*------- Product ----------*/
  //////////////////////////////////////////
  //! Products
  assign prod[0] =  coeff[0]  * register[0] ;
  assign prod[1] =  coeff[1]  * register[1] ;
  assign prod[2] =  coeff[2]  * register[2] ;
  assign prod[3] =  coeff[3]  * register[3] ;
  assign prod[4] =  coeff[4]  * register[4] ;
  assign prod[5] =  coeff[5]  * register[5] ;
  assign prod[6] =  coeff[6]  * register[6] ;
  assign prod[7] =  coeff[7]  * register[7] ;
  assign prod[8] =  coeff[8]  * register[8] ;
  assign prod[9] =  coeff[9]  * register[9] ;
  assign prod[10] = coeff[10] * register[10];
  assign prod[11] = coeff[11] * register[11];


  /*------- Adders ----------*/
  //////////////////////////////////////////
  //! Declaration
  wire signed [NB_ADD-1:0] sum      [11:1]; //! Add samples
  //! Adders
  assign sum[1]  = prod[0] + prod[1] ;
  assign sum[2]  = sum[1]  + prod[2] ;
  assign sum[3]  = sum[2]  + prod[3] ;
  assign sum[4]  = sum[3]  + prod[4] ;
  assign sum[5]  = sum[4]  + prod[5] ;
  assign sum[6]  = sum[5]  + prod[6] ;
  assign sum[7]  = sum[6]  + prod[7] ;
  assign sum[8]  = sum[7]  + prod[8] ;
  assign sum[9]  = sum[8]  + prod[9] ;
  assign sum[10] = sum[9]  + prod[10];
  assign sum[11] = sum[10] + prod[11];

/*    Opcion sin registro de adder tree final                 
reg signed [NB_OUTPUT-1:0] o_os_data_reg;

always @(posedge clk) begin
  if (i_srst)
    o_os_data_reg <= {NB_OUTPUT{1'b0}};
  else
    o_os_data_reg <= ( ~|sum[11][NB_ADD-1 -: NB_SAT+1] || &sum[11][NB_ADD-1 -: NB_SAT+1]) ? sum[11][NB_ADD-(NBI_ADD-NBI_OUTPUT) - 1 -: NB_OUTPUT] :
                      (sum[11][NB_ADD-1]) ? {{1'b1},{NB_OUTPUT-1{1'b0}}} : {{1'b0},{NB_OUTPUT-1{1'b1}}};
end

assign o_os_data = o_os_data_reg; */


wire signed [NB_ADD-1:0] sum_0_3;
assign sum_0_3 = prod[0] + prod[1] + prod[2] + prod[3];

reg signed [NB_ADD-1:0] sum_0_3_reg;
always @(posedge clk) begin
  sum_0_3_reg <= sum_0_3;
end

wire signed [NB_ADD-1:0] sum_4_7;
assign sum_4_7 = prod[4] + prod[5] + prod[6] + prod[7];

reg signed [NB_ADD-1:0] sum_4_7_reg;
always @(posedge clk) begin
  sum_4_7_reg <= sum_4_7;
end

wire signed [NB_ADD-1:0] sum_8_11;
assign sum_8_11 = prod[8] + prod[9] + prod[10] + prod[11];

reg signed [NB_ADD-1:0] sum_8_11_reg;
always @(posedge clk) begin
  sum_8_11_reg <= sum_8_11;
end

reg signed [NB_ADD-1:0] final_sum;
always @(posedge clk) begin
  final_sum <= sum_0_3_reg + sum_4_7_reg + sum_8_11_reg;
end

assign o_os_data = ( ~|final_sum[NB_ADD-1 -: NB_SAT+1] || &final_sum[NB_ADD-1 -: NB_SAT+1]) ? final_sum[NB_ADD-(NBI_ADD-NBI_OUTPUT) - 1 -: NB_OUTPUT] :
                      (final_sum[NB_ADD-1]) ? {{1'b1},{NB_OUTPUT-1{1'b0}}} : {{1'b0},{NB_OUTPUT-1{1'b1}}};
                      
endmodule
