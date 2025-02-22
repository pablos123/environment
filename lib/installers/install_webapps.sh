#!/usr/bin/env bash
# Create web apps executables.

declare -rA web_apps=(
    ["whatsapp"]="https://web.whatsapp.com/"
    ["discord"]="https://discord.com/channels/@me"
    ["telegram"]="https://web.telegram.org/a/"
    ["spotify"]="https://open.spotify.com/"
)

# 1: name
# 2: url
function create_web_app() {
    local app_url app_name app_exec
    app_name="${1}"
    app_url="${2}"

    app_instance="$(echo "${app_url}" | sed -r 's/^https:\/\/([a-zA-Z.]+).*/\1/')"
    app_exec="${HOME}/bin/${app_name}"

    cat > "${app_exec}" <<EOF
#!/usr/bin/env bash

app_url="${app_url}"
app_instance="${app_instance}"

mapfile -t chrome_window_ids < <(xdotool search --class "Google-chrome" | tr '\n' ' ')
for id in "\${chrome_window_ids[@]}"; do
    instance_name="\$(xprop -id "\${id}" | grep WM_CLASS | awk '{ print $3 }')"
    [[ "\${instance_name}" == "\${app_name}" ]] &&
        exit 0
done

chrome --app="\${app_url}"
EOF

    chmod +x "${app_exec}"
}


for app_name in "${!web_apps[@]}"; do
    create_web_app "${app_name}" "${web_apps["${app_name}"]}"
done

