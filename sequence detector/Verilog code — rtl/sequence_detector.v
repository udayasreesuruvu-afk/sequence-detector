`timescale 1ns/1ps

module sequence_detector (
    input  wire clk,
    input  wire reset,
    input  wire data_in,
    output reg  detected
);

    // FSM states
    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;

    reg [2:0] state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin

        next_state = S0;
        detected   = 1'b0;

        case (state)

            // No matching bits
            S0: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S0;
            end

            // Detected "1"
            S1: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = S2;
            end

            // Detected "10"
            S2: begin
                if (data_in)
                    next_state = S3;
                else
                    next_state = S0;
            end

            // Detected "101"
            S3: begin
                if (data_in) begin
                    // 1011 detected
                    next_state = S1;
                    detected   = 1'b1;
                end
                else begin
                    next_state = S2;
                end
            end

            default: begin
                next_state = S0;
                detected   = 1'b0;
            end

        endcase
    end

endmodule