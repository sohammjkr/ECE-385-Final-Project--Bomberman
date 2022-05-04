//bomb_explode.sv
// bomb explosions

module bomb_explode(


input logic Reset, Clk,
input logic [3:0] bomb2_state, bomb1_state,
input logic [9:0] bomb1X, bomb1Y, bomb2X, bomb2Y,

output logic [9:0] explode_addr [10],
output logic [0:0] explode_flag [10],
output logic [3:0] explode_data [10]
);


logic [8:0] c_addr2, l_addr2, r_addr2, t_addr2, b_addr2, c_addr, l_addr, r_addr, t_addr, b_addr;

logic [3:0] c_data, c2_data;

assign c_addr = bomb1Y[9:5] * 20 + bomb1X[9:5];

assign c_addr2 = bomb2Y[9:5] * 20 + bomb2X[9:5];

logic [8:0] temp_addr, temp2_addr;

map read(
	.address_a(c_addr),
	.address_b(c_addr2),
	.clock(Clk),
	.data_a(1'bx),
	.data_b(1'bx),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(c_data),
	.q_b(c2_data));
	
map write(
	.address_a(explode_addr[0]),
	.address_b(explode_addr[1]),
	.clock(Clk),
	.data_a(explode_data[0]),
	.data_b(explode_data[1]),
	.rden_a(~(explode_flag[0])),
	.rden_b(~(explode_flag[1])),
	.wren_a((explode_flag[0])),
	.wren_b((explode_flag[1])),
	.q_a(l_data),
	.q_b(l2_data));

always_comb 
	begin	
	
		if(l_data || c_data == 4'b0001 && bomb1_state == 4'b0010)
			begin
				explode_addr[0] = 10'd301;//set offscreen
			end
		else
			explode_addr[0] = c_addr;
			explode_flag[0] = 1'b1;
			explode_data[0] = 4'b0101;
	
		if(l2_data || c2_data == 4'b0001 && bomb2_state == 4'b0010)
			begin
				explode_addr[1] = 10'd301;//set offscreen
			end
		else
			explode_addr[1] = c_addr2;
			explode_flag[1] = 1'b1;
			explode_data[1] = 4'b0101;
	end		
	
endmodule 