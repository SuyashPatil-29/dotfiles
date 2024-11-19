-- cpp.lua
if vim.bo.filetype == "cpp" then
  local buf = vim.api.nvim_get_current_buf()
  local num_lines = vim.api.nvim_buf_line_count(buf)

  -- Check if the buffer is empty
  if num_lines == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
    local lines = {
      "#include<bits/stdc++.h>",
      "",
      "using namespace std;",
      "",
      "int main(){",
      "  return 0;",
      "}",
    }

    -- Insert the lines at the beginning of the buffer
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
  end
end
