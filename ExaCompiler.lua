---@alias pattern string
---@alias keyFunction fun(param1:string, param1:string, lineNum:integer, instNum:integer): instructionObj?
---@alias parameter
--- | "VALUE"
--- | "REGISTER"
--- | "RESULT"
--- | "MEMORY"
--- | "LINE"
--- | "DEFINITION"
--- | "NIL"
---@alias key
--- | "MARK"
--- | "NOOP" Not really useful in a non-cycle based cpu
--- | "ADD"
--- | "SUB"
--- | "DIVIDE"
--- | "MULTIPLY"
--- | "LOAD"
--- | "STORE"
--- | "DEFINE"
--- | "JUMP" ; TODO: add jumping to pointers
--- | "FUNC"
--- | "RETURN"
-- TODO: More keywords
-- POP
-- PUSH

---@class instructionObj
---@field instruction integer
---@field parameter1 string
---@field parameter2 string
---@field lineNum integer
---@field errorMsg string

---@return instructionObj
local function newInstruction(e)
	e.instruction = e[1]
	e.parameter1 = e[2]
	e.parameter2 = e[3]
	e.lineNum = e[4]
	e.errMsg = e[5]
	return e
end

---@class undefiendDefinition
---@field instructionNum integer
---@field lineNum integer
---@field key keyFunction
---@field numParam integer

---@return undefiendDefinition
local function newUndefinition(e)
	e.instructionNum = e[1]
	e.lineNum = e[2]
	e.key = e[3]
	e.numParam = e[4]
	return e
end

---@class Compiler
---@field keys {[key]: keyFunction}
---@field definitionsDefined {[string]: string}
---@field definitionsUndefined {[string]: undefiendDefinition[]}
Compiler = {}
---@enum
Compiler.parameters = {
	VALUE = "^%d+$",
	REGISTER = "^#%d$",
	RESULT = "^#RES$",
	MEMORY = "^&%d+$",
	LINE = "^!%d+$",
	DEFINITION = "^@%w+$",
	NIL = "^$",
}
Compiler.keys = {
	---Returns a default inst built from the passed parameters
	---@param param1 string
	---@param param2 string
	---@param lineNum integer
	---@param minParams integer
	---@param adjective string
	---@return instructionObj
	---@return string?
	---@return string?
	default = function (param1, param2, lineNum, minParams, adjective)
		if minParams == 2 and not (param1 and param2) then
			return newInstruction{-100, param1, param2, lineNum, adjective.." needs 2 values"}
		elseif minParams == 1 and not param1 then
			return newInstruction{-100, param1, param2, lineNum, adjective.." needs at least 1 value"}
		end
		local param1Type = Compiler:getParamtype(param1)
		local param2Type = Compiler:getParamtype(param2)
		return newInstruction{-100, param1, param2, lineNum}, param1Type, param2Type
	end,
}
---@return nil
function Compiler.keys.MARK(param1, param2, lineNum, instNum)
	if Compiler.definitionsDefined[param1] ~= nil then
		return {-1, param1, 0, lineNum, param1.." is already defined"}
	end
	-- instNum is supposed to be 'next line' but Lua is index 1 instead of 0
	return Compiler:define("@"..param1, "!"..(instNum-1))
end
---@return instructionObj
function Compiler.keys.NOOP(param1, param2, lineNum)
	return {0, 0, 0, lineNum};
end
--#region Math keys
function Compiler.keys.genericMath(param1, param2, lineNum, type,
	VV,ResRes,ResV,VRes,RR,RV,VR,RRes,ResR)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 2, type)
	if (param1Type == "VALUE" and param2Type == "VALUE") then
		output[1] = VV
	elseif (param1Type == "RESULT" and param2Type == "RESULT") then
		output[1] = ResRes
	elseif (param1Type == "RESULT" and param2Type == "VALUE") then
		output[1] = ResV
	elseif (param2Type == "RESULT" and param1Type == "VALUE") then
		output[1] = VRes
	elseif (param1Type == "REGISTER" and param2Type == "REGISTER") then
		output[1] = RR
	elseif (param1Type == "REGISTER" and param2Type == "VALUE") then
		output[1] = RV
	elseif (param2Type == "REGISTER" and param1Type == "VALUE") then
		output[1] = VR
	elseif (param1Type == "REGISTER" and param2Type == "RESULT") then
		output[1] = RRes
	elseif (param2Type == "REGISTER" and param1Type == "RESULT") then
		output[1] = ResR
	end
	if output[1] == -100 then
		output[5] = param1Type.." and "..param2Type.." are not currently supported parameter types"
	end
	return output
end
---@return instructionObj
function Compiler.keys.ADD(param1, param2, lineNum)
	local output = Compiler.keys.genericMath(param1, param2, lineNum, "Addition",
		-10, -11, 1, -1, 2, 3, -3, 4, -4)
	if output[1] == -10 then
		local preCalc = tostring(tonumber(output[2])+tonumber(output[3]))
		return Compiler.keys.LOAD(preCalc, "#RES", lineNum)
	elseif output[1] == -11 then
		return Compiler.keys.MULTIPLY("#RES", "2", lineNum)
	elseif output[1] < 0 and output[1] > -10 then
		local temp = output[2]
		output[2] = output[3]
		output[3] = temp
		output[1] = -output[1]
	end
	return output
end
---@return instructionObj
function Compiler.keys.SUB(param1,param2,lineNum)
	local output = Compiler.keys.genericMath(param1, param2, lineNum, "Addition",
		-10, -11, 5, 6, 7, 8, 9, 10, 11)
	if output[1] == -10 then
		return Compiler.keys.LOAD(output[2]-output[3], "#RES", lineNum)
	elseif output[1] == -11 then
		return Compiler.keys.LOAD("0", "#RES", lineNum)
	end
	return output
end
---@return instructionObj
function Compiler.keys.MULTIPLY(param1, param2, lineNum)
	local output = Compiler.keys.genericMath(param1, param2, lineNum, "Addition",
		-1, -2, 12, -12, 13, 14, -14, 15, -15)
	if output[1] == -1 then
		return Compiler.keys.LOAD(output[2]*output[3], "#RES", lineNum)
	elseif output[1] == -2 then
		output[1] = -100
		output[5] = "Cannot support #RES * #RES at this time. Please load #RES into a register, and multiply that way"
	elseif output[1] < 0 and output[1] > -100 then
		local temp = output[2]
		output[2] = output[3]
		output[3] = temp
	end
	return output
end
---@return instructionObj
function Compiler.keys.DIVIDE(param1,param2,lineNum)
	if Compiler:getParamtype(param2) == "VALUE" and tonumber(param2) == 0 then
		return {-100, param1, 0, "Cannot divide by zero"}
	end
	local output = Compiler.keys.genericMath(param1, param2, lineNum, "Addition",
		-1, -2, 5, 6, 7, 8, 9, 10, 11)
	if output[1] == -1 then
		return Compiler.keys.LOAD(output[2]-output[3], "#RES", lineNum)
	elseif output[1] == -2 then
		return Compiler.keys.LOAD(1, "#RES", lineNum)
	end
	return output
end
--#endregion
--#region Load/Store keys
---@return instructionObj
function Compiler.keys.LOAD(param1, param2, lineNum)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 2, "storing")
	if param1Type=="VALUE" and param2Type=="RESULT" then
		output[1] = 23
	elseif param1Type=="REGISTER" and param2Type=="RESULT" then
		output[1] = 24
	elseif param1Type=="VALUE" and param2Type=="REGISTER" then
		output[1] = 25
	elseif param1Type=="REGISTER" and param2Type=="REGISTER" then
		output[1] = 26
	elseif param1Type=="RESULT" and param2Type=="REGISTER" then
		output[1] = 27
		output[2] = output[3]
	elseif param1Type=="MEMORY" and param2Type=="REGISTER" then
		output[1] = 28
	end
	if output[1] == -100 then
		output[5] = param1Type.." and "..param2Type.." are not currently supported parameter types"
	end
	return output
end
---@return instructionObj
function Compiler.keys.STORE(param1, param2, lineNum)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 2, "storing")
	if param1Type=="VALUE" and param2Type=="RESULT" then
		output[1] = 23
	elseif param1Type=="REGISTER" and param2Type=="RESULT" then
		output[1] = 24
	elseif param1Type=="VALUE" and param2Type=="REGISTER" then
		output[1] = 25
	elseif param1Type=="REGISTER" and param2Type=="REGISTER" then
		output[1] = 26
	elseif param1Type=="RESULT" and param2Type=="REGISTER" then
		output[1] = 27
		output[2] = output[3]
	elseif param1Type=="MEMORY" and param2Type=="REGISTER" then
		output[1] = 28
	elseif param1Type=="REGISTER" and param2Type=="MEMORY" then
		output[1] = 29
	end
	if output[1] == -100 then
		output[5] = param1Type.." and "..param2Type.." are not currently supported parameter types"
	end
	return output
end
--#endregion
--#region Flow Control -- FIXME: Sometimes returns a number
--#region Jump
	---@return instructionObj
function Compiler.keys.JUMP(param1, param2, lineNum)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 1, "jumping")
	if param1Type=="LINE" then
		output[1] = 30
	else
		output[5] = "Can only jump to lines"
	end
	return output
end
---@return instructionObj
Compiler.keys["JUMP0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 31 end
	return output
end
---@return instructionObj
Compiler.keys["JUMP!0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 32 end
	return output
end
---@return instructionObj
Compiler.keys["JUMP>0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 33 end
	return output
end
---@return instructionObj
Compiler.keys["JUMP>=0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 34 end
	return output
end
---@return instructionObj
Compiler.keys["JUMP<0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 35 end
	return output
end
---@return instructionObj
Compiler.keys["JUMP<=0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 30 then output[1] = 36 end
	return output
end
--#endregion
--#region Func
---@return instructionObj
function Compiler.keys.FUNC(param1, param2, lineNum)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 1, "jumping")
	if param1Type=="LINE" then
		output[1] = 37
	else
		output[5] = "Can only jump to lines"
	end
	return output
end
---@return instructionObj
Compiler.keys["FUNC0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 38 end
	return output
end
---@return instructionObj
Compiler.keys["FUNC!0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 39 end
	return output
end
---@return instructionObj
Compiler.keys["FUNC>0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 40 end
	return output
end
---@return instructionObj
Compiler.keys["FUNC>=0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 41 end
	return output
end
---@return instructionObj
Compiler.keys["FUNC<0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 42 end
	return output
end
---@return instructionObj
Compiler.keys["FUNC<=0"] = function (param1, param2, lineNum)
	local output = Compiler.keys.JUMP(param1, param2, lineNum)
	if output[1] == 37 then output[1] = 43 end
	return output
end
--#endregion
---@return instructionObj
function Compiler.keys.RETURN(param1, param2, lineNum)
	local output, param1Type, param2Type =
		Compiler.keys.default(param1, param2, lineNum, 0, "jumping")
	output[1] = 44
	return output
end
--#endregion

---Fully Compiles the given file and returns the text
---you have to give to the Exa
---@param filename string
---@param isDebug boolean?
---@return string
---@nodiscard
function Compiler:from_file(filename, isDebug)
	self.definitionsUndefined = {}
	self.definitionsDefined = {}

	local instArray = self:defineUndefined(self:create_insts(filename, isDebug), isDebug)

	-- Create data array
	local output = {}
	local errorList =  {}
	local errored = false
	for i,instruction in ipairs(instArray) do
		if instruction[1] < 0 then
			-- Create error instead of write a bad instruction out
			if (isDebug) then
				print("Error: {"..table.concat(instruction, ", ").."}")
			end
			errorList[#errorList+1] = instruction[4].." : "..instruction[5]
			errored = true
		elseif not errored then
			-- HACK: Patch out nils as they come out
			if not instruction[2] or not instruction[3] then
				if (isDebug) then
					print(instruction[4].." : "..instruction[1].." : Let out a NIL")
				end
				instruction[2] = instruction[2] or "0"
				instruction[3] = instruction[3] or "0"
			end
			-- Continue writing out if compilation successful
			output[#output+1] = instruction[1]
			output[#output+1] = self:resolveParameter(instruction[2], self:getParamtype(instruction[2]))
			output[#output+1] = self:resolveParameter(instruction[3], self:getParamtype(instruction[3]))
		end
	end

	-- Turn data array into text
	return self:blockOfData(table.unpack(output)).."\n\nLength: "..#output;
end
---Does a first run through of the given file, and builds the starting
---instruction set. This is just a list of `instructionObj`'s.
---@param filename string
---@param isDebug boolean?
---@return instructionObj[]
---@nodiscard
function Compiler:create_insts(filename, isDebug)
	local output = {}
	local lineNum = 0
	for line in io.lines(filename) do
		lineNum = lineNum + 1
		-- Remove tabs and capitalize
		output[#output+1] = self:readLine(line, #output+1, lineNum, isDebug)
	end
	return output
end
---This reads an individual line and returns an instructionObj
---@param line string
---@param instNum integer
---@param lineNum integer
---@param isDebug boolean?
---@return instructionObj?
---@nodiscard
function Compiler:readLine(line, instNum, lineNum, isDebug)
	line = line:gsub("\t+", ""):upper();
	local inst,E = line:find("%S+")

	-- If matched word is a key
	if inst and E and Compiler.keys[line:sub(inst,E)] then
		---@type keyFunction
		local newKey = Compiler.keys[line:sub(inst,E)]

		-- Get first param
		---@type integer|string?
		local param1, E = line:find("%S+", E+1)
		if param1 then
			---@diagnostic disable-next-line: param-type-mismatch
			param1 = line:sub(param1, E)
		else
			param1 = ""
		end
		-- Get second param
		-- If param1 is nil, then this should also be nil
		---@type integer|string?
		local param2, E = line:find("%S+", E+1)
		if param2 then
			---@diagnostic disable-next-line: param-type-mismatch
			param2 = line:sub(param2, E)
		else
			param2 = ""
		end

		-- change definitions
		if param1:find(Compiler.parameters.DEFINITION) then
			param1 = self:isDefined(param1, 1, instNum, lineNum, newKey, isDebug)
		end
		if param2:find(Compiler.parameters.DEFINITION) then
			param2 = self:isDefined(param2, 2, instNum, lineNum, newKey, isDebug)
		end
		-- Add key to output
		return newKey(param1,param2,lineNum,instNum);
	end
end
---This will run through the list of undefined words in `self.definitionsUndefined`
---and resolve them through `self.definitionsDefined` again and reconstruct the
---relevent instructins in the passed array
---@param output instructionObj[]
---@param isDebug boolean?
---@return instructionObj[]
function Compiler:defineUndefined(output, isDebug)
	-- Go back and finish those with undefiend definitions
	for k,lines in pairs(self.definitionsUndefined) do
		local value = self.definitionsDefined[k]
		-- Get upset if still not defined
		if not value then
			error(k.." needs to be defined in order to be used at line "..lines[1][2])
		end
		-- reset output with undefiend lines
		for _,line in ipairs(lines) do
			local oldOutput = output[line[1]]
			local params = {oldOutput[2],oldOutput[3]}
			-- Replace params
			params[line[4]] = self.definitionsDefined[k]
			-- Re-initialize instruction
			if (isDebug) then
				print("OldInst: {"..table.concat(oldOutput, ", ").."}")
			end
			output[line[1]] = line[3](params[1], params[2], oldOutput[4])
		end
	end
	return output
end

---Will resolve the type from the first matching pattern in `self.parameters`
---@param param string
---@return string
function Compiler:getParamtype(param)
	param = tostring(param) --HACK: why is this ever a number?
	for k,v in pairs(Compiler.parameters) do
		if param:find(v) then return k end
	end
	error("parameterType cannot be found for "..param)
end
---Will resolve the value based on what type was passed
---@param param string
---@param paramType any
---@return integer
function Compiler:resolveParameter(param, paramType)
	if paramType == "RESULT" or paramType == "DEFINITON" or paramType == "NIL" then
		return 0
	elseif paramType == "VALUE" then
		return tonumber(param) --[[@as integer]]
	else
		return tonumber(param:sub(2)) --[[@as integer]]
	end
end

---Will resolve a definition or add it to `self.definitionsUndefined`
---@param param string
---@param numParam integer
---@param instNum integer
---@param lineNum integer
---@param isDebug boolean?
---@param key fun(param1:string, param1:string, lineNum:integer, instNum:integer): instructionObj
---@return string
function Compiler:isDefined(param, numParam, instNum, lineNum, key, isDebug)
	-- Get definiton without @
	local newParam = self.definitionsDefined[param]
	local undefiend = self.definitionsUndefined[param]
	local undefinedValue = newUndefinition{instNum, lineNum, key, numParam}
	if not newParam then
		if (isDebug) then
			print(lineNum.." : "..param.." is not defined")
		end
		if not undefiend then
			self.definitionsUndefined[param] = {undefinedValue}
		else
			undefiend[#undefiend+1] = undefinedValue
		end
	end
	return newParam or ""
end
---Adds the `key` and `definition` to the definition dictionary
---@param key string
---@param definition string
function Compiler:define(key, definition)
	self.definitionsDefined[key] = definition
end

---Turns all the numbers passed into a block of text
---that can fit in an Exa
---@param ... integer
---@return string
function Compiler:blockOfData(...)
	local output = "";
	local curLine = {}
	local curLineLength = 0
	for _,v in ipairs({...}) do
		curLineLength = curLineLength + 1 + #tostring(v)
		if curLineLength > 20 then 
			output = output..self:lineOfData(table.unpack(curLine)).."\n"
			curLine = {v}
			curLineLength = 1 + #tostring(v)
		else
			curLine[#curLine+1] = v
		end
	end
	return output..self:lineOfData(table.unpack(curLine))
end
---Turns all the numbers passed into a single line of text.
--- @See `Compiler.blockOfData` for a version that
---makes it all fit within an Exa
---@param ... integer
---@return string
function Compiler:lineOfData(...)
	return "DATA "..table.concat({...}, " ")
end