package instructions;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.fail;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import com.pennyjim.exacode.Parameter;
import com.pennyjim.exacode.Parameter.InvalidParameterException;

public class ParameterTests {
	private static Class<InvalidParameterException> exception = InvalidParameterException.class;
	
	@Test
	@DisplayName("Value test")
	void ValueTest() {
		final int randomCount = 100;
		for (int i = 0; i < randomCount; i++) {
			int randomValue = (int)(Math.random() * 20000);
			int randomReg = randomValue % 20;

			if (randomReg > 9) {
				assertThrows(exception, () -> {new Parameter("#"+randomReg);});
			} else {
				Parameter testRegister = new Parameter("#"+randomReg);

				assertEquals(randomReg, testRegister.getValue(), "Value does not match expected");
			}

			if (randomValue > 9999) {
				assertThrows(exception, () -> {new Parameter("&"+randomValue);});
				assertThrows(exception, () -> {new Parameter("!"+randomValue);});
			} else {
				Parameter testMemory = new Parameter("&"+randomValue);
				Parameter testLine = new Parameter("!"+randomValue);

				assertEquals(randomValue, testMemory.getValue(), "Value does not match expected");
				assertEquals(randomValue, testLine.getValue(), "Value does not match expected");
			}

			int possiblyNegative = (int)(Math.random() * 30000) - 10000;
			if (possiblyNegative < -9999 || possiblyNegative > 9999) {
				assertThrows(exception, () -> {new Parameter(Integer.toString(possiblyNegative));});
			} else {
				Parameter testValue = new Parameter(Integer.toString(possiblyNegative));

				assertEquals(possiblyNegative, testValue.getValue(), "Value does not match expected");
			}
		}
	}

	@Test
	@DisplayName("Definition Test")
	void DefinitionTest() {
		// TODO: Once I understand how it's going to happen in Parameter, make the test
		fail("Not Implemented");
	}
}
