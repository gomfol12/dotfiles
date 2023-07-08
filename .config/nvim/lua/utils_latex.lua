local _M = {}

_M.in_mathzone = function()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
_M.in_text = function()
    return not _M.in_mathzone()
end
_M.in_comment = function()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end
_M.in_env = function(name)
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
_M.in_equation = function()
    return _M.in_env("equation")
end
_M.in_itemize = function()
    return _M.in_env("itemize")
end
_M.in_tikz = function()
    return _M.in_env("tikzpicture")
end

return _M
