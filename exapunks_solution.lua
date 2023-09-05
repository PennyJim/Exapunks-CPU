-- This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild
--
-- This file is compatible with Lua 5.3

package.path = package.path .. ";./kaitai-runtime/?.lua"
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
}

ExapunksSolution.MemoryScope = enum.Enum {
  global = 0,
  _local = 1,
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


