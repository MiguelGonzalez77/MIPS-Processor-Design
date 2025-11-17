// You can use this skeleton testbench code, the textbook testbench code, or your own
module tb_MIPS_2();
  reg CLK;
  reg RST;
  wire CS;
  wire WE;
  wire [31:0] Mem_Bus;
  wire [6:0] Address;
// wire [7:0] REGOUT;

  reg commence;
  reg tb_WE, tb_CS;
  wire memory_WE, memory_CS;
  reg [6:0] ADDR_TB;
  wire [6:0] ADDR_memory;
  parameter index = 10;
  reg[31:0] result[index:1];
  
  
  initial
  begin
    CLK = 0;
  end

assign ADDR_memory = (commence) ? ADDR_TB : Address;
assign memory_WE = (commence) ? tb_WE : WE;
assign memory_CS = (commence) ? tb_CS : CS;
  MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus);
  //   MIPS CPU(CLK, RST, CS, WE, Address, Mem_Bus, REGOUT);
  Memory MEM(CS, WE, CLK, Address, Mem_Bus);

  always
  begin
    #5 CLK = !CLK;
  end
initial begin
CLK = 0;
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
	@(posedge WE); //word executed
	@(negedge CLK);
		if(Mem_Bus != result[iterate])
			$display("INCORRECT: your_result %d, correct_result %d", Mem_Bus, result[iterate]);
    end
    $display("TEST COMPLETE");
    $stop;
  end

endmodule
