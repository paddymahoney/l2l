local utils = require("leftry").utils

local vector = utils.prototype("vector", function(vector, ...)
  return setmetatable({n=select("#", ...), ...}, vector)
end)

function vector:insert(value)
  self.n = self.n + 1
  self[self.n] = value
  return self
end

function vector:next(i)
  if i < self.n then
    return i + 1, self[i + 1]
  end
end

function vector:__ipairs()
  return vector.next, self, 0
end

function vector:__tostring()
  local text = {}
  for i=1, self.n do
    if type(self[i]) == "string" then
      text[i] = utils.escape(self[i])
    else
      text[i] = tostring(self[i])
    end
  end
  return "vector.cast({n="..self.n..","..table.concat(text, ",").."})"
end

function vector.sub(t, from, to)
  to = to or #t
  from = from or 1
  return vector.cast(t, function(i)
    return i >= from and i <= to
  end)
end

function vector.cast(t, f, g)
  if not t then
    return setmetatable({n=0}, vector)
  end
  local u = setmetatable({}, vector)
  local n = 0
  for i, v in ipairs(t) do
    if not g or g(i, v) then
      n = n + 1
      if f then
        u[i] = f(v, i)
      else
        u[i] = v
      end
    end
  end
  u.n = n
  return u
end

function vector:__len()
  return self.n or #self
end

return vector
