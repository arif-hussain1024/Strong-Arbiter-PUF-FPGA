// Top-Level Wrapper for Urbana Board
module puf_top_urbana(
    input [15:0] SW,        // 16 switches for challenge input
    input BTN0,             // NEW: Button to trigger the race
    output [15:0] LED       // 16 LEDs for output
);
    
    // Internal signals
    wire [31:0] challenge;
    wire response;
    
    // Challenge expansion: 16 switches -> 32-bit challenge
    // Uses {SW, ~SW} to ensure entropy across all stages
    assign challenge = {SW, ~SW};
    
    // Instantiate the PUF
    arbiterPUF #(
        .STAGES(32),
        .SEED(12345)
    ) puf_inst (
        .trigger(BTN0),      // Connect Button 0 to Trigger
        .challenge(challenge),
        .response(response)
    );
    
    // LED outputs
    assign LED[0] = response;      // LED0: PUF response bit
    assign LED[15:1] = SW[15:1];   // LED15-1: Echo switch positions
    
endmodule