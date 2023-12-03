local M = {}
local function open_url(window, pane)
    local url = window:get_selection_text_for_pane(pane)
    os.execute("chrome " .. url)
end

local function view_img(window, pane)
    local image_url = window:get_selection_text_for_pane(pane)
    os.execute("wget -O /tmp/wezterm_img '" .. image_url .. "' && convert /tmp/wezterm_img /tmp/wezterm_img.png")
    local print_image_url = ";echo '" .. image_url .. "'"
    local wait_for_user_input = "; input=':)'; while [[ ! $input == 'q' ]]" ..
        " && [[ ! $input == '' ]] && [[ ! $input == $'\\e' ]]; do read -s -n 1 input; done"
    pane:split { args = { '/bin/bash', '-c',
        'wezterm imgcat /tmp/wezterm_img.png' .. print_image_url .. wait_for_user_input } }
end

M.open_url = open_url
M.view_img = view_img

return M
