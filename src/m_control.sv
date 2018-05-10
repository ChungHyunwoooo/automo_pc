module m_control
	#(
		parameter CGES = 'd7
		
	)
	(
		input clk, 
		input logic reset_n,
		input start, fin,
		output logic cal,
		output logic [$clog2(CGES)-'d1:0] addr
		
	);
	
	localparam INIT = 3'b000;
	localparam SAVE = 3'b001;
	localparam WAIT = 3'b010;
	localparam CALC = 3'b011;
	localparam FCAL = 3'b100;
	
	
	logic [2:0]state;
	logic [2:0]n_state;
	
	logic [$clog2(CGES)-'d1:0] s_counter = 0;
	shortint counter = 0;
	
	always @(posedge clk) begin
		if(reset_n) 				state = INIT;
		else							state = n_state;
	end
	
	always @(state, s_counter, counter, start, fin) begin
		case(state)
		INIT: 						n_state = WAIT;
		WAIT:begin
			if(start == 1'b0) 	n_state = WAIT;
			else 						n_state = CALC;
			
		end
		CALC: begin
			if(fin == 0)			n_state = CALC;
			else 						n_state = FCAL;
		end
		FCAL: begin
			if($clog2(CGES) > counter)
										n_state = FCAL;
			else 						n_state = WAIT;
		end
		default: n_state = 2'bxx;
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
		INIT: begin
			cal = 1'b0;
		end
		WAIT: begin
			s_counter = {$clog2(CGES){1'd0}};
			counter = 16'd0;
			cal = 1'b0;
		end
		CALC: begin
			cal = 1'b1;
		end
		FCAL: begin
			cal = 1'b0;
			counter = counter + 16'd1;
		end
		default: n_state = 2'bxx;
		endcase
	end
	assign addr = s_counter;
endmodule
