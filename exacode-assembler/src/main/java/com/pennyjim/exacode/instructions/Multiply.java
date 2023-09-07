package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class Multiply extends MathInstruction {
	public Multiply(
		Parameter param1,
		Parameter param2,
		int lineNum
	) {
		super("Multiply", param1, param2, lineNum, "Adding",
			-10, -11, 12, -12, 13, 14, -14, 15, -15);
		if (this.instNum == -100) { // Defined Error
			return;
		} else if (this.instNum == -10) { //Precalc
			// TODO: Return a load instruction
		} else if (this.instNum == -11) { //Change instruction
			this.instNum = -100;
			this.errMsg = "Cannot support #RES * #RES at this time. Please load #RES into a register, and multiply that way";
		} else if (this.instNum < 0) {
			Parameter temp = this.param1;
			this.param1 = this.param2;
			this.param2 = temp;
			this.instNum *= -1;
		}
	}
}
