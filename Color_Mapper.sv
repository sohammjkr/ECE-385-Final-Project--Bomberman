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

module  color_mapper ( input        [9:0] user1X, user1Y, bomb1X, bomb1Y, bomb1S, user1S,
							  input 			[9:0] user2X, user2Y, bomb2X, bomb2Y, bomb2S, user2S,
							  input        [9:0] wall1X, wall1Y, wall1S,
							  input		   [9:0] DrawX, DrawY,
							  input 			[7:0] wall_R, wall_G, wall_B,
							  input			Clk, blank,
							  
                       output logic [7:0]  Red, Green, Blue);
							  
  logic user1_on, bomb1_on, user2_on, bomb2_on;
  logic wall1_on;

	 logic [7:0] TR, TG, TB, user2R, user2G, user2B, bomb1R, bomb1G, bomb1B, bomb2R, bomb2G, bomb2B, bgR, bgG, bgB;
   logic [23:0] user1_data, user2_data, bomb1_data, bomb2_data, background_data;

	  
    logic [9:0] user1DistX, user1DistY, user2DistX, user2DistY;
	 
	 int user1Size, bomb1DistX, bomb1DistY, bomb1Size;
	 int user2Size, bomb2DistX, bomb2DistY, bomb2Size;
	 int wall1DistX, wall1DistY, wall1Size;
	 
	 assign wall1Size = wall1S;
	 assign wall1DistX = DrawX - wall1X;
    assign wall1DistY = DrawY - wall1Y;
	 
    assign user1Size = user1S;	 
  	 assign user1DistX = DrawX - user1X; //(x-h) 
    assign user1DistY = DrawY - user1Y;
	 
	 assign bomb1DistX = DrawX - bomb1X;
    assign bomb1DistY = DrawY - bomb1Y;
    assign bomb1Size = bomb1S;
	 
	 assign user2DistX = DrawX - user2X;
    assign user2DistY = DrawY - user2Y;
    assign user2Size = user2S;
	 

	 assign bomb2DistX = DrawX - bomb2X;
    assign bomb2DistY = DrawY - bomb2Y;
    assign bomb2Size = bomb2S;
 
	 
logic [18:0] user1_addr, user2_addr, bomb1_addr, bomb2_addr, background_addr;
logic [3:0] rom_addr;
	 
assign user1_addr = user1DistX + (16 * user1DistY);
assign user2_addr = user2DistX + (19 * user2DistY); 
assign bomb1_addr = bomb1DistX + (17 * bomb1DistY); 
assign bomb2_addr = bomb2DistX + (17 * bomb2DistY); 
assign background_addr = DrawX + (640 * DrawY);

user1_ram sprite_user1(  .read_address(user1_addr),
									.Clk(Clk),
									.data_Out(user1_data));	
//map ram
//bomb ram
user2_ram sprite_user2(.read_address(user2_addr),
									.Clk(Clk),
									.data_Out(user2_data));

bomb_ram sprite_bomb1(.read_address(bomb1_addr),
									.Clk(Clk),
									.data_Out(bomb1_data));

bomb_ram sprite_bomb2(.read_address(bomb2_addr),
									.Clk(Clk),
									.data_Out(bomb2_data));	
									
background_ram sprite_background(.read_address(background_addr),
												.Clk(Clk),
												.data_Out(background_data));

always_ff @(posedge Clk) 
	begin
		TR [7:0]	<= user1_data[23:16];
		TG [7:0] <= user1_data[15:8];
		TB [7:0] <= user1_data[7:0];
		
		user2R [7:0] <= user2_data[23:16];
		user2G [7:0] <= user2_data[15:8];
		user2B [7:0] <= user2_data[7:0];
		
		bomb1R [7:0] <= bomb1_data[23:16];
		bomb1G [7:0] <= bomb1_data[15:8];
		bomb1B [7:0] <= bomb1_data[7:0];
		
		bomb2R [7:0] <= bomb2_data[23:16];
		bomb2G [7:0] <= bomb2_data[15:8];
		bomb2B [7:0] <= bomb2_data[7:0];
		
		bgR [7:0] <= background_data[23:16];
		bgG [7:0] <= background_data[15:8];
		bgB [7:0] <= background_data[7:0];
		
	end

    always_comb
    begin
			//User 1 display
        if ((user1DistX <= 10'd16 && user1DistY <= 10'd23) && ((user1DistX >= 10'd0 && user1DistY >= 10'd0))) 
				begin
					user1_on = 1'b1;
				end
				
			else 
			 begin
					user1_on = 1'b0;
			 end

			
				//Bomb 1 Display
		  if ((bomb1DistX <= 10'd17 && bomb1DistY <= 10'd19) && ((bomb1DistX >= 10'd0 && bomb1DistY >= 10'd0))) 
			begin
            bomb1_on = 1'b1;
			end
			
		  else 
			begin
				bomb1_on = 1'b0;
			end
			
			// User 2 Display
			if ((user2DistX <= 10'd19 && user2DistY <= 10'd25) && ((user2DistX >= 10'd0 && user2DistY >= 10'd0)))  
			begin
            user2_on = 1'b1;
			end
			
		  else 
			begin
				user2_on = 1'b0;
			end
		
			//Bomb 2 Display
		  if ((bomb2DistX <= 10'd17 && bomb2DistY <= 10'd19) && ((bomb2DistX >= 10'd0 && bomb2DistY >= 10'd0))) 
			begin
            bomb2_on = 1'b1;
			end
			
		  else 
			begin
				bomb2_on = 1'b0;
			end
			
        //  Wall Display
		  
        if ((wall1DistX < wall1S && wall1DistY < wall1S) && ((wall1DistX >= 10'd0 && wall1DistY >= 10'd0)))
			begin
            wall1_on = 1'b1;
			end
			
		  else 
			begin
				wall1_on = 1'b0;
			end
		 
		  
end


 always_ff @ (posedge Clk)
    begin:RGB_Display
       
	  if(blank)
		begin

		 if ((user1_on == 1'b1)) 
		  begin
			
				
				Red <= TR;
				Green <= TG;
				Blue <= TB;
				
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
		  
		  else if ((user2_on == 1'b1)) 
        begin 
            Red <= user2R;
            Green <= user2G;
            Blue <= user2B;

        end 
		  
		  else if ((wall1_on == 1'b1)) 
        begin 
            Red <= wall_R;
            Green <= wall_G;
            Blue <= wall_B;

        end 
		  
		  else
        begin 
            Red = bgR; 
            Green = bgG;
            Blue = bgB;
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