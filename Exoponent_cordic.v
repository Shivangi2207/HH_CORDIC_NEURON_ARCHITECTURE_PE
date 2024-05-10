module cordic_exp (
    input wire clk,         // Clock input
    input wire rst,         // Reset input
    input wire signed [21:0] x,  // Input value (16-bit signed)
    output reg signed [21:0] exp_result,  // Output result (16-bit signed)
    output reg do
);

parameter N = 11;  // Number of iterations

// Internal variables
reg signed [159:0] z1, z2;
reg signed [43:0] r1, r2;
reg signed [21:0] r3;
reg signed [21:0] mul, mul_2, mul_3;
reg [9:0] x_int;
reg signed [21:0] x_frac;
reg [21:0] a [0:12];  // Values of e^(-i)
reg [21:0] b [0:12];
integer i, j;
reg[4:0] k, n;
reg [11:0] x_f;
reg flag;
integer k_f;

//checking variables
reg signed [21:0] x_frac_2;
reg [21:0] frac_out, frac_out2;
reg done, done_2;
reg [1:0] state;
parameter IDLE = 00;
parameter CALC = 01;
parameter FINAL = 10;

// Initialize a(i) values
initial begin
    a[0] = {10'd0, 12'b000000000001}; // a(0) = 2^(-0)
    for (i = 1; i <= 11; i = i + 1) begin
        a[i] = a[i-1] << 1; // a(i) = 2^(-i)
    end
end

initial begin
    b[0] = 22'd4095;
    b[1] = 22'd6750;
    b[2] = 22'd5259;
    b[3] = 22'd4640;
    b[4] = 22'd4360;
    b[5] = 22'd4225;
    b[6] = 22'd4160;
    b[7] = 22'd4128;
    b[8] = 22'd4112;
    b[9] = 22'd4104;
    b[10] = 22'd4100;
    b[11] = 22'd4098;
    b[12] = 22'd4096;
end

// CORDIC exponential computation
always @(posedge clk) begin
if(!rst)
    begin
    
        if (x<0) 
        begin
           x_int <= x[21:12]+1;
        end
        else 
           x_int <= x[21:12];
    
    end

end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        z1 <= 22'd4096;
        z2 <= 22'd4096;
        r1 <= 22'd4096;
        r2 <= 22'd4096;
        mul <= 22'd4096;
        mul_2 <= 22'd4096;
        mul_3 <= 22'd4096;
        flag <= 0;
        done_2 <= 0;
        x_int <= 0;
        x_frac <= 0;
        k <= 0;
        n <= 0;
        state <= IDLE;
        exp_result <= 0;
        do <= 0;
    end else begin
        case(state)
            IDLE: begin
                z1 <= 22'd4096;
                z2 <= 22'd4096;
                r1 <= 22'd4096;
                r2 <= 22'd4096;
                mul <= 22'd4096;
                mul_2 <= 22'd4096;
                mul_3 <= 22'd4096;
                flag <= 0;
                done_2 <= 0;
                k <= 0;
                n <= 0;
           //     state <= IDLE;
                exp_result <= 0;
                do <= 0;
          //      k_f=0;
                if (x<0) 
                begin
                    x_int <= x[21:12]+1;
                    end
                else 
                    x_int <= x[21:12];
        
                x_frac <= {10'd0, x[11:0]};
                
                state <= CALC;
            end

            CALC: begin
            
                if(x_int == 0) begin
                    done_2 =1;
                    mul_3 = 22'd4096;
                 end
                for (i = -N; i <= -2; i = i + 1) begin
                    if (x_frac > a[-i]) begin
                        x_frac = x_frac - a[-i];
                        z1 = z1 * b[-i];
                        k = k + 1;
                    end
                    if(i == -2 && flag != 1) begin
                        if (x < 0) begin
                            z1 = z1 * 22'd1506;
                            done = 1;
                            k = k + 1;
                            flag = 1;
                        end else begin
                            done = 1;
                            flag = 1;
                        end
                    end
                end

               for(k_f=0;k_f<20;k_f=k_f+1) begin
                if (x_int != 0 ) begin
                    if (x < 0) begin
                        r1 = mul_3 * 22'd1506; // Divide by 'e' (2.718)
                        mul_3 = {r1[33:12]};
                        x_int = x_int + 10'd1;
                   //     k_f=k_f+1;
                    end else begin
                        r1 = mul_3 * 22'd11132; // Multiply by 'e' (2.718)
                        mul_3 = {r1[33:12]};
                        x_int = x_int - 10'd1;
                  //      k_f=k_f+1;
                    end
                    if(x_int == 0) begin
                    done_2 =1;
                 //   k_f=20;
                    
                    end
                end
                end
                
                if(done)begin
                 if (k == 5'd0) begin
                        frac_out = 22'd4096;
                    end else if (k == 5'd1) begin
                        frac_out = z1[33:12];
                    end else if (k == 5'd2) begin
                        frac_out = z1[45:24];
                    end else if (k == 5'd3) begin
                        frac_out = z1[57:36];
                    end else if (k == 5'd4) begin
                        frac_out = z1[69:48];
                    end else if (k == 5'd5) begin
                        frac_out = z1[81:60];
                    end else if (k == 5'd6) begin
                        frac_out = z1[93:72];
                    end else if (k == 5'd7) begin
                        frac_out = z1[105:84];
                    end else if (k == 5'd8) begin
                        frac_out = z1[117:96];
                    end else if (k == 5'd9) begin
                        frac_out = z1[129:108];
                    end else if (k == 5'd10) begin
                        frac_out = z1[141:120];
                    end else if (k == 5'd11) begin
                        frac_out = z1[153:132];
                    end
                end
                if (done_2 && done) begin
                    r2 = frac_out * mul_3;
                    exp_result = r2[33:12];
                    do = 1;
                    state = IDLE;
                end
            end
 
        default: state<= IDLE;

        endcase
    end
end

endmodule
