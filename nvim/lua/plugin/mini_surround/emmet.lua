-- copy from: https://github.com/atusy/dotfiles/blob/2c646b21f43ab1ef6098fd19f2cf64aa2143d5ea/dot_config/nvim/lua/atusy/parser/emmet.lua#L4

local lpeg = vim.lpeg

local name = (lpeg.P(1) - lpeg.S("#.[>")) ^ 1
local tag = lpeg.Cg(name, "tag")
local id = lpeg.P("#") * name
local cls = lpeg.P(".") * name
local kv = lpeg.P({ "[" * ((1 - lpeg.S("[]")) + lpeg.V(1)) ^ 0 * "]" })
local child = lpeg.P(">") * lpeg.P(1) ^ 1
local attr = lpeg.C(child + kv + id + cls) ^ 0

local kindmap = {
	["."] = "class",
	["#"] = "id",
	["["] = "kv",
	[">"] = "child",
}

local function parse(s)
	local splits = lpeg.match(lpeg.Ct(tag * attr), s)

	if type(splits) ~= "table" then
		return
	end

	local res = {
		tag = splits.tag,
		class = {},
		id = {},
		kv = {},
		child = nil,
	}

	for _, sp in ipairs(splits) do
		local k, v = string.match(sp, "(.)(.*)")
		local kind = kindmap[k]
		if kind == "child" then
			res.child = parse(v)
		else
			if kind == "kv" then
				v = string.gsub(v, "%]$", "")
			end
			table.insert(res[kind], v)
		end
	end

	return res
end

local function opentag(x)
	local res = "<" .. x.tag
	if #x.id > 0 then
		res = res .. ' id="' .. x.id[1] .. '"'
	end
	if #x.class > 0 then
		res = res .. ' class="' .. table.concat(x.class, " ") .. '"'
	end
	if #x.kv > 0 then
		res = res .. " " .. table.concat(x.kv, " ")
	end
	res = res .. ">"
	if x.child then
		res = res .. opentag(x.child)
	end
	return res
end

local function closetag(x)
	local res = ""
	if x.child then
		res = closetag(x.child) .. res
	end
	res = res .. "</" .. x.tag .. ">"
	return res
end

local function totag(x)
	local p = parse(x)
	return { left = opentag(p), right = closetag(p) }
end

return {
	parse = parse,
	totag = totag,
}
