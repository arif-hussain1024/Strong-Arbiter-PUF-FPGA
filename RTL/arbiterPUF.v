// -----------------------------------------------------------------------
// DELAY BUFFER MODULE
// Uses a LUT1 to force a physical delay without being optimized away
// -----------------------------------------------------------------------
module lut_delay(
    input in,
    output out
);
    // LUT1 configured as a buffer (O = I0)
    // DONT_TOUCH ensures Vivado keeps this cell to create real delay
    (* DONT_TOUCH = "TRUE" *) LUT1 #(.INIT(2'b10)) buff (.O(out), .I0(in));
endmodule

// -----------------------------------------------------------------------
// ARBITER PUF TOP MODULE
// -----------------------------------------------------------------------
module arbiterPUF #(
    parameter STAGES = 32,
    parameter SEED = 12345,
    parameter real DELAY_MEAN = 2.0,
    parameter real DELAY_STDDEV = 0.5
)(
    input trigger,                  
    input [STAGES-1:0] challenge,   
    output response                 
);
    
    // Internal wires
    (* DONT_TOUCH = "TRUE" *) wire [STAGES:0] top_path;
    (* DONT_TOUCH = "TRUE" *) wire [STAGES:0] bot_path;
    
    // Start the race
    assign top_path[0] = trigger; 
    assign bot_path[0] = trigger; 
    
    // Generate the chain
    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : puf_chain
            // Parameters for simulation
            localparam real top_delay = DELAY_MEAN + (((i * 7 + SEED) % 100) - 50) * DELAY_STDDEV / 50.0;
            localparam real bot_delay = DELAY_MEAN + (((i * 13 + SEED) % 100) - 50) * DELAY_STDDEV / 50.0;
            
            switchPUF #(
                .TOP_DELAY(top_delay), .BOT_DELAY(bot_delay)
            ) stage (
                .top_in(top_path[i]),   .bot_in(bot_path[i]),
                .sel(challenge[i]),
                .top_out(top_path[i+1]), .bot_out(bot_path[i+1])
            );
        end
    endgenerate
    
    // --- THE FIX: MANUAL DELAY INSERTION ---
    wire bot_delayed_1;
    wire bot_delayed_2;
    
    // Insert 2 delay buffers on the "Clock" (Bottom) path.
    // This forces the Clock to arrive LATER, giving Data time to settle to '1'.
    lut_delay d1 (.in(bot_path[STAGES]), .out(bot_delayed_1));
    lut_delay d2 (.in(bot_delayed_1),    .out(bot_delayed_2));

    // Final Arbiter
    // Top = Data (Arrives First)
    // Bot = Clock (Arrives Second due to delay) -> Captures the '1'
    arbiter final_arbiter (
        .top_in(top_path[STAGES]),
        .bot_in(bot_delayed_2),    // Use the delayed signal for Clock
        .response(response)
    );
    
endmodule