package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public class NOOP extends Instruction {
	public NOOP(Parameter param1, Parameter param2, int lineNum) {
		super("NOOP", param1, param2, 0, lineNum, "");
		this.instNum = 0;
	}
}
