/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  pausescreen_ram
(
		input [19:0] read_address,
		input we, Clk,

		output logic [1:0]data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [1:0] mem [0:12053];

initial
begin
	 $readmemh("pausescreen.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
