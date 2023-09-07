package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class Sub extends MathInstruction{
	public Sub(
		Parameter param1,
		Parameter param2,
		int lineNum
	) {
		super("Sub", param1, param2, lineNum, "Subtracting",
			-10, -11, 5, 6, 7, 8, 9, 10, 11);
		if (this.instNum == -100) { // Defined Error
			return;
		} else if (this.instNum == -10) { //Precalc
			int preCacl = param1.getValue() - param2.getValue();
			transformInto(new Move(new Parameter(Integer.toString(preCacl)), new Parameter("#RES"), lineNum));
		} else if (this.instNum == -11) { //Change instruction
			transformInto(new Move(new Parameter("0"), new Parameter("#RES"), lineNum));
		}
	}
}
