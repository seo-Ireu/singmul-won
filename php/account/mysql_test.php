<?php
    error_reporting( E_ALL );
    ini_set( "display_errors", 1 );
    $mysql_host = ".";
    $mysql_user = ".";
    $mysql_pw = ".";
    $mysql_dbName = ".";
    $mysql_charset = 'UTF8';

    $conn = new mysqli($mysql_host, $mysql_user, $mysql_pw, $mysql_dbName);

    /* DB 연결 확인 */
    if($conn->connect_errno){ echo "Connection established"."<br>"; }
    $sql = "SELECT * FROM account";
    $result = mysqli_query($conn, $sql);
    while($row = $result->fetch_array(MYSQLI_ASSOC)){
        $results[]= $row;
    }
    header('Content-type: application/json');
    echo json_encode($results, JSON_NUMERIC_CHECK);

    mysqli_close($conn);
?>
