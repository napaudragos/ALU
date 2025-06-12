`timescale 1ns / 1ps


module top_level_tb;

    reg clk, rst, start;
    reg [7:0] inbus;
    reg [1:0] op;

    wire final;
    wire [15:0] outbus;
    wire [3:0] state;
    wire [7:0] A, Q, M; // debug
    wire ready;
    wire c3_debug;
    wire op_latched_debug;
    // Instan?ierea modulului top_level
    alu_top uut (
        .clk(clk),
        .rst(rst),
        .inbus(inbus),
        .op(op),
        .start(start),
        .final(final),
        .outbus(outbus),
        .state(state),
        .A(A),
        .Q(Q),
        .M(M),
        .ready(ready),
        .c3_debug(c3_debug),
        .op_latched_debug(op_latched_debug)
    );

    // Ceas
    initial clk = 0;
    always #5 clk = ~clk;

    // Task-uri de testare

    task add;
        input signed [7:0] in1, in2;
        reg signed [15:0] expected;
        begin
            expected = in1 + in2;

            op = 2'b00;     
            wait(ready);
            start = 1;
            inbus = in1; #10;
            start = 0;   #10;
            inbus = in2; #10;

            wait(final); #10;

            if ({8'b00000000, outbus[15:8]} !== expected)
                $display("FAIL: %d + %d = %d, expected %d", in1, in2, {8'b00000000, outbus[15:8]}, expected);
            else
                $display("PASS: %d + %d = %d", in1, in2, {8'b00000000, outbus[15:8]});
        end
    endtask

    task subtract;
        input signed [7:0] in1, in2;
        reg signed [15:0] expected;
        begin
            expected = in2 - in1;

            op = 2'b01; #10 
            wait(ready);
    
            start = 1;
            inbus = in1; #10;
            start = 0;   #10;
            inbus = in2; #10;

            wait(final); #10;
            if ({8'b00000000, outbus[15:8]} !== expected)
                $display("FAIL: %d + %d = %d, expected %d", in1, in2, {8'b00000000, outbus[15:8]}, expected);
            else
                $display("PASS: %d + %d = %d", in1, in2, {8'b00000000, outbus[15:8]});
        end
    endtask

    task multiply;
        input signed [7:0] in1, in2;
        reg signed [15:0] expected;
        begin
            expected = in1 * in2;
            
            op = 2'b10;   
            #10;
            wait(ready);
            start = 1;
            inbus = in1; #10;
            start = 0;   #10;
            inbus = in2; #10;

            wait(final); #10;

            if (outbus !== expected)
                $display("FAIL: %d * %d = %d, expected %d", in1, in2, outbus, expected);
            else
                $display("PASS: %d * %d = %d", in1, in2, outbus);
        end
    endtask

    task divide;
        input [15:0] in1;
        input [7:0] in2;
        reg [7:0] expected_quotient, expected_remainder;
        begin
            expected_quotient = in1 / in2;
            expected_remainder = in1 % in2;

            op = 2'b11;
            #10;
            wait(ready);
            start = 1;
            inbus = in1[15:8]; #10;
            start = 0;         #10;
            inbus = in1[7:0];  #10;
            inbus = in2;       #20;

            wait(final); #10;

            if (outbus[7:0] !== expected_quotient || outbus[15:8] !== expected_remainder)
                $display("FAIL: %d / %d = %d | R: %d, expected %d | R: %d",
                    in1, in2, outbus[15:8], outbus[7:0], expected_quotient, expected_remainder);
            else
                $display("PASS: %d / %d = %d | R: %d", in1, in2, outbus[7:0], outbus[15:8]);
        end
    endtask

    // Testare complet?
    initial begin
        $display("=== TEST BENCH START ===");

        rst = 1; start = 0; op = 2'b00; inbus = 8'h00;
        #20 rst = 0;

        add(20, 10);
        subtract(10, 30);
        multiply(5, 4);
        divide(16'h03E8, 8'd12); // 1000 / 12 // 

        $display("=== TEST BENCH END ===");
        $stop;
    end

endmodule


