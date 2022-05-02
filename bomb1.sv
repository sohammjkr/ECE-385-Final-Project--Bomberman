// bomb.sv

// making and dropping bombs?

module bomb1(

input logic Reset, frame_clk, make,
input logic [9:0] userX, userY,
input logic [3:0] bomb_state,

output logic bomb_check,
output logic [9:0] bombX, bombY, bombXS, bombYS,
output logic [9:0] explode_addr [5],
output logic [0:0] explode_flag [5],
output logic [3:0] explode_data [5]
);



logic [9:0] Bomb_X_Pos, Bomb_Y_Pos, Bomb_X_Size, Bomb_Y_Size, Bomb_Y_Offa, Bomb_Y_Offb;

logic [9:0] w_type, w_typel, w_typer, w_typea, w_typeb;


logic [3:0] wall_datal, wall_datar, wall_dataa, wall_datab, l_data, r_data, a_data, b_data, c_data, wall_datac;

logic make_bomb, explode_check, explode_en, l_en, r_en, b_en, a_en, c_en;


    parameter [9:0] Bomb_X_Center=320;  // Center position on the X axis
    parameter [9:0] Bomb_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Bomb_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bomb_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bomb_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bomb_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bomb_X_Step=1;      // Step size on the X axis
    parameter [9:0] Bomb_Y_Step=1;      // Step size on the Y axis	

assign Bomb_X_Size = 15;
assign Bomb_Y_Size = 20;

assign w_type = Bomb_Y_Pos[9:5] * 20 + Bomb_X_Pos[9:5];

assign w_typel = Bomb_Y_Pos[9:5] * 20 + (Bomb_X_Pos[9:5] - 5'b00001);

assign w_typer = Bomb_Y_Pos[9:5] * 20 + (Bomb_X_Pos[9:5] + 5'b00001);

assign w_typea = (Bomb_Y_Pos[9:5] - 5'b00001) * 20 + Bomb_X_Pos[9:5];

assign w_typeb = (Bomb_Y_Pos[9:5] + 5'b00001) * 20 + Bomb_X_Pos[9:5];

map checklr(
	.address_a(w_typel),
	.address_b(w_typer),
	.clock(frame_clk),
	.data_a(1'bX),
	.data_b(1'bX),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(wall_datal),
	.q_b(wall_datar));
	
	
	map checkab(
	.address_a(w_typea),
	.address_b(w_typeb),
	.clock(frame_clk),
	.data_a(1'bX),
	.data_b(1'bX),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(wall_dataa),
	.q_b(wall_datab));
	
	
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
	if (Reset)
		begin 
			bomb_check <= 1'b0;
			make_bomb <= 1'b0;
			Bomb_X_Pos <= 700;
			Bomb_Y_Pos <= 500;
			explode_en <= 1'b0;
			c_data <= wall_datac;
			l_data <= wall_datal;
			r_data <= wall_datar;
			a_data <= wall_dataa;
			b_data <= wall_datab;

			l_en <= 1'b0;
			r_en <= 1'b0;
			b_en <= 1'b0;
			a_en <= 1'b0;
			c_en <= 1'b0;
		end
		  
		  
	else  
      begin 	  
		
			if(make)
			 begin
				make_bomb <= 1'b1;
			 end
			
			 else
			  begin
				make_bomb <= 1'b0;
			  end
			 	
			if(bomb_check && bomb_state == 4'b1111) 
			 begin
				bomb_check <= 1'b0;
				make_bomb <= 1'b0;
				Bomb_X_Pos <= 700;
				Bomb_Y_Pos <= 500;
			 end
			 
			else if (make_bomb && ~bomb_check && bomb_state == 4'b0000)
				begin
					bomb_check <= 1'b1;
					Bomb_X_Pos <= userX + 4;
					Bomb_Y_Pos <= userY + 4;
				end

			if(bomb_state == 4'b0001)
				begin
					
					if(wall_datal != 1'b1)
						begin
						
						end
					
				
				end
			
		end
	
	assign bombY = Bomb_Y_Pos;
	assign bombX = Bomb_X_Pos;
	assign bombXS = Bomb_X_Size;
	assign bombYS = Bomb_Y_Size;
		
endmodule 