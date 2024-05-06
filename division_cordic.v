`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2024 05:02:16 PM
// Design Name: 
// Module Name: cordic_divider
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


module cordic_divider (
    input wire clk,          // Clock input
    input wire rst,          // Reset input
    input signed [21:0] x,   // Multiplicant (22-bit signed fixed-point)
    input signed [21:0] y,   // Multiplier (22-bit signed fixed-point)
    output reg signed [21:0] z, // Result (22-bit signed fixed-point)
    output reg done          // Done signal
);

    // Define states
    parameter [1:0] IDLE = 2'b00;
    parameter [1:0] CALC = 2'b01;
    parameter [1:0] DONE = 2'b10;

    reg [1:0] state; // State register
    reg signed [21:0] x_reg; // Register for x
    reg signed [21:0] y_reg; // Register for y
    reg signed [21:0] z_reg; // Register for z
    integer  i; // Iteration counter
   
     

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset values
            state <= IDLE;
            x_reg <= 0;
            y_reg <= 0;
            z_reg <= 0;
            i <= 0;
            z<=0;
           
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Initialize registers
                    x_reg <= x;
                    y_reg <= y;
                    z_reg <= 0;
                    i <= -10;
                    // Move to CALC state
                    state <= CALC;
                    done<=0;
                end
                CALC: begin
                    // CORDIC multiplication
                   
                   
                    if (i < 10) begin
                   
                        if (x_reg >= 0) begin
                            x_reg <= x_reg -(y_reg <<-i);
                            z_reg <= z_reg + ( 1<<-i);
                         
                        end else begin
                            x_reg <= x_reg + (y_reg <<-i);
                            z_reg <= z_reg - ( 1<<-i);
                        end
                       
                       
                        i <= i + 1;
                    end else begin
                        // Move to DONE state
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Output result
                    z <= {z_reg[9:0],12'b0};
                    done <= 1;
                    // Reset state
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
