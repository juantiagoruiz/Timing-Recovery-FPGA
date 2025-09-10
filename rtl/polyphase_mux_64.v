module polyphase_matched_filter_mux_64 #(
//! - Fir polyphase filter with 768 coefficients in 64 phases of 12 coefficients
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
    input         [5          :0] coeff_sel, //! Coefficient Selector
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
  reg signed [         NB_COEFF-1:0] coeff    [11:0]; //! Matrix for Coefficients
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
  wire signed [         NB_COEFF-1:0] coeff_phase16   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase17   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase18   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase19   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase20   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase21   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase22   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase23   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase24   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase25   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase26   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase27   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase28   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase29   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase30   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase31   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase32   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase33   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase34   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase35   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase36   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase37   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase38   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase39   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase40   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase41   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase42   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase43   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase44   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase45   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase46   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase47   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase48   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase49   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase50   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase51   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase52   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase53   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase54   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase55   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase56   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase57   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase58   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase59   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase60   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase61   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase62   [11:0]; //! Matrix for Coefficients
  wire signed [         NB_COEFF-1:0] coeff_phase63   [11:0]; //! Matrix for Coefficients
  
  



  //! //! Coefficients, S(13,12), 64 fases de 12 coeficientes

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
assign coeff_phase1[0] = 13'h0000;
assign coeff_phase1[1] = 13'h0000;
assign coeff_phase1[2] = 13'h0001;
assign coeff_phase1[3] = 13'h0000;
assign coeff_phase1[4] = 13'h1FF6;
assign coeff_phase1[5] = 13'h0033;
assign coeff_phase1[6] = 13'h0FFE;
assign coeff_phase1[7] = 13'h1FCF;
assign coeff_phase1[8] = 13'h000A;
assign coeff_phase1[9] = 13'h0000;
assign coeff_phase1[10] = 13'h1FFF;
assign coeff_phase1[11] = 13'h0000;
assign coeff_phase2[0] = 13'h0000;
assign coeff_phase2[1] = 13'h0000;
assign coeff_phase2[2] = 13'h0002;
assign coeff_phase2[3] = 13'h0000;
assign coeff_phase2[4] = 13'h1FEA;
assign coeff_phase2[5] = 13'h0069;
assign coeff_phase2[6] = 13'h0FF8;
assign coeff_phase2[7] = 13'h1FA1;
assign coeff_phase2[8] = 13'h0014;
assign coeff_phase2[9] = 13'h0000;
assign coeff_phase2[10] = 13'h1FFE;
assign coeff_phase2[11] = 13'h0000;
assign coeff_phase3[0] = 13'h0000;
assign coeff_phase3[1] = 13'h0000;
assign coeff_phase3[2] = 13'h0003;
assign coeff_phase3[3] = 13'h0000;
assign coeff_phase3[4] = 13'h1FDE;
assign coeff_phase3[5] = 13'h00A1;
assign coeff_phase3[6] = 13'h0FEF;
assign coeff_phase3[7] = 13'h1F74;
assign coeff_phase3[8] = 13'h001D;
assign coeff_phase3[9] = 13'h0000;
assign coeff_phase3[10] = 13'h1FFD;
assign coeff_phase3[11] = 13'h0000;
assign coeff_phase4[0] = 13'h1FFF;
assign coeff_phase4[1] = 13'h0000;
assign coeff_phase4[2] = 13'h0004;
assign coeff_phase4[3] = 13'h0001;
assign coeff_phase4[4] = 13'h1FD1;
assign coeff_phase4[5] = 13'h00DB;
assign coeff_phase4[6] = 13'h0FE2;
assign coeff_phase4[7] = 13'h1F4A;
assign coeff_phase4[8] = 13'h0025;
assign coeff_phase4[9] = 13'h0000;
assign coeff_phase4[10] = 13'h1FFC;
assign coeff_phase4[11] = 13'h0000;
assign coeff_phase5[0] = 13'h1FFF;
assign coeff_phase5[1] = 13'h0000;
assign coeff_phase5[2] = 13'h0005;
assign coeff_phase5[3] = 13'h0001;
assign coeff_phase5[4] = 13'h1FC4;
assign coeff_phase5[5] = 13'h0118;
assign coeff_phase5[6] = 13'h0FD1;
assign coeff_phase5[7] = 13'h1F23;
assign coeff_phase5[8] = 13'h002D;
assign coeff_phase5[9] = 13'h0001;
assign coeff_phase5[10] = 13'h1FFC;
assign coeff_phase5[11] = 13'h0000;
assign coeff_phase6[0] = 13'h1FFF;
assign coeff_phase6[1] = 13'h0000;
assign coeff_phase6[2] = 13'h0006;
assign coeff_phase6[3] = 13'h0002;
assign coeff_phase6[4] = 13'h1FB6;
assign coeff_phase6[5] = 13'h0156;
assign coeff_phase6[6] = 13'h0FBC;
assign coeff_phase6[7] = 13'h1EFE;
assign coeff_phase6[8] = 13'h0034;
assign coeff_phase6[9] = 13'h0002;
assign coeff_phase6[10] = 13'h1FFB;
assign coeff_phase6[11] = 13'h0000;
assign coeff_phase7[0] = 13'h1FFE;
assign coeff_phase7[1] = 13'h0000;
assign coeff_phase7[2] = 13'h0007;
assign coeff_phase7[3] = 13'h0003;
assign coeff_phase7[4] = 13'h1FA8;
assign coeff_phase7[5] = 13'h0197;
assign coeff_phase7[6] = 13'h0FA4;
assign coeff_phase7[7] = 13'h1EDB;
assign coeff_phase7[8] = 13'h003B;
assign coeff_phase7[9] = 13'h0002;
assign coeff_phase7[10] = 13'h1FFA;
assign coeff_phase7[11] = 13'h0000;
assign coeff_phase8[0] = 13'h1FFE;
assign coeff_phase8[1] = 13'h0000;
assign coeff_phase8[2] = 13'h0009;
assign coeff_phase8[3] = 13'h0004;
assign coeff_phase8[4] = 13'h1F99;
assign coeff_phase8[5] = 13'h01DA;
assign coeff_phase8[6] = 13'h0F88;
assign coeff_phase8[7] = 13'h1EBB;
assign coeff_phase8[8] = 13'h0041;
assign coeff_phase8[9] = 13'h0003;
assign coeff_phase8[10] = 13'h1FF9;
assign coeff_phase8[11] = 13'h0000;
assign coeff_phase9[0] = 13'h1FFE;
assign coeff_phase9[1] = 13'h1FFF;
assign coeff_phase9[2] = 13'h000A;
assign coeff_phase9[3] = 13'h0005;
assign coeff_phase9[4] = 13'h1F89;
assign coeff_phase9[5] = 13'h021F;
assign coeff_phase9[6] = 13'h0F69;
assign coeff_phase9[7] = 13'h1E9D;
assign coeff_phase9[8] = 13'h0046;
assign coeff_phase9[9] = 13'h0004;
assign coeff_phase9[10] = 13'h1FF8;
assign coeff_phase9[11] = 13'h0000;
assign coeff_phase10[0] = 13'h1FFD;
assign coeff_phase10[1] = 13'h1FFF;
assign coeff_phase10[2] = 13'h000B;
assign coeff_phase10[3] = 13'h0007;
assign coeff_phase10[4] = 13'h1F7A;
assign coeff_phase10[5] = 13'h0266;
assign coeff_phase10[6] = 13'h0F47;
assign coeff_phase10[7] = 13'h1E81;
assign coeff_phase10[8] = 13'h004B;
assign coeff_phase10[9] = 13'h0005;
assign coeff_phase10[10] = 13'h1FF8;
assign coeff_phase10[11] = 13'h1FFF;
assign coeff_phase11[0] = 13'h1FFD;
assign coeff_phase11[1] = 13'h1FFF;
assign coeff_phase11[2] = 13'h000C;
assign coeff_phase11[3] = 13'h0009;
assign coeff_phase11[4] = 13'h1F6A;
assign coeff_phase11[5] = 13'h02AF;
assign coeff_phase11[6] = 13'h0F20;
assign coeff_phase11[7] = 13'h1E68;
assign coeff_phase11[8] = 13'h0050;
assign coeff_phase11[9] = 13'h0006;
assign coeff_phase11[10] = 13'h1FF7;
assign coeff_phase11[11] = 13'h1FFF;
assign coeff_phase12[0] = 13'h1FFD;
assign coeff_phase12[1] = 13'h1FFF;
assign coeff_phase12[2] = 13'h000D;
assign coeff_phase12[3] = 13'h000A;
assign coeff_phase12[4] = 13'h1F59;
assign coeff_phase12[5] = 13'h02F9;
assign coeff_phase12[6] = 13'h0EF7;
assign coeff_phase12[7] = 13'h1E51;
assign coeff_phase12[8] = 13'h0053;
assign coeff_phase12[9] = 13'h0007;
assign coeff_phase12[10] = 13'h1FF6;
assign coeff_phase12[11] = 13'h1FFF;
assign coeff_phase13[0] = 13'h1FFD;
assign coeff_phase13[1] = 13'h1FFE;
assign coeff_phase13[2] = 13'h000E;
assign coeff_phase13[3] = 13'h000C;
assign coeff_phase13[4] = 13'h1F48;
assign coeff_phase13[5] = 13'h0345;
assign coeff_phase13[6] = 13'h0ECA;
assign coeff_phase13[7] = 13'h1E3C;
assign coeff_phase13[8] = 13'h0056;
assign coeff_phase13[9] = 13'h0008;
assign coeff_phase13[10] = 13'h1FF6;
assign coeff_phase13[11] = 13'h1FFF;
assign coeff_phase14[0] = 13'h1FFC;
assign coeff_phase14[1] = 13'h1FFE;
assign coeff_phase14[2] = 13'h000F;
assign coeff_phase14[3] = 13'h000E;
assign coeff_phase14[4] = 13'h1F37;
assign coeff_phase14[5] = 13'h0393;
assign coeff_phase14[6] = 13'h0E9B;
assign coeff_phase14[7] = 13'h1E29;
assign coeff_phase14[8] = 13'h0059;
assign coeff_phase14[9] = 13'h0009;
assign coeff_phase14[10] = 13'h1FF6;
assign coeff_phase14[11] = 13'h1FFE;
assign coeff_phase15[0] = 13'h1FFC;
assign coeff_phase15[1] = 13'h1FFD;
assign coeff_phase15[2] = 13'h0010;
assign coeff_phase15[3] = 13'h0011;
assign coeff_phase15[4] = 13'h1F26;
assign coeff_phase15[5] = 13'h03E2;
assign coeff_phase15[6] = 13'h0E68;
assign coeff_phase15[7] = 13'h1E19;
assign coeff_phase15[8] = 13'h005B;
assign coeff_phase15[9] = 13'h000A;
assign coeff_phase15[10] = 13'h1FF5;
assign coeff_phase15[11] = 13'h1FFE;
assign coeff_phase16[0] = 13'h1FFC;
assign coeff_phase16[1] = 13'h1FFD;
assign coeff_phase16[2] = 13'h0011;
assign coeff_phase16[3] = 13'h0013;
assign coeff_phase16[4] = 13'h1F15;
assign coeff_phase16[5] = 13'h0433;
assign coeff_phase16[6] = 13'h0E32;
assign coeff_phase16[7] = 13'h1E0B;
assign coeff_phase16[8] = 13'h005D;
assign coeff_phase16[9] = 13'h000B;
assign coeff_phase16[10] = 13'h1FF5;
assign coeff_phase16[11] = 13'h1FFE;
assign coeff_phase17[0] = 13'h1FFC;
assign coeff_phase17[1] = 13'h1FFD;
assign coeff_phase17[2] = 13'h0012;
assign coeff_phase17[3] = 13'h0016;
assign coeff_phase17[4] = 13'h1F03;
assign coeff_phase17[5] = 13'h0485;
assign coeff_phase17[6] = 13'h0DF9;
assign coeff_phase17[7] = 13'h1DFF;
assign coeff_phase17[8] = 13'h005E;
assign coeff_phase17[9] = 13'h000C;
assign coeff_phase17[10] = 13'h1FF4;
assign coeff_phase17[11] = 13'h1FFE;
assign coeff_phase18[0] = 13'h1FFB;
assign coeff_phase18[1] = 13'h1FFC;
assign coeff_phase18[2] = 13'h0013;
assign coeff_phase18[3] = 13'h0018;
assign coeff_phase18[4] = 13'h1EF1;
assign coeff_phase18[5] = 13'h04D8;
assign coeff_phase18[6] = 13'h0DBD;
assign coeff_phase18[7] = 13'h1DF4;
assign coeff_phase18[8] = 13'h005E;
assign coeff_phase18[9] = 13'h000D;
assign coeff_phase18[10] = 13'h1FF4;
assign coeff_phase18[11] = 13'h1FFD;
assign coeff_phase19[0] = 13'h1FFB;
assign coeff_phase19[1] = 13'h1FFC;
assign coeff_phase19[2] = 13'h0013;
assign coeff_phase19[3] = 13'h001B;
assign coeff_phase19[4] = 13'h1EE0;
assign coeff_phase19[5] = 13'h052C;
assign coeff_phase19[6] = 13'h0D7F;
assign coeff_phase19[7] = 13'h1DEC;
assign coeff_phase19[8] = 13'h005F;
assign coeff_phase19[9] = 13'h000E;
assign coeff_phase19[10] = 13'h1FF4;
assign coeff_phase19[11] = 13'h1FFD;
assign coeff_phase20[0] = 13'h1FFB;
assign coeff_phase20[1] = 13'h1FFB;
assign coeff_phase20[2] = 13'h0014;
assign coeff_phase20[3] = 13'h001E;
assign coeff_phase20[4] = 13'h1ECE;
assign coeff_phase20[5] = 13'h0581;
assign coeff_phase20[6] = 13'h0D3E;
assign coeff_phase20[7] = 13'h1DE6;
assign coeff_phase20[8] = 13'h005F;
assign coeff_phase20[9] = 13'h000F;
assign coeff_phase20[10] = 13'h1FF4;
assign coeff_phase20[11] = 13'h1FFD;
assign coeff_phase21[0] = 13'h1FFB;
assign coeff_phase21[1] = 13'h1FFB;
assign coeff_phase21[2] = 13'h0015;
assign coeff_phase21[3] = 13'h0021;
assign coeff_phase21[4] = 13'h1EBC;
assign coeff_phase21[5] = 13'h05D7;
assign coeff_phase21[6] = 13'h0CFB;
assign coeff_phase21[7] = 13'h1DE1;
assign coeff_phase21[8] = 13'h005E;
assign coeff_phase21[9] = 13'h0010;
assign coeff_phase21[10] = 13'h1FF4;
assign coeff_phase21[11] = 13'h1FFD;
assign coeff_phase22[0] = 13'h1FFB;
assign coeff_phase22[1] = 13'h1FFA;
assign coeff_phase22[2] = 13'h0015;
assign coeff_phase22[3] = 13'h0024;
assign coeff_phase22[4] = 13'h1EAB;
assign coeff_phase22[5] = 13'h062E;
assign coeff_phase22[6] = 13'h0CB5;
assign coeff_phase22[7] = 13'h1DDE;
assign coeff_phase22[8] = 13'h005D;
assign coeff_phase22[9] = 13'h0011;
assign coeff_phase22[10] = 13'h1FF4;
assign coeff_phase22[11] = 13'h1FFC;
assign coeff_phase23[0] = 13'h1FFB;
assign coeff_phase23[1] = 13'h1FFA;
assign coeff_phase23[2] = 13'h0016;
assign coeff_phase23[3] = 13'h0027;
assign coeff_phase23[4] = 13'h1E9A;
assign coeff_phase23[5] = 13'h0685;
assign coeff_phase23[6] = 13'h0C6D;
assign coeff_phase23[7] = 13'h1DDD;
assign coeff_phase23[8] = 13'h005C;
assign coeff_phase23[9] = 13'h0012;
assign coeff_phase23[10] = 13'h1FF4;
assign coeff_phase23[11] = 13'h1FFC;
assign coeff_phase24[0] = 13'h1FFB;
assign coeff_phase24[1] = 13'h1FF9;
assign coeff_phase24[2] = 13'h0016;
assign coeff_phase24[3] = 13'h002B;
assign coeff_phase24[4] = 13'h1E89;
assign coeff_phase24[5] = 13'h06DD;
assign coeff_phase24[6] = 13'h0C23;
assign coeff_phase24[7] = 13'h1DDE;
assign coeff_phase24[8] = 13'h005A;
assign coeff_phase24[9] = 13'h0013;
assign coeff_phase24[10] = 13'h1FF4;
assign coeff_phase24[11] = 13'h1FFC;
assign coeff_phase25[0] = 13'h1FFB;
assign coeff_phase25[1] = 13'h1FF9;
assign coeff_phase25[2] = 13'h0017;
assign coeff_phase25[3] = 13'h002E;
assign coeff_phase25[4] = 13'h1E78;
assign coeff_phase25[5] = 13'h0735;
assign coeff_phase25[6] = 13'h0BD7;
assign coeff_phase25[7] = 13'h1DE0;
assign coeff_phase25[8] = 13'h0059;
assign coeff_phase25[9] = 13'h0013;
assign coeff_phase25[10] = 13'h1FF4;
assign coeff_phase25[11] = 13'h1FFC;
assign coeff_phase26[0] = 13'h1FFB;
assign coeff_phase26[1] = 13'h1FF8;
assign coeff_phase26[2] = 13'h0017;
assign coeff_phase26[3] = 13'h0032;
assign coeff_phase26[4] = 13'h1E68;
assign coeff_phase26[5] = 13'h078D;
assign coeff_phase26[6] = 13'h0B8A;
assign coeff_phase26[7] = 13'h1DE4;
assign coeff_phase26[8] = 13'h0056;
assign coeff_phase26[9] = 13'h0014;
assign coeff_phase26[10] = 13'h1FF4;
assign coeff_phase26[11] = 13'h1FFC;
assign coeff_phase27[0] = 13'h1FFB;
assign coeff_phase27[1] = 13'h1FF8;
assign coeff_phase27[2] = 13'h0017;
assign coeff_phase27[3] = 13'h0035;
assign coeff_phase27[4] = 13'h1E59;
assign coeff_phase27[5] = 13'h07E5;
assign coeff_phase27[6] = 13'h0B3B;
assign coeff_phase27[7] = 13'h1DE9;
assign coeff_phase27[8] = 13'h0054;
assign coeff_phase27[9] = 13'h0015;
assign coeff_phase27[10] = 13'h1FF4;
assign coeff_phase27[11] = 13'h1FFB;
assign coeff_phase28[0] = 13'h1FFB;
assign coeff_phase28[1] = 13'h1FF8;
assign coeff_phase28[2] = 13'h0017;
assign coeff_phase28[3] = 13'h0038;
assign coeff_phase28[4] = 13'h1E4A;
assign coeff_phase28[5] = 13'h083D;
assign coeff_phase28[6] = 13'h0AEA;
assign coeff_phase28[7] = 13'h1DEF;
assign coeff_phase28[8] = 13'h0052;
assign coeff_phase28[9] = 13'h0015;
assign coeff_phase28[10] = 13'h1FF5;
assign coeff_phase28[11] = 13'h1FFB;
assign coeff_phase29[0] = 13'h1FFB;
assign coeff_phase29[1] = 13'h1FF7;
assign coeff_phase29[2] = 13'h0017;
assign coeff_phase29[3] = 13'h003C;
assign coeff_phase29[4] = 13'h1E3B;
assign coeff_phase29[5] = 13'h0895;
assign coeff_phase29[6] = 13'h0A98;
assign coeff_phase29[7] = 13'h1DF7;
assign coeff_phase29[8] = 13'h004F;
assign coeff_phase29[9] = 13'h0016;
assign coeff_phase29[10] = 13'h1FF5;
assign coeff_phase29[11] = 13'h1FFB;
assign coeff_phase30[0] = 13'h1FFB;
assign coeff_phase30[1] = 13'h1FF7;
assign coeff_phase30[2] = 13'h0017;
assign coeff_phase30[3] = 13'h003F;
assign coeff_phase30[4] = 13'h1E2E;
assign coeff_phase30[5] = 13'h08ED;
assign coeff_phase30[6] = 13'h0A44;
assign coeff_phase30[7] = 13'h1E00;
assign coeff_phase30[8] = 13'h004C;
assign coeff_phase30[9] = 13'h0016;
assign coeff_phase30[10] = 13'h1FF5;
assign coeff_phase30[11] = 13'h1FFB;
assign coeff_phase31[0] = 13'h1FFB;
assign coeff_phase31[1] = 13'h1FF6;
assign coeff_phase31[2] = 13'h0017;
assign coeff_phase31[3] = 13'h0042;
assign coeff_phase31[4] = 13'h1E21;
assign coeff_phase31[5] = 13'h0944;
assign coeff_phase31[6] = 13'h09EF;
assign coeff_phase31[7] = 13'h1E0A;
assign coeff_phase31[8] = 13'h0049;
assign coeff_phase31[9] = 13'h0017;
assign coeff_phase31[10] = 13'h1FF5;
assign coeff_phase31[11] = 13'h1FFB;
assign coeff_phase32[0] = 13'h1FFB;
assign coeff_phase32[1] = 13'h1FF6;
assign coeff_phase32[2] = 13'h0017;
assign coeff_phase32[3] = 13'h0046;
assign coeff_phase32[4] = 13'h1E15;
assign coeff_phase32[5] = 13'h099A;
assign coeff_phase32[6] = 13'h099A;
assign coeff_phase32[7] = 13'h1E15;
assign coeff_phase32[8] = 13'h0046;
assign coeff_phase32[9] = 13'h0017;
assign coeff_phase32[10] = 13'h1FF6;
assign coeff_phase32[11] = 13'h1FFB;
assign coeff_phase33[0] = 13'h1FFB;
assign coeff_phase33[1] = 13'h1FF5;
assign coeff_phase33[2] = 13'h0017;
assign coeff_phase33[3] = 13'h0049;
assign coeff_phase33[4] = 13'h1E0A;
assign coeff_phase33[5] = 13'h09EF;
assign coeff_phase33[6] = 13'h0944;
assign coeff_phase33[7] = 13'h1E21;
assign coeff_phase33[8] = 13'h0042;
assign coeff_phase33[9] = 13'h0017;
assign coeff_phase33[10] = 13'h1FF6;
assign coeff_phase33[11] = 13'h1FFB;
assign coeff_phase34[0] = 13'h1FFB;
assign coeff_phase34[1] = 13'h1FF5;
assign coeff_phase34[2] = 13'h0016;
assign coeff_phase34[3] = 13'h004C;
assign coeff_phase34[4] = 13'h1E00;
assign coeff_phase34[5] = 13'h0A44;
assign coeff_phase34[6] = 13'h08ED;
assign coeff_phase34[7] = 13'h1E2E;
assign coeff_phase34[8] = 13'h003F;
assign coeff_phase34[9] = 13'h0017;
assign coeff_phase34[10] = 13'h1FF7;
assign coeff_phase34[11] = 13'h1FFB;
assign coeff_phase35[0] = 13'h1FFB;
assign coeff_phase35[1] = 13'h1FF5;
assign coeff_phase35[2] = 13'h0016;
assign coeff_phase35[3] = 13'h004F;
assign coeff_phase35[4] = 13'h1DF7;
assign coeff_phase35[5] = 13'h0A98;
assign coeff_phase35[6] = 13'h0895;
assign coeff_phase35[7] = 13'h1E3B;
assign coeff_phase35[8] = 13'h003C;
assign coeff_phase35[9] = 13'h0017;
assign coeff_phase35[10] = 13'h1FF7;
assign coeff_phase35[11] = 13'h1FFB;
assign coeff_phase36[0] = 13'h1FFB;
assign coeff_phase36[1] = 13'h1FF5;
assign coeff_phase36[2] = 13'h0015;
assign coeff_phase36[3] = 13'h0052;
assign coeff_phase36[4] = 13'h1DEF;
assign coeff_phase36[5] = 13'h0AEA;
assign coeff_phase36[6] = 13'h083D;
assign coeff_phase36[7] = 13'h1E4A;
assign coeff_phase36[8] = 13'h0038;
assign coeff_phase36[9] = 13'h0017;
assign coeff_phase36[10] = 13'h1FF8;
assign coeff_phase36[11] = 13'h1FFB;
assign coeff_phase37[0] = 13'h1FFB;
assign coeff_phase37[1] = 13'h1FF4;
assign coeff_phase37[2] = 13'h0015;
assign coeff_phase37[3] = 13'h0054;
assign coeff_phase37[4] = 13'h1DE9;
assign coeff_phase37[5] = 13'h0B3B;
assign coeff_phase37[6] = 13'h07E5;
assign coeff_phase37[7] = 13'h1E59;
assign coeff_phase37[8] = 13'h0035;
assign coeff_phase37[9] = 13'h0017;
assign coeff_phase37[10] = 13'h1FF8;
assign coeff_phase37[11] = 13'h1FFB;
assign coeff_phase38[0] = 13'h1FFC;
assign coeff_phase38[1] = 13'h1FF4;
assign coeff_phase38[2] = 13'h0014;
assign coeff_phase38[3] = 13'h0056;
assign coeff_phase38[4] = 13'h1DE4;
assign coeff_phase38[5] = 13'h0B8A;
assign coeff_phase38[6] = 13'h078D;
assign coeff_phase38[7] = 13'h1E68;
assign coeff_phase38[8] = 13'h0032;
assign coeff_phase38[9] = 13'h0017;
assign coeff_phase38[10] = 13'h1FF8;
assign coeff_phase38[11] = 13'h1FFB;
assign coeff_phase39[0] = 13'h1FFC;
assign coeff_phase39[1] = 13'h1FF4;
assign coeff_phase39[2] = 13'h0013;
assign coeff_phase39[3] = 13'h0059;
assign coeff_phase39[4] = 13'h1DE0;
assign coeff_phase39[5] = 13'h0BD7;
assign coeff_phase39[6] = 13'h0735;
assign coeff_phase39[7] = 13'h1E78;
assign coeff_phase39[8] = 13'h002E;
assign coeff_phase39[9] = 13'h0017;
assign coeff_phase39[10] = 13'h1FF9;
assign coeff_phase39[11] = 13'h1FFB;
assign coeff_phase40[0] = 13'h1FFC;
assign coeff_phase40[1] = 13'h1FF4;
assign coeff_phase40[2] = 13'h0013;
assign coeff_phase40[3] = 13'h005A;
assign coeff_phase40[4] = 13'h1DDE;
assign coeff_phase40[5] = 13'h0C23;
assign coeff_phase40[6] = 13'h06DD;
assign coeff_phase40[7] = 13'h1E89;
assign coeff_phase40[8] = 13'h002B;
assign coeff_phase40[9] = 13'h0016;
assign coeff_phase40[10] = 13'h1FF9;
assign coeff_phase40[11] = 13'h1FFB;
assign coeff_phase41[0] = 13'h1FFC;
assign coeff_phase41[1] = 13'h1FF4;
assign coeff_phase41[2] = 13'h0012;
assign coeff_phase41[3] = 13'h005C;
assign coeff_phase41[4] = 13'h1DDD;
assign coeff_phase41[5] = 13'h0C6D;
assign coeff_phase41[6] = 13'h0685;
assign coeff_phase41[7] = 13'h1E9A;
assign coeff_phase41[8] = 13'h0027;
assign coeff_phase41[9] = 13'h0016;
assign coeff_phase41[10] = 13'h1FFA;
assign coeff_phase41[11] = 13'h1FFB;
assign coeff_phase42[0] = 13'h1FFC;
assign coeff_phase42[1] = 13'h1FF4;
assign coeff_phase42[2] = 13'h0011;
assign coeff_phase42[3] = 13'h005D;
assign coeff_phase42[4] = 13'h1DDE;
assign coeff_phase42[5] = 13'h0CB5;
assign coeff_phase42[6] = 13'h062E;
assign coeff_phase42[7] = 13'h1EAB;
assign coeff_phase42[8] = 13'h0024;
assign coeff_phase42[9] = 13'h0015;
assign coeff_phase42[10] = 13'h1FFA;
assign coeff_phase42[11] = 13'h1FFB;
assign coeff_phase43[0] = 13'h1FFD;
assign coeff_phase43[1] = 13'h1FF4;
assign coeff_phase43[2] = 13'h0010;
assign coeff_phase43[3] = 13'h005E;
assign coeff_phase43[4] = 13'h1DE1;
assign coeff_phase43[5] = 13'h0CFB;
assign coeff_phase43[6] = 13'h05D7;
assign coeff_phase43[7] = 13'h1EBC;
assign coeff_phase43[8] = 13'h0021;
assign coeff_phase43[9] = 13'h0015;
assign coeff_phase43[10] = 13'h1FFB;
assign coeff_phase43[11] = 13'h1FFB;
assign coeff_phase44[0] = 13'h1FFD;
assign coeff_phase44[1] = 13'h1FF4;
assign coeff_phase44[2] = 13'h000F;
assign coeff_phase44[3] = 13'h005F;
assign coeff_phase44[4] = 13'h1DE6;
assign coeff_phase44[5] = 13'h0D3E;
assign coeff_phase44[6] = 13'h0581;
assign coeff_phase44[7] = 13'h1ECE;
assign coeff_phase44[8] = 13'h001E;
assign coeff_phase44[9] = 13'h0014;
assign coeff_phase44[10] = 13'h1FFB;
assign coeff_phase44[11] = 13'h1FFB;
assign coeff_phase45[0] = 13'h1FFD;
assign coeff_phase45[1] = 13'h1FF4;
assign coeff_phase45[2] = 13'h000E;
assign coeff_phase45[3] = 13'h005F;
assign coeff_phase45[4] = 13'h1DEC;
assign coeff_phase45[5] = 13'h0D7F;
assign coeff_phase45[6] = 13'h052C;
assign coeff_phase45[7] = 13'h1EE0;
assign coeff_phase45[8] = 13'h001B;
assign coeff_phase45[9] = 13'h0013;
assign coeff_phase45[10] = 13'h1FFC;
assign coeff_phase45[11] = 13'h1FFB;
assign coeff_phase46[0] = 13'h1FFD;
assign coeff_phase46[1] = 13'h1FF4;
assign coeff_phase46[2] = 13'h000D;
assign coeff_phase46[3] = 13'h005E;
assign coeff_phase46[4] = 13'h1DF4;
assign coeff_phase46[5] = 13'h0DBD;
assign coeff_phase46[6] = 13'h04D8;
assign coeff_phase46[7] = 13'h1EF1;
assign coeff_phase46[8] = 13'h0018;
assign coeff_phase46[9] = 13'h0013;
assign coeff_phase46[10] = 13'h1FFC;
assign coeff_phase46[11] = 13'h1FFB;
assign coeff_phase47[0] = 13'h1FFE;
assign coeff_phase47[1] = 13'h1FF4;
assign coeff_phase47[2] = 13'h000C;
assign coeff_phase47[3] = 13'h005E;
assign coeff_phase47[4] = 13'h1DFF;
assign coeff_phase47[5] = 13'h0DF9;
assign coeff_phase47[6] = 13'h0485;
assign coeff_phase47[7] = 13'h1F03;
assign coeff_phase47[8] = 13'h0016;
assign coeff_phase47[9] = 13'h0012;
assign coeff_phase47[10] = 13'h1FFD;
assign coeff_phase47[11] = 13'h1FFC;
assign coeff_phase48[0] = 13'h1FFE;
assign coeff_phase48[1] = 13'h1FF5;
assign coeff_phase48[2] = 13'h000B;
assign coeff_phase48[3] = 13'h005D;
assign coeff_phase48[4] = 13'h1E0B;
assign coeff_phase48[5] = 13'h0E32;
assign coeff_phase48[6] = 13'h0433;
assign coeff_phase48[7] = 13'h1F15;
assign coeff_phase48[8] = 13'h0013;
assign coeff_phase48[9] = 13'h0011;
assign coeff_phase48[10] = 13'h1FFD;
assign coeff_phase48[11] = 13'h1FFC;
assign coeff_phase49[0] = 13'h1FFE;
assign coeff_phase49[1] = 13'h1FF5;
assign coeff_phase49[2] = 13'h000A;
assign coeff_phase49[3] = 13'h005B;
assign coeff_phase49[4] = 13'h1E19;
assign coeff_phase49[5] = 13'h0E68;
assign coeff_phase49[6] = 13'h03E2;
assign coeff_phase49[7] = 13'h1F26;
assign coeff_phase49[8] = 13'h0011;
assign coeff_phase49[9] = 13'h0010;
assign coeff_phase49[10] = 13'h1FFD;
assign coeff_phase49[11] = 13'h1FFC;
assign coeff_phase50[0] = 13'h1FFE;
assign coeff_phase50[1] = 13'h1FF6;
assign coeff_phase50[2] = 13'h0009;
assign coeff_phase50[3] = 13'h0059;
assign coeff_phase50[4] = 13'h1E29;
assign coeff_phase50[5] = 13'h0E9B;
assign coeff_phase50[6] = 13'h0393;
assign coeff_phase50[7] = 13'h1F37;
assign coeff_phase50[8] = 13'h000E;
assign coeff_phase50[9] = 13'h000F;
assign coeff_phase50[10] = 13'h1FFE;
assign coeff_phase50[11] = 13'h1FFC;
assign coeff_phase51[0] = 13'h1FFF;
assign coeff_phase51[1] = 13'h1FF6;
assign coeff_phase51[2] = 13'h0008;
assign coeff_phase51[3] = 13'h0056;
assign coeff_phase51[4] = 13'h1E3C;
assign coeff_phase51[5] = 13'h0ECA;
assign coeff_phase51[6] = 13'h0345;
assign coeff_phase51[7] = 13'h1F48;
assign coeff_phase51[8] = 13'h000C;
assign coeff_phase51[9] = 13'h000E;
assign coeff_phase51[10] = 13'h1FFE;
assign coeff_phase51[11] = 13'h1FFD;
assign coeff_phase52[0] = 13'h1FFF;
assign coeff_phase52[1] = 13'h1FF6;
assign coeff_phase52[2] = 13'h0007;
assign coeff_phase52[3] = 13'h0053;
assign coeff_phase52[4] = 13'h1E51;
assign coeff_phase52[5] = 13'h0EF7;
assign coeff_phase52[6] = 13'h02F9;
assign coeff_phase52[7] = 13'h1F59;
assign coeff_phase52[8] = 13'h000A;
assign coeff_phase52[9] = 13'h000D;
assign coeff_phase52[10] = 13'h1FFF;
assign coeff_phase52[11] = 13'h1FFD;
assign coeff_phase53[0] = 13'h1FFF;
assign coeff_phase53[1] = 13'h1FF7;
assign coeff_phase53[2] = 13'h0006;
assign coeff_phase53[3] = 13'h0050;
assign coeff_phase53[4] = 13'h1E68;
assign coeff_phase53[5] = 13'h0F20;
assign coeff_phase53[6] = 13'h02AF;
assign coeff_phase53[7] = 13'h1F6A;
assign coeff_phase53[8] = 13'h0009;
assign coeff_phase53[9] = 13'h000C;
assign coeff_phase53[10] = 13'h1FFF;
assign coeff_phase53[11] = 13'h1FFD;
assign coeff_phase54[0] = 13'h1FFF;
assign coeff_phase54[1] = 13'h1FF8;
assign coeff_phase54[2] = 13'h0005;
assign coeff_phase54[3] = 13'h004B;
assign coeff_phase54[4] = 13'h1E81;
assign coeff_phase54[5] = 13'h0F47;
assign coeff_phase54[6] = 13'h0266;
assign coeff_phase54[7] = 13'h1F7A;
assign coeff_phase54[8] = 13'h0007;
assign coeff_phase54[9] = 13'h000B;
assign coeff_phase54[10] = 13'h1FFF;
assign coeff_phase54[11] = 13'h1FFD;
assign coeff_phase55[0] = 13'h0000;
assign coeff_phase55[1] = 13'h1FF8;
assign coeff_phase55[2] = 13'h0004;
assign coeff_phase55[3] = 13'h0046;
assign coeff_phase55[4] = 13'h1E9D;
assign coeff_phase55[5] = 13'h0F69;
assign coeff_phase55[6] = 13'h021F;
assign coeff_phase55[7] = 13'h1F89;
assign coeff_phase55[8] = 13'h0005;
assign coeff_phase55[9] = 13'h000A;
assign coeff_phase55[10] = 13'h1FFF;
assign coeff_phase55[11] = 13'h1FFE;
assign coeff_phase56[0] = 13'h0000;
assign coeff_phase56[1] = 13'h1FF9;
assign coeff_phase56[2] = 13'h0003;
assign coeff_phase56[3] = 13'h0041;
assign coeff_phase56[4] = 13'h1EBB;
assign coeff_phase56[5] = 13'h0F88;
assign coeff_phase56[6] = 13'h01DA;
assign coeff_phase56[7] = 13'h1F99;
assign coeff_phase56[8] = 13'h0004;
assign coeff_phase56[9] = 13'h0009;
assign coeff_phase56[10] = 13'h0000;
assign coeff_phase56[11] = 13'h1FFE;
assign coeff_phase57[0] = 13'h0000;
assign coeff_phase57[1] = 13'h1FFA;
assign coeff_phase57[2] = 13'h0002;
assign coeff_phase57[3] = 13'h003B;
assign coeff_phase57[4] = 13'h1EDB;
assign coeff_phase57[5] = 13'h0FA4;
assign coeff_phase57[6] = 13'h0197;
assign coeff_phase57[7] = 13'h1FA8;
assign coeff_phase57[8] = 13'h0003;
assign coeff_phase57[9] = 13'h0007;
assign coeff_phase57[10] = 13'h0000;
assign coeff_phase57[11] = 13'h1FFE;
assign coeff_phase58[0] = 13'h0000;
assign coeff_phase58[1] = 13'h1FFB;
assign coeff_phase58[2] = 13'h0002;
assign coeff_phase58[3] = 13'h0034;
assign coeff_phase58[4] = 13'h1EFE;
assign coeff_phase58[5] = 13'h0FBC;
assign coeff_phase58[6] = 13'h0156;
assign coeff_phase58[7] = 13'h1FB6;
assign coeff_phase58[8] = 13'h0002;
assign coeff_phase58[9] = 13'h0006;
assign coeff_phase58[10] = 13'h0000;
assign coeff_phase58[11] = 13'h1FFF;
assign coeff_phase59[0] = 13'h0000;
assign coeff_phase59[1] = 13'h1FFC;
assign coeff_phase59[2] = 13'h0001;
assign coeff_phase59[3] = 13'h002D;
assign coeff_phase59[4] = 13'h1F23;
assign coeff_phase59[5] = 13'h0FD1;
assign coeff_phase59[6] = 13'h0118;
assign coeff_phase59[7] = 13'h1FC4;
assign coeff_phase59[8] = 13'h0001;
assign coeff_phase59[9] = 13'h0005;
assign coeff_phase59[10] = 13'h0000;
assign coeff_phase59[11] = 13'h1FFF;
assign coeff_phase60[0] = 13'h0000;
assign coeff_phase60[1] = 13'h1FFC;
assign coeff_phase60[2] = 13'h0000;
assign coeff_phase60[3] = 13'h0025;
assign coeff_phase60[4] = 13'h1F4A;
assign coeff_phase60[5] = 13'h0FE2;
assign coeff_phase60[6] = 13'h00DB;
assign coeff_phase60[7] = 13'h1FD1;
assign coeff_phase60[8] = 13'h0001;
assign coeff_phase60[9] = 13'h0004;
assign coeff_phase60[10] = 13'h0000;
assign coeff_phase60[11] = 13'h1FFF;
assign coeff_phase61[0] = 13'h0000;
assign coeff_phase61[1] = 13'h1FFD;
assign coeff_phase61[2] = 13'h0000;
assign coeff_phase61[3] = 13'h001D;
assign coeff_phase61[4] = 13'h1F74;
assign coeff_phase61[5] = 13'h0FEF;
assign coeff_phase61[6] = 13'h00A1;
assign coeff_phase61[7] = 13'h1FDE;
assign coeff_phase61[8] = 13'h0000;
assign coeff_phase61[9] = 13'h0003;
assign coeff_phase61[10] = 13'h0000;
assign coeff_phase61[11] = 13'h0000;
assign coeff_phase62[0] = 13'h0000;
assign coeff_phase62[1] = 13'h1FFE;
assign coeff_phase62[2] = 13'h0000;
assign coeff_phase62[3] = 13'h0014;
assign coeff_phase62[4] = 13'h1FA1;
assign coeff_phase62[5] = 13'h0FF8;
assign coeff_phase62[6] = 13'h0069;
assign coeff_phase62[7] = 13'h1FEA;
assign coeff_phase62[8] = 13'h0000;
assign coeff_phase62[9] = 13'h0002;
assign coeff_phase62[10] = 13'h0000;
assign coeff_phase62[11] = 13'h0000;
assign coeff_phase63[0] = 13'h0000;
assign coeff_phase63[1] = 13'h1FFF;
assign coeff_phase63[2] = 13'h0000;
assign coeff_phase63[3] = 13'h000A;
assign coeff_phase63[4] = 13'h1FCF;
assign coeff_phase63[5] = 13'h0FFE;
assign coeff_phase63[6] = 13'h0033;
assign coeff_phase63[7] = 13'h1FF6;
assign coeff_phase63[8] = 13'h0000;
assign coeff_phase63[9] = 13'h0001;
assign coeff_phase63[10] = 13'h0000;
assign coeff_phase63[11] = 13'h0000;


