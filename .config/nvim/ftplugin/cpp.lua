-- cpp.lua
if vim.bo.filetype == "cpp" then
  local buf = vim.api.nvim_get_current_buf()
  local num_lines = vim.api.nvim_buf_line_count(buf)

  -- Check if the buffer is empty
  if num_lines == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == "" then
    local lines = {
      "#include \"/usr/local/include/bits/stdc++.h\"",
      "",
      "using namespace std;",
      "",
      "bool comp(vector<int> v1, vector<int> v2) {",
      "if (v2 > v1) {",
      "return true;",
      "}",
      "return false;",
      "}",
      "",
      "int main(){",
      "  ios_base::sync_with_stdio(false);",
      "  cin.tie(NULL);",
      "  cout.tie(NULL);",
      "",
      "  return 0;",
      "}",
    }

    -- Insert the lines at the beginning of the buffer
    vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
  end
end
