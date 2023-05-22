# Zap Appimage PM (requires jq)
REQUIRE_CMD "jq" || {
    printf "%b\n" "Aborting 'zap' install. Dependency required: 'jq'."
    exit 1
}

bash -s <(curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh)
