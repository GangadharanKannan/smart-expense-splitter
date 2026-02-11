<?php

require_once "../config/db.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$group_name = trim($data['group_name'] ?? '');
$created_by = $data['created_by'] ?? '';

if(!$group_name || !$created_by){
    echo json_encode([
        "status"=>false,
        "message"=>"Group name and creator required"
    ]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO groups(group_name, created_by) VALUES(?,?)");
$stmt->bind_param("si", $group_name, $created_by);

if(!$stmt->execute()){
    echo json_encode([
        "status"=>false,
        "message"=>"Failed to create group"
    ]);
    exit;
}

$group_id = $stmt->insert_id;

$memberStmt = $conn->prepare("INSERT INTO group_members(group_id, user_id) VALUES(?,?)");
$memberStmt->bind_param("ii", $group_id, $created_by);
$memberStmt->execute();

echo json_encode([
    "status"=>true,
    "message"=>"Group created successfully",
    "group_id"=>$group_id
]);

?>