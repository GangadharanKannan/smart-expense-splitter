<?php

require_once "../config/db.php";

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$group_id = $data['group_id'] ?? null;
$paid_by = $data['paid_by'] ?? null;
$title = $data['title'] ?? '';
$amount = $data['amount'] ?? 0;
$members = $data['members'] ?? [];

if(!$group_id || !$paid_by || !$title || !$amount || empty($members)){
    echo json_encode([
        "status"=>false,
        "message"=>"All fields required"
    ]);
    exit;
}

$conn->begin_transaction();

try{
    $stmt = $conn->prepare("
        INSERT INTO expenses(group_id, paid_by, title, amount)
        VALUES(?,?,?,?)
    ");

    $stmt->bind_param("iisd",$group_id,$paid_by,$title,$amount);
    $stmt->execute();

    $expense_id = $stmt->insert_id;

    $split_amount = round($amount / count($members), 2);

    $splitStmt = $conn->prepare("
        INSERT INTO expense_splits(expense_id, user_id, amount_owed)
        VALUES(?,?,?)
    ");

    foreach($members as $user_id){
        $splitStmt->bind_param("iid",$expense_id,$user_id,$split_amount);
        $splitStmt->execute();
    }

    $conn->commit();

    echo json_encode([
        "status"=>true,
        "message"=>"Expense added successfully"
    ]);

}catch(Exception $e){

    $conn->rollback();

    echo json_encode([
        "status"=>false,
        "message"=>"Failed to add expense"
    ]);
}