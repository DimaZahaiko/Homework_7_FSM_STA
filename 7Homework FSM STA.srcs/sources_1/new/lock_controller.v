
module lock_controller(
    input clk, rst,
    input [3:0] digit_in,
    output reg unlocked_led = 0 // active high
    );
    
    reg [1:0] state;
    reg [1:0] next_state;
    
    localparam [3:0] D1 = 2;
    localparam [3:0] D2 = 4;
    localparam [3:0] D3 = 8;
    
    localparam [1:0] LOCKED = 2'b00;
    localparam [1:0] WAIT_D2 = 2'b01;
    localparam [1:0] WAIT_D3 = 2'b10;
    localparam [1:0] UNLOCKED = 2'b11;
    
    always @(posedge clk or posedge rst) begin
        state <= (rst)? LOCKED: next_state;
        end 
    
    always @(*) begin
        next_state = LOCKED;
        case (state)
            LOCKED: next_state = (digit_in == D1) ? WAIT_D2: LOCKED;
            WAIT_D2: next_state = (digit_in == D2) ? WAIT_D3: LOCKED;
            WAIT_D3: next_state = (digit_in == D3) ? UNLOCKED: LOCKED;
            UNLOCKED: next_state = UNLOCKED;
            default: next_state = LOCKED;
        endcase
    end
    
    always @(*) begin
        unlocked_led <= (rst) ? 0: (state == UNLOCKED);
    end
    
    
endmodule
