#!/usr/bin/env bash
set -Eeuo pipefail

# Source shared utilities
source "${HOME}/environment/lib/helpers.bash"

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
log "Creating web app launchers"
for APP_NAME in "${!WEB_APPS[@]}"; do
    APP_URL="${WEB_APPS[${APP_NAME}]}"
    APP_INSTANCE=$(echo "${APP_URL}" | sed --regexp-extended 's/^https:\/\/([a-zA-Z.]+).*/\1/')
    APP_EXEC="${HOME}/bin/${APP_NAME}"

    cat > "${APP_EXEC}" <<EOF
#!/usr/bin/env bash

mapfile -t chrome_window_ids < <(xdotool search --class "Google-chrome")
for id in "\${chrome_window_ids[@]}"; do
    instance_name="\$(xprop -id "\${id}" | grep WM_CLASS | awk '{ print \$3 }' | tr --delete ' \n",')"
    [[ "${APP_INSTANCE}" == "\${instance_name}" ]] &&
        exit 0
done

chrome --app="${APP_URL}"
EOF

    chmod +x "${APP_EXEC}" || true
done
