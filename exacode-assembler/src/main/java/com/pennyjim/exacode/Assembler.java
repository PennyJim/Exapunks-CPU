package com.pennyjim.exacode;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.pennyjim.exacode.instructions.Add;
import com.pennyjim.exacode.instructions.Instruction;

public class Assembler {
	private static Pattern lineRegex = Pattern.compile("^.*?(?=;|$)");

	public static void fromFile(String filepath) throws FileNotFoundException {
		ArrayList<Instruction> instructions = new ArrayList<>();

		try (BufferedReader br = new BufferedReader(new FileReader(filepath))) {
			String line;
			int lineNum = 0;
			while ((line = br.readLine()) != null) {
				lineNum++;
				Instruction newInst = assembleLine(line, lineNum);
				if (newInst != null) instructions.add(newInst);
			}
		} catch (IOException e) {
			// TODO: handle exception
		}
	}

	private static Instruction assembleLine(String line, int lineNum) {
		// Trim string of comments and whitespace
		Matcher matcher = lineRegex.matcher(line.toUpperCase());
		if (!matcher.find()) return null;
		line = matcher.group().trim();

		//TODO figure out which instruction to instantiate

		//TODO: get params

		return new Add(new Parameter(""), new Parameter(""), lineNum);
	}
}
