`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2024 11:16:15
// Design Name: 
// Module Name: TOP_IQmod
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


module TOP_IQmod#(
BIT_WIDTH = 10,
ADDR_MAX = 1024,
AMP_WIDTH = 8  
)(
input                             clk_in,
input                             rst_in,
input                             en_in,
input      [clog2(ADDR_MAX)-1:0]  step,
input      [clog2(ADDR_MAX)-1:0]  phase_zero_I,
input      [clog2(ADDR_MAX)-1:0]  phase_zero_Q,
input      [clog2(ADDR_MAX)-1:0]  phase_I,
input      [clog2(ADDR_MAX)-1:0]  phase_Q,
input      [AMP_WIDTH-1:0]        amp_coef_I,
input      [AMP_WIDTH-1:0]        amp_coef_Q,
input      [BIT_WIDTH-1:0]        zero_lvl_I,
input      [BIT_WIDTH-1:0]        zero_lvl_Q,
output reg [BIT_WIDTH-1:0]        I,
output reg [BIT_WIDTH-1:0]        Q

    );

wire [BIT_WIDTH-1:0] I_sin, Q_sin;

reg [clog2(ADDR_MAX)-1:0] addr_I = 0;
reg [clog2(ADDR_MAX)-1:0] addr_Q = 0;

always @(posedge clk_in or negedge rst_in)
begin
    if ( ~rst_in ) begin
        addr_I <= phase_zero_I;
        addr_Q <= phase_zero_Q; 
    end
    else    if ( ~en_in ) begin
            addr_I <= phase_zero_I;
            addr_Q <= phase_zero_Q;
            end
            else    if (en_in) begin
                        addr_I <= addr_I + step;
                        addr_Q <= addr_Q + step;
                    end
end

wire [9:0] addr_I_mod = addr_I + phase_I;
wire [9:0] addr_Q_mod = addr_Q + phase_Q;

sin_lut#(
    .BIT_WIDTH  ( BIT_WIDTH ),
    .ADDR_MAX   ( ADDR_MAX )
)sin_lut_inst(
    .addr_I      ( addr_I_mod ),
    .addr_Q      ( addr_Q_mod ),
    .I_sin       ( I_sin ),
    .Q_sin       ( Q_sin )
    );

wire [2*BIT_WIDTH-1:0] lvl_set_I = zero_lvl_I - max_lvl_I;
wire [2*BIT_WIDTH-1:0] lvl_set_Q = zero_lvl_Q - max_lvl_I;

wire [2*BIT_WIDTH:0] max_lvl_I_rash = ((amp_coef_I<<BIT_WIDTH)-amp_coef_I)>>(AMP_WIDTH);
wire [BIT_WIDTH-1:0] max_lvl_I = max_lvl_I_rash+1;
wire [2*BIT_WIDTH:0] max_lvl_Q_rash = ((amp_coef_Q<<BIT_WIDTH)-amp_coef_Q)>>(AMP_WIDTH);
wire [BIT_WIDTH-1:0] max_lvl_Q = max_lvl_Q_rash+1;

wire [BIT_WIDTH+AMP_WIDTH-1:0] I_mull = I_sin*amp_coef_I;
wire [BIT_WIDTH+AMP_WIDTH-1:0] Q_mull = Q_sin*amp_coef_Q; 

reg  [BIT_WIDTH-1:0] I_mull_reg, Q_mull_reg;

always @(posedge clk_in or negedge rst_in) begin
    if ( ~rst_in ) begin
        I_mull_reg <= 0;
        Q_mull_reg <= 0;
    end    
    else begin
        I_mull_reg <= I_mull[BIT_WIDTH+AMP_WIDTH-1:AMP_WIDTH-1];
        Q_mull_reg <= Q_mull[BIT_WIDTH+AMP_WIDTH-1:AMP_WIDTH-1];
    end
end

wire [2*BIT_WIDTH-1:0] I_wire = I_mull_reg+lvl_set_I;
wire [2*BIT_WIDTH-1:0] Q_wire = Q_mull_reg+lvl_set_Q;



always @(posedge clk_in or negedge rst_in) begin
    if (~rst_in) begin    
        I <= 0;
        Q <= 0;
    end
    else
        if ( en_in ) begin
            I <= I_wire[BIT_WIDTH-1:0];
            Q <= Q_wire[BIT_WIDTH-1:0];
        end
        else begin
            I <= zero_lvl_I;
            Q <= zero_lvl_Q;
        end
end

 function integer clog2;
       input integer value;
           begin
               value = value-1;
               for ( clog2 = 0; value > 0; clog2 = clog2+1 ) begin
                   value = value >> 1;
               end
           end
       endfunction   



/*
TOP_IQmod#(
    .BIT_WIDTH      (  ),
    .ADDR_MAX       (  ),
    .AMP_WIDTH      (  ) 
)TOP_IQmod_inst(
    .clk_in         (  ),
    .rst_in         (  ),
    .en_in          (  ),
    .step           (  ),
    .phase_zero_I         (  ),
    .phase_zero_Q         (  ),
    .phase_I        (  ),
    .phase_Q        (  ),
    .amp_coef_I      (  ),
    .amp_coef_Q      (  ),
    .zero_lvl_I      (  ),
    .zero_lvl_Q      (  ),
    .I              (  ),
    .Q              (  ) 

    );
*/

endmodule
