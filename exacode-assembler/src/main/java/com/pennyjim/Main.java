package com.pennyjim;

import com.pennyjim.exacode.Assembler;

/**
 * Handle arguments
 */
public class Main {
	public static void main(String[] args) {
		if (args.length > 0)
			Assembler.from_file(args[0]);
		else
			Assembler.from_file("Test.exaCode");
	}
}