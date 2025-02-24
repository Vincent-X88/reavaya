<?php
include '../connection.php';

$userId = $_GET['user_id'];

if (!isset($userId)) {
    $response = [
        'success' => false,
        'message' => 'User ID not provided'
    ];
} else {
    $query = "SELECT points_balance FROM users_table WHERE user_id = ? AND is_active = 1";
    $stmt = mysqli_prepare($connectNow, $query);
    mysqli_stmt_bind_param($stmt, "i", $userId);
      
    $result = mysqli_stmt_execute($stmt);

    if ($result) {
        mysqli_stmt_bind_result($stmt, $pointsBalance);

        mysqli_stmt_fetch($stmt);

        $response = [
            'success' => true,
            'points_balance' => $pointsBalance
        ];
    } else {
        $response = [
            'success' => false,
            'message' => 'Failed to fetch points balance'
        ];
    }

    mysqli_stmt_close($stmt);
}

mysqli_close($connectNow);

header('Content-Type: application/json');
echo json_encode($response);
?>
