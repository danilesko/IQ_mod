`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2024 11:32:20
// Design Name: 
// Module Name: test_IQmod
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


module test_IQmod();

localparam BIT_DEPTH = 10;
localparam ADDR_MAX = 1024;
localparam AMP_DEPTH = 8;

reg clk_in;
reg rst_in;
reg en_in;
reg [clog2(ADDR_MAX)-1:0] step;
reg [clog2(ADDR_MAX)-1:0] phase_I;
reg [clog2(ADDR_MAX)-1:0] phase_Q;
reg [AMP_DEPTH-1:0] amp_coef_I, amp_coef_Q;
reg [BIT_DEPTH-1:0] zero_lvl_I;
reg [BIT_DEPTH-1:0] zero_lvl_Q;
wire [BIT_DEPTH-1:0] I;
wire [BIT_DEPTH-1:0] Q;

reg [BIT_DEPTH-1:0] mod;

TOP_IQmod#(
    .BIT_DEPTH      ( BIT_DEPTH ),
    .ADDR_MAX       ( ADDR_MAX ),
    .AMP_DEPTH      ( AMP_DEPTH ) 
)TOP_IQmod_inst(
    .clk_in         ( clk_in ),
    .rst_in         ( rst_in ),
    .en_in          ( en_in ),
    .step           ( step ),
    .phase_zero_I   ( phase_I ),
    .phase_zero_Q   ( phase_Q ),
    .phase_I        ( mod ),
    .phase_Q        ( mod ),
    .amp_coef_I     ( amp_coef_I ),
    .amp_coef_Q     ( amp_coef_Q ),
    .zero_lvl_I     ( zero_lvl_I ),
    .zero_lvl_Q     ( zero_lvl_Q ),
    .I              ( I ),
    .Q              ( Q ) 

    );

initial
begin
clk_in = 0;
rst_in = 0;
en_in = 0;
step = 0;
phase_I = 0;
phase_Q = 256;
amp_coef_I = 128;
amp_coef_Q = 128;
zero_lvl_I = 512;
zero_lvl_Q = 512;
end

always
#10 clk_in = ~clk_in;

integer i;
integer hex_file;

initial
begin
    hex_file = $fopen("lchm_lut_hex.txt","r");
    #600
    for (i = 0; i<131072; i = i + 1)
    begin
    #20 $fscanf(hex_file, "%h/n", mod);
    end
    $fclose(hex_file);
end

//initial
//begin
//mod = 10'h000; #21100 mod = 10'h200; #40960 mod = 10'h000; #20480 mod = 10'h200; 
//end


initial
begin
    #200 rst_in = 0; #100 rst_in = 1; #300 en_in = 1; #2000000 en_in = 0;
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

endmodule