reg [5:0] coeff_sel_sync;

always @(posedge clk) begin
    coeff_sel_sync <= coeff_sel;  // Or use 2-stage sync if it's from another clock domain
end


generate
    genvar ptr_phase;
    for (ptr_phase = 0; ptr_phase < 12; ptr_phase = ptr_phase + 1) begin : coeff_assign
        always @(posedge clk) begin
            case (coeff_sel_sync)
                6'd0:  coeff[ptr_phase] <= coeff_phase0 [ptr_phase];
                6'd1:  coeff[ptr_phase] <= coeff_phase1 [ptr_phase];
                6'd2:  coeff[ptr_phase] <= coeff_phase2 [ptr_phase];
                6'd3:  coeff[ptr_phase] <= coeff_phase3 [ptr_phase];
                6'd4:  coeff[ptr_phase] <= coeff_phase4 [ptr_phase];
                6'd5:  coeff[ptr_phase] <= coeff_phase5 [ptr_phase];
                6'd6:  coeff[ptr_phase] <= coeff_phase6 [ptr_phase];
                6'd7:  coeff[ptr_phase] <= coeff_phase7 [ptr_phase];
                6'd8:  coeff[ptr_phase] <= coeff_phase8 [ptr_phase];
                6'd9:  coeff[ptr_phase] <= coeff_phase9 [ptr_phase];
                6'd10: coeff[ptr_phase] <= coeff_phase10[ptr_phase];
                6'd11: coeff[ptr_phase] <= coeff_phase11[ptr_phase];
                6'd12: coeff[ptr_phase] <= coeff_phase12[ptr_phase];
                6'd13: coeff[ptr_phase] <= coeff_phase13[ptr_phase];
                6'd14: coeff[ptr_phase] <= coeff_phase14[ptr_phase];
                6'd15: coeff[ptr_phase] <= coeff_phase15[ptr_phase];
                6'd16: coeff[ptr_phase] <= coeff_phase16[ptr_phase];
                6'd17: coeff[ptr_phase] <= coeff_phase17[ptr_phase];
                6'd18: coeff[ptr_phase] <= coeff_phase18[ptr_phase];
                6'd19: coeff[ptr_phase] <= coeff_phase19[ptr_phase];
                6'd20: coeff[ptr_phase] <= coeff_phase20[ptr_phase];
                6'd21: coeff[ptr_phase] <= coeff_phase21[ptr_phase];
                6'd22: coeff[ptr_phase] <= coeff_phase22[ptr_phase];
                6'd23: coeff[ptr_phase] <= coeff_phase23[ptr_phase];
                6'd24: coeff[ptr_phase] <= coeff_phase24[ptr_phase];
                6'd25: coeff[ptr_phase] <= coeff_phase25[ptr_phase];
                6'd26: coeff[ptr_phase] <= coeff_phase26[ptr_phase];
                6'd27: coeff[ptr_phase] <= coeff_phase27[ptr_phase];
                6'd28: coeff[ptr_phase] <= coeff_phase28[ptr_phase];
                6'd29: coeff[ptr_phase] <= coeff_phase29[ptr_phase];
                6'd30: coeff[ptr_phase] <= coeff_phase30[ptr_phase];
                6'd31: coeff[ptr_phase] <= coeff_phase31[ptr_phase];
                6'd32: coeff[ptr_phase] <= coeff_phase32[ptr_phase];
                6'd33: coeff[ptr_phase] <= coeff_phase33[ptr_phase];
                6'd34: coeff[ptr_phase] <= coeff_phase34[ptr_phase];
                6'd35: coeff[ptr_phase] <= coeff_phase35[ptr_phase];
                6'd36: coeff[ptr_phase] <= coeff_phase36[ptr_phase];
                6'd37: coeff[ptr_phase] <= coeff_phase37[ptr_phase];
                6'd38: coeff[ptr_phase] <= coeff_phase38[ptr_phase];
                6'd39: coeff[ptr_phase] <= coeff_phase39[ptr_phase];
                6'd40: coeff[ptr_phase] <= coeff_phase40[ptr_phase];
                6'd41: coeff[ptr_phase] <= coeff_phase41[ptr_phase];
                6'd42: coeff[ptr_phase] <= coeff_phase42[ptr_phase];
                6'd43: coeff[ptr_phase] <= coeff_phase43[ptr_phase];
                6'd44: coeff[ptr_phase] <= coeff_phase44[ptr_phase];
                6'd45: coeff[ptr_phase] <= coeff_phase45[ptr_phase];
                6'd46: coeff[ptr_phase] <= coeff_phase46[ptr_phase];
                6'd47: coeff[ptr_phase] <= coeff_phase47[ptr_phase];
                6'd48: coeff[ptr_phase] <= coeff_phase48[ptr_phase];
                6'd49: coeff[ptr_phase] <= coeff_phase49[ptr_phase];
                6'd50: coeff[ptr_phase] <= coeff_phase50[ptr_phase];
                6'd51: coeff[ptr_phase] <= coeff_phase51[ptr_phase];
                6'd52: coeff[ptr_phase] <= coeff_phase52[ptr_phase];
                6'd53: coeff[ptr_phase] <= coeff_phase53[ptr_phase];
                6'd54: coeff[ptr_phase] <= coeff_phase54[ptr_phase];
                6'd55: coeff[ptr_phase] <= coeff_phase55[ptr_phase];
                6'd56: coeff[ptr_phase] <= coeff_phase56[ptr_phase];
                6'd57: coeff[ptr_phase] <= coeff_phase57[ptr_phase];
                6'd58: coeff[ptr_phase] <= coeff_phase58[ptr_phase];
                6'd59: coeff[ptr_phase] <= coeff_phase59[ptr_phase];
                6'd60: coeff[ptr_phase] <= coeff_phase60[ptr_phase];
                6'd61: coeff[ptr_phase] <= coeff_phase61[ptr_phase];
                6'd62: coeff[ptr_phase] <= coeff_phase62[ptr_phase];
                6'd63: coeff[ptr_phase] <= coeff_phase63[ptr_phase];
                default: coeff[ptr_phase] <= coeff_phase0[ptr_phase]; // Default case
            endcase
        end
    end
endgenerate



/*------- Shift Register ----------*/
  
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
