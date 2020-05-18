local u  = require 'luaunit'
local fmt = require "fmt"

local eq   = u.assertEquals
local fail = u.assertErrorMsgContains

function _G.test_basic()
   eq(fmt("{} {} {}", 1, 2, 3), "1 2 3")
   eq(fmt("{1} {1} {1}", 1), "1 1 1")
   eq(fmt("{{"), "{")
   eq(fmt("}}"), "}")
   eq(fmt("{:}", 1), "1")
   eq(fmt("{a}", {a = 1}), "1")
   eq(fmt("{a[1]}", {a = {1}}), "1")
   eq(fmt("{a[a]}", {a = {a = 1}}), "1")
   eq(fmt("{a[!]}", {a = {["!"] = 1}}), "1") eq(fmt("{a.1}", {a = {1}}), "1")
   eq(fmt("{a.a}", {a = {a = 1}}), "1")
   fail("Single '{' encountered in format string",
      function() fmt "{" end)
   fail("Single '}' encountered in format string",
      function() fmt "}" end)
      fail("expected '}' before end of string",
   --fail("unmatched '{' in format spec",
      function() fmt("{:", 1) end)
   fail("argument index out of range",
      function() fmt("{0", 1) end)
   fail("expected '}' before end of string",
      function() fmt("{1", 1) end)
   fail("Format specifier missing precision",
      function() fmt("{:.}", 1) end)
   fail("Invalid format specifier: 'dd}'",
      function() fmt("{:dd}", 1) end)
   fail("unmatched '{' in format spec",
      function() fmt("{:dd", 1) end)
   fail("integer expected for width, got table",
      function() fmt("{:{}}", 1, {}) end)
   fail("unexpected ':' in field name",
      function() fmt("{:{:}}", 1, {}) end)
   fail("unmatched '{' in format spec",
      function() fmt("{:#", 1) end)
   fail("automatic index out of range",
      function() fmt("{} {} {}", 1) end)
   fail("unexpected '!' in field name",
      function() fmt("{!}", 1) end)
   fail("unexpected '!' in field name",
      function() fmt("{a.!}", { a = {} }) end)
   fail("expected '}' before end of string",
      function() fmt("{a[}", { a = {} }) end)
   fail("cannot switch from automatic field numbering to manual field specification",
      function() fmt("{} {1}", 1) end)
   fail("cannot switch from manual field specification to automatic field numbering",
      function() fmt("{1} {}", 1) end)
   fail("Too many decimal digits in format string",
      function() fmt("{:10000000000d}", 1) end)
end

function _G.test_int()
   eq(fmt("{:c}", 12345), '\227\128\185')
   eq(fmt("{:c}", 97), 'a')
   eq(fmt("{:b}", 97), '1100001')
   eq(fmt("{:#b}", 97), '0b1100001')
   eq(fmt("{:#B}", 97), '0B1100001')
   eq(fmt("{:o}", 97), '141')
   eq(fmt("{:#o}", 97), '0o141')
   eq(fmt("{:#O}", 97), '0O141')
   eq(fmt("{:x}", 97), '61')
   eq(fmt("{:#x}", 97), '0x61')
   eq(fmt("{:#X}", 97), '0X61')
   eq(fmt("{:#X}", -100), '-0X64')
   eq(fmt("{:#10X}", -100), '     -0X64')
   eq(fmt("{:#010X}", -100), '-0X0000064')
   eq(fmt("{:+}", 100), "+100")
   eq(fmt("{:+}", -100), "-100")
   eq(fmt("{:-}", 100), "100")
   eq(fmt("{:-}", -100), "-100")
   eq(fmt("{: }", 100), " 100")
   eq(fmt("{: }", -100), "-100")
   eq(fmt("{:0100_}", -100), "-000_000_000_000_000_000_000_000_000_000_"..
      "000_000_000_000_000_000_000_000_000_000_000_000_000_0000100")
   eq(fmt("{:0101_}", -100), "-0_000_000_000_000_000_000_000_000_000_000_"..
      "000_000_000_000_000_000_000_000_000_000_000_000_000_0000100")
   fail("Unknown format code 'z' for object of type 'number'",
      function() fmt("{:z}", 1) end)
   fail("Sign not allowed with integer format specifier 'c'",
      function() fmt("{:+c}", 1) end)
   fail("Alternate form (#) not allowed with integer format specifier 'c'",
      function() fmt("{:#c}", 1) end)
   fail("Zero form (0) not allowed with integer format specifier 'c'",
      function() fmt("{:0c}", 1) end)
   fail("Cannot specify ',' with 'c'",
      function() fmt("{:,c}", 1) end)
   fail("'c' arg not in range(2147483647)",
      function() fmt("{:c}", -1) end)
end

function _G.test_flt()
   if _VERSION >= "Lua 5.3" then
      eq(fmt("{}", 1.0), "1.0")
   end
   eq(fmt("{}", 1.1), "1.1")
   eq(fmt("{:.10f}", 1.0), "1.0000000000")
   eq(fmt("{:010.1f}", 1.0), "00000001.0")
   eq(fmt("{:%}", 1.0), "100.0%")
   fail("precision specifier too large",
      function() fmt("{:.100}", 1.1) end)
   fail("Grouping form (_) not allowed in float format specifier",
      function() fmt("{:_}", 1.1) end)
end

function _G.test_string()
   eq(fmt("{}", "foo"), "foo")
   eq(fmt("{:-<10}", "foo"), "-------foo")
   eq(fmt("{:->10}", "foo"), "foo-------")
   eq(fmt("{:-^10}", "foo"), "---foo----")
   eq(fmt("{:s<10000}", ""), ("s"):rep(10000))
   eq(fmt("{:<10000}", ""), (" "):rep(10000))
   eq(fmt("{:{}}", "", 10), (" "):rep(10))
   eq(fmt("{:{}.{}}", "abc", 10, 1), "         a")
   fail("Unknown format code 'x' for object of type 'string'",
      function() fmt("{:x}", "") end)
   fail("Sign not allowed in string format specifier",
      function() fmt("{:+}", "") end)
   fail("Alternate form (#) not allowed in string format specifier",
      function() fmt("{:#}", "") end)
   fail("Zero form (0) not allowed in string format specifier",
      function() fmt("{:0}", "") end)
   fail("Grouping form (_) not allowed in string format specifier",
      function() fmt("{:_}", "") end)
end

function _G.test_other()
   eq(fmt("{}", nil), "nil")
   eq(fmt("{}", true), "true")
   eq(fmt("{}", false), "false")
   fail("Unknown format code 'p' for object of type 'nil'",
      function() fmt("{:p}", nil) end)
   local t = {}
   local ts = tostring(t):match "table: (%w+)"
   eq(fmt("{}", t), tostring(t))
   eq(fmt("{:p}", t), ts)

   local t1 = setmetatable({}, {__tostring = function() return "foo" end})
   local t2 = setmetatable({}, {__tostring = function() return {} end})
   eq(fmt("{}", t1), "foo")
   if _VERSION ~= "Lua 5.2" then
      fail("'__tostring' must return a string",
      function() fmt("{}", t2) end)
   end
end

if _VERSION == "Lua 5.1" and not _G.jit then
   u.LuaUnit.run()
else
   os.exit(u.LuaUnit.run(), true)
end

-- cc: run='rm -f *.gcda; time lua test.lua; gcov lfmt.c'
