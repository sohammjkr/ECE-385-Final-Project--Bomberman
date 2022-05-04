// bomb.sv

// making and dropping bombs?

module bomb1(

input logic Reset, frame_clk, make,
input logic [9:0] userX, userY,
input logic [3:0] bomb_state,

output logic bomb_check,
output logic [9:0] bombX, bombY, bombXS, bombYS
);



logic [9:0] Bomb_X_Pos, Bomb_Y_Pos, Bomb_X_Size, Bomb_Y_Size, Bomb_Y_Offa, Bomb_Y_Offb;

logic make_bomb, explode_check;


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


	
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
	if (Reset)
		begin 
			bomb_check <= 1'b0;
			make_bomb <= 1'b0;
			Bomb_X_Pos <= 700;
			Bomb_Y_Pos <= 500;
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
			 	
			if(bomb_check && bomb_state == 4'b1011) 
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
	
	end

end
	
	assign bombY = Bomb_Y_Pos;
	assign bombX = Bomb_X_Pos;
	assign bombXS = Bomb_X_Size;
	assign bombYS = Bomb_Y_Size;
		
endmodule 