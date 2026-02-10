<?php

require_once "../config/db.php";

header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$name = trim($data['name'] ?? '');
$email = trim($data['email'] ?? '');
$password = trim($data['password'] ?? '');

if(!$name || !$email || !$password){
    echo json_encode([
        "status"=>false,
        "message"=>"All fields are required"
    ]);
    exit();
}

$check = $conn->prepare("SELECT id FROM users WHERE email=?");
$check->bind_param("s",$email);
$check->execute();
$result = $check->get_result();

if($result->num_rows > 0){
    echo json_encode([
        "status"=>false,
        "message"=>"Email already registered"
    ]);
    exit;
}
$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO users(name,email,password) VALUES(?,?,?)");
$stmt->bind_param("sss",$name,$email,$hashedPassword);

if($stmt->execute()){
    echo json_encode([
        "status"=>true,
        "message"=>"User registered successfully"
    ]);
}else{
    echo json_encode([
        "status"=>false,
        "message"=>"Registration failed"
    ]);
}
?>