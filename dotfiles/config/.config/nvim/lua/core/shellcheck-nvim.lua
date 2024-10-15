local function get_nvim_severity(shellcheck_severity)
    local severity_table = {
        ["style"] = vim.diagnostic.severity.HINT,
        ["info"] =  vim.diagnostic.severity.INFO,
        ["warning"] = vim.diagnostic.severity.WARN,
        ["error"] =  vim.diagnostic.severity.ERROR,
    }
    return severity_table[shellcheck_severity]
end

local function get_shellcheck_output(file_path)
    local fileh = assert(io.popen("shellcheck --color=never -f json " .. file_path))
    local output = assert(fileh:read("*a"))
    fileh:close()
    output = output.gsub(output, "\n", "")
    return output
end

local function parse_shellcheck_output(shellcheck_output, buffern)
    local diagnostics_table = {}
    for _, sc_diag in ipairs(shellcheck_output) do
        local diagnostic = {
          bufnr = buffern,
          lnum = sc_diag.line - 1,
          end_lnum = sc_diag.endLine - 1,
          col = sc_diag.column - 1,
          end_col = sc_diag.endColumn - 1,
          message = sc_diag.message,
          code = "https://www.shellcheck.net/wiki/SC" .. sc_diag.code,
          severity = get_nvim_severity(sc_diag.level),
          source = "shellcheck-nvim",
        }
        table.insert(diagnostics_table, diagnostic)
    end
    return diagnostics_table
end

local function set_shellcheck_diagnostics()
    local file_path = vim.api.nvim_buf_get_name(0)
    if file_path == "" then return end

    local shellcheck_namespace = vim.api.nvim_create_namespace("shellcheck-nvim")
    local shellcheck_output = vim.fn.json_decode(get_shellcheck_output(file_path))

    local buffern = vim.api.nvim_get_current_buf()
    local diagnostics_table = parse_shellcheck_output(shellcheck_output, buffern)
    vim.diagnostic.set(shellcheck_namespace, buffern, diagnostics_table, {})
end

local shellcheck_autogroup = vim.api.nvim_create_augroup("shellcheck-nvim", {})
vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    pattern = "*",
    callback = function() if vim.bo.filetype == "sh" then set_shellcheck_diagnostics() end end,
    group = shellcheck_autogroup
})

vim.api.nvim_create_user_command("RunShellCheck", function() set_shellcheck_diagnostics() end, {})
