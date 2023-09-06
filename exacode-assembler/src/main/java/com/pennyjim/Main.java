package com.pennyjim;

import com.pennyjim.exacode.Assembler;

/**
 * Handle arguments
 */
public class Main {
	public static void main(String[] args) {
		if (args.length > 0)
			Assembler.fromFile(args[0]);
		else
			Assembler.fromFile("Test.exaCode");
	}
}