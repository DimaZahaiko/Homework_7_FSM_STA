`timescale 1ns / 1ps

module tb_lock_controller_with_debounce;
    reg clk, rst;
    reg [3:0] digit;
    wire led;
    
    lock_controller dut(.clk(clk), 
    .rst(rst), 
    .digit_raw(digit), 
    .unlocked_led(led));
    
    task automatic wait_10edges; begin
        repeat (10) begin
            @(posedge clk);
        end
        #1; 
        $display("STATE = %d", dut.state);
        end
    endtask
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        @(posedge clk); #1
        rst = 0;
        @(posedge clk); #1
        digit = 4'd1;
        wait_10edges; 
        digit = dut.D1;
        wait_10edges;
        digit = dut.D2;
        wait_10edges; 
        digit = dut.D3;
        wait_10edges;
        digit = 4'd9;
        wait_10edges;
        rst = 1;
        wait_10edges;
        rst = 0;
        digit = dut.D1;
        wait_10edges;
        digit = dut.D2;
        wait_10edges; 
        digit = dut.D3 - 1;
        wait_10edges;
        #20;
        
        $finish;
    end
    
endmodule
