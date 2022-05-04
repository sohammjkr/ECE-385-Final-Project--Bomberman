//user.sv

//player controls

module user1(

input logic Reset, frame_clk,
input logic [7:0] keycode,
input logic [4:0] allow,
input logic [9:0] bomb2X, bomb2Y, bomb2XS, bomb2YS,
input logic [9:0] die_addr [10],

output logic bomb_drop, collide,
output logic [9:0] userX, userY,
output logic [3:0] wall_out, 
output logic [2:0] live_count 
); 


logic [9:0] User_X_Pos, User_X_Motion, User_Y_Pos, User_Y_Motion, User_X_Size, User_Y_Size, User_X_Off, User_Y_Off;

logic [9:0] BombX, BombY, BombXS, BombYS, w_typetl, w_typetr, w_typebl, w_typebr;

logic [3:0] wall_datatl, wall_databl, wall_datatr, wall_databr;

logic	bomb_flag, wall_L, wall_R, wall_T, wall_B, die_flag;

logic [2:0] death_count;




	assign BombX = bomb2X;
	assign BombY = bomb2Y;
	assign BombXS = bomb2XS;
	assign BombYS = bomb2YS;
	
    parameter [9:0] User_X_Center=320;  // Center position on the X axis
    parameter [9:0] User_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] User_X_Min=32;       // Leftmost point on the X axis
    parameter [9:0] User_X_Max=575;     // Rightmost point on the X axis
    parameter [9:0] User_Y_Min=32;       // Topmost point on the Y axis
    parameter [9:0] User_Y_Max=447;     // Bottommost point on the Y axis
    parameter [9:0] User_X_Step=1;      // Step size on the X axis
    parameter [9:0] User_Y_Step=1;      // Step size on the Y axis		

	assign User_X_Size = 20;
	assign User_Y_Size = 27;
	
assign w_typetl = User_Y_Pos[9:5] * 20 + User_X_Pos[9:5];

assign User_X_Off = User_X_Pos + User_X_Size;
assign User_Y_Off = User_Y_Pos + User_Y_Size;

assign w_typebr = User_Y_Off[9:5] * 20 + User_X_Off[9:5];

assign w_typetr = User_Y_Pos[9:5] * 20 + User_X_Off[9:5];

assign w_typebl = User_Y_Off[9:5] * 20 + User_X_Pos[9:5];

map checkleft(
	.address_a(w_typetl),
	.address_b(w_typetr),
	.clock(frame_clk),
	.data_a(1'bX),
	.data_b(1'bX),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(wall_datatl),
	.q_b(wall_datatr));
	

	map checkright(
	.address_a(w_typebl),
	.address_b(w_typebr),
	.clock(frame_clk),
	.data_a(1'bX),
	.data_b(1'bX),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(wall_databl),
	.q_b(wall_databr));
	
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		if (Reset)
        begin 
            User_Y_Motion <= 10'd0; //User X Motion;
				User_X_Motion <= 10'd0; //User Y Motion;
				User_Y_Pos <= User_Y_Min + 3;
				User_X_Pos <= User_X_Min + 7;
				bomb_drop <= 1'b0;
				wall_T <= 1'b0;
				wall_B <= 1'b0;
				wall_R <= 1'b0;
				wall_L <= 1'b0;
				bomb_flag <= 1'b0;
				die_flag <= 1'b0;
				death_count <= 3'b000;
		  end

	  else if(allow == 5'b00000 || allow == 5'b00001 || allow == 5'b11111)
		begin
			User_Y_Pos <= (User_Y_Pos);  // Update User position
			User_X_Pos <= (User_X_Pos);
			User_Y_Motion <= 10'd0; //User X Motion;
			User_X_Motion <= 10'd0; //User Y Motion;
			bomb_drop <= bomb_drop;
			wall_T <= wall_T;
			wall_B <= wall_B;
			wall_R <= wall_R;
			wall_L <= wall_L;

		end
		
	 else  
        begin

				 if ( (User_Y_Pos + User_Y_Size) >= User_Y_Max )  // User is at the bottom edge, BOUNCE!
					  wall_T <= 1'b1; 	  
				 else if ( (User_Y_Pos) <= User_Y_Min )  // User is at the top edge, BOUNCE!
					  wall_B <= 1'b1;
				 else if ( (User_X_Pos + User_X_Size) >= User_X_Max )  // User is at the Right edge, BOUNCE!
					  wall_L <= 1'b1;
				 else if ( (User_X_Pos) <= User_X_Min )  // User is at the Left edge, BOUNCE!
					  wall_R <= 1'b1;
					   
					  //Bomb Reset
//				 else if ((User_X_Pos <= BombX + BombXS) && (User_Y_Pos <= BombY + BombYS) && (User_X_Pos > BombX) && (User_Y_Pos > BombY))
//					begin
//						bomb_flag <= 1'b1;
//					end
//				 else if ((User_X_Pos <= BombX + BombXS) && (User_Y_Pos+ User_Y_Size <= BombY + BombYS) && (User_X_Pos > BombX) && (User_Y_Pos + User_Y_Size > BombY))
//					begin
//						bomb_flag <= 1'b1;
//					end
//				 else if ((User_X_Pos + User_X_Size <= BombX + BombXS) && (User_Y_Pos <= BombY + BombYS) && (User_X_Pos + User_X_Size > BombX) && (User_Y_Pos > BombY))
//					begin
//						bomb_flag <= 1'b1;
//					end
//				 else if ((User_X_Pos + User_X_Size <= BombX + BombXS) && (User_Y_Pos + User_Y_Size <= BombY + BombYS) && (User_X_Pos + User_X_Size > BombX) && (User_Y_Pos + User_Y_Size > BombY))
//					begin
//						bomb_flag <= 1'b1;
//					end	

					


					else if (w_typetl == die_addr[5] || w_typetl == die_addr[6] || w_typetl == die_addr[7] || w_typetl == die_addr[8] || w_typetl == die_addr[9] || w_typetr == die_addr[5] || w_typetr == die_addr[6] || w_typetr == die_addr[7] || w_typetr == die_addr[8] || w_typetr == die_addr[9] || w_typetr == die_addr[5] || w_typetr == die_addr[6] || w_typetr == die_addr[7] || w_typetr == die_addr[8] || w_typetr == die_addr[9] || w_typebl == die_addr[5] || w_typebl == die_addr[6] || w_typebl == die_addr[7] || w_typebl == die_addr[8] || w_typebl == die_addr[9] || w_typebr == die_addr[5] || w_typebr == die_addr[6] || w_typebr == die_addr[7] || w_typebr == die_addr[8] || w_typebr == die_addr[9])
					begin
						
						bomb_flag <= 1'b1;
						
					end
					
					else if (w_typetl == die_addr[0] || w_typetl == die_addr[1] || w_typetl == die_addr[2] || w_typetl == die_addr[3] || w_typetl == die_addr[4] || w_typetr == die_addr[0] || w_typetr == die_addr[1] || w_typetr == die_addr[2] || w_typetr == die_addr[3] || w_typetr == die_addr[4] || w_typetr == die_addr[0] || w_typetr == die_addr[1] || w_typetr == die_addr[2] || w_typetr == die_addr[3] || w_typetr == die_addr[4] || w_typebl == die_addr[0] || w_typebl == die_addr[1] || w_typebl == die_addr[2] || w_typebl == die_addr[3] || w_typebl == die_addr[4] || w_typebr == die_addr[0] || w_typebr == die_addr[1] || w_typebr == die_addr[2] || w_typebr == die_addr[3] || w_typebr == die_addr[4])
					begin
						bomb_flag<= 1'b1;
					end
					
					//Wall Check
					
//				else if (((((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_X_Motion != 1'b0))
//					begin
//						wall_L <= 1'b1;
//					end
//					
//				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_Y_Motion != 1'b0))
//					begin
//						wall_B <= 1'b1;
//					end
//					
//				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64) > 10'd32)) && (User_Y_Motion != 1'b0))
//					begin
//						wall_T <= 1'b1;
//					end
//					
//				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_X_Motion != 1'b0))
//					begin
//						wall_R <= 1'b1;
//					end
					
				else if(wall_databl == 3'b010 || wall_databl == 3'b001)		//UserX and UserY hitting Bricks
					begin
						if(User_X_Motion != 1'b0)	//Sprite is going left
							begin
								wall_R <= 1'b1;
							end
						else if(User_Y_Motion != 1'b0) //Sprite is going up
							begin
								wall_T <= 1'b1;
							end
					end
				else if(wall_datatl == 3'b010 || wall_datatl == 3'b001)		//UserX and UserY hitting Bricks
					begin
						if(User_X_Motion != 1'b0)	//Sprite is going left
							begin
								wall_R <= 1'b1;
							end
						else if(User_Y_Motion != 1'b0) //Sprite is going up
							begin
								wall_B <= 1'b1;
							end
					end
					
				else if(wall_databr == 3'b010 || wall_databr == 3'b001)		//UserX and UserY hitting Bricks
					begin
						if(User_X_Motion != 1'b0)	//Sprite is going left
							begin
								wall_L <= 1'b1;
							end
						else if(User_Y_Motion != 1'b0) //Sprite is going up
							begin
								wall_T <= 1'b1;
							end
					end
					
				else if(wall_datatr == 3'b010 || wall_datatr == 3'b001)		//UserX and UserY hitting Bricks
					begin
						if(User_X_Motion != 1'b0)	//Sprite is going left
							begin
								wall_L <= 1'b1;
							end
						else if(User_Y_Motion != 1'b0) //Sprite is going up
							begin
								wall_B <= 1'b1;
							end
					end
							
				else 
					begin

					  bomb_flag <= 1'b0;
					  bomb_drop <= 1'b0;
					  wall_T <= 1'b0;
					  wall_B <= 1'b0;
					  wall_R <= 1'b0;
					  wall_L <= 1'b0;
					  User_Y_Motion <= User_Y_Motion;  // User is somewhere in the middle, don't bounce, just keep moving
					  die_flag <= 1'b0;
				 case (keycode)
					8'h04 : begin
								User_X_Motion <= -1;//A
								User_Y_Motion<= 0;
								bomb_drop <= 1'b0;
								die_flag <= 1'b0;
							  end
					        
					8'h07 : begin
								
					        User_X_Motion <= 1;//D
							  User_Y_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							  end

							  
					8'h16 : begin

					        User_Y_Motion <= 1;//S
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							 end
							  
					8'h1A : begin
					        User_Y_Motion <= -1;//W
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							 end	  
							 
					8'h19 : begin
								bomb_drop <= 1'b1;
								die_flag <= 1'b0;
							  end
					default: ;
			   endcase
				end
				 
				 if(bomb_flag)
					begin
						User_Y_Pos <= User_Y_Min + 3;
						User_X_Pos <= User_X_Min + 7;
						User_X_Motion <= User_X_Step - 1;
						User_Y_Motion <= User_Y_Step - 1;
						death_count <= death_count + 1'b1;
						die_flag <= 1'b0;
					end
					
				else if(death_count >= 3'b110)
						begin
						
							die_flag <= 1'b1;
						end
				 else if(wall_T)
					begin
						User_Y_Pos <= User_Y_Pos - 1;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;
						die_flag <= 1'b0;
					end 
				else if(wall_L)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= User_X_Pos - 1;
						User_X_Motion <= User_X_Step - 1;
						die_flag <= 1'b0;

					end 
					else if(wall_R)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= User_X_Pos + 1;
						User_X_Motion <= User_X_Step - 1;
						die_flag <= 1'b0;
						end 
					else if(wall_B)
					begin
						User_Y_Pos <= User_Y_Pos + 1;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;
						die_flag <= 1'b0;

					end
				else
					begin
						User_Y_Pos <= (User_Y_Pos + User_Y_Motion);  // Update User position
						User_X_Pos <= (User_X_Pos + User_X_Motion);
						die_flag <= 1'b0;

					end
			end
		end
		
	assign userY = User_Y_Pos;
	assign userX = User_X_Pos;
	assign live_count = (3'b110 - death_count) / 2;
	assign collide = die_flag;
	
endmodule
