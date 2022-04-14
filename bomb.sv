// bomb.sv

// making and dropping bombs?

module bomb(

input logic Reset, frame_clk, make, explode,

output logic bomb_check,
output logic [9:0] bombX, bombY, bombS
);



logic [9:0] Bomb_X_Pos, Bomb_X_Motion, Bomb_Y_Pos, Bomb_Y_Motion, Bomb_Size;

    parameter [9:0] Bomb_X_Center=320;  // Center position on the X axis
    parameter [9:0] Bomb_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Bomb_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bomb_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bomb_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bomb_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bomb_X_Step=1;      // Step size on the X axis
    parameter [9:0] Bomb_Y_Step=1;      // Step size on the Y axis	

	 
	 assign Bomb_Size = 4;
	 
always_ff @(posedge Reset or posedge frame_clk) 
	begin	
		
		bombX = bombX;
		bombY = bombY;
		
		if (Reset)
        begin 
				bomb_check = 1'b0;

		  end
		  
		  
		else  
        begin 