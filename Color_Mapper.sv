//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

module  color_mapper ( input        [9:0] user1X, user1Y, bomb1X, bomb1Y, bomb1XS, bomb1YS, //User1 sprite and bomb position
							  input 			[9:0] user2X, user2Y, bomb2X, bomb2Y, bomb2XS, bomb2YS, //User2 sprite and bomb position
							  input	logic [4:0] game_state,
							  input  logic [3:0] bomb1_state, bomb2_state,
							  input		   [9:0] DrawX, DrawY,
							  input			Clk, blank, 
							  
                       output logic [7:0]  Red, Green, Blue);
							  
  logic user1_on, bomb1_on, user2_on, bomb2_on, p1w_data, p2w_data;

	 logic [7:0] user1R, user1G, user1B, user2R, user2G, user2B;
	 logic [7:0] bomb1R, bomb1G, bomb1B, bomb2R, bomb2G, bomb2B;
	 logic [7:0] startR, startG, startB, pauseR, pauseG, pauseB;
 	 logic [7:0] WallR, WallG, WallB, BrickR, BrickG, BrickB;
  	 logic [7:0] SPPUR, SPPUG, SPPUB, BOPUR, BOPUG, BOPUB;
	 logic [7:0] EXR, EXG, EXB;

	 logic [7:0] win1R, win1G, win1B, win2R, win2G, win2B;

	 
    logic [9:0] user1DistX, user1DistY, user2DistX, user2DistY;
	 
	 logic [18:0] user1_addr, user2_addr, bomb1_addr, bomb2_addr, background_addr, pause_addr, pw_addr, wall_addr;
	 
	 logic [19:0] start_addr;
	 
	 logic [3:0] start_data;
	 
	 logic [2:0] user1_data, user2_data, bomb1_data, bomb2_data, wall_color, brick_color, speedpu_color, bombpu_color;
	 
	 logic [2:0] cbig_color, csmall_color;
	 
	 logic [1:0] pause_data;
	 
	 logic [9:0] w_type;

    logic [3:0] wall_data, wall_temp;
 
	 
	 int bomb1DistX, bomb1DistY, bomb1Size;
	 int bomb2DistX, bomb2DistY, bomb2Size;
	 
	 assign user1DistX = DrawX - user1X; //(x-h) 
    assign user1DistY = DrawY - user1Y;
	 
	 assign bomb1DistX = DrawX - bomb1X;
    assign bomb1DistY = DrawY - bomb1Y;
	 
	 assign user2DistX = DrawX - user2X;
    assign user2DistY = DrawY - user2Y;	 

	 assign bomb2DistX = DrawX - bomb2X;
    assign bomb2DistY = DrawY - bomb2Y;
 
	 

	assign user1_addr = user1DistX + (20 * user1DistY);
	assign user2_addr = user2DistX + (20 * user2DistY); 
	
	assign start_addr = DrawX + (640 * DrawY);
	
	assign pw_addr = (DrawX - 10'd210) + ( 220 * (DrawY - 10'd232));
	
	assign pause_addr = (DrawX - 10'd173) + (294 * (DrawY - 10'd220));
	
	assign bomb1_addr = bomb1DistX + (15 * bomb1DistY); 
	assign bomb2_addr = bomb2DistX + (15 * bomb2DistY); 

	assign w_type = DrawY[9:5] * 20 + DrawX[9:5];
	
	assign wall_addr = DrawX[4:0] + (32 * DrawY[4:0]);

p1win_ram p1win(.read_address(pw_addr),
								 .Clk(Clk),
								 .data_Out(p1w_data));

p2win_ram p2win(.read_address(pw_addr),
								 .Clk(Clk),
								 .data_Out(p2w_data));


//startpage_ram startstate(.read_address(start_addr),
//								 .Clk(Clk),
//								 .data_Out(start_data));

pausescreen_ram pausestate(.read_address(pause_addr),
								 .Clk(Clk),
								 .data_Out(pause_data));
								 
user1_ram sprite_user1(  .read_address(user1_addr),
									.Clk(Clk),
									.data_Out(user1_data));	

user2_ram sprite_user2(.read_address(user2_addr),
									.Clk(Clk),
									.data_Out(user2_data));

bomb_ram sprite_bomb1(.read_address(bomb1_addr),
									.Clk(Clk),
									.data_Out(bomb1_data));

bomb_ram sprite_bomb2(.read_address(bomb2_addr),
									.Clk(Clk),
									.data_Out(bomb2_data));	

