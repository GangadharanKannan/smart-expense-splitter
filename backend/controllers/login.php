<?php

require_once "../config/db.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$email = trim($data['email'] ?? '');
$password = trim($data['password'] ?? '');

if(!$email || !$password){
    echo json_encode([
        "status" => false,
        "message"=>"Email and password are required"
    ]);
    exit;
}

$check = $conn->prepare("SELECT id, name, email, password FROM users WHERE email=?");
$check->bind_param("s", $email);
$check-> execute();
$result = $check->get_result();

if($result->num_rows === 0){
    echo json_encode([
        "status"=>false,
        "message"=>"Invalid email or password"
    ]);
    exit;
}

$user = $result->fetch_assoc();

if(!password_verify($password, $user['password'])){
    echo json_encode([
        "status"=>false,
        "message"=>"Invalid email or password"
    ]);
    exit;
}

unset($user['password']);

echo json_encode([
    "status"=>true,
    "message"=>"Login successful",
    "user"=>$user
]);

