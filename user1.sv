//user.sv

//player controls

module user1(

input logic Reset, frame_clk, Clk, ram_en, Max,
input logic [7:0] keycode,
input logic [4:0] allow,
input logic [9:0] bomb2X, bomb2Y, bomb2XS, bomb2YS, user2X, user2Y,
input logic [9:0] die_addr [10],
input logic [9:0] ram_addr,
input logic [3:0] ram_data,
input logic speed_pu, lives_pu,
output logic bomb_drop, collide,
output logic [9:0] userX, userY,
output logic [3:0] wall_out, 
output logic [2:0] live_count 
); 


logic [9:0] User_X_Pos, User_X_Motion, User_Y_Pos, User_Y_Motion, User_X_Size, User_Y_Size, User_X_Off, User_Y_Off, speedX, speedY;

logic [9:0] BombX, BombY, BombXS, BombYS, w_typetl, w_typetr, w_typebl, w_typebr;

logic [3:0] wall_datatl, wall_databl, wall_datatr, wall_databr, wall_data, write_data;

logic	bomb_flag, wall_L, wall_R, wall_T, wall_B, die_flag, write_en, port_flag;

logic [2:0] death_count;

logic [4:0] port_count;




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
logic [3:0] max_lives;

map tl(
	.address_a(w_typetl),
	.address_b(ram_addr),
	.clock(Clk),
	.data_a(0),
	.data_b(write_data),
	.rden_a(1'b1),
	.rden_b(1'b0),
	.wren_a(ram_en),
	.wren_b(write_en),
	.q_a(wall_datatl), 
	.q_b());
	
map bl(
	.address_a(w_typebl),
	.address_b(ram_addr),
	.clock(Clk),
	.data_a(0),
	.data_b(write_data),
	.rden_a(1'b1),
	.rden_b(1'b0),
	.wren_a(1'b0),
	.wren_b(write_en),
	.q_a(wall_databl), 
	.q_b());
		
		
map tr(
	.address_a(w_typetr),
	.address_b(ram_addr),
	.clock(Clk),
	.data_a(0),
	.data_b(write_data),
	.rden_a(1'b1),
	.rden_b(1'b0),
	.wren_a(1'b0),
	.wren_b(write_en),
	.q_a(wall_datatr), 
	.q_b());
		
map br(
	.address_a(w_typebr),
	.address_b(ram_addr),
	.clock(Clk),
	.data_a(),
	.data_b(write_data),
	.rden_a(1'b1),
	.rden_b(1'b0),
	.wren_a(1'b0),
	.wren_b(write_en),
	.q_a(wall_databr), 
	.q_b());
	


always_comb 
		begin
			if(Reset)
				begin
					write_data = ram_data;
					write_en = 1'b1;
				end
			else
				begin
					write_data = 4'b0000;
					write_en = ram_en;
				end
				
		end
		
		
	always_ff @(posedge Max)
		begin
			
				port_count <= port_count + 1;
				
		end
	
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
				speedX <= 10'd0;
				speedY <= 10'd0;
				max_lives <= 4'b0110;

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
			speedX <= 10'd1;
			speedY <= 10'd1;
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
				
//				else if(wall_data == 4'b0001 || wall_data == 4'b0010)
//					begin
//					
//					if(ram_addr == w_typebl)
//						begin 
//						if(User_X_Motion != 1'b0)	//Sprite is going left
//							begin
//								wall_R <= 1'b1;
//							end
//						else if(User_Y_Motion != 1'b0) //Sprite is going up
//							begin
//								wall_T <= 1'b1;
//							end
//						end
//					else if (ram_addr == w_typetl)
//						begin
//							if(User_X_Motion != 1'b0)	//Sprite is going left
//							begin
//								wall_R <= 1'b1;
//							end
//						else if(User_Y_Motion != 1'b0) //Sprite is going up
//							begin
//								wall_B <= 1'b1;
//							end
//						end
//					else if(ram_addr == w_typebr)
//						begin
//							if(User_X_Motion != 1'b0)	//Sprite is going left
//							begin
//								wall_L <= 1'b1;
//							end
//						else if(User_Y_Motion != 1'b0) //Sprite is going up
//							begin
//								wall_T <= 1'b1;
//							end
//						end
//					else if (ram_addr == w_typetr)
//						begin
//						
//							if(User_X_Motion != 1'b0)	//Sprite is going left
//							begin
//								wall_L <= 1'b1;
//							end
//						else if(User_Y_Motion != 1'b0) //Sprite is going up
//							begin
//								wall_B <= 1'b1;
//							end
//						
//						end
//					
//					
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
					
					
				else if((wall_datatl == 4'b0011 && wall_datatr == 4'b0011) || (wall_datatl == 4'b0011 && wall_databl == 4'b0011) || (wall_databr == 4'b0011 && wall_datatr == 4'b0011) || (wall_databl == 4'b0011 && wall_databr == 4'b0011))
					begin
						
						port_flag <= 1'b1;
					
					end
					
//				else if(~speed_pu) 
//					begin
//						speedX <= speedX;
//						speedY <= speedY;
//					end
//					
				else if((wall_datatl == 4'b0100 && wall_datatr == 4'b0100) || (wall_datatl == 4'b0100 && wall_databl == 4'b0100) || (wall_databr == 4'b0100 && wall_datatr == 4'b0100) || (wall_databl == 4'b0100 && wall_databr == 4'b0100))
					begin
							max_lives <= max_lives + 2;
							
					end
//				else if(~lives_pu)
//					begin
//						max_lives <= max_lives;
//					end
							
				else 
					begin
					
					  port_flag <= 1'b0;
					  bomb_flag <= 1'b0;
					  bomb_drop <= 1'b0;
					  wall_T <= 1'b0;
					  wall_B <= 1'b0;
					  wall_R <= 1'b0;
					  wall_L <= 1'b0;
					  User_Y_Motion <= User_Y_Motion;  // User is somewhere in the middle, don't bounce, just keep moving
					  die_flag <= 1'b0;
					  speedX <= speedX;
					  speedY <= speedY;
					  max_lives <= max_lives;
				 case (keycode)
					8'h04 : begin
								User_X_Motion <= -1;// - speedX;//A
								User_Y_Motion<= 0;
								bomb_drop <= 1'b0;
								die_flag <= 1'b0;
								max_lives <= max_lives;
							  end
					        
					8'h07 : begin
								
					        User_X_Motion <= 1;// + speedX;//D
							  User_Y_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							  max_lives <= max_lives;
							  end

							  
					8'h16 : begin

					        User_Y_Motion <= 1;// + speedY;//S
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							  max_lives <= max_lives;
							 end
							  
					8'h1A : begin
					        User_Y_Motion <= -1;// - speedY;//W
							  User_X_Motion <= 0;
							  bomb_drop <= 1'b0;
							  die_flag <= 1'b0;
							  max_lives <= max_lives;
							 end	  
							 
					8'h19 : begin
								bomb_drop <= 1'b1;
								die_flag <= 1'b0;
								max_lives <= max_lives;
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
						max_lives <= max_lives;

					end
					
				else if(port_flag)
					begin
						if(port_count[0] && ((user2Y[7:3] * 20 + user2X[7:3]) > 10'd20) && ((user2Y[7:3] * 20 + user2X[7:3]) <= 10'd277))
							begin
								User_X_Pos <= user2X;								
								User_Y_Pos <= user2Y;	
								User_X_Motion <= User_X_Step - 1;
								User_Y_Motion <= User_Y_Step - 1;
							end
						else
							begin
								User_Y_Pos <= User_Y_Min + 3;
								User_X_Pos <= User_X_Min + 7;
								User_X_Motion <= User_X_Step - 1;
								User_Y_Motion <= User_Y_Step - 1;
							end
						
					end
					
				else if(death_count >= max_lives)
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
	assign collide = die_flag;
	assign live_count = (max_lives - death_count) / 2;

endmodule