map background(
	.address_a(w_type),
	.address_b(w_type),
	.clock(Clk),
	.data_a(1'bX),
	.data_b(1'bX),
	.rden_a(1'b1),
	.rden_b(1'b1),
	.wren_a(1'b0),
	.wren_b(1'b0),
	.q_a(wall_temp),
	.q_b(wall_data));
	
wall_ram wall_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(wall_color));
							
brick_ram brick_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(brick_color));

speedpu_ram sppu_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(speedpu_color));			
			
bombpu_ram bopu_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(bombpu_color));			

cbig_ram cbig_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(cbig_color));
							
csmall_ram csmall_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(csmall_color));
							
//lrbig_ram cbig_sprite(.read_address(wall_addr),
//							.Clk(Clk),
//							.data_Out(cbig_color));
//							
//lrsmall_ram csmall_sprite(.read_address(wall_addr),
//							.Clk(Clk),
//							.data_Out(csmall_color));
//tbbig_ram cbig_sprite(.read_address(wall_addr),
//							.Clk(Clk),
//							.data_Out(cbig_color));
//							
//tbsmall_ram csmall_sprite(.read_address(wall_addr),
//							.Clk(Clk),
//							.data_Out(csmall_color));						
always_ff @(posedge Clk) 
	begin
	
	if(wall_data == 3'b001)
		begin
			
		case(wall_color)
						
			4'h1 : begin
					 WallR <= 8'h00;
					 WallG <= 8'h00;
					 WallB <= 8'h00;
					 end
					 
			4'h2 : begin
					 WallR <= 8'hff;
					 WallG <= 8'hff;
					 WallB <= 8'hff;
					 end
					 
			4'h3 : begin
					 WallR <= 8'hb0;
					 WallG <= 8'hb0;
					 WallB <= 8'hb0;
					 end
			default;
		endcase
			end
			
	else if(wall_data == 4'b0101)
		begin
			
		case(csmall_color)
						
			4'h1 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hff;
					 EXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 EXR <= 8'hf9;
					 EXG <= 8'hff;
					 EXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hed;
					 EXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hb6;
					 EXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 EXR <= 8'hfd;
					 EXG <= 8'h75;
					 EXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 EXR <= 8'h00;
					 EXG <= 8'h00;
					 EXB <= 8'h00;
					 end
					 
			default: begin
					EXR <= 8'h00;
					EXG <= 8'ha2;
					EXB <= 8'he8;
					end 
		endcase
			end
			
	else if(wall_data == 4'b0110)
		begin
			
		case(cbig_color)
						
			4'h1 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hff;
					 EXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 EXR <= 8'hf9;
					 EXG <= 8'hff;
					 EXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hed;
					 EXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 EXR <= 8'hff;
					 EXG <= 8'hb6;
					 EXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 EXR <= 8'hfd;
					 EXG <= 8'h75;
					 EXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 EXR <= 8'h00;
					 EXG <= 8'h00;
					 EXB <= 8'h00;
					 end
					 
			default: ;
		endcase
			end
	
			
	else if(wall_data == 3'b011)
		begin
			
		case(speedpu_color)
						
			4'h1 : begin
					 SPPUR <= 8'hf8;
					 SPPUG <= 8'h28;
					 SPPUB <= 8'h00;
					 end
					 
			4'h2 : begin
					 SPPUR <= 8'h30;
					 SPPUG <= 8'ha0;
					 SPPUB <= 8'h58;
					 end
					 
			4'h3 : begin
					 SPPUR <= 8'h00;
					 SPPUG <= 8'h00;
					 SPPUB <= 8'h00;
					 end
			4'h4 : begin
					 SPPUR <= 8'hf8;
					 SPPUG <= 8'hf8;
					 SPPUB <= 8'hf8;
					 end
					 
			4'h5 : begin
					 SPPUR <= 8'hf8;
					 SPPUG <= 8'hc8;
					 SPPUB <= 8'h00;
					 end
					 
			4'h6 : begin
					 SPPUR <= 8'h00;
					 SPPUG <= 8'h60;
					 SPPUB <= 8'hf8;
					 end
			4'h7 : begin
					 SPPUR <= 8'h30;
					 SPPUG <= 8'h50;
					 SPPUB <= 8'h40;
					 end		 
			default: begin
					SPPUR <= 8'h00;
					SPPUG <= 8'ha2;
					SPPUB <= 8'he8;
					end
		endcase
			end
			
	else if(wall_data == 3'b100)
		begin
			
		case(bombpu_color)
						
			4'h1 : begin
					 BOPUR <= 8'hf8;
					 BOPUG <= 8'h28;
					 BOPUB <= 8'h00;
					 end
					 
			4'h3 : begin
					 BOPUR <= 8'h30;
					 BOPUG <= 8'ha0;
					 BOPUB <= 8'h58;
					 end
					 
			4'h2 : begin
					 BOPUR <= 8'h00;
					 BOPUG <= 8'h00;
					 BOPUB <= 8'h00;
					 end
					 
			4'h4 : begin
					 BOPUR <= 8'hf8;
					 BOPUG <= 8'hf8;
					 BOPUB <= 8'hf8;
					 end
					 
			4'h5 : begin
					 BOPUR <= 8'hf8;
					 BOPUG <= 8'hc8;
					 BOPUB <= 8'h00;
					 end
					 
			4'h6 : begin
					 BOPUR <= 8'hf8;
					 BOPUG <= 8'h78;
					 BOPUB <= 8'h00;
					 end	 
			default: begin
					BOPUR <= 8'h00;
					BOPUG <= 8'ha2;
					BOPUB <= 8'he8;
					end
		endcase
			end
			
		else if(wall_data == 2'b10)
		begin			
		case(brick_color)
						
			4'h1 : begin
					 BrickR <= 8'hff;
					 BrickG <= 8'h81;
					 BrickB <= 8'h70;
					 end
					 
			4'h2 : begin
					 BrickR <= 8'hb5;
					 BrickG <= 8'h31;
					 BrickB <= 8'h20;
					 end
					 
			4'h3 : begin
					 BrickR <= 8'hff;
					 BrickG <= 8'hcc;
					 BrickB <= 8'hc5;
					 end
			default;
		endcase
			end
		
		case(user1_data)
					 
			4'h2 : begin
					 user1R <= 8'h00;
					 user1G <= 8'h00;
					 user1B <= 8'h00;
					 end
					 
			4'h3 : begin
					 user1R <= 8'he8;
					 user1G <= 8'h20;
					 user1B <= 8'h50;					 
					 end
					 
			4'h4 : begin
					 user1R <= 8'hf8;
					 user1G <= 8'hf8;
					 user1B <= 8'hf8;					 
					 end
					 
			4'h5 : begin
					 user1R <= 8'h00;
					 user1G <= 8'h58;
					 user1B <= 8'he8;					 
					 end
			
			4'h6 : begin
					 user1R <= 8'ha0;
					 user1G <= 8'ha0;
					 user1B <= 8'ha0;					 
					 end
					 
			4'h7 : begin
					 user1R <= 8'hf8;
					 user1G <= 8'ha0;
					 user1B <= 8'h20;					 
					 end
					 
			default:begin
					 user1R <= 8'h00;
					 user1G <= 8'ha2;
					 user1B <= 8'he8;					 
					 end					 
					 			
			endcase
			
			
		case(user2_data)
					 
			4'h2 : begin
					 user2R <= 8'h00;
					 user2G <= 8'h00;
					 user2B <= 8'h00;
					 end
					 
			4'h3 : begin
					 user2R <= 8'he0;
					 user2G <= 8'h18;
					 user2B <= 8'h98;					 
					 end
					 
			4'h4 : begin
					 user2R <= 8'h00;
					 user2G <= 8'h58;
					 user2B <= 8'he8;					 
					 end
					 
			4'h5 : begin
					 user2R <= 8'hf8;
					 user2G <= 8'ha0;
					 user2B <= 8'h20;					 
					 end
			
			4'h6 : begin
					 user2R <= 8'h00;
					 user2G <= 8'h40;
					 user2B <= 8'h80;					 
					 end
					 
			default: begin
					 user2R <= 8'h00;
					 user2G <= 8'ha2;
					 user2B <= 8'he8;					 
					 end
			
			endcase
			
			case(bomb1_data)
					 
			4'h2 : begin
					 bomb1R <= 8'h00;
					 bomb1G <= 8'h00;
					 bomb1B <= 8'h00;
					 end
					 
			4'h3 : begin
					 bomb1R <= 8'hf8;
					 bomb1G <= 8'hf8;
					 bomb1B <= 8'hf8;					 
					 end
					 
			4'h4 : begin
					 bomb1R <= 8'h20;
					 bomb1G <= 8'h40;
					 bomb1B <= 8'h58;					 
					 end
					 
			4'h5 : begin
					 bomb1R <= 8'hc0;
					 bomb1G <= 8'hc0;
					 bomb1B <= 8'hc0;					 
					 end
			
			4'h6 : begin
					 bomb1R <= 8'h90;
					 bomb1G <= 8'h70;
					 bomb1B <= 8'h38;					 
					 end
					 
			4'h7 : begin
					 bomb1R <= 8'hf8;
					 bomb1G <= 8'h98;
					 bomb1B <= 8'h00;					 
					 end
					 
			default: begin
					 bomb1R <= 8'h00;
					 bomb1G <= 8'ha2;
					 bomb1B <= 8'he8;					 
					 end
			
			endcase
			
			case(bomb2_data)
					 
			4'h2 : begin
					 bomb2R <= 8'h00;
					 bomb2G <= 8'h00;
					 bomb2B <= 8'h00;
					 end
					 
			4'h3 : begin
					 bomb2R <= 8'hf8;
					 bomb2G <= 8'hf8;
					 bomb2B <= 8'hf8;					 
					 end
					 
			4'h4 : begin
					 bomb2R <= 8'h20;
					 bomb2G <= 8'h40;
					 bomb2B <= 8'h58;					 
					 end
					 
			4'h5 : begin
					 bomb2R <= 8'hc0;
					 bomb2G <= 8'hc0;
					 bomb2B <= 8'hc0;					 
					 end
			
			4'h6 : begin
					 bomb2R <= 8'h90;
					 bomb2G <= 8'h70;
					 bomb2B <= 8'h38;					 
					 end
					 
			4'h7 : begin
					 bomb2R <= 8'hf8;
					 bomb2G <= 8'h98;
					 bomb2B <= 8'h00;					 
					 end
					 
			default: begin
					 bomb2R <= 8'h00;
					 bomb2G <= 8'ha2;
					 bomb2B <= 8'he8;					 
					 end
			
			endcase	
		
			case(start_data)
			
			4'h1 : begin
					 startR <= 8'hF8;
					 startG <= 8'hB0;
					 startB <= 8'h40;
					 end
					 
			4'h2 : begin
					 startR <= 8'h00;
					 startG <= 8'h00;
					 startB <= 8'h00;
					 end
					 
			4'h3 : begin
					 startR <= 8'hF8;
					 startG <= 8'hF8;
					 startB <= 8'hF8;					 
					 end
					 
			4'h4 : begin
					 startR <= 8'hD0;
					 startG <= 8'h20;
					 startB <= 8'h38;					 
					 end
					 
			4'h5 : begin
					 startR <= 8'h60;
					 startG <= 8'h60;
					 startB <= 8'h60;					 
					 end
					 
			default: begin
					 startR <= 8'h00;
					 startG <= 8'h00;
					 startB <= 8'h00;
					 end
			endcase
			
			case(pause_data)
			
			2'b00 : begin
					 pauseR <= 8'h00;
					 pauseG <= 8'h00;
					 pauseB <= 8'h00;
					 end
					 
			2'b01: begin
					 pauseR <= 8'h00;
					 pauseG <= 8'h00;
					 pauseB <= 8'h00;
					 end
			2'b10: begin
					 pauseR <= 8'hFF;
					 pauseG <= 8'hFF;
					 pauseB <= 8'hFF;
					 end			
			default: ;
			endcase
			
			case(p1w_data)
			
			1'b0 : begin
					 win1R <= 8'h00;
					 win1G <= 8'h00;
					 win1B <= 8'h00;
					 end
					 
			1'b1: begin
					 win1R <= 8'hFF;
					 win1G <= 8'hFF;
					 win1B <= 8'hFF;
					 end
			default: ;
			endcase
			
			case(p2w_data)
			
			1'b0 : begin
					 win2R <= 8'h00;
					 win2G <= 8'h00;
					 win2B <= 8'h00;
					 end
					 
			1'b1: begin
					 win2R <= 8'hFF;
					 win2G <= 8'hFF;
					 win2B <= 8'hFF;
					 end			
			default: ;
			endcase
			
			

	end	

    always_comb
    begin 

			//User 1 display
        if ((user1DistX < 10'd20 && user1DistY < 10'd27) && ((user1DistX >= 10'd2 && user1DistY >= 10'd2))) 
				begin
					user1_on = 1'b1;
				end
				
			else 
			 begin
					user1_on = 1'b0;
			 end

			
				//Bomb 1 Display
		  if ((bomb1DistX <= 10'd15 && bomb1DistY <= 10'd18) && ((bomb1DistX >= 10'd2 && bomb1DistY >= 10'd0))) 
			begin
            bomb1_on = 1'b1;
			end
			
		  else 
			begin
				bomb1_on = 1'b0;
			end
			
			// User 2 Display
			if ((user2DistX < 10'd20 && user2DistY < 10'd27) && ((user2DistX >= 10'd2 && user2DistY >= 10'd0)))  
			begin
            user2_on = 1'b1;
			end
			
		  else 
			begin
				user2_on = 1'b0;
			end
		
			//Bomb 2 Display
		  if ((bomb2DistX <= 10'd15 && bomb2DistY <= 10'd18) && ((bomb2DistX >= 10'd2 && bomb2DistY >= 10'd0))) 
			begin
            bomb2_on = 1'b1;
			end
			
		  else 
			begin
				bomb2_on = 1'b0;
			end
		
		  
end


 always_ff @ (posedge Clk)
    begin:RGB_Display
       
	  if(blank && DrawX > 1'b1)
		begin
		
		if((game_state == 5'b00000 || game_state == 5'b00001))	//Start1 or Start2 State 
			begin
				if((DrawY <= 10'd350) && (DrawX > 10'd5))
					begin
						Red <= startR;
						Green <= startG;
						Blue <= startB;
					end
					
				else if (DrawY >= 10'd377)
					begin
						Red <= 8'h00;
						Green <= 8'h00;
						Blue <= 8'h00;
					end
					
				else if(game_state == 5'b00000 && DrawX > 10'd5 && DrawY > 10'd350 && DrawY < 10'd377)
					begin
						Red <= startR;
						Green <= startG;
						Blue <= startB;
					end
				else if(game_state == 5'b00001 && DrawY > 10'd350 && DrawX > 10'd5 && DrawY < 10'd377)
					begin
						Red <= 8'h00;
						Green <= 8'h00;
						Blue <= 8'h00;
					end
			end
			
		else if (game_state == 5'b11111) 						//Pause State
			begin
				if(DrawX >= 10'd173 && DrawY >= 10'd220 && DrawX < 10'd467 && DrawY < 10'd261)
					begin
						Red <= pauseR;
						Green <= pauseG;
						Blue <= pauseB;
					end
				else
					begin
						Red <= 8'h00;
						Green <= 8'h00;
						Blue <= 8'h00;
					end
			end
		
		else if (game_state == 5'b10000)							//P1 Win State
			begin		
				
				if(DrawX >= 10'd210 && DrawY >= 10'd232 && DrawX < 10'd430 && DrawY < 10'd248)
					begin
						Red <= win1R;
						Green <= win1G;
						Blue <= win1B;
					end
					
				else
					begin
						Red <= 8'h00;
						Green <= 8'h00;
						Blue <= 8'h00;
					end
			end
			
		else if (game_state == 5'b10001)							//P2 Win State
			begin
				
				if(DrawX >= 10'd210 && DrawY >= 10'd232 && DrawX < 10'd430 && DrawY < 10'd248)
					begin
						Red <= win2R;
						Green <= win2G;
						Blue <= win2B;
					end
				else
					begin
						Red <= 8'h00;
						Green <= 8'h00;
						Blue <= 8'h00;
					end
			end
			
		
else 															//continue State
	begin
			
		if((wall_data == 2'b01))
			begin
				
				Red <= WallR;
            Green <= WallG;
            Blue <= WallB;
			end
			
		  else if((wall_data == 2'b10))
			begin
				
				Red <= BrickR;
            Green <= BrickG;
            Blue <= BrickB;
			end
			
		 else if((wall_data == 4'b0101) || (wall_data == 4'b0110))
			begin
				Red <= EXR;
            Green <= EXG;
            Blue <= EXB;
			end
		
		 else if ((user1_on == 1'b1)) 
		  begin	
				Red <= user1R;
				Green <= user1G;
				Blue <= user1B;
				
			end 
		 
		else if ((user2_on == 1'b1)) 
        begin 
            Red <= user2R;
            Green <= user2G;
            Blue <= user2B;

        end 
		  
		  else if ((bomb1_on == 1'b1))
		  begin
				Red <= bomb1R;
				Green <= bomb1G;
				Blue <= bomb1B;

			end
			
		else if ((bomb2_on == 1'b1))
		  begin
				Red <= bomb2R;
				Green <= bomb2G;
				Blue <= bomb2B;
		  
		  end
		  
		  else if((wall_data == 2'b11))
			begin
				
				Red <= SPPUR;
            Green <= SPPUG;
            Blue <= SPPUB;
			end
		
			else if((wall_data == 3'b100))
			begin
				Red <= BOPUR;
            Green <= BOPUG;
            Blue <= BOPUB;
			end
		 	
		  else
        begin 
            Red <= 8'h00; 
            Green <= 8'ha2;
            Blue <= 8'he8;
        end 
		 
		 end
		  
		 end
		  
        else
        begin 
            Red <= 8'h00; 
            Green <= 8'h00;
            Blue <= 8'h00;

        end 
		
    end 
    
endmodule 