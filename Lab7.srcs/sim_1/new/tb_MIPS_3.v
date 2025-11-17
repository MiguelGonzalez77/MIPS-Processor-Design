`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 06:18:55 AM
// Design Name: 
// Module Name: tb_MIPS_3
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


// You can use this skeleton testbench code, the textbook testbench code, or your own
module tb_MIPS_3();
  reg CLK;
  reg RST;
  wire CS;
  wire WE;
  wire [31:0] Mem_Bus;
  wire [6:0] Address;
  reg regB;
  reg [2:0] REGctl;
  wire [7:0] REGAOUT;
  wire [31:0] REGBOUT;


  reg commence;
  reg tb_WE, tb_CS;
  wire memory_WE, memory_CS;
  reg [6:0] ADDR_TB;
  wire [6:0] ADDR_memory;
  parameter index = 600;
  // reg[31:0] result[index:1];
  initial
  begin
    CLK = 0;
  end

assign ADDR_memory = (commence) ? ADDR_TB : Address;
assign memory_WE = (commence) ? tb_WE : WE;
assign memory_CS = (commence) ? tb_CS : CS;

  // MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus);
  MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus, REGAOUT, REGctl, regB, REGBOUT);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);

  always
  begin
    #5 CLK = !CLK;
  end

initial begin
CLK = 0;
REGctl = 0;
regB = 1;

end

integer iterate;

  always
  begin
    RST <= 1'b1; //reset the processor
	commence <= 1; tb_WE <= 1; tb_CS <= 1;

    //Notice that the memory is initialize in the in the memory module not here

    @(posedge CLK);
    commence <= 0; tb_WE <= 0; tb_CS <= 0;

    @(posedge CLK);
    // driving reset low here puts processor in normal operating mode
    RST = 1'b0;

    /* add your testing code here */
    // you can add in a 'Halt' signal here as well to test Halt operation
    // you will be verifying your program operation using the
    // waveform viewer and/or self-checking operations
    for(iterate = 1; iterate <= index; iterate = iterate + 1) begin
	@(posedge CLK)begin
	   if(iterate % 100 == 0) REGctl = REGctl + 1;
	end
    end

    $display("TEST COMPLETE");
    $stop;
  end

endmodule

