package instructions;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.pennyjim.exacode.Parameter;
import com.pennyjim.exacode.Parameter.Types;
import com.pennyjim.exacode.instructions.*;

@DisplayName("Math Instructions Tests")
class MathInstructionsTests {
	static int randomCount = 100;
	static Parameter p(String input) {
		return new Parameter(input);
	}
	static Parameter p(Types input) {
		switch (input) {
			case VALUE:
				return p("0");
			case REGISTER:
				return p("#0");
			case RESULT:
				return p("#RES");
			case MEMORY:
				return p("&0");
			case LINE:
				return p("!0");
			case DEFINITION:
				return p("@test");
		
			default:
				throw new Error();
		}
	}

	class MathInstructionTesting extends MathInstruction {
		public MathInstructionTesting(
			Parameter param1, 
			Parameter param2, 
			int lineNum
		) {
			super("test", param1, param2, lineNum, "testing", 
			1, 2, 3, 4, 5, 6, 7, 8, 9);
		}
	}
	
	@Test
	@DisplayName("Parameter Type Tests")
	void TypeTest() {

		individualTypeTest(Types.VALUE, Types.VALUE, 1);
		individualTypeTest(Types.RESULT, Types.RESULT, 2);
		individualTypeTest(Types.RESULT, Types.VALUE, 3);
		individualTypeTest(Types.VALUE, Types.RESULT, 4);
		individualTypeTest(Types.REGISTER, Types.REGISTER, 5);
		individualTypeTest(Types.REGISTER, Types.VALUE, 6);
		individualTypeTest(Types.VALUE, Types.REGISTER, 7);
		individualTypeTest(Types.REGISTER, Types.RESULT, 8);
		individualTypeTest(Types.RESULT, Types.REGISTER, 9);
	}

	void individualTypeTest(Types param1, Types param2, int expectedInst) {
		
		assertEquals(
			expectedInst,
			new MathInstructionTesting(p(param1),p(param2), 0).getInstNum(),
			"Passing a "+param1+" and a "+param2+" does not result in the expected "+expectedInst
		);
	}


	@Test
	@DisplayName("Parameter Differenciation Test")
	void ParamMixupTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomNum1 = (int)(Math.random() * 10000);
			int randomNum2 = (int)(Math.random() * 10000);

			//Make sure Values don't get mixed
			Instruction testInst0 = new MathInstructionTesting(p(""+randomNum1), p(""+randomNum2), 0);
			assertEquals(randomNum1, testInst0.getParam1().getValue(), "Parameters got swapped");
			assertEquals(randomNum2, testInst0.getParam2().getValue(), "Parameters got swapped");
		}
	}

	@Test
	@DisplayName("Add Precomputation")
	void AddPrecomputeTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomNum1 = (int)(Math.random() * 10000);
			int randomNum2 = (int)(Math.random() * 10000);

			Instruction testInst = new Add(p(""+randomNum1),p(""+randomNum2),i);
			assertEquals("Load", testInst.getInstName(), "Instruction is not a Load");
			assertEquals(randomNum1+randomNum2, testInst.getParam1().getValue(), "Incorrectly Calculated");
			assertEquals(Types.RESULT, testInst.getParam2().getType(), "Loading into the wrong register");
		}
	}

	@Test
	@DisplayName("Add 'Optimization'")
	void AddOptimizeTest() {
		Instruction testInst = new Add(p("#RES"),p("#RES"),0);
		assertEquals("Multiply", testInst.getInstName(), "Instruction is not a Multiply");
		assertEquals(Types.RESULT, testInst.getParam1().getType(), "Multiplying wrong register");
		assertEquals(2, testInst.getParam2().getValue(), "Multiplying wrong value");
	}

	@Test
	@DisplayName("Parameter Swap (Add)")
	void AddParameterSwap() {
		for (int i = 0; i < randomCount; i++) {
			
			Parameter result = p("#RES");
			Parameter register = p("#"+(int)(Math.random()*10));
			Parameter value = p(""+(int)(Math.random()*10000));

			Instruction testInst1 = new Add(result, register, 1);
			Instruction testInst2 = new Add(register, result, 2);

			assertEquals(testInst1.getParam1().getType(),		testInst2.getParam1().getType());
			assertEquals(testInst1.getParam1().getValue(),	testInst2.getParam1().getValue());
			assertEquals(testInst1.getParam2().getType(),		testInst2.getParam2().getType());
			assertEquals(testInst1.getParam2().getValue(),	testInst2.getParam2().getValue());

			Instruction testInst3 = new Add(result, value, 3);
			Instruction testInst4 = new Add(value, result, 4);

			assertEquals(testInst3.getParam1().getType(),		testInst4.getParam1().getType());
			assertEquals(testInst3.getParam1().getValue(),	testInst4.getParam1().getValue());
			assertEquals(testInst3.getParam2().getType(),		testInst4.getParam2().getType());
			assertEquals(testInst3.getParam2().getValue(),	testInst4.getParam2().getValue());

			Instruction testInst5 = new Add(register, value, 5);
			Instruction testInst6 = new Add(value, register, 6);

			assertEquals(testInst5.getParam1().getType(),		testInst6.getParam1().getType());
			assertEquals(testInst5.getParam1().getValue(),	testInst6.getParam1().getValue());
			assertEquals(testInst5.getParam2().getType(),		testInst6.getParam2().getType());
			assertEquals(testInst5.getParam2().getValue(),	testInst6.getParam2().getValue());
		}
	}
}