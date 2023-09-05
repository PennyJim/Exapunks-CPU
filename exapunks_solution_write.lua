require("exapunks_solution")

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