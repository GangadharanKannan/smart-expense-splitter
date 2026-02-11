<?php

require_once "../config/db.php";

header("Content-Type: application/json");

$group_id = $_GET['group_id'] ?? '';

if(!$group_id){
    echo json_encode([
        "status"=>false,
        "message"=>"Group ID required"
    ]);
    exit;
}

$stmt = $conn->prepare("
    SELECT u.id, u.name, u.email
    FROM users u
    JOIN group_members gm ON u.id = gm.user_id
    WHERE gm.group_id = ?
");

$stmt->bind_param("i",$group_id);
$stmt->execute();

$result = $stmt->get_result();

$members = [];

while($row = $result->fetch_assoc()){
    $members[] = $row;
}

echo json_encode([
    "status"=>true,
    "members"=>$members
]);

?>