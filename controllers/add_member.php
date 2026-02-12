<?php

require_once "../config/db.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); 
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$group_id = $data['group_id'] ?? '';
$email = trim($data['email'] ?? '');

if(!$group_id || !$email){
    echo json_encode([
        "status"=>false,
        "message"=>"Group ID and member email required"
    ]);
    exit;
}

$userStmt = $conn-> prepare('SELECT id, name FROM users WHERE email=?');
$userStmt->bind_param("s", $email);
$userStmt->execute();
$userResult = $userStmt->get_result();

if($userResult->num_rows === 0){
    echo json_encode([
        "status"=>false,
        "message"=>"User not registered"
    ]);
    exit;
}

$user = $userResult->fetch_assoc();
$user_id = $user['id'];

$checkStmt = $conn->prepare(
    "SELECT id FROM group_members WHERE group_id=? AND user_id=?"
);
$checkStmt->bind_param("ii", $group_id, $user_id);
$checkStmt->execute();

if($checkStmt->get_result()->num_rows > 0){
    echo json_encode([
        "status"=>false,
        "message"=>"User already in group"
    ]);
    exit;
}

$addStmt = $conn->prepare(
    "INSERT INTO group_members(group_id, user_id) VALUES(?,?)"
);
$addStmt->bind_param("ii", $group_id, $user_id);

if($addStmt->execute()){
    echo json_encode([
        "status"=>true,
        "message"=>"Member added successfully",
        "member"=>[
            "id"=>$user_id,
            "name"=>$user['name'],
            "email"=>$email
        ]
    ]);
}else{
    echo json_encode([
        "status"=>false,
        "message"=>"Failed to add member"
    ]);
}

?>