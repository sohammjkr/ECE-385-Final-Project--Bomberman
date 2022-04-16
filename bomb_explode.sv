//bomb_explode.sv
// bomb explosions

module bomb_explode(


input logic Reset, frame_clk, bomb_exist,

output logic detonate
);

logic det;


always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
	if (Reset)
		begin 
			det = 1'b0;
		end
		
	else
		begin
		
		
		
			if(bomb_exist)
				begin
					det = 1'b1;
				end
			else
				begin
					det = 1'b0;
				end
			
		
		end
		
	end
	
assign detonate = det;
	
endmodule 


/*
bomb_explode p1_explode(.Reset(Reset_h), 
					  .frame_clk(VGA_VS),
					  .bomb_exist(bomb1_exist),
					  .detonate(boom1),
					  
*/