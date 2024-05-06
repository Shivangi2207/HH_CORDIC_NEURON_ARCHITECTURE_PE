`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 03:19:06 PM
// Design Name: 
// Module Name: hh_neuron
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


module hh_neuron (
    input clk,
    input reset
);


parameter dt = 22'd40; 
parameter C = 22'd40;  
parameter g_Na = 22'd491;
parameter g_K = 22'd147;   
parameter g_L = 22'd1;
parameter V_Na = 22'd225; //0.05512
parameter V_K = -22'd295;  //-72.14
parameter V_L = -22'd202;//-49.42
parameter e = 2.7182818;
parameter a = 0.1;
parameter I_inj = 22'd4; //1mA

integer i =0;

reg [21:0] m, h, n, V, alpha_den, beta_den_two, alpha_num, alpha_n, alpha_m_num, alpha_h, alpha_m, beta_n, beta_h, beta_m;
reg [21:0] n_sq, m_sq, v_vna_sub, gna_h_mul, tw_co_ou;
reg [21: 0] shift_ou;
reg [2:0] state;
reg rst, rese;

wire done_1, done_2, done_3, done_4,done_5,done_6, flag_k_reached;
reg [21:0] n_1, n_2, n_3;
reg [21:0] in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10;
wire [21:0] ou_1, ou_2, ou_3, ou_4, ou_5, ou_6, ou_n_dup;

reg [21:0] ou_a, ou_b, ou_c, ou_d, ou_e, ou_f, ou_g, ou_h, ou_i, ou_j, ou_k, ou_l, ou_m, ou_n, ou_o, ou_p, ou_q, ou_r, ou_s, ou_t, ou_u, ou_v, ou_w, ou_x, ou_y, ou_z, ou_aa, ou_ab, ou_ac, ou_ad, ou_ae, ou_af, ou_ag, ou_ah, ou_ai, ou_aj;
reg [21:0] m_next, h_next, n_next, V_next;

reg f=1;
cordic_multiplier_2  M0(
clk,          // Clock input
rst,          // Reset input
in_1,   // Multiplicant (22-bit signed fixed-point)
in_2,   // Multiplier (22-bit signed fixed-point)
ou_1, // Result (22-bit signed fixed-point)
done_1          // Done signal
);

cordic_multiplier_2  M1(
clk,          // Clock input
rst,          // Reset input
in_3,   // Multiplicant (22-bit signed fixed-point)
in_4,   // Multiplier (22-bit signed fixed-point)
ou_2, // Result (22-bit signed fixed-point)
done_2          // Done signal
);

cordic_multiplier_2  M2(
clk,          // Clock input
rst,          // Reset input
in_5,   // Multiplicant (22-bit signed fixed-point)
in_6,   // Multiplier (22-bit signed fixed-point)
ou_3, // Result (22-bit signed fixed-point)
done_3          // Done signal
);

cordic_exp E1(
clk,        // Clock input
rst,        // Reset input
tw_co_ou,  // Input value
    

ou_4, // Output representing exp(2^-x)
 // Flag to indicate when k iterations are reached
done_4
);


cordic_exp E2(
clk,        // Clock input
rst,        // Reset input
in_7,  // Input value

    

ou_5, // Output representing exp(2^-x)
 // Flag to indicate when k iterations are reached
done_5
);


cordic_divider D1(
    clk,          // Clock input
    rst,          // Reset input
    in_9,   // Multiplicant (22-bit signed fixed-point)
    in_10,   // Multiplier (22-bit signed fixed-point)
    ou_6, // Result (22-bit signed fixed-point)
    done_6          // Done signal
);

//ila_0 your_instance_name (
//	.clk(clk), // input wire clk


//	.probe0(done_1), // input wire [0:0]  probe0  
//	.probe1(done_2), // input wire [0:0]  probe1 
//	.probe2(done_3), // input wire [0:0]  probe2 
//	.probe3(done_4), // input wire [0:0]  probe3 
//	.probe4(done_6), // input wire [0:0]  probe4 
//	.probe5(ou_1), // input wire [21:0]  probe5 
//	.probe6(ou_2), // input wire [21:0]  probe6 
//	.probe7(ou_3), // input wire [21:0]  probe7 
//	.probe8(ou_4), // input wire [21:0]  probe8 
//	.probe9(ou_6) // input wire [21:0]  probe9
//);

always@ (posedge clk)
begin

if (reset)
begin

V = 22'd40;
n =22'd4;
h = 22'd4095;
m =22'd1;
rst = 1;
in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;
alpha_den = 0;
alpha_num = 0;
//rese=1;



end

else begin
rst = 1'b0;
rese =1'b0;
case(state)
3'b000: begin
in_1 <= n;
in_2 <= n;
in_3 <= m;
in_4 <= m;
in_5 <= g_Na;
in_6 <= h;
v_vna_sub = V - V_Na;
n_2 <= (V>>5)+(V>>7)+(V>>+4);
n_1 = n_2 + 22'd20480;
tw_co_ou = ~(n_1)+1;

beta_den_two = ~(n_2 + 22'd12288)+1;
n_3 = ~(n_2 + 22'd14336)+1;
in_7 = n_3;
if (done_4 == 1)
begin 
alpha_den = 22'd4096 -  ou_4;
end
shift_ou <= (V>>5)+(V>>6)+(V>>9);
//if(tw_co_ou && f) begin
//f=0;





if (done_1 && done_2 && done_3 && done_5 && done_4)
begin
ou_a = ou_1;
ou_b = ou_2;
ou_c = ou_3;
ou_d = v_vna_sub;
ou_e = shift_ou;
ou_h = alpha_den;
ou_g = beta_den_two;
ou_f = ou_5;



//in_1 = 0;
//in_2 = 0;
//in_3 = 0;
//in_4 = 0;
//in_5 = 0;
//in_6 = 0;
//in_7 = 0;
//in_8 = 0;


rst = 1;

state = 3'b001;
 
end
end


3'b001: begin
rst <= 0;

in_1 = ou_a;
in_2 = ou_a;
in_3 = ou_b;
in_4 = m;
in_5 = ou_c;
in_6 = ou_d;
in_7 = ou_g;
//alpha_num = (22'd40)*(V+(22'd204800));
alpha_num = 22'd2048;
in_9 = alpha_num;
in_10 = ou_h;

if(done_1 && done_2 && done_3 && done_5 && done_6)
begin

ou_i = ou_1;
ou_j = V - V_K;
ou_k = ou_2;
ou_l = V - V_L;
ou_m = ou_3;
ou_n = (V>>10) + ou_e - 22'd12288;
ou_o = ou_5;
ou_p = 22'd4096 - ou_f;

alpha_n = ou_6;


in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;


rst = 1;

state = 3'b010;
 


end




end

3'b010: begin
rst <= 0;

in_1 = ou_j;
in_2 = ou_i;
in_3 = ou_k;
in_4 = ou_m;
in_5 = ou_l;
in_6 = g_L;
in_7 = ou_n;
alpha_m_num = (22'd409)*(V + (22'd143360));
in_9 = alpha_m_num;
in_10 = ou_p;



if(done_1 && done_2 && done_3 && done_5 && done_6)
begin

ou_q = ou_1;
ou_r = 22'd4096 - n;
ou_s = ou_2;
ou_t = 22'd4096 - m;
ou_u = ou_3;
ou_v = ~((V>>7)+(V>>8)+(V>>10)+(22'd3072))+1;
alpha_h = ou_5>>3;
alpha_m = ou_6;


in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;


rst = 1;

state = 3'b011;



end







end




3'b011: begin
rst <= 0;

in_1 = ou_q;
in_2 = g_K;
in_3 = ou_r;
in_4 = alpha_n;
in_5 = ou_t;
in_6 = alpha_m;
in_7 = ou_v;

in_9 = 22'd4096;
in_10 = ou_o;



if(done_1 && done_2 && done_3 && done_5 && done_6)
begin

ou_w = ou_1;
ou_x = ou_2;
ou_y = ou_s + ou_u;
ou_z = ou_3;
ou_aa = 22'd4096 - h;
beta_n = ou_5;
ou_ab = ~((V>>5)+(V>>6)+(V>>7)+(22'd13639))+1;
//alpha_h = ou_5;
beta_h = ou_6;


in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;


rst = 1;

state = 3'b100;



end







end




3'b100: begin
rst <= 0;

in_1 = beta_n;
in_2 = n;
in_3 = beta_h;
in_4 = h;
in_5 = alpha_h;
in_6 = ou_aa;
in_7 = ou_ab;




if(done_1 && done_2 && done_3 && done_5)
begin

ou_ac = ou_1;
ou_ad = ou_w + ou_y + I_inj;
ou_ae = ou_2;
ou_af = ou_3;
beta_m = ou_5;
//ou_aa = 1 - h;
//beta_n = ou_4;
//ou_ab = ~((V>>5)+(V>>6)+(V>>7)+(22'd13639))+1;
////alpha_h = ou_5;
//beta_h = ou_6;


in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;


rst = 1;

state = 3'b101;



end







end




3'b101: begin
rst <= 0;

in_1 = (1/C)>>5;
in_2 = ou_ad;
in_3 = beta_m;
in_4 = m;
//in_5 = alpha_h;
//in_6 = ou_aa;
//in_7 = ou_ab[21:12];
//in_8 = ou_ab[11:0];




if(done_1 && done_2)
begin

ou_ag = ou_1>>5;
ou_ah = ou_x - ou_ac ;
ou_ai = ou_z - ou_2;
ou_aj = ou_af - ou_ae;
V_next = ou_ag + V;
n_next = ou_ah>>5 + n;
m_next = (ou_ai>>5) + m;
h_next = ou_aj>>5 + h;



in_1 = 0;
in_2 = 0;
in_3 = 0;
in_4 = 0;
in_5 = 0;
in_6 = 0;
in_7 = 0;
in_8 = 0;
in_9 = 0;
in_10 = 0;




rst = 1;

i=i+1;

if(i<17)
begin

V = V_next;
n = n_next;
m = m_next;
h = h_next;
state = 3'b000;
end

else 
state = 3'b110;



end







end



default : state = 3'b000;






endcase











end


end


endmodule
