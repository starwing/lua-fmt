package = "lua-fmt"
version = "0.1.0-1"
source = {
   url = "https://github.com/starwing/lua-fmt/archive/refs/tags/0.1.0.tar.gz",
   dir = "lua-fmt-0.1.0"
}
description = {
   summary = "A fmtlib implement for Lua",
   detailed = [[
A simple C module for Lua to format string.
  ]],
   homepage = "https://github.com/starwing/lua-fmt",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      fmt = "lfmt.c"
   }
}
