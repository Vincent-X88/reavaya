<?php
// Include necessary database connection code and other configurations
include '../connection.php';

// Check the request method
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Handle notification submission from ASP.NET website

    // Retrieve data from the POST request
    $manager_id = (int)$_POST['manager_id'];
    $title = $_POST['title'];
    $notice = $_POST['notice'];
    //$timesent = $_POST['timesent'];

   // $timesentDT = new DateTime($timesent);
   // $timesentFormatted = $timesentDT->format('Y-m-d H:i:s');
    // Insert the notice into the database
    $query = "INSERT INTO notification_table ( manager_id, title, notice, timesent) VALUES ( ?, ?, ?, NOW())";
    $stmt = $connectNow->prepare($query);
    $stmt->bind_param("iss", $manager_id, $title, $notice);

    if ($stmt->execute()) {
        // Successful insertion
        $response = array('message' => 'Notice added successfully');
        echo json_encode($response);
    } else {
        // Error inserting data
        $response = array('message' => 'Error adding notice');
        echo json_encode($response);
        var_dump($stmt->error);
        
    }

    $stmt->close();
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Handle fetching of notifications for the Flutter app
    
    // Retrieve notices from the database
    $query = "SELECT notification_id, title, notice FROM notification_table ORDER BY timesent DESC"; 
    $result = $connectNow->query($query);
    
    // Initialize an array to store the notices
    $notices = array();
    
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            // Add each notice to the array
            $notices[] = array('id' => $row['notification_id'], 'title' => $row['title'], 'notice' => $row['notice']);
        }
    }
    
    // Return the notices as JSON response
    echo json_encode($notices);
} else {
    // Return an error response for unsupported request methods
    http_response_code(405); // Method Not Allowed
    $response = array('message' => 'Unsupported request method');
    echo json_encode($response);
}

// Close the database connection
$connectNow->close();
?>


