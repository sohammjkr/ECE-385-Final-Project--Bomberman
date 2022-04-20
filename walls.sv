module walls (

input logic Reset, frame_clk,

output logic [9:0] wall1X, wall1Y, wall1S,
output logic [7:0]  wall_R, wall_G, wall_B
);


logic [9:0] Wall_X_Pos, Wall_Y_Pos, Wall_Size;
logic [7:0]  w_r, w_g, w_b;

    parameter [9:0] Wall_X_Center=50;  // Center position on the X axis
    parameter [9:0] Wall_Y_Center=37;  // Center position on the Y axis
    parameter [9:0] Wall_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Wall_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Wall_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Wall_Y_Max=479;     // Bottommost point on the Y axis
	 
	 
assign Wall_Size = 10'd10;

//always_comb
//begin
//	for(int i = 20; i < 640; i = i + 20)
//	begin
//		Wall_X_Center += i;
//	end
//	
//	for(int i = 20; i < 480; i = i + 20)
//	begin
//		Wall_Y_Center += i;
//	end
//
//end








always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		if (Reset)
        begin 
				Wall_Y_Pos <= Wall_Y_Center;
				Wall_X_Pos <= Wall_X_Center;
				w_r <= 8'hFF;
				w_g <= 8'hFF;
				w_b <= 8'hFF;
		  end

	
	end
	
	assign wall1X = Wall_X_Pos;
	assign wall1Y = Wall_Y_Pos;
	assign wall1S = Wall_Size;
	assign wall_R = w_r;
	assign wall_G = w_g;
	assign wall_B = w_b;

endmodule 