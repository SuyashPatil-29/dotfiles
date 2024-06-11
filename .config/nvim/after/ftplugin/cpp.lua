local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("cpp", {
  s("arr", {
    t "vector<int> arr = {};",
    t { "", "" }, -- This will insert a newline without moving the cursor
    t "int n = arr.size();",
  }),
})

ls.add_snippets("cpp", {
  s("hello", {
    t 'cout << "Hello, World!" << endl;',
  }),
})
