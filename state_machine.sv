module state_machine (input logic Clk, Reset, 
							 input logic [7:0] keycode,
							 input logic p1die, p2die,
							 output logic [2:0] state,
							 output logic [7:0] count_out);
							 
				
    enum logic [2:0] {Start1, Start2, Continue, Pause, P1Win, P2Win}   curr_state, next_state; 

 	 logic [7:0] count, count_next;

	assign count_out = count;

	always_ff @ (posedge Clk or posedge Reset) 
    begin
        if (Reset) begin
			//Start is "Hit Space to Begin"
            curr_state <= Start1;
				count <= 8'h00;
			end
			
        else 
			begin
            curr_state <= next_state;
				count <= count_next;
			end
	end
			
always_comb 	
	begin

		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        case (curr_state)
	
			Start1 :begin 
						
						if(keycode == 8'h2c) //Space to Start the Game
							begin
                       next_state = Continue;
							end
						else if (count_next == 8'h4E )	//Flickering Words Logic
							begin
								next_state = Start2;
							end
						else
							begin
								next_state = Start1;
							end
						
					end
					
			Start2 :begin 
						
						if(keycode == 8'h2c) //Space to Start the Game
							begin
                       next_state = Continue;
							end
						else if (count_next == 8'hFF)	//Flickering Words Logic
							begin
								next_state = Start1;
							end
						else
							begin
								next_state = Start2;
							end
						
					end
					
			Continue :begin 
						
						if(keycode == 8'h29) 		//Esc to Pause the Game
							begin
                       next_state = Pause;
							end
							
						else if (p1die) 				//collide1 == p1die
							begin
								next_state = P2Win;	//Player 2 Win state
							end
							
						else if (p2die)				//collide2 = p2die
							begin
								next_state = P1Win;	//Player 1 Win State
							end
						
					end
					
			Pause :begin
						
						if(keycode == 8'h2c)			//Spacebar to Unpause
							begin
								next_state = Continue;
							end
					 end
					 
			P1Win :begin
						
						if(count_next == 8'hFF)
							begin
								next_state = Start1;
							end
						else
							begin
								next_state = P1Win;
							end
					 end
			
			P2Win :begin
						
						if(count_next == 8'hFF)
							begin
								next_state = Start1;
							end
						else
							begin
								next_state = P2Win;
							end
					 end
endcase


				case(curr_state)
				
		Start1 :begin 
					state = 3'b000;
					count_next = count + 1;
				 end
				 
		Start2 :begin 
					state = 3'b101;
					count_next = count + 1;
				 end
		Continue :begin 
						
						state = 3'b001;
						count_next = 8'h00;
					 end
					
		Pause :begin 
						
						state = 3'b010;
						count_next = 8'h00;
					end
		P1Win :begin 
						
						state = 3'b011;
						count_next = count + 1;
			
			    end
					
		P2Win :begin 
						
						state = 3'b100;
						count_next = count + 1;
						
				 end
				 
		default: ;
	endcase
end	  
			
endmodule 