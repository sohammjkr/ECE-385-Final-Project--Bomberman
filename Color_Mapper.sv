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
							  input logic [9:0] explode_addr [10],
							  input logic [0:0] explode_flag [10],
							  input logic [3:0] explode_data [10],
							  input		   [9:0] DrawX, DrawY,
							  input			Clk, blank, Reset,
							  
							  output logic [9:0] die_addr [10],
                       output logic [7:0]  Red, Green, Blue);
							  
  logic user1_on, bomb1_on, user2_on, bomb2_on, p1w_data, p2w_data;

	 logic [7:0] user1R, user1G, user1B, user2R, user2G, user2B;
	 logic [7:0] bomb1R, bomb1G, bomb1B, bomb2R, bomb2G, bomb2B;
	 logic [7:0] startR, startG, startB, pauseR, pauseG, pauseB;
 	 logic [7:0] WallR, WallG, WallB, BrickR, BrickG, BrickB;
  	 logic [7:0] SPPUR, SPPUG, SPPUB, BOPUR, BOPUG, BOPUB;
	 logic [7:0] EXR, EXG, EXB, LREXR, LREXG, LREXB, TBEXR, TBEXG, TBEXB;

	 logic [7:0] win1R, win1G, win1B, win2R, win2G, win2B;

	 
    logic [9:0] user1DistX, user1DistY, user2DistX, user2DistY;
	 
	 logic [18:0] user1_addr, user2_addr, bomb1_addr, bomb2_addr, background_addr, pause_addr, pw_addr, wall_addr;
	 
	 logic [19:0] start_addr;
	 
	 logic [3:0] start_data;
	 
	 logic [2:0] user1_data, user2_data, bomb1_data, bomb2_data, wall_color, brick_color, speedpu_color, bombpu_color;
	 
	 logic [2:0] cbig_color, csmall_color, lrbig_color, lrsmall_color, tbbig_color, tbsmall_color;
	 
	 logic [1:0] pause_data;
	 
	 logic [9:0] w_type, b_pos, b_post, b_posl, b_posr, b_posb, b2_pos, b2_post, b2_posl, b2_posr, b2_posb;

    logic [3:0] wall_data, wall_temp, wall_datal, wall_datar, wall_datat, wall_datab, wall_datac;
 
	 
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
	assign b_pos = bomb1Y[9:5] * 20 + bomb1X[9:5];
	assign b_post = (bomb1Y[9:5] * 20 + bomb1X[9:5]) - 20;
	assign b_posb = (bomb1Y[9:5] * 20 + bomb1X[9:5]) + 20;
	assign b_posr = (bomb1Y[9:5] * 20 + bomb1X[9:5]) + 1;
	assign b_posl = (bomb1Y[9:5] * 20 + bomb1X[9:5]) - 1;
	
	assign b2_pos = bomb2Y[9:5] * 20 + bomb2X[9:5];
	assign b2_post = (bomb2Y[9:5] * 20 + bomb2X[9:5]) - 20;
	assign b2_posb = (bomb2Y[9:5] * 20 + bomb2X[9:5]) + 20;
	assign b2_posr = (bomb2Y[9:5] * 20 + bomb2X[9:5]) + 1;
	assign b2_posl = (bomb2Y[9:5] * 20 + bomb2X[9:5]) - 1;
	
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
	
map write(
	.address_a(explode_addr[0]),
	.address_b(explode_addr[1]),
	.clock(Clk),
	.data_a(explode_data[0]),
	.data_b(explode_data[1]),
	.rden_a(1'b0),
	.rden_b(1'b0),
	.wren_a(1'b1),
	.wren_b(1'b1),
	.q_a(),
	.q_b());
	
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
							
lrbig_ram lrbig_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(lrbig_color));
							
lrsmall_ram lrsmall_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(lrsmall_color));
							
tbbig_ram tbbig_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(tbbig_color));
							
tbsmall_ram tbsmall_sprite(.read_address(wall_addr),
							.Clk(Clk),
							.data_Out(tbsmall_color));						
always_ff @(posedge Clk) 
	begin
	
	if(wall_data == 4'b0001)
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
			
			
	else if((b2_pos == w_type || b_pos == w_type)  && (bomb1_state == 4'b0010 || bomb1_state == 4'b0100 || bomb2_state == 4'b0010 || bomb2_state == 4'b0100))
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
			
	else if((b2_pos == w_type || b_pos == w_type) && (bomb1_state == 4'b0011 || bomb2_state == 4'b0011))
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
					 
			default: begin
					EXR <= 8'h00;
					EXG <= 8'ha2;
					EXB <= 8'he8;
					end 
		endcase
			end
			
		else if((b2_posl == w_type || b2_posr == w_type || b_posl == w_type || b_posr == w_type) && (bomb1_state == 4'b0010 || bomb1_state == 4'b0100 || bomb2_state == 4'b0010 || bomb2_state == 4'b0100))
		begin
			
		case(lrsmall_color)
						
			4'h1 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hff;
					 LREXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 LREXR <= 8'hf9;
					 LREXG <= 8'hff;
					 LREXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hed;
					 LREXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hb6;
					 LREXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 LREXR <= 8'hfd;
					 LREXG <= 8'h75;
					 LREXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 LREXR <= 8'h00;
					 LREXG <= 8'h00;
					 LREXB <= 8'h00;
					 end
					 
			default: begin
					LREXR <= 8'h00;
					LREXG <= 8'ha2;
					LREXB <= 8'he8;
					end 
		endcase
			end
			
		else if((b2_posl == w_type || b2_posr == w_type) || (b_posl == w_type || b_posr == w_type) && (bomb1_state == 4'b0011 || bomb2_state == 4'b0011))
		begin
			
		case(lrbig_color)
						
			4'h1 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hff;
					 LREXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 LREXR <= 8'hf9;
					 LREXG <= 8'hff;
					 LREXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hed;
					 LREXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 LREXR <= 8'hff;
					 LREXG <= 8'hb6;
					 LREXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 LREXR <= 8'hfd;
					 LREXG <= 8'h75;
					 LREXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 LREXR <= 8'h00;
					 LREXG <= 8'h00;
					 LREXB <= 8'h00;
					 end
					 
			default: begin
					LREXR <= 8'h00;
					LREXG <= 8'ha2;
					LREXB <= 8'he8;
					end 
		endcase
			end
			
	else if((b2_posb == w_type || b2_post == w_type || b_posb == w_type || b_post == w_type) && (bomb1_state == 4'b0010 || bomb1_state == 4'b0100 || bomb2_state == 4'b0010 || bomb2_state == 4'b0100))
		begin
			
		case(tbsmall_color)
						
			4'h1 : begin
					 TBEXR <= 8'hff;
					 TBEXG <= 8'hff;
					 TBEXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 TBEXR <= 8'hf9;
					 TBEXG <= 8'hff;
					 TBEXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 TBEXR <= 8'hff;
					 TBEXG <= 8'hed;
					 TBEXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 TBEXR <= 8'hff;
					 TBEXG <= 8'hb6;
					 TBEXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 TBEXR <= 8'hfd;
					 TBEXG <= 8'h75;
					 TBEXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 TBEXR <= 8'h00;
					 TBEXG <= 8'h00;
					 TBEXB <= 8'h00;
					 end
					 
			default: begin
					TBEXR <= 8'h00;
					TBEXG <= 8'ha2;
					TBEXB <= 8'he8;
					end 
		endcase
			end
			
	else if((b2_post == w_type || b2_posb == w_type || b_posb == w_type || b_post == w_type) &&  (bomb1_state == 4'b0011 || bomb2_state == 4'b0011))
		begin
			
		case(tbbig_color)
						
			4'h1 : begin
					TBEXR <= 8'hff;
					 TBEXG <= 8'hff;
					 TBEXB <= 8'hff;
					 end
					 
			4'h2 : begin
					 TBEXR <= 8'hf9;
					 TBEXG <= 8'hff;
					 TBEXB <= 8'hd1;
					 end
					 
			4'h3 : begin
					 TBEXR <= 8'hff;
					 TBEXG <= 8'hed;
					 TBEXB <= 8'h79;
					 end
					 
			4'h4 : begin
					 TBEXR <= 8'hff;
					 TBEXG <= 8'hb6;
					 TBEXB <= 8'h2a;
					 end
					 
			4'h5 : begin
					 TBEXR <= 8'hfd;
					 TBEXG <= 8'h75;
					 TBEXB <= 8'h15;
					 end
					 
			4'h6 : begin
					 TBEXR <= 8'h00;
					 TBEXG <= 8'h00;
					 TBEXB <= 8'h00;
					 end
					 
			default: begin
					TBEXR <= 8'h00;
					TBEXG <= 8'ha2;
					TBEXB <= 8'he8;
					end 
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
			
		else if(wall_data == 4'b0010)
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
        if (((user1DistX < 10'd20 && user1DistY < 10'd27) && ((user1DistX >= 10'd2 && user1DistY >= 10'd2)) && user1_data != 4'h0)) 
				begin
					user1_on = 1'b1;
				end
				
			else 
			 begin
					user1_on = 1'b0;
			 end

			
				//Bomb 1 Display
		  if (((bomb1DistX <= 10'd15 && bomb1DistY <= 10'd18) && ((bomb1DistX >= 10'd2 && bomb1DistY >= 10'd0))) && (bomb1_data != 4'h1)) 
			begin
            bomb1_on = 1'b1;
			end
			
		  else 
			begin
				bomb1_on = 1'b0;
			end
			
			// User 2 Display
			if (((user2DistX < 10'd20 && user2DistY < 10'd27) && ((user2DistX >= 10'd2 && user2DistY >= 10'd0))) && user2_data != 4'h0) 
			begin
            user2_on = 1'b1;
			end
			
		  else 
			begin
				user2_on = 1'b0;
			end
		
			//Bomb 2 Display
		  if (((bomb2DistX <= 10'd15 && bomb2DistY <= 10'd18) && ((bomb2DistX >= 10'd2 && bomb2DistY >= 10'd0))) && (bomb2_data != 4'h1))
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
	 
	 if(Reset)
		begin
				die_addr[0] <= 10'd300;
				die_addr[1] <= 10'd300;
				die_addr[2] <= 10'd300;
				die_addr[3] <= 10'd300;
				die_addr[4] <= 10'd300;
				die_addr[5] <= 10'd300;
				die_addr[6] <= 10'd300;
				die_addr[7] <= 10'd300;
				die_addr[8] <= 10'd300;
				die_addr[9] <= 10'd300;
				Red <= startR;
				Green <= startG;
				Blue <= startB;
		
		
		
		
		end
    else
	 
		begin
		
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
				die_addr[0] <= 10'd300;
				die_addr[1] <= 10'd300;
				die_addr[2] <= 10'd300;
				die_addr[3] <= 10'd300;
				die_addr[4] <= 10'd300;
				
				die_addr[6] <= 10'd300;
				die_addr[7] <= 10'd300;
				die_addr[8] <= 10'd300;
				die_addr[9] <= 10'd300;
				die_addr[5] <= 10'd300;
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
				die_addr[6] <= 10'd300;
				die_addr[7] <= 10'd300;
				die_addr[8] <= 10'd300;
				die_addr[9] <= 10'd300;
				die_addr[5] <= 10'd300;
				
				die_addr[0] <= 10'd300;
				die_addr[1] <= 10'd300;
				die_addr[2] <= 10'd300;
				die_addr[3] <= 10'd300;
				die_addr[4] <= 10'd300;
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
			
	
		
		
		if((wall_data == 4'b0101) || (wall_data == 4'b0110))
			begin
				Red <= EXR;
            Green <= EXG;
            Blue <= EXB;
			end
			
		else if (wall_data == 4'b0111 || wall_data == 4'b1000 || (wall_datar == 4'b0111) || wall_datal == 4'b0111 || (wall_datar == 4'b1000) || wall_datal == 4'b1000)
			begin
				Red <= LREXR;
            Green <= LREXG;
            Blue <= LREXB;
			end
			
		else if (wall_data == 4'b1001 || wall_data == 4'b1010 || (wall_datat == 4'b1001) || wall_datab == 4'b1001 || (wall_datat == 4'b1010) || wall_datab == 4'b1010)
			begin
				Red <= TBEXR;
            Green <= TBEXG;
            Blue <= TBEXB;
			end
		else if((wall_data == 4'b0001))
			begin
				
				Red <= WallR;
            Green <= WallG;
            Blue <= WallB;
			end
		
		 
		  else if(( b_pos == w_type) && (bomb1_state == 4'b0010 || bomb1_state == 4'b0011 || bomb1_state == 4'b0100))
					begin
						die_addr[4] <= b_pos;
						Red <= EXR;
						Green <= EXG;
						Blue <= EXB;
					end
		  else if((b_posb == w_type || b_post == w_type) && (bomb1_state == 4'b0010 || bomb1_state == 4'b011 || bomb1_state == 4'b0100))
					begin
						die_addr[3] <= b_posb;
						die_addr[2] <= b_post;

						Red <= TBEXR;
						Green <= TBEXG;
						Blue <= TBEXB;
					end
		  else if((b_posl == w_type || b_posr == w_type) && (bomb1_state == 4'b0010 || bomb1_state == 4'b0011 || bomb1_state == 4'b0100))
					begin
						die_addr[0] <= b_posl;
						die_addr[1] <= b_posr;
						
						Red <= LREXR;
						Green <= LREXG;
						Blue <= LREXB;
					end
					
			else if((b2_pos == w_type) && (bomb2_state == 4'b0010 || bomb2_state == 4'b0011 || bomb2_state == 4'b0100))
					begin
						die_addr[9] <= b2_pos;
						
						Red <= EXR;
						Green <= EXG;
						Blue <= EXB;
					end
		  else if((b2_posb == w_type || b2_post == w_type) && (bomb2_state == 4'b0010 || bomb2_state == 4'b011 || bomb2_state == 4'b0100))
					begin
						die_addr[7] <= b2_post;
						die_addr[8] <= b2_posb;
						
						Red <= TBEXR;
						Green <= TBEXG;
						Blue <= TBEXB;
					end
		  else if((b2_posr == w_type || b2_posl == w_type) && (bomb2_state == 4'b0010 || bomb2_state == 4'b0011 || bomb2_state == 4'b0100))
					begin
						die_addr[5] <= b2_posl;
						die_addr[6] <= b2_posr;
						
						Red <= LREXR;
						Green <= LREXG;
						Blue <= LREXB;
					end
		
		  else if(bomb1_state == 4'b0101 )
			begin
				die_addr[0] <= 10'd300;
				die_addr[1] <= 10'd300;
				die_addr[2] <= 10'd300;
				die_addr[3] <= 10'd300;
				die_addr[4] <= 10'd300;

				Red <= EXR;
				Green <= EXG;
				Blue <= EXB;
				
			end

		  
		  else if(bomb2_state == 4'b0101)
			begin
				die_addr[5] <= 10'd300;
				die_addr[6] <= 10'd300;
				die_addr[7] <= 10'd300;
				die_addr[8] <= 10'd300;
				die_addr[9] <= 10'd300;
				
				Red <= EXR;
				Green <= EXG;
				Blue <= EXB;
				
			end
		  
		  
		  
		  
		  else if((wall_data == 4'b0010))
			begin
				
				Red <= BrickR;
            Green <= BrickG;
            Blue <= BrickB;
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
		  
		  else if((wall_data == 4'b0011))
			begin
				
				Red <= SPPUR;
            Green <= SPPUG;
            Blue <= SPPUB;
			end
		
			else if((wall_data == 4'b0100))
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
    end 
    
endmodule 