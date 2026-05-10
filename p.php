<?php
if(isset($_POST['i'])){
    $img=str_replace('data:image/jpeg;base64,','',$_POST['i']);
    $img=str_replace(' ','+',$img);
    file_put_contents('SCAN_'.date('His').'.jpg', base64_decode($img));
}
?>
