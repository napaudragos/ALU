module reg8bit (
    input clk,
    input rst,
    input load,
    input [7:0] in,       // datele de intrare
    output reg [7:0] out   // datele de ie?ire
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 8'b00000000;
        else if (load)
            out <= in;
    end

endmodule