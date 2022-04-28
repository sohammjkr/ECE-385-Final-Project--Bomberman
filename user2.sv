//user.sv

//player controls

module user2(

input logic Reset, frame_clk,
input logic [7:0] keycode,
input logic [9:0] wall1X, wall1Y, wall1S,
input logic [9:0] bomb1X, bomb1Y, bomb1XS, bomb1YS,

output logic bomb_drop, damage, collide,
output logic [2:0] heart,
output logic [9:0] userX, userY
); 


logic [9:0] User_X_Pos, User_X_Motion, User_Y_Pos, User_Y_Motion, User_X_Size, User_Y_Size, halfX, halfY;
logic [9:0] WallX, WallY, WallS;
logic [9:0] BombX, BombY, BombXS, BombYS;
logic	bomb_flag, wall_L, wall_R, wall_T, wall_B;

	assign BombX = bomb1X;
	assign BombY = bomb1Y;
	assign BombXS = bomb1XS;
	assign BombYS = bomb1YS;
	
	assign WallX = wall1X;
	assign WallY = wall1Y;
	assign WallS = wall1S;
	
    parameter [9:0] User_X_Center=320;  // Center position on the X axis
    parameter [9:0] User_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] User_X_Min=32;       // Leftmost point on the X axis
    parameter [9:0] User_X_Max=575;     // Rightmost point on the X axis
    parameter [9:0] User_Y_Min=32;       // Topmost point on the Y axis
    parameter [9:0] User_Y_Max=447;     // Bottommost point on the Y axis
    parameter [9:0] User_X_Step=1;      // Step size on the X axis
    parameter [9:0] User_Y_Step=1;      // Step size on the Y axis	
	// w = 8'h52	
	// a = 8'h50
	// s = 8'h51
	// d = 8'h4F
	// v = 8'h13
	
	// up = 8'h52
	// down = 8'h51
	// left = 8'h50
	// right = 8'h4F
	// p = 8'h13
	
	assign User_X_Size = 19;
	assign User_Y_Size = 26;
	assign halfX = 10;
	assign halfY = 13;
	
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		if (Reset)
        begin 
            User_Y_Motion <= 10'd0; //User X Motion;
				User_X_Motion <= 10'd0; //User Y Motion;
				User_Y_Pos <= User_Y_Max - 32;
				User_X_Pos <= User_X_Max - 32;
				bomb_drop = 1'b0;
				wall_T = 1'b0;
				wall_B = 1'b0;
				wall_R = 1'b0;
				wall_L = 1'b0;
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
				 else if ((User_X_Pos <= BombX + BombXS) && (User_Y_Pos <= BombY + BombYS) && (User_X_Pos > BombX) && (User_Y_Pos > BombY))
					begin
						bomb_flag <= 1'b1;
					end
				 else if ((User_X_Pos <= BombX + BombXS) && (User_Y_Pos+ User_Y_Size <= BombY + BombYS) && (User_X_Pos > BombX) && (User_Y_Pos + User_Y_Size > BombY))
					begin
						bomb_flag <= 1'b1;
					end
				 else if ((User_X_Pos + User_X_Size <= BombX + BombXS) && (User_Y_Pos <= BombY + BombYS) && (User_X_Pos + User_X_Size > BombX) && (User_Y_Pos > BombY))
					begin
						bomb_flag <= 1'b1;
					end
				 else if ((User_X_Pos + User_X_Size <= BombX + BombXS) && (User_Y_Pos + User_Y_Size <= BombY + BombYS) && (User_X_Pos + User_X_Size > BombX) && (User_Y_Pos + User_Y_Size > BombY))
					begin
						bomb_flag <= 1'b1;
					end
					  
					//Wall Check	
			
				else if (((((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_X_Motion != 1'b0))
					begin
						wall_L <= 1'b1;
					end
					
				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_Y_Motion != 1'b0))
					begin
						wall_B <= 1'b1;
					end
					
				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64) > 10'd32)) && (User_Y_Motion != 1'b0))
					begin
						wall_T <= 1'b1;
					end
					
				else if (((((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && ~((((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos - 10'd32) % 10'd64 > 10'd32)) || (((User_X_Pos + User_X_Size - 10'd32) % 10'd64 > 10'd32) && ((User_Y_Pos + User_Y_Size - 10'd32) % 10'd64) > 10'd32)) && (User_X_Motion != 1'b0))
					begin
						wall_R <= 1'b1;
					end
					  
				 else 
				 
					begin
					  bomb_flag <= 1'b0;
					  bomb_drop = 1'b0;
					  wall_T <= 1'b0;
					  wall_B <= 1'b0;
					  wall_R <= 1'b0;
					  wall_L <= 1'b0;
					  User_Y_Motion <= User_Y_Motion;  // User is somewhere in the middle, don't bounce, just keep moving
					  
				 case (keycode)
					8'h50 : begin
								User_X_Motion <= -1;//A
								User_Y_Motion<= 0;
								bomb_drop <= 1'b0;
							  end
					        
					8'h4F : begin
								
					        User_X_Motion <= 1;//D
							  User_Y_Motion <= 0;
							  bomb_drop <= 1'b0;
							  end

							  
					8'h51 : begin

					        User_Y_Motion <= 1;//S
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							 end
							  
					8'h52 : begin
					        User_Y_Motion <= -1;//W
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							 end	  
							 
					8'h13 : begin
								bomb_drop <= 1'b1;
							  end
					default: ;
			   endcase
				end
				
				
				if(bomb_flag)
					begin
						User_Y_Pos <= User_Y_Max - 32;
						User_X_Pos <= User_X_Max - 32;
						User_X_Motion <= User_X_Step - 1;
						User_Y_Motion <= User_Y_Step - 1;

					end				 
					else if(wall_T)
					begin
						User_Y_Pos <= User_Y_Pos - 2;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;
					end 
				else if(wall_L)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= User_X_Pos - 2;
						User_X_Motion <= User_X_Step - 1;

					end 
					else if(wall_R)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= User_X_Pos + 2;
						User_X_Motion <= User_X_Step - 1;
						end 
					else if(wall_B)
					begin
						User_Y_Pos <= User_Y_Pos + 2;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;

					end
						
				else
					begin
						User_Y_Pos <= (User_Y_Pos + User_Y_Motion);  // Update User position
						User_X_Pos <= (User_X_Pos + User_X_Motion);
					end
			end
		end
		
	assign userY = User_Y_Pos;
	assign userX = User_X_Pos;
	assign collide = bomb_flag;


endmodule
