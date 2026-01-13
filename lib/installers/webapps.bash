#!/usr/bin/env bash
# --------------------------------------------------
# NOTE:
# This file is intended to be SOURCED, not executed.
# Must be compatible with set -Eeuo pipefail.
# --------------------------------------------------

# Create web apps executables.

declare -rA WEB_APPS=(
    ["whatsapp"]="https://web.whatsapp.com/"
    ["discord"]="https://discord.com/channels/@me"
    ["telegram"]="https://web.telegram.org/a/"
    ["spotify"]="https://open.spotify.com/"
    ["skype"]="https://web.skype.com/"
    ["excalidraw"]="https://excalidraw.com/"
    ["chatgpt"]="https://chatgpt.com/"
    ["teams"]="https://teams.live.com/v2"
    ["tidal"]="https://tidal.com/"
    ["gmail"]="https://mail.google.com/mail/u/0/"
    ["desmos"]="https://www.desmos.com/calculator"
)

# --------------------------------------------------
# Create web app launchers
# --------------------------------------------------
for app_name in "${!WEB_APPS[@]}"; do
    app_url="${WEB_APPS[${app_name}]}"
    app_instance=$(echo "${app_url}" | sed --regexp-extended 's/^https:\/\/([a-zA-Z.]+).*/\1/')
    app_exec="${HOME}/bin/${app_name}"

    cat > "${app_exec}" <<EOF
#!/usr/bin/env bash

mapfile -t chrome_window_ids < <(xdotool search --class "Google-chrome")
for id in "\${chrome_window_ids[@]}"; do
    instance_name="\$(xprop -id "\${id}" | grep -- WM_CLASS | awk '{ print \$3 }' | tr --delete ' \n",')"
    [[ "${app_instance}" == "\${instance_name}" ]] &&
        exit 0
done

chrome --app="${app_url}"
EOF

    chmod +x "${app_exec}" || true
done

# Note: WEB_APPS is readonly and cannot be unset
unset app_name app_url app_instance app_exec
