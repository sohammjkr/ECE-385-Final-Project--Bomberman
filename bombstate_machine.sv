module bombstate_machine (input logic Clk, Reset,
								  input logic bomb_exist,

								  output logic [3:0] state,
								  output logic [7:0] count_out
								  );				
    enum logic [4:0] {Before, Exist, Explode1, Explode2, Explode3, Explode4, Bomb_Count1, Bomb_Count2, Bomb_Count3, Bomb_Count4}   curr_state, next_state; 

 	 logic [7:0] count, count_next;

	assign count_out = state;

	always_ff @ (posedge Clk or posedge Reset) 
    begin
        if (Reset) begin
			//Start is "Hit Space to Begin"
            curr_state <= Before;
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
	
			Before :begin 		
						if(bomb_exist) 
							begin
                       next_state = Exist;
							end
					end
					
			Exist :begin 
						
					 if (count_next == 8'ha0)
							begin
								next_state = Bomb_Count1;
							end
						else
							begin
								next_state = Exist;
							end
						
					end
					
			Bomb_Count1 : begin
						
								next_state = Explode1;
							end
			Bomb_Count2: begin
						
								next_state = Explode2;
							end
			Bomb_Count3 : begin
						
								next_state = Explode3;
							end
			Bomb_Count4 : begin
						
								next_state = Explode4;
							end
							
			Explode1 :begin 
						
						
						if (count_next == 8'h20)
							begin
								next_state = Bomb_Count2;
							end
						else
							begin
								next_state = Explode1;
							end
						
					end
					
			Explode2 :begin 
						
						
						if (count_next == 8'h40)
							begin
								next_state = Bomb_Count3;
							end
						else
							begin
								next_state = Explode2;
							end
						
					end
					
			Explode3 :begin 
						
						
						if (count_next == 8'h60)
							begin
								next_state = Bomb_Count4;
							end
						else
							begin
								next_state = Explode3;
							end
						
					end
					
			Explode4 :begin 
						
						
						if (count_next == 8'hff)
							begin
								next_state = Explode4;
							end
						else
							begin
								next_state = Before;
							end
						
					end
endcase


				case(curr_state)
				
		Before :begin 
					state = 4'b0000;
					count_next = 8'h00;
				 end
				 
		Exist :begin 
					state = 4'b0001;
					count_next = count + 1;
				 end
				 
		Bomb_Count1 :begin
					state = 4'b1111;
					count_next = 8'h00;
					end
					
		Explode1 :begin 
						
						state = 4'b0010;
						count_next = count + 1;
					 end
					 
		Bomb_Count2 :begin
					state = 4'b1110;
					count_next = count;
					end
					 
		Explode2 :begin
						state = 4'b0011;
						count_next = count + 1;
					 end
					 
		Bomb_Count3 :begin
					state = 4'b1101;
					count_next = count;
					end
						
		Explode3 :begin 
						
						state = 4'b0100;
						count_next = count + 1;
					 end
					 
		Bomb_Count4 :begin
					state = 4'b1011;
					count_next = count;
					end
					 
		Explode4 :begin
						state = 4'b0101;
						count_next = count + 1;
					end
					 
				 
		default: ;
	endcase
end	  
			
endmodule 