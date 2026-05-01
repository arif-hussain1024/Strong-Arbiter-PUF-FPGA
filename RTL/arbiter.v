// Arbiter Module for Arbiter PUF
// Uses a D-Flip-Flop to capture which path arrived first.
module arbiter(
    input top_in,      // Top path input signal (D input)
    input bot_in,      // Bottom path input signal (CLK input)
    output reg response    // PUF response bit
);

    // If top_in (D) arrives before bot_in (CLK), response latches 1.
    // If bot_in (CLK) arrives before top_in (D), response latches 0.
    always @(posedge bot_in) begin
        response <= top_in;
    end
    
endmodule