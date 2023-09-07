package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public abstract class Instruction {
	protected int instNum;
	protected String instName;
	protected Parameter param1;
	protected Parameter param2;
	protected int lineNum;
	protected String errMsg;

	/**
	 * Creates a basic Instruction
	 * @param instName
	 * @param param1
	 * @param param2
	 * @param lineNum
	 * @param minParams
	 * @param adjective for argument count error message
	 */
	public Instruction(
		String instName,
		Parameter param1, 
		Parameter param2, 
		int lineNum, 
		int minParams, 
		String adjective
	) {
		// Set values
		this.instNum = -100;
		this.instName = instName;
		this.param1 = param1;
		this.param2 = param2;
		this.lineNum = lineNum;
		this.errMsg = "";
		
		// Check argument count
		if (minParams > 0 && param1.isDefined()) errMsg = adjective + " needs at least 1 value";
		else if (minParams == 2 && param2.isDefined()) errMsg = adjective + " needs 2 values";
	}
}
