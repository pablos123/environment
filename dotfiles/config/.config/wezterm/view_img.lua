local M = {}

local function show_image(file_name)
    return "wezterm imgcat /tmp/" .. file_name .. "; "
end

local function print_image_url(image_url)
    return "echo '" .. image_url .. "'; "
end

local function wait_for_user_input()
    return "" ..
        "input='thisisnotnull'; " ..
        "while [[ ! $input == 'q' ]] && [[ ! $input == '' ]] && [[ ! $input == $'\\e' ]]; " ..
        "do read -s -n 1 input; " ..
        "done"
end

local function get_extension(image_url)
    return string.sub(image_url, string.len(image_url) - 3)
end

local function get_file_name(image_url)
    local file_name = image_url
    local chars_to_replace = { "/", "-", ":", " ", "%.", "%(", "%)" }
    for _, char in ipairs(chars_to_replace) do
        file_name = string.gsub(file_name, char, "_")
    end
    local extension = get_extension(image_url)
    if extension == "webp" then
        extension = ".png"
    end
    return file_name .. extension
end

local function cache_image(image_url, file_name)
    local command = "wget -O /tmp/" .. file_name .. " '" .. image_url .. "'"
    if get_extension(image_url) == "webp" then
        command = "wget -O /tmp/wezterm_temporal.webp '" .. image_url ..
            "' && convert /tmp/wezterm_temporal.webp /tmp/" .. file_name
    end
    os.execute(command)
end

local function is_cached(file_name)
    local file = io.open("/tmp/" .. file_name)
    if file == nil then
        return false
    end
    io.close(file)
    return true
end

local function view_img(window, pane)
    local image_url = window:get_selection_text_for_pane(pane)
    local file_name = get_file_name(image_url)
    local cached = " (cached)"
    if not is_cached(file_name) then
        cache_image(image_url, file_name)
        cached = " (!cached)"
    end
    pane:split { args = { '/bin/bash', '-c', show_image(file_name) ..
    print_image_url(image_url .. cached) .. wait_for_user_input() } }
end

M.view_img = view_img

return M
