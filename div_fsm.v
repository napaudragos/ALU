module div_fsm (
    input clk,
    input rst,
    input enable,
    input start,
    input a7,
    input cnt_ok,
    input [3:0] state_curr,

    output reg [3:0] state_next,

    output reg c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
    output reg ready
);

    always @(*) begin
        // Reset semnale de control
        {c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10} = 11'd0;
        state_next = state_curr;
        ready = (state_curr == 4'd0);

        if (!enable) begin
            state_next = 4'd0;
        end else begin
            case (state_curr)

                // IDLE ? a?teapt? începutul opera?iei
                4'd0: begin
                    if (start)
                        state_next = 4'd11;  // trece în WAIT_START_FALL
                end

                // WAIT_START_FALL ? a?teapt? c?derea lui start
                4'd11: begin
                    if (!start) begin
                        c9 = 1;              // încarc? A (partea superioar? a împ?r?itului)
                        state_next = 4'd1;
                    end
                end

                // LOAD Q (partea inferioar? a împ?r?itului)
                4'd1: begin
                    c1 = 1;                 // încarc? Q
                    state_next = 4'd2;
                end

                // LOAD B (împ?r?itorul)
                4'd2: begin
                    c0 = 1;                 // încarc? M
                    state_next = 4'd3;
                end

                // SHL AQ
                4'd3: begin
                    c4 = 1;                 // shift stânga A:Q
                    state_next = 4'd4;
                end

                // A = A - M
                4'd4: begin
                    c2 = 1;                 // încarc? A cu rezultatul
                    c3 = 1;                 // sc?dere
                    state_next = 4'd5;
                end

                // CHECK A < 0
                4'd5: begin
                    if (a7) begin
                        // Dac? A < 0, restaur?m ?i Q[0] = 0
                        c2 = 1;             // restaur?m A = A + M
                        c10 = 1;            // for??m Q[0] = 0
                        state_next = 4'd6;
                    end else begin
                        // A >= 0 ? Q[0] = 1
                        c10 = 1;
                        c6 = 1;             // bit_in = 1
                        state_next = 4'd6;
                    end
                end

                // INCREMENT COUNTER + CHECK DONE
                4'd6: begin
                    c5 = 1;                 // incrementare contor
                    if (cnt_ok)
                        state_next = 4'd7;
                    else
                        state_next = 4'd3; // mai facem un pas
                end

                // OUT QUOTIENT
                4'd7: begin
                    c7 = 1;                 // A => outbus[7:0]
                    state_next = 4'd8;
                end

                // OUT REMAINDER
                4'd8: begin
                    c8 = 1;                 // A => outbus[15:0]
                    state_next = 4'd0;
                end

                default: state_next = 4'd0;

            endcase
        end
    end

endmodule

