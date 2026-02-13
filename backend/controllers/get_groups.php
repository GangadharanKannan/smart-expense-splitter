<?php

require_once "../config/db.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

$user_id = $_GET['user_id'] ?? '';

if(!$user_id){
    echo json_encode([
        "status"=>false,
        "message"=>"User ID required"
    ]);
    exit;
}

$stmt = $conn->prepare("
    SELECT g.id, g.group_name, g.created_at
    FROM groups g
    JOIN group_members gm ON g.id = gm.group_id
    WHERE gm.user_id = ?
    ORDER BY g.created_at DESC
");

$stmt->bind_param("i",$user_id);
$stmt->execute();

$result = $stmt->get_result();

$groups = [];

while($row = $result->fetch_assoc()){
    $groups[] = $row;
}

echo json_encode([
    "status"=>true,
    "groups"=>$groups
]);

?>
