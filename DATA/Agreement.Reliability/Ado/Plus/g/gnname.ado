*! version 1.0.0  12jul1995
program define gnname
	version 5.0
	local name "`1'"
	local i 1
	cap confirm var `name'
	while !_rc {
		local name "`1'`i'"
		local i = `i' + 1
		cap confirm var `name'
	}
	global S_1 "`name'"
end
