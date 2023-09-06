package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class Add extends MathInstruction{
	public Add(
		Parameter param1,
		Parameter param2,
		int lineNum
	) {
		super("Add", param1, param2, lineNum, "Adding",
			-10, -11, 1, -1, 2, 3, -3, 4, -4);
		if (this.instNum == -100) { // Defined Error
			return;
		} else if (this.instNum == -10) {
			// TODO: Return a load instruction
		} else if (this.instNum == -11) {
			// TODO: Return a multiply instruction
		} else if (this.instNum < 0) {
			Parameter temp = this.param1;
			this.param1 = this.param2;
			this.param2 = temp;
			this.instNum *= -1;
		}
	}
}
