<?php
include '../connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $buscode = $_POST['buscode'];
    $cleanliness = $_POST['cleanliness'];
    $driver = $_POST['driver'];
    $comments = $_POST['comments'];
    
    $insert_query = "INSERT INTO feedback_table (user_id, buscode, cleanliness, driver, comments, timesent) VALUES (?, ?, ?, ?, ?, NOW())";
    
    $stmt = $connectNow->prepare($insert_query);
    
    if ($stmt) {
        $stmt->bind_param("isiis", $user_id, $buscode, $cleanliness, $driver, $comments);
        
        if ($stmt->execute()) {
            $response = array("success" => true);
        } else {
            $response = array("success" => false);
        }
        
        $stmt->close();
    } else {
        $response = array("success" => false);
    }
    
    echo json_encode($response);
} else {
    $response = array("success" => false);
    echo json_encode($response);
}

$connectNow->close();
?>
