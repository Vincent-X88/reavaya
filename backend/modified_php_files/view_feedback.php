<?php
include '../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $startDate = $_GET['startDate'];
    $endDate = $_GET['endDate'];

    $sqlQuery = "SELECT * FROM feedback_table WHERE timesent BETWEEN ? AND ? ORDER BY timesent DESC";
    $stmt = $connectNow->prepare($sqlQuery);
    $stmt->bind_param("ss", $startDate, $endDate);
    $stmt->execute();
    $queryResponse = $stmt->get_result();

    if ($queryResponse) {
        $feedbackData = array();
        while ($row = $queryResponse->fetch_assoc()) {
            $feedbackData[] = array(
                'Buscode' => $row['buscode'],
                'Cleanliness' => $row['cleanliness'],
                'Driver' => $row['driver'],
                'Comments' => $row['comments'],
                'TimeSent' => $row['timesent'],
            );
        }

        echo json_encode(array("feedbackData" => $feedbackData));
    } else {
        echo json_encode(array("feedbackData" => array()));
    }
} else {
    http_response_code(405);
    $response = array('message' => 'Unsupported request method');
    echo json_encode($response);
}

$connectNow->close();
?>
