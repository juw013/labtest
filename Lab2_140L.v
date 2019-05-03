// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//my github is github/juw013/lab2_turn/lab_check
module Lab2_140L (
 input wire Gl_rst,                  // reset signal (active high)
 input wire clk,                     // global clock
 input wire Gl_adder_start,          // r1, r2, OP are ready  
 input wire Gl_subtract,             // subtract (active high)
 input wire [7:0] Gl_r1           , // 8bit number 1
 input wire [7:0] Gl_r2           , // 8bit number 1
 output wire [7:0] L2_adder_data   ,   // 8 bit ascii sum
 output wire L2_adder_rdy          , //pulse
 output wire [7:0] L2_led
);

	sigDelay	s_d(				//call the sigDelay module to let the computer on which period what is down is will do.
.sigOut(L2_adder_rdy),
.sigIn(Gl_adder_start),
.clk(clk),
.rst(Gl_rst)
);


wire [3:0] carry;		// create a wire for the carry_in



Full_Adder bit1(				// the first bit adder
.Num1(Gl_r1[0]),
.Num2(Gl_r2[0]^Gl_subtract),
.C_in(Gl_subtract),
.Sum(L2_adder_data[0]),
.C_out(carry[0])
);

Full_Adder bit2(			//the second bit
.Num1(Gl_r1[1]),
.Num2(Gl_r2[1]^Gl_subtract),
.C_in(carry[0]),
.Sum(L2_adder_data[1]),
.C_out(carry[1])
);

Full_Adder bit3(				//the third bit
.Num1(Gl_r1[2]),
.Num2(Gl_r2[2]^Gl_subtract),
.C_in(carry[1]),
.Sum(L2_adder_data[2]),
.C_out(carry[2])
);

Full_Adder bit4(				// the forth bit
.Num1(Gl_r1[3]),
.Num2(Gl_r2[3]^Gl_subtract),
.C_in(carry[2]),
.Sum(L2_adder_data[3]),
.C_out(carry[3])
);

assign L2_led[0] = L2_adder_data[0]; 		// the led[0] through to led[3] is equal to the adder_dada
assign L2_led[1] = L2_adder_data[1];
assign L2_led[2] = L2_adder_data[2];
assign L2_led[3] = L2_adder_data[3];
assign L2_led[4] = carry[3]^Gl_subtract;


//assign L2_led[0] = 1;
//assign L2_led[1] = 1;
//assign L2_led[2] = 1;
//assign L2_led[3] = 1;
//assign L2_led[4] = 1;
assign L2_adder_data[4] = 1;		//we know that the 8th bits and 5th bits is 0 and 1.
assign L2_adder_data[5] = !L2_led[4];
assign L2_adder_data[6] = L2_led[4];
assign L2_adder_data[7] = 0;
 
endmodule




module sigDelay(
		  output      sigOut,
		  input       sigIn,
		  input       clk,
		  input       rst);

   parameter delayVal = 4;
   reg [15:0] 		      delayReg;


   always @(posedge clk) begin
      if (rst)
	delayReg <= 16'b0;
      else begin
	 delayReg <= {delayReg[14:0], sigIn};
      end
   end

   assign sigOut = delayReg[delayVal];
	

endmodule // sigDelay




module Full_Adder(		// this is a one bit Full_Adder
		Num1,
		Num2,
		C_in,
		Sum,
		C_out
);

	input Num1;
	input Num2;
	input C_in;
	output Sum;
	output C_out;
	
	assign Sum = (Num1 ^ Num2) ^ C_in;
	assign C_out = (Num1 & Num2) | C_in & (Num1 ^ Num2);
	
endmodule
