<?php
include '../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['manager_id']) && is_numeric($_GET['manager_id'])) {
        $manager_id = (int)$_GET['manager_id'];
		$startDate = $_GET['startDate'];
		$endDate = $_GET['endDate'];
        
        $sqlQuery = "SELECT * FROM notification_table WHERE manager_id = ? AND timesent BETWEEN ? AND ? ORDER BY timesent DESC";
        $stmt = $connectNow->prepare($sqlQuery);
        $stmt->bind_param("iss", $manager_id, $startDate, $endDate);
        $stmt->execute();
        $queryResponse = $stmt->get_result();
        
        if ($queryResponse) {
            $notificationsData = array();
            while ($row = $queryResponse->fetch_assoc()) {
                $notificationsData[] = array(
                    'TimeSent' => $row['timesent'],
                    'Title' => $row['title'],
                    'Notice' => $row['notice'],
                );
            }
            
            echo json_encode(array("notificationsData" => $notificationsData));
        } else {
            echo json_encode(array("notificationsData" => array()));
        }
    } else {
        http_response_code(400);
        $response = array('message' => 'Invalid or missing manager_id');
        echo json_encode($response);
    }
} else {
    http_response_code(405);
    $response = array('message' => 'Unsupported request method');
    echo json_encode($response);
}

$connectNow->close();
?>

