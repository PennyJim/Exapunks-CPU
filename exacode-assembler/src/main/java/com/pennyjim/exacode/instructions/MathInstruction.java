package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;

public abstract class MathInstruction extends Instruction {
	/**
	 * Checks paramter types and sets instNum accordingly
	 * @param instName
	 * @param param1
	 * @param param2
	 * @param lineNum
	 * @param adjective for argument count error message
	 * 
	 * @param ValVal 
	 * @param ResRes 
	 * @param ResVal
	 * @param ValRes
	 * @param RegReg
	 * @param RegVal
	 * @param ValReg
	 * @param RegRes
	 * @param ResReg
	 */
	public MathInstruction(
		String instName,
		Parameter param1, 
		Parameter param2, 
		int lineNum,
		String adjective,
		
		int ValVal,
		int ResRes,
		int ResVal,
		int ValRes,
		int RegReg,
		int RegVal,
		int ValReg,
		int RegRes,
		int ResReg
	) {
		super(instName, param1, param2, lineNum, 2, adjective);
		if (this.errMsg != "") return; //Already errored;

		//TODO: set instNum to approrppiate value
		// This requires Parameter to be finalized
	}

	// VV,ResRes,ResV,VRes,RR,RV,VR,RRes,ResR)
	// local output, param1Type, param2Type =
	// 	Compiler.keys.default(param1, param2, lineNum, 2, type)
	// if (param1Type == "VALUE" and param2Type == "VALUE") then
	// 	output[1] = VV
	// elseif (param1Type == "RESULT" and param2Type == "RESULT") then
	// 	output[1] = ResRes
	// elseif (param1Type == "RESULT" and param2Type == "VALUE") then
	// 	output[1] = ResV
	// elseif (param2Type == "RESULT" and param1Type == "VALUE") then
	// 	output[1] = VRes
	// elseif (param1Type == "REGISTER" and param2Type == "REGISTER") then
	// 	output[1] = RR
	// elseif (param1Type == "REGISTER" and param2Type == "VALUE") then
	// 	output[1] = RV
	// elseif (param2Type == "REGISTER" and param1Type == "VALUE") then
	// 	output[1] = VR
	// elseif (param1Type == "REGISTER" and param2Type == "RESULT") then
	// 	output[1] = RRes
	// elseif (param2Type == "REGISTER" and param1Type == "RESULT") then
	// 	output[1] = ResR
	// end
	// if output[1] == -100 then
	// 	output[5] = param1Type.." and "..param2Type.." are not currently supported parameter types"
	// end
	// return output
}
