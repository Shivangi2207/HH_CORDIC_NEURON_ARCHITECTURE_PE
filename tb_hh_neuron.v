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


module tb();

    reg clk;
    reg reset;
    reg [21:0] dt;
    reg [21:0] C;
    reg [21:0] g_Na;
    reg [21:0] g_K;
    reg [21:0] g_L;
    reg [21:0] V_Na;
    reg [21:0] V_K;
    reg [21:0] V_L;
    reg [21:0] e;
    reg [21:0] a;
    reg [21:0] I_inj;

    hh_neuron dut(
        .clk(clk),
        .reset(reset),
        .dt(dt),
        .C(C),
        .g_Na(g_Na),
        .g_K(g_K),
        .g_L(g_L),
        .V_Na(V_Na),
        .V_K(V_K),
        .V_L(V_L),
        .e(e),
        .a(a),
        .I_inj(I_inj)
    );

    initial begin
        clk = 0;
        reset = 0;
        dt = 22'd40;
        C = 22'd40;
//        g_Na = 22'd491;
//        g_K = 22'd147;
//        g_L = 22'd1;
//        V_Na = 22'd225;
//        V_K = -22'd295;
//        V_L = -22'd202;
        e = 22'd27182818; // 2.7182818 in fixed point format
        a = 22'd1; // 0.1 in fixed point format
        I_inj = 22'd4;
        
        #5 reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule
