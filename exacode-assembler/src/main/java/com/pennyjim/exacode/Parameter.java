package com.pennyjim.exacode;

public class Parameter {
	private boolean isDefined = false;
	private String input;
	private String type;
// Valid types:
// --- | "VALUE"
// --- | "REGISTER"
// --- | "RESULT"
// --- | "MEMORY"
// --- | "LINE"
// --- | "DEFINITION"
// Lua Patterns:
// VALUE = "^%d+$",
// REGISTER = "^#%d$",
// RESULT = "^#RES$",
// MEMORY = "^&%d+$",
// LINE = "^!%d+$",
// DEFINITION = "^@%w+$",
// NIL = "^$",
	private int value;

	public Parameter(String input) {

	}


	public boolean	isDefined()		{ return this.isDefined;	}
	public String		getInput()		{ return this.input;			}
	public String		getType()			{ return this.type;				}
	public int			getValue()		{ return this.value;			}
}
