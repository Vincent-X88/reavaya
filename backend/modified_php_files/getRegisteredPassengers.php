<?php
include '../connection.php';

$response = array();

$sqlQuery = "SELECT COUNT(*) AS registered_passengers FROM users_table WHERE is_active = 1";

$queryResponse = $connectNow->query($sqlQuery);

if ($queryResponse->num_rows > 0) {
    $rowFound = $queryResponse->fetch_assoc();
    $registeredPassengersCount = $rowFound['registered_passengers'];
    $response['success'] = true;
    $response['count'] = $registeredPassengersCount;
} else {
    $response['success'] = false;
}

echo json_encode($response);

$connectNow->close();
?>
