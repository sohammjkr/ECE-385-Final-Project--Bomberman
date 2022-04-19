module walls (

input logic Reset, frame_clk,

output logic [9:0] wall1X, wall1Y, wall1S
);


logic [9:0] Wall_X_Pos, Wall_Y_Pos, Wall_Size;

    parameter [9:0] Wall_X_Center=320;  // Center position on the X axis
    parameter [9:0] Wall_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Wall_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Wall_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Wall_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Wall_Y_Max=479;     // Bottommost point on the Y axis
	 
	 
assign Wall_Size = 10'd100;

always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		if (Reset)
        begin 
				Wall_Y_Pos <= Wall_Y_Center;
				Wall_X_Pos <= Wall_X_Center;
		  end

	
	end
	
	assign wall1X = Wall_X_Pos;
	assign wall1Y = Wall_Y_Pos;
	assign wall1S = Wall_Size;

endmodule 