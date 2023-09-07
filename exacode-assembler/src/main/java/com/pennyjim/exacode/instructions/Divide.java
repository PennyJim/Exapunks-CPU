package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class Divide extends MathInstruction {
	public Divide(
		Parameter param1,
		Parameter param2,
		int lineNum
	) {
		super("Divide", param1, param2, lineNum, "Dividing",
			-10, -11, 16, 17, 18, 19, 20, 21, 22);
		if (this.instNum == -100) { // Defined Error
			return;
		} else if (this.instNum == -10) { //Precalc
			// TODO: Return a load instruction
		} else if (this.instNum == -11) { //Change instruction
			// TODO: Return a load 1 instruction
		}
	}
}
