<?php
include '../connection.php';

$response = array();

if (isset($_GET['startDate']) && isset($_GET['endDate'])) {
    $startDate = $_GET['startDate'];
    $endDate = $_GET['endDate'];

    $sqlQuery = "SELECT COUNT(*) AS login_count FROM users_table WHERE last_login >= '$startDate' AND last_login <= '$endDate' AND is_active = 1";
    
    $queryResponse = $connectNow->query($sqlQuery);

    if ($queryResponse->num_rows > 0) {
        $rowFound = $queryResponse->fetch_assoc();
        $loginCount = $rowFound['login_count'];
        $response['success'] = true;
        $response['count'] = $loginCount;
    } else {
        $response['success'] = false;
    }
} else {
    $response['success'] = false;
    $response['message'] = 'Please provide valid start and end dates.';
}

echo json_encode($response);

$connectNow->close();
