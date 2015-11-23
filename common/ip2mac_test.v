`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:49:59 11/23/2015
// Design Name:   ip2mac
// Module Name:   /home/c/c-stack/TOE/common/ip2mac_test.v
// Project Name:  TOE_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ip2mac
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ip2mac_test;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] ip;
    reg [31:0] ip_i;
    reg [47:0] mac_i;
    reg wea;

    // Outputs
    wire [47:0] mac_o;
    wire found;

    // Instantiate the Unit Under Test (UUT)
    ip2mac uut (
        .clk(clk), 
        .reset(reset), 
        .ip(ip), 
        .mac_o(mac_o), 
        .found(found), 
        .ip_i(ip_i), 
        .mac_i(mac_i), 
        .wea(wea)
    );

    initial forever #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        ip = 0;
        ip_i = 0;
        mac_i = 0;
        wea = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        wea = 1;
        ip_i  = {8'h0a, 8'hd6, 8'h80, 8'hea};
        mac_i = {8'h9c, 8'heb, 8'he8, 8'h22, 8'hfd, 8'h18};

        #10;
        wea = 1;
        ip  = {8'h0a, 8'hd6, 8'h80, 8'hea};

        ip_i  = {8'h0b, 8'hd6, 8'h80, 8'hea};
        mac_i = {8'h9c, 8'heb, 8'he8, 8'h22, 8'hfd, 8'h19};
    end

endmodule

