-- Declarative helpers for working with lua associative arrays

return {
  -- Get an array of values from an associative array
  values = function(assoc_array)
    local vs = {}
    for _, v in pairs(assoc_array) do
      table.insert(vs, v)
    end
    return vs
  end
}
