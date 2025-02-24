<?php
include '../connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $user_id = $_GET['user_id'];
    
    $select_query = "SELECT * FROM users_table WHERE user_id = ? & is_active = 1";
    
    $stmt = $connectNow->prepare($select_query);
    
    if ($stmt) {
        $stmt->bind_param("i", $user_id);
        
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            
            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                
                $user_info = array(
                    'name' => $row['name'],
                    'surname' => $row['surname'],
                    'email' => $row['email'],
                    'phoneNo' => $row['phoneNo'],
                    'age' => $row['age']
                );
                
                echo json_encode($user_info);
            } else {
                echo json_encode(array("message" => "User not found"));
            }
        } else {
            echo json_encode(array("message" => "Database query failed"));
        }
        
        $stmt->close();
    } else {
        echo json_encode(array("message" => "Database query preparation failed"));
    }
} else {
    echo json_encode(array("message" => "Invalid request method"));
}

$connectNow->close();
?>
