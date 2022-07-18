<?php
    error_reporting( E_ALL );
    ini_set( "display_errors", 1 );
    $mysql_host = ".";
    $mysql_user = ".";
    $mysql_pw = ".";
    $mysql_dbName = ".";
    $mysql_charset = 'UTF8';

    $conn = new mysqli($mysql_host, $mysql_user, $mysql_pw, $mysql_dbName);

$userid = $_GET['userid'];
$pw = $_GET['pw'];
$nickname = $_GET['nickname'];
$phone_number = $_GET['phone_number'];
$profile_intro = $_GET['profile_intro'];

$sql = "INSERT INTO account (user_id, pw, nickname,phone_number,profile_intro)
VALUE ('$userid', '$pw','$nickname','$phone_number','$profile_intro')";

if ($conn->query($sql)){
    echo 'Insert New Record';
} else {
    echo $conn->error;
}
$conn->close();
?>
