//user.sv

//player controls

module user1(

input logic Reset, frame_clk,
input logic [7:0] keycode,
input logic [9:0] wall1X, wall1Y, wall1S,
input logic [9:0] bomb2X, bomb2Y, bomb2XS, bomb2YS,

output logic bomb_drop, damage, collide,
output logic [2:0] heart,
output logic [9:0] userX, userY
); 


logic [9:0] User_X_Pos, User_X_Motion, User_Y_Pos, User_Y_Motion, User_X_Size, User_Y_Size;
logic [9:0] WallX, WallY, WallS;
logic [9:0] BombX, BombY, BombXS, BombYS;
logic	bomb_flag, wall_L, wall_R, wall_T, wall_B;

	assign BombX = bomb2X;
	assign BombY = bomb2Y;
	assign BombXS = bomb2XS;
	assign BombYS = bomb2YS;
		
	assign WallX = wall1X;
	assign WallY = wall1Y;
	assign WallS = wall1S;
	
    parameter [9:0] User_X_Center=320;  // Center position on the X axis
    parameter [9:0] User_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] User_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] User_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] User_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] User_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] User_X_Step=1;      // Step size on the X axis
    parameter [9:0] User_Y_Step=1;      // Step size on the Y axis	
	// w = 8'h1A	
	// a = 8'h04
	// s = 8'h14
	// d = 8'h07
	// v = 8'h19
	
	// up = 8'h52
	// down = 8'h51
	// left = 8'h50
	// right = 8'h4F
	// p = 8'h13
	
	assign User_X_Size = 18;
	assign User_Y_Size = 26;
	
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		if (Reset)
        begin 
            User_Y_Motion <= 10'd0; //User X Motion;
				User_X_Motion <= 10'd0; //User Y Motion;
				User_Y_Pos <= User_Y_Min + 20;
				User_X_Pos <= User_X_Min + 20;
				bomb_drop = 1'b0;
				wall_T = 1'b0;
				wall_B = 1'b0;
				wall_R = 1'b0;
				wall_L = 1'b0;
		  end

	 else  
        begin 
				 if ( (User_Y_Pos + User_Y_Size) >= User_Y_Max )  // User is at the bottom edge, BOUNCE!
					  User_Y_Motion <= (~ (User_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (User_Y_Pos) <= User_Y_Min )  // User is at the top edge, BOUNCE!
					  User_Y_Motion <= User_Y_Step;
					  
				 else if ( (User_X_Pos + User_X_Size) >= User_X_Max )  // User is at the Right edge, BOUNCE!
					  User_X_Motion <= (~ (User_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (User_X_Pos) <= User_X_Min )  // User is at the Left edge, BOUNCE!
					  User_X_Motion <= User_X_Step;
					  
					  
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
					  
					//Wall Reset 
					
				 else if ((User_X_Pos <= WallX + WallS) && (User_Y_Pos <= WallY + WallS) && (User_X_Pos > WallX) && (User_Y_Pos > WallY) && ((User_X_Pos <= WallX + WallS) && (User_Y_Pos+ User_Y_Size <= WallY + WallS) && (User_X_Pos > WallX) && (User_Y_Pos + User_Y_Size > WallY)))
					begin	//Left edge of sprite
//					  User_X_Motion <= User_X_Step;	
					  wall_R <= 1'b1;
					end
				 else if ((User_X_Pos <= WallX + WallS) && (User_Y_Pos+ User_Y_Size <= WallY + WallS) && (User_X_Pos > WallX) && (User_Y_Pos + User_Y_Size > WallY) && ((User_X_Pos + User_X_Size <= WallX + WallS) && (User_Y_Pos + User_Y_Size <= WallY + WallS) && (User_X_Pos + User_X_Size > WallX) && (User_Y_Pos + User_Y_Size > WallY))) 
					begin	//Bottom Edge
//					  User_Y_Motion <= (~ (User_Y_Step) + 1'b1);  // 2's complement.
						wall_T <= 1'b1;
					end
				 else if ((User_X_Pos + User_X_Size <= WallX + WallS) && (User_Y_Pos <= WallY + WallS) && (User_X_Pos + User_X_Size > WallX) && (User_Y_Pos > WallY) && ((User_X_Pos + User_X_Size <= WallX + WallS) && (User_Y_Pos + User_Y_Size <= WallY + WallS) && (User_X_Pos + User_X_Size > WallX) && (User_Y_Pos + User_Y_Size > WallY)))
					begin	//Right Edge
//					  User_X_Motion <= (~ (User_X_Step) + 1'b1);  // 2's complement.
					  wall_L <= 1'b1;
					end
				 else if ((User_X_Pos + User_X_Size <= WallX + WallS) && (User_Y_Pos <= WallY + WallS) && (User_X_Pos + User_X_Size > WallX) && (User_Y_Pos > WallY) && ((User_X_Pos <= WallX + WallS) && (User_Y_Pos <= WallY + WallS) && (User_X_Pos > WallX) && (User_Y_Pos > WallY)))
					begin		//Top Edge
//					  User_Y_Motion <= User_Y_Step;
						wall_B <= 1'b1;
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
					  
				 case (keycode)
					8'h04 : begin
								User_X_Motion <= -1;//A
								User_Y_Motion<= 0;
								bomb_drop <= 1'b0;
							  end
					        
					8'h07 : begin
								
					        User_X_Motion <= 1;//D
							  User_Y_Motion <= 0;
							  bomb_drop <= 1'b0;
							  end

							  
					8'h16 : begin

					        User_Y_Motion <= 1;//S
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							 end
							  
					8'h1A : begin
					        User_Y_Motion <= -1;//W
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							 end	  
							 
					8'h19 : begin
								bomb_drop <= 1'b1;
							  end
					default: ;
			   endcase
				end
				 
				 if(bomb_flag)
					begin
						User_Y_Pos <= User_Y_Min + 20;
						User_X_Pos <= User_X_Min + 20;
						User_X_Motion <= User_X_Step - 1;

					end
				 else if(wall_T)
					begin
						User_Y_Pos <= WallY - User_Y_Size;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;
					end 
				else if(wall_L)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= WallX - User_X_Size;
						User_X_Motion <= User_X_Step - 1;

					end 
					else if(wall_R)
					begin
						User_Y_Pos <= User_Y_Pos;
						User_X_Pos <= WallX + WallS + 2;
						User_X_Motion <= User_X_Step - 1;
						end 
					else if(wall_B)
					begin
						User_Y_Pos <= WallY + WallS + 2;
						User_X_Pos <= User_X_Pos;
						User_Y_Motion <= User_Y_Step - 1;

					end 
				else
					begin
						User_Y_Pos <= (User_Y_Pos + User_Y_Motion);  // Update User position
						User_X_Pos <= (User_X_Pos + User_X_Motion);
//						wall_flag <= 1'b0;

					end
			end
		end
		
	assign userY = User_Y_Pos;
	assign userX = User_X_Pos;
	assign collide = bomb_flag;

endmodule
