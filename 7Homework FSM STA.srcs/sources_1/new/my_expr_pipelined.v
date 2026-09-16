// my_expr_pipelined.v
// Pipelined version of (a+b)(a-b)


module my_expr_pipelined(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [15:0] result
);

    // ---- Stage 0: registered inputs (same fix) ----
    reg [7:0] a_reg, b_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 8'd0;
            b_reg <= 8'd0;
        end 
        else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // ---- Stage 1: sum and differance of a and b  ----
    reg [7:0] sum;
    reg [7:0] dif;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            //result <= 16'd0;
            sum <= 8'd0;
            dif <= 8'd0; 
            end
        else begin
            sum <= a_reg + b_reg;
            dif <= a_reg - b_reg;
            end
    end
    
    // --- Stage 2: multiplication
    always @(posedge clk or posedge rst) begin
        if (rst) result <= 16'd0;
        else result <= sum * dif;
    end
    
endmodule
