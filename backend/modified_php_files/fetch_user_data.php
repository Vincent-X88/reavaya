<?php
include '../connection.php';

$query = "SELECT * FROM users_table WHERE is_active = 1";
$result = $connectNow->query($query);

$data = array();
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
$connectNow->close();

?>
