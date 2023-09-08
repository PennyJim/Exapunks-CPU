package instructions;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.fail;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.pennyjim.exacode.Parameter;
import com.pennyjim.exacode.Parameter.InvalidParameterException;
import com.pennyjim.exacode.Parameter.Types;

public class ParameterTests {
	private static Class<InvalidParameterException> exception = InvalidParameterException.class;
	private static int randomCount = 100;
	
	@Disabled
	@Test
	@DisplayName("Old Random Value test")
	void RandValueTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 20000);
			int randomReg = randomValue % 20;

			if (randomReg > 9) {
				assertThrows(exception, () -> {new Parameter("#"+randomReg);});
			} else {
				Parameter testRegister = new Parameter("#"+randomReg);

				assertEquals(Types.REGISTER, testRegister.getType(), "Is not a REGISTER");
				assertEquals(randomReg, testRegister.getValue(), "Value does not match expected");
			}

			if (randomValue > 9999) {
				assertThrows(exception, () -> {new Parameter("&"+randomValue);});
				assertThrows(exception, () -> {new Parameter("!"+randomValue);});
			} else {
				Parameter testMemory = new Parameter("&"+randomValue);
				Parameter testLine = new Parameter("!"+randomValue);

				assertEquals(Types.MEMORY, testMemory.getType(), "Is not a MEMORY");
				assertEquals(randomValue, testMemory.getValue(), "Value does not match expected");

				assertEquals(Types.LINE, testLine.getType(), "Is not a LINE");
				assertEquals(randomValue, testLine.getValue(), "Value does not match expected");
			}

			int possiblyNegative = (int)(Math.random() * 30000) - 10000;
			if (possiblyNegative < -9999 || possiblyNegative > 9999) {
				assertThrows(exception, () -> {new Parameter(Integer.toString(possiblyNegative));});
			} else {
				Parameter testValue = new Parameter(Integer.toString(possiblyNegative));

				assertEquals(Types.VALUE, testValue.getType(), "Is not a VALUE");
				assertEquals(possiblyNegative, testValue.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Random Register Test")
	void RandomRegTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 20);

			if (randomValue > 9) {
				assertThrows(exception, () -> {new Parameter("#"+randomValue);});
			} else {
				Parameter testRegister = new Parameter("#"+randomValue);

				assertEquals(Types.REGISTER, testRegister.getType(), "Is not a REGISTER");
				assertEquals(randomValue, testRegister.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Random Memory Test")
	void RandomMemTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 20000);

			if (randomValue > 9999) {
				assertThrows(exception, () -> {new Parameter("&"+randomValue);});
			} else {
				Parameter testMemory = new Parameter("&"+randomValue);

				assertEquals(Types.MEMORY, testMemory.getType(), "Is not a MEMORY");
				assertEquals(randomValue, testMemory.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Random Line Test")
	void RandomLineTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 10000);

			if (randomValue > 3333) {
				assertThrows(exception, () -> {new Parameter("!"+randomValue);});
			} else {
				Parameter testLine = new Parameter("!"+randomValue);

				assertEquals(Types.LINE, testLine.getType(), "Is not a LINE");
				assertEquals(randomValue, testLine.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Random Value Test")
	void RandomValTest() {
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 40000) - 20000;

			if (randomValue < -9999 || randomValue > 9999) {
				assertThrows(exception, () -> {new Parameter(Integer.toString(randomValue));});
			} else {
				Parameter testValue = new Parameter(Integer.toString(randomValue));

				assertEquals(Types.VALUE, testValue.getType(), "Is not a VALUE");
				assertEquals(randomValue, testValue.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Static Value Test")
	void StaticValueTest() {
		Parameter result = new Parameter("#RES");
		assertEquals(Types.RESULT, result.getType(), "Is not a RESULT");

		assertThrows(exception, () -> {new Parameter("#RESULT");}, "Shouldn't have worked");
		assertThrows(exception, () -> {new Parameter("VARIABLE");}, "Shouldn't have worked");
		assertThrows(exception, () -> {new Parameter("#O");}, "Shouldn't have worked");
		assertThrows(exception, () -> {new Parameter("what");}, "Shouldn't have worked");
		assertThrows(exception, () -> {new Parameter("%TEST");}, "Shouldn't have worked");
		assertThrows(exception, () -> {new Parameter("ILLOGIC");}, "Shouldn't have worked");
	}

	@Test
	@DisplayName("Definition Test")
	void DefinitionTest() {
		// TODO: Once I understand how it's going to happen in Parameter, make the test
		fail("Not Implemented");
	}
}
