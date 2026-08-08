`timescale 1ns/1ps

module tb_sequence_detector;

    reg  clk;
    reg  reset;
    reg  data_in;
    wire detected;

    // Instantiate DUT
    sequence_detector uut (
        .clk      (clk),
        .reset    (reset),
        .data_in  (data_in),
        .detected (detected)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    // Task to send one bit
    task send_bit;
        input bit_value;
        begin
            data_in = bit_value;
            #10;
        end
    endtask

    initial begin

        // Generate waveform
        $dumpfile("sequence_detector.vcd");
        $dumpvars(0, tb_sequence_detector);

        // Initialize
        clk     = 1'b0;
        reset   = 1'b1;
        data_in = 1'b0;

        $display("==============================================");
        $display("        1011 SEQUENCE DETECTOR TEST");
        $display("==============================================");
        $display("Time\tReset\tInput\tDetected");
        $display("----------------------------------------------");

        $monitor("%0t\t%b\t%b\t%b",
                 $time,
                 reset,
                 data_in,
                 detected);

        // Reset
        #12;
        reset = 1'b0;

        // ------------------------------------------------
        // Send 1011
        // ------------------------------------------------
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        // ------------------------------------------------
        // Send 1011011
        // This contains two overlapping 1011 sequences
        // ------------------------------------------------
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);

        #10;

        $display("----------------------------------------------");
        $display("Simulation completed successfully.");

        $finish;

    end

endmodule