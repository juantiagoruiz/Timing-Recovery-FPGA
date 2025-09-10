module prbs5 (
    input  clk,
    input  rst,
    input i_en,
    output prbs_out
);
    reg [4:0] lfsr = 5'b00001; // Seed must not be all zeros

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 5'b00001; // Reset to non-zero value
        else if (i_en)
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // taps at 5 and 3
    end

    assign prbs_out = lfsr[0];
endmodule