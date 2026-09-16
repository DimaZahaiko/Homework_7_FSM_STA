`timescale 1ns / 1ps

module tb_lock_controller;
    reg clk, rst;
    reg [3:0] digit;
    wire led;
    
    lock_controller dut(.clk(clk), 
    .rst(rst), 
    .digit_in(digit), 
    .unlocked_led(led));
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        rst = 0;
        @(posedge clk); #1; 
        digit = 4'd1;
        @(posedge clk); #1; 
        digit = dut.D1;
        @(posedge clk); #1
        digit = dut.D2;
        @(posedge clk); #1 
        digit = dut.D3;
        @(posedge clk); #1 
        digit = 4'd9;
        #12;
        rst = 1;
        @(posedge clk); #2
        rst = 0;
        digit = dut.D1;
        @(posedge clk); #2
        digit = dut.D2;
        @(posedge clk); #2 
        digit = dut.D3 - 1 ;
        #10;
        
        $finish;
    end
    
endmodule
