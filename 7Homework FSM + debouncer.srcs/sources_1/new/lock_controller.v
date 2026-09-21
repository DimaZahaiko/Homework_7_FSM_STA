
module lock_controller(
    input clk, rst,
    input [3:0] digit_raw,
    output reg unlocked_led = 0 // active high
    );
    
    wire [3:0] digit_clean;
    
    debounce dig_in(clk, digit_raw, digit_clean);
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    localparam [3:0] D1 = 4'd2;
    localparam [3:0] D2 = 4'd4;
    localparam [3:0] D3 = 4'd8;
    
    localparam [1:0] LOCKED = 2'b00;
    localparam [1:0] WAIT_D2 = 2'b01;
    localparam [1:0] WAIT_D3 = 2'b10;
    localparam [1:0] UNLOCKED = 2'b11;
    
    always @(posedge clk or posedge rst) begin
        state <= (rst)? LOCKED: next_state;
        end 
        
    reg [3:0] digit_prev;
    
    always @(posedge clk or posedge rst) begin
    if (rst)
        digit_prev <= 0;
    else
        digit_prev <= digit_clean;
    end    
    
    wire new_digit = (digit_prev != digit_clean);

    always @(*) begin
        next_state = state;
        if (new_digit) begin
        case (state)
            LOCKED: next_state = (digit_clean == D1) ? WAIT_D2: LOCKED;
            WAIT_D2: next_state = (digit_clean == D2) ? WAIT_D3: LOCKED;
            WAIT_D3: next_state = (digit_clean == D3) ? UNLOCKED: LOCKED;
            UNLOCKED: next_state = UNLOCKED;
            default: next_state = LOCKED;
        endcase
        end
    end
    
    always @(*) begin
        unlocked_led = (state == UNLOCKED);
    end
    
    
endmodule

module debounce #(parameter integer COUNT_MAX = 5) (
    input  wire clk, input wire [3:0] btn_raw, output reg [3:0] btn_clean = 4'b0
);
    reg [2:0] counter = 3'b0;

    always @(posedge clk) begin
        if (btn_raw != btn_clean) begin
            counter <= counter + 1;
            if (counter == COUNT_MAX - 1) begin
                btn_clean <= btn_raw; counter <= 0;
            end
        end else counter <= 0;
    end
endmodule

