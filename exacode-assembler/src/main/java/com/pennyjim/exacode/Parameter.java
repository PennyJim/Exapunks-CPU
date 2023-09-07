package com.pennyjim.exacode;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Parameter {
	public static enum Types {
		VALUE("\\d+"),
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
