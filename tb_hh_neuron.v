`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2024 08:32:51 AM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb(

    );
    reg clk;
    reg reset;
     hh_neuron  dut(
     clk,
 reset
);

initial
begin
clk=0;
reset=0;
 end
 
 always #5 clk=~clk;
 
 initial begin
 #5 reset=0;
 #5 reset=1;
 #10 reset=0;
 
 end
 

endmodule
