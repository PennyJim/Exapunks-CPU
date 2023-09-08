package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;
import com.pennyjim.exacode.Parameter.Types;

public abstract class MathInstruction extends Instruction {
	/**
	 * Checks paramter types and sets instNum accordingly
	 * @param instName
	 * @param param1
	 * @param param2
	 * @param lineNum
	 * @param verb for argument count error message
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
		String verb,
		
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
		this(instName,param1,param2,lineNum,verb,
			ValVal, ResRes, ResVal, ValRes, RegReg, RegVal, ValReg, RegRes, ResReg, false);
	}

	public MathInstruction(
		String instName,
		Parameter param1, 
		Parameter param2, 
		int lineNum,
		String verb,
		
		int ValVal,
		int ResRes,
		int ResVal,
		int ValRes,
		int RegReg,
		int RegVal,
		int ValReg,
		int RegRes,
		int ResReg,
		boolean isOld
	) {
		super(instName, param1, param2, lineNum, 2, verb);
		if (this.errMsg != "") return; //Already errored;
		if (isOld) {
			//Old if else if implementation
			if (param1.getType() == Types.VALUE && param2.getType() == Types.VALUE) {
				this.instNum = ValVal;
			} else if (param1.getType() == Types.RESULT && param2.getType() == Types.RESULT) {
				this.instNum = ResRes;
			} else if (param1.getType() == Types.RESULT && param2.getType() == Types.VALUE) {
				this.instNum = ResVal;
			} else if (param1.getType() == Types.VALUE && param2.getType() == Types.RESULT) {
				this.instNum = ValRes;
			} else if (param1.getType() == Types.REGISTER && param2.getType() == Types.REGISTER) {
				this.instNum = RegReg;
			} else if (param1.getType() == Types.REGISTER && param2.getType() == Types.VALUE) {
				this.instNum = RegVal;
			} else if (param1.getType() == Types.VALUE && param2.getType() == Types.REGISTER) {
				this.instNum = ValReg;
			} else if (param1.getType() == Types.REGISTER && param2.getType() == Types.RESULT) {
				this.instNum = RegRes;
			} else if (param1.getType() == Types.RESULT && param2.getType() == Types.REGISTER) {
				this.instNum = ResReg;
			}

			if (this.instNum == -100) {
				this.errMsg = param1.getType()+" and "+param2.getType()+" are not currently supported parameter types";
			}

		} else {
			//New 2D switch case implementation
			int selector = param1.getType().ordinal() * Types.values().length + param2.getType().ordinal();
			switch (selector) {
				case 0 :	//	Value				Value
					this.instNum = ValVal;
					break;
				case 14:	//	Result			Result
					this.instNum = ResRes;
					break;
				case 12:	//	Result			Value
					this.instNum = ResVal;
					break;
				case 2 :	//	Value				Result
					this.instNum = ValRes;
					break;
				case 7 :	//	Register		Register
					this.instNum = RegReg;
					break;
				case 6 :	//	Register		Value
					this.instNum = RegVal;
					break;
				case 1 :	//	Value				Register
					this.instNum = ValReg;
					break;
				case 8 :	//	Register		Result
					this.instNum = RegRes;
					break;
				case 13:	//	Result			Register
					this.instNum = ResReg;				
					break;

				default: //		Other
					this.errMsg = param1.getType()+" and "+param2.getType()+" are not currently supported parameter types";
					break;
			}
		}
	}
}
