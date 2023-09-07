package com.pennyjim.exacode.instructions;

import com.pennyjim.exacode.Parameter;
import com.pennyjim.exacode.Parameter.Types;

public class Move extends Instruction {
	public Move(Parameter param1, Parameter param2, int lineNum) {
		super("Move", param1, param2, lineNum, 2, "Moving");
		if (this.errMsg != "") return; //Already errored

		int selector = param1.getType().ordinal() * Types.values().length + param2.getType().ordinal();
		switch (selector) {
			case 2 :	//	Value				Result
				this.instNum = 23;
				break;

			case 8 :	//	Register		Result
				this.instNum = 24;
				break;

			case 1 :	//	Value				Register
				this.instNum = 25;
				break;

			case 13:	//	Result			Register
				this.instNum = 27;
				this.param1 = this.param2;
				break;

			case 7 :	//	Register		Register
				this.instNum = 26;
				break;

			case 19:	//	Memory			Register
				this.instNum = 28;
				break;

			case 9 :	//	Register		Memory
				this.instNum = 29;
				break;
			// Maybe in the future?
			// case 25:	//	Line				Register
			// case 26:	//	Line				Result
			// case 31:	//	Definition	Register
			// case 32:	//	Definition	Result
		
			default: //Unsupported
				this.errMsg = param1.getType()+" and "+param2.getType()+" are not currently supported parameter types";
				break;
		}
	}
}
