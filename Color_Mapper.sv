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
							  input	logic [2:0] game_state,
							  input		   [9:0] DrawX, DrawY,
							  input			Clk, blank, 
							  
                       output logic [7:0]  Red, Green, Blue);
							  
  logic user1_on, bomb1_on, user2_on, bomb2_on;

	 logic [7:0] user1R, user1G, user1B, user2R, user2G, user2B;
	 logic [7:0] bomb1R, bomb1G, bomb1B, bomb2R, bomb2G, bomb2B;
	 logic [7:0] startR, startG, startB;

	 
    logic [23:0] user1_data, user2_data, bomb1_data, bomb2_data;
	 
    logic [9:0] user1DistX, user1DistY, user2DistX, user2DistY;
	 
	 logic [18:0] user1_addr, user2_addr, bomb1_addr, bomb2_addr, background_addr;
	 
	 logic [19:0] start_addr;
	 
	 logic [3:0] start_data;

	 logic [9:0] w_type;

    logic [1:0] wall_data, wall_temp;
 
	 
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
 
	 

	assign user1_addr = user1DistX + (18 * user1DistY);
	assign user2_addr = user2DistX + (19 * user2DistY); 
	
	assign start_addr = DrawX + (640 * DrawY);
	
	assign bomb1_addr = bomb1DistX + (15 * bomb1DistY); 
	assign bomb2_addr = bomb2DistX + (15 * bomb2DistY); 

	assign w_type = DrawY[9:5] * 20 + DrawX[9:5];


startpage_ram startstate(.read_address(start_addr),
								 .Clk(Clk),
								 .data_Out(start_data));
								 
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
									

always_ff @(posedge Clk) 
	begin
		user1R [7:0]	<= user1_data[23:16];
		user1G [7:0] <= user1_data[15:8];
		user1B [7:0] <= user1_data[7:0];
		
		user2R [7:0] <= user2_data[23:16];
		user2G [7:0] <= user2_data[15:8];
		user2B [7:0] <= user2_data[7:0];
		
		bomb1R [7:0] <= bomb1_data[23:16];
		bomb1G [7:0] <= bomb1_data[15:8];
		bomb1B [7:0] <= bomb1_data[7:0];
		
		bomb2R [7:0] <= bomb2_data[23:16];
		bomb2G [7:0] <= bomb2_data[15:8];
		bomb2B [7:0] <= bomb2_data[7:0];		
		
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
					 
			default: ;
			endcase
	end	

    always_comb
    begin 

			//User 1 display
        if ((user1DistX <= 10'd18 && user1DistY <= 10'd25) && ((user1DistX >= 10'd2 && user1DistY >= 10'd2))) 
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
			if ((user2DistX <= 10'd19 && user2DistY <= 10'd23) && ((user2DistX >= 10'd2 && user2DistY >= 10'd0)))  
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
       
	  if(blank)
		begin
		
		if((game_state == 3'b000 || game_state == 3'b101) && (DrawY <= 10'd350) && (DrawX > 10'd5)) 
			begin
				Red = startR;
				Green = startG;
				Blue = startB;
			end
		else if(game_state == 3'b000 && DrawY > 10'd350 && (DrawX > 10'd5))
			begin
				Red = startR;
				Green = startG;
				Blue = startB;
			end
		else if(game_state == 3'b101 && DrawY > 10'd350 && (DrawX > 10'd5))
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
			end
		else if((game_state == 3'b000 || game_state == 3'b101)  && (DrawX <= 10'd5))
			begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;
				
			end	
			
		else 
			begin
			
		if((wall_data == 2'b01))
			begin
				
				Red <= 8'hff;
            Green <= 8'h71;
            Blue <= 8'h80;
			end
			
		  else if((wall_data == 2'b10))
			begin
				
				Red <= 8'h00;
            Green <= 8'hae;
            Blue <= 8'h28;
			end
			
			else if((wall_data == 2'b11))
			begin
				
				Red <= 8'hff;
            Green <= 8'he2;
            Blue <= 8'h29;
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
		 	
		  else
        begin 
            Red = 8'h00; 
            Green = 8'ha2;
            Blue = 8'he8;
        end 
		 
		 end
		  
		 end
		  
        else
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;

        end 
		
    end 
    
endmodule 