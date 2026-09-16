

module alu(
    input clk,
    input rst,
    input [3:0] a, b,
    input [1:0] op,
    input oe,
    output wire [3:0] result
    );

// ---- Stage 1: registered inputs ----
    reg a_reg, b_reg, op_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg  <= 4'b0;
            b_reg  <= 4'b0;
            op_reg <= 2'b0;
        end
        else begin
            a_reg  <= a;
            b_reg  <= b;
            op_reg <= op;
        end
    end
    
// ---- Combinational ALU logic (operates on the registered inputs) ----
    reg [3:0 ] result_alu;
    
    always @(*) begin
        result_alu = 4'b0;
        case (op_reg)
            2'b00: result_alu = a + b;
            2'b01: result_alu = a - b;
            2'b10: result_alu = a & b;
            2'b11: result_alu = a | b;
        default: result_alu = 4'b0;
        endcase
    end

// ---- Stage 2: registered output ----
    reg [3: 0] result_reg;
    
    always @(posedge clk or posedge rst) begin
        if (rst) result_reg <= 4'b0;
        else result_reg <= result_alu;
    end

// ---- Tri-state output: oe=0 -> Z (demonstrates the Z state) ----
    assign result = oe ? result_reg: 4'bZZZZ;

endmodule
