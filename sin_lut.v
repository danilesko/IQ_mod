`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2024 16:38:33
// Design Name: 
// Module Name: sin_lut
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


module sin_lut#(
    BIT_DEPTH = 10,
    ADDR_MAX = 1024
)(
input [clog2(ADDR_MAX)-1:0] addr_I,
input [clog2(ADDR_MAX)-1:0] addr_Q,
output [BIT_DEPTH-1:0]      I_sin,
output [BIT_DEPTH-1:0]      Q_sin
    );
    

reg [BIT_DEPTH-1:0] sin[ADDR_MAX-1:0];    

initial
 $readmemh("sin_lut_hex.mem", sin);
 
assign I_sin = sin[addr_I];
assign Q_sin = sin[addr_Q];

    
    
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
sin_lut#(
    .BIT_DEPTH  (   ),
    .ADDR_MAX   (   )
)sin_lut_inst(
    .addr_I      (   ),
    .addr_Q      (   ),
    .I_sin      (   ),
    .Q_sin      (   )
    );
*/    
endmodule


