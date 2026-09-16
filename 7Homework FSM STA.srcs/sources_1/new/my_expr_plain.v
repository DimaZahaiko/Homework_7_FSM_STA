// my_expr_plain.v
// Non-pipelined version of ((a+b)*c)-d.
//


module my_expr_plain (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [15:0] result
);

    // ---- Stage 0: registered inputs (this is what fixes it) ----
    reg [7:0] a_reg, b_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 8'd0;
            b_reg <= 8'd0;

        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // ---- Stage 1: the long combinational path + registered output ----
    always @(posedge clk or posedge rst) begin
        if (rst)
            result <= 16'd0;
        else
            result <= (a_reg + b_reg)*(a_reg - b_reg);
    end

endmodule
