/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  p2win_ram
(
		input [19:0] read_address,
		input we, Clk,

		output logic data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [0:0] mem [0:3519];

initial
begin
	 $readmemh("p2win.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
