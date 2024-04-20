-- Insert C++ template
_G.insert_cpp_template = function()
  local lines = {
    "#include<bits/stdc++.h>",
    "",
    "using namespace std;",
    "",
    "",
    "int main(){",
    "",
    "  return 0;",
    "}"
  }

  for _, line in ipairs(lines) do
    vim.api.nvim_put({ line }, "l", false, true)
  end
end

vim.api.nvim_set_keymap('n', 'cpp', ':lua insert_cpp_template()<CR>', { noremap = true, silent = true })

