module reg1bit (
    input clk,
    input rst,
    input load,
    input in,
    output reg out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 1'b0;
        else if (load)
            out <= in;
    end

endmodule
