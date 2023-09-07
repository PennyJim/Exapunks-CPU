package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class Sub extends MathInstruction{
	public Sub(
		Parameter param1,
		Parameter param2,
		int lineNum
	) {
		super("Sub", param1, param2, lineNum, "Adding",
			-10, -11, 5, 6, 7, 8, 9, 10, 11);
		if (this.instNum == -100) { // Defined Error
			return;
		} else if (this.instNum == -10) { //Precalc
			// TODO: Return a load instruction
		} else if (this.instNum == -11) { //Change instruction
			// TODO: Return a load 0 instruction
		}
	}
}
