---@diagnostic disable: unreachable-code, undefined-global
--
-- Adapted from http://lua-users.org/wiki/ObjectOrientationTutorial
--
-- The "class" function is called with one or more tables that specify the base
-- classes.
--
-- If the user provides an "_init" method, this will be used as the class
-- constructor.
--
-- Each class also provides Python-style properties, which are implemented as
-- tables that provide a "get" and "set" method.
--

---@class Class
local Class = {}

function Class.class(...)
    -- "cls" is the new class
    local cls, bases = {}, {...}

    -- Copy base class contents into the new class
    for _, base in ipairs(bases) do
        for k, v in pairs(base) do
            cls[k] = v
        end
    end

    -- Class also provides Python-style properties. These are implemented as
    -- tables with a "get" and "set" method
    cls.property = {}

    function cls:__index(key)
        local property = cls.property[key]

        if property then
            return property.get(self)
        else
            return cls[key]
        end

        return member
    end

    function cls:__newindex(key, value)
        local property = cls.property[key]

        if property then
            return property.set(self, value)
        else
            return rawset(self, key, value)
        end
    end

    -- Start filling an "is_a" table that contains this class and all of its
    -- bases so you can do an "instance of" check using
    -- my_instance.is_a[MyClass]
    cls.is_a = { [cls] = true }
    for i, base in ipairs(bases) do
        for c in pairs(base.is_a) do
            cls.is_a[c] = true
        end
        cls.is_a[base] = true
    end

    -- The class's __call metamethod
    setmetatable(cls, {
        __call = function(c, ...)
            local instance = setmetatable({}, c)
            -- Run the "init" method if it's there
            local init = instance._init
            if init then init(instance, ...) end

            return instance
        end,
        __tostring = function (c)
        	local depth = c.__depth or 1
        	local hasPrinted = c.__hasPrinted or {}
        	local string = "{"
        	for k,v in pairs(c) do
        		if k ~= "__depth" and k ~= "__hasPrinted" --[[and not hasPrinted[v]--]] then
        			local isClass = type(v) == "table" and v.is_a
        			local isClassOrEnum = type(v) == "table" and (v.is_a or v._enums)
		    		if isClassOrEnum and not hasPrinted[v] then
		    			v.__depth = depth+1
		    			v.__hasPrinted = hasPrinted
	    			end

		    		string = string.."\n"..string.rep("\t", depth)..k.." : "

					if isClass and c == v then string = string.."self: recursion"
					elseif hasPrinted[v] then string = string.."already printed as "..hasPrinted[v]
					else string = string..tostring(v) end

					local dontRepeat = {
						userdata = true,
						thread = true,
						table = true}
					dontRepeat["function"] = true

					if dontRepeat[type(v)] then hasPrinted[v] = k end

		    		if isClassOrEnum then
		    			v.__depth = nil
		    			v.__hasPrinted = nil
	    			end
		    	end
        	end
        	return string.."\n"..string.rep("\t",depth-1).."}"
        end
    })

    -- Return the new class table, that's ready to fill with methods
    return cls
end

return Class
