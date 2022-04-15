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

module  color_mapper ( input        [9:0] userX, userY, bombX, bombY, DrawX, DrawY, bombS, userS,
                       output logic [7:0]  Red, Green, Blue);
  logic user_on;
  logic bomb_on;
  
/* 
     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). 
*/
	  
    int userDistX, userDistY, userSize, bombDistX, bombDistY, bombSize;
	 assign userDistX = DrawX - userX;
    assign userDistY = DrawY - userY;
    assign userSize = userS;
	 assign bombDistX = DrawX - bombX;
    assign bombDistY = DrawY - bombY;
    assign bombSize = bombS;
	 
    always_comb
    begin
        if ( ( userDistX*userDistX + userDistY*userDistY) <= (userSize * userSize) ) 
			begin
            user_on = 1'b1;
			end
			
		  else 
			begin
				user_on = 1'b0;
			end
			
		  if ( ( bombDistX*bombDistX + bombDistY*bombDistY) <= (bombSize * bombSize) ) 
			begin
            bomb_on = 1'b1;
			end
			
		  else 
			begin
				bomb_on = 1'b0;
			end
	  end 	  
       
    always_comb
    begin:RGB_Display
        if ((user_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
        end 
		  else if ((bomb_on == 1'b1))
		  begin
				Red = 8'h00;
				Green = 8'hff;
				Blue = 8'h00;
			end
        else if( 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule
