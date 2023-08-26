-- This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild
--
-- This file is compatible with Lua 5.3

local class = require("class")
require("kaitaistruct")
local enum = require("enum")
local str_decode = require("string_decode")

ExapunksSolution = class.class(KaitaiStruct)

ExapunksSolution.WinValueType = enum.Enum {
  cycles = 0,
  size = 1,
  activity = 2,
}

ExapunksSolution.EditorDisplayStatus = enum.Enum {
  unrolled = 0,
  collapsed = 1,
  other = 2,
}

ExapunksSolution.MemoryScope = enum.Enum {
  global = 0,
  local_ = 1,
}

function ExapunksSolution:_init(io, parent, root)
  KaitaiStruct._init(self, io)
  self._parent = parent
  self._root = root or self
  self:_read()
end

function ExapunksSolution:_read()
  self.version = self._io:read_u4le()
  self.file_id = ExapunksSolution.Pstr(self._io, self, self._root)
  self.name = ExapunksSolution.Pstr(self._io, self, self._root)
  self.competition_wins = self._io:read_u4le()
  self.redshift_program_size = self._io:read_u4le()
  self.win_stats_count = self._io:read_u4le()
  self.win_stats = {}
  for i = 0, self.win_stats_count - 1 do
    self.win_stats[i + 1] = ExapunksSolution.WinValuePair(self._io, self, self._root)
  end
  self.exa_instances_count = self._io:read_u4le()
  self.exa_instances = {}
  for i = 0, self.exa_instances_count - 1 do
    self.exa_instances[i + 1] = ExapunksSolution.ExaInstance(self._io, self, self._root)
  end
end


ExapunksSolution.Pstr = class.class(KaitaiStruct)

function ExapunksSolution.Pstr:_init(io, parent, root)
  KaitaiStruct._init(self, io)
  self._parent = parent
  self._root = root or self
  self:_read()
end

function ExapunksSolution.Pstr:_read()
  self.length = self._io:read_u4le()
  self.string = str_decode.decode(self._io:read_bytes(self.length), "ASCII")
end


ExapunksSolution.WinValuePair = class.class(KaitaiStruct)

function ExapunksSolution.WinValuePair:_init(io, parent, root)
  KaitaiStruct._init(self, io)
  self._parent = parent
  self._root = root or self
  self:_read()
end

function ExapunksSolution.WinValuePair:_read()
  self.type = ExapunksSolution.WinValueType(self._io:read_u4le())
  self.value = self._io:read_u4le()
end


ExapunksSolution.ExaInstance = class.class(KaitaiStruct)

function ExapunksSolution.ExaInstance:_init(io, parent, root)
  KaitaiStruct._init(self, io)
  self._parent = parent
  self._root = root or self
  self:_read()
end

function ExapunksSolution.ExaInstance:_read()
  self._unnamed0 = self._io:read_bytes(1)
  if not(self._unnamed0 == "\010") then
    error("not equal, expected " ..  "\010" .. ", but got " .. self._unnamed0)
  end
  self.name = ExapunksSolution.Pstr(self._io, self, self._root)
  self.code = ExapunksSolution.Pstr(self._io, self, self._root)
  self.editor_display_status = ExapunksSolution.EditorDisplayStatus(self._io:read_u1())
  self.memory_scope = ExapunksSolution.MemoryScope(self._io:read_u1())
  self.bitmap = self._io:read_bytes(100)
end

-- This is manually added code. -- TODO: either change language, or move out of generated file.

function ExapunksSolution:_write(outputStream)
  outputStream:write(string.pack("<I4", self.version))
  outputStream:write(string.pack("<s4", self.file_id.string)) --Replace with PB040?
  outputStream:write(string.pack("<s4", self.name.string))
  outputStream:write(string.pack("<I4", self.competition_wins))
  outputStream:write(string.pack("<I4", self.redshift_program_size))
  outputStream:write(string.pack("<I4", self.win_stats_count))
  for i=1,self.win_stats_count,1 do
    self.win_stats[i]:_write(outputStream)
  end
  outputStream:write(string.pack("<I4", self.exa_instances_count))
  for i=1,self.exa_instances_count,1 do
    self.exa_instances[i]:_write(outputStream)
  end
end

function ExapunksSolution.WinValuePair:_write(outputStream)
  outputStream:write(string.pack("<I4", self.type.value, self.value))
end
function ExapunksSolution.ExaInstance:_write(outputStream)
  outputStream:write("\n")
  outputStream:write(string.pack("<s4", self.name.string))
  outputStream:write(string.pack("<s4", self.code.string))
  outputStream:write(string.pack("<I1", self.editor_display_status.value))
  outputStream:write(string.pack("<I1", self.memory_scope.value))
  outputStream:write(self.bitmap)
end

---Save state to a stream
---@param outputStream file*
---@return boolean?
---@return exitcode?
---@return integer?
function ExapunksSolution:save_to(outputStream)
	self:_write(outputStream)
	return outputStream:close()
end
---Save state to a file
---@param filename string
---@return boolean?
---@return exitcode?
---@return integer?
function ExapunksSolution:save_to_file(filename)
	local fileStream, err = io.open(filename, "w")
	if err then return false, err end
	return self:save_to(fileStream --[[@as file*]])
end

---Change code in the exa at index
---@param index integer
---@param filename string
function ExapunksSolution:import_code(index, filename)
  local code = self.exa_instances[index].code
  local isRedshift = self.redshift_program_size > 0
  local keyList = {}
  code.string = ""
  -- Setup Redshift Counting
  if isRedshift then
    self.redshift_program_size = 0
    keyList = {
      "MARK",
      "SEEK",
      "COPY",
      "ADDI",
      "SUBI",
      "MULI",
      "DIVI",
      "SWIZ",
      "JUMP",
      "FJMP",
      "TJMP",
      "VOID",
    }
  end
  -- Loop over lines to remove tabs
  for line in io.lines(filename) do
    -- Count the line if it contains a key
    for _,v in ipairs(keyList) do
      if line:find(v) then self.redshift_program_size = self.redshift_program_size + 1 end
    end
    code.string = code.string..
      line:gsub("^[\t]+", "").."\n"
  end
end