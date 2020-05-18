package = "lua-fmt"
version = "scm-1"

source = {
  url = "git://github.com/starwing/lua-fmt.git",
}

description = {
  summary = "A fmtlib implement for Lua",
  detailed = [[
A simple C module for Lua to format string.
  ]],
  homepage = "https://github.com/starwing/lua-fmt",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    fmt = "lfmt.c";
  }
}

