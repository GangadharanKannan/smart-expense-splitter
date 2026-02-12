<?php

require_once "../config/db.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); 
header("Content-Type: application/json");

$group_id = $_GET['group_id'] ?? null;

if(!$group_id){
    echo json_encode([
        "status"=>false,
        "message"=>"Group id required"
    ]);
    exit;
}

$stmt = $conn->prepare("
    SELECT 
        e.id,
        e.title,
        e.amount,
        e.paid_by as paid_by_id,
        u.name as paid_by,
        e.created_at
    FROM expenses e
    JOIN users u ON u.id = e.paid_by
    WHERE e.group_id = ?
    ORDER BY e.created_at DESC
");

$stmt->bind_param("i",$group_id);
$stmt->execute();

$result = $stmt->get_result();

$expenses = [];

while($row = $result->fetch_assoc()){
    $expenses[] = $row;
}

if(empty($expenses)){
   echo json_encode([
    "status"=>true,
    "expenses"=>[]
   ]); 
   exit;
}

echo json_encode([
    "status"=>true,
    "expenses"=>$expenses
]);