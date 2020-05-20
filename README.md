# lua-fmt - A fmtlib implement for Lua

[![Build Status](https://travis-ci.org/starwing/lua-fmt.svg?branch=master)](https://travis-ci.org/starwing/lua-fmt)[![Coverage Status](https://coveralls.io/repos/github/starwing/lua-fmt/badge.svg?branch=master)](https://coveralls.io/github/starwing/lua-fmt?branch=master)


Lua-fmt is a fmt like simple C module for Lua to format string.

The format syntax is same with
[fmtlib](https://fmt.dev/latest/syntax.html), which is same with
Python's `format` routine.

## Install

The simplest way to install it is using Luarocks:

```shell
luarocks install --server=https://luarocks.org/dev lua-fmt
```

Or, just compile the single C file:

```shell
# Linux
gcc -o lfmt.so -O3 -fPIC -shared lfmt.c
# macOS
gcc -o lfmt.so -O3 -fPIC -shared -undefined dynamic_lookup lfmt.c
# Windows
cl /Fefmt.dll /LD /MT /O2 /DLUA_BUILD_AS_DLL /Ipath/to/lua/include lfmt.c path/to/lua/lib
```

# Example

```lua
local fmt = require "fmt"

-- automatic indexed argument
print(fmt("{} {} {}", 1,2, 3)) --> "1 2 3"

-- manual indexed argument
print(fmt("{2}, {1}", "World", "Hello")) --> "Hello, World"

-- named indexed argument
print(fmt("{name} is {type}", { name = "foo", type = "bar" })) --> "foo is bar"
print(fmt("{t.name} is {t.type}", {t = { name = "foo", type = "bar" }})) --> "foo is bar"

-- format specifier
print(fmt("{:b}", 42)) --> "101010"

```

## Document

Mostly same as [fmtlib](https://fmt.dev/latest/syntax.html).

Format strings contain “replacement fields” surrounded by curly braces
`{}`. Anything that is not contained in braces is considered literal
text, which is copied unchanged to the output. If you need to include
a brace character in the literal text, it can be escaped by doubling:
`{{` and `}}`.

The grammar for a replacement field is as follows:

```
replacement_field ::=  "{" [arg_id] [":" format_spec] "}"
arg_id            ::=  field_name accessor*
field_name        ::=  integer | identifier
accessor          ::=  "." field_name | "[" key_name "]"
key_name          ::=  field_name | <any chars except ']'>*
integer           ::=  digit+
digit             ::=  "0"..."9"
identifier        ::=  id_start id_continue*
id_start          ::=  "a"..."z" | "A"..."Z" | "_"
id_continue       ::=  id_start | digit
```

the mainly difference is the support of accessor, which is supported
by Python but not by fmtlib.

- - -

“Format specifications” are used within replacement fields contained
within a format string to define how individual values are presented.
Each formattable type may define how the format specification is to be
interpreted.

Most built-in types implement the following options for format
specifications, although some of the formatting options are only
supported by the numeric types.

The general form of a standard format specifier is:

```
format_spec ::=  [[fill]align][sign]["#"]["0"][width][grouping]["." precision][type]
fill        ::=  <a character other than '{' or '}'>
align       ::=  "<" | ">" | "^"
sign        ::=  "+" | "-" | " "
width       ::=  integer | "{" [arg_id] "}"
grouping    ::=  "_" | ","
precision   ::=  integer | "{" [arg_id] "}"
type        ::=  int_type | flt_type | str_type
int_type    ::=  "b" | "B" | "d" | "o" | "x" | "X" | "c"
flt_type    ::=  "e" | "E" | "f" | "F" | "g" | "G" | "%"
str_type    ::=  "p" | "s"
```

Differences (all exists in Python):
- add grouping support for int_type: `"{:_}"` e.g. `"10_000"`
- add `"%"` specifier for float type: `"{:%}"` e.g. `"100.0%"`

Lua type vs. type specifiers:
| Lua Type  | Type specifiers    |
| --------- | ------------------ |
| "integer" | `int_type` |
| "float"   | `flt_type` |
| Others    | `str_type` |


