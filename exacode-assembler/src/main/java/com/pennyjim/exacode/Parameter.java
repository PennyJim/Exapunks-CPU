package com.pennyjim.exacode;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

// 2D Switch statement

// int selector = param1.getType().ordinal() * Types.values().length + param2.getType().ordinal();
// switch (selector) {
// 	case 0 :	//	Value				Value
// 	case 1 :	//	Value				Register
// 	case 2 :	//	Value				Result
// 	case 3 :	//	Value				Memory
// 	case 4 :	//	Value				Line
// 	case 5 :	//	Value				Definition
// 	case 6 :	//	Register		Value
// 	case 7 :	//	Register		Register
// 	case 8 :	//	Register		Result
// 	case 9 :	//	Register		Memory
// 	case 10:	//	Register		Line
// 	case 11:	//	Register		Definition
// 	case 12:	//	Result			Value
// 	case 13:	//	Result			Register
// 	case 14:	//	Result			Result
// 	case 15:	//	Result			Memory
// 	case 16:	//	Result			Line
// 	case 17:	//	Result			Definition
// 	case 18:	//	Memory			Value
// 	case 19:	//	Memory			Register
// 	case 20:	//	Memory			Result
// 	case 21:	//	Memory			Memory
// 	case 22:	//	Memory			Line
// 	case 23:	//	Memory			Definition
// 	case 24:	//	Line				Value
// 	case 25:	//	Line				Register
// 	case 26:	//	Line				Result
// 	case 27:	//	Line				Memory
// 	case 28:	//	Line				Line
// 	case 29:	//	Line				Definition
// 	case 30:	//	Definition	Value
// 	case 31:	//	Definition	Register
// 	case 32:	//	Definition	Result
// 	case 33:	//	Definition	Memory
// 	case 34:	//	Definition	Line
// 	case 35:	//	Definition	Definition
		
// 		break;

// 	default:
// 		break;
// }

public class Parameter {
	public static enum Types {
		VALUE("-?\\d+"),
		REGISTER("#\\d"),
		RESULT("#RES"),
		MEMORY("&\\d+"),
		LINE("!\\d+"),
		DEFINITION("@\\w+");

		private Pattern regex;
		Types(String regexString) {
			this.regex = Pattern.compile(regexString);
		}
		public Matcher matcher(String input) {
			return this.regex.matcher(input);
		}
		public boolean matches(String input) {
			return this.regex.matcher(input).matches();
		}
	}


	private boolean isDefined = false;
	private String input;
	private Types type;
	private int value;

	public Parameter(String input) {
		this.input = input;
		for (Types type : Types.values()) {
			if (type.matches(input)) {
				this.type = type;
				break;
			}
		}

		if (this.type == Types.DEFINITION) {
			//TODO: handle the variable;

		} else if (this.type == Types.RESULT) {
			this.isDefined = true;
			this.value = 0;

		} else if (this.type != null) {
			this.isDefined = true;
			if (this.type != Types.VALUE) input = input.substring(1);
			if (this.type == Types.REGISTER) input = input.substring(0,1);

			this.value = Integer.parseInt(input);
		}
	}


	public boolean	isDefined()		{ return this.isDefined;	}
	public String		getInput()		{ return this.input;			}
	public Types		getType()			{ return this.type;				}
	public int			getValue()		{ return this.value;			}
}
