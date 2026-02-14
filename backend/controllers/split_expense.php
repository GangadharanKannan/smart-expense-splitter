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



$query = $conn->prepare("
SELECT 
    u.id,
    u.name,

    IFNULL(paid.total_paid,0) as total_paid,
    IFNULL(owed.total_owed,0) as total_owed,

    (IFNULL(paid.total_paid,0) - IFNULL(owed.total_owed,0)) as balance

FROM group_members gm

JOIN users u 
ON u.id = gm.user_id


LEFT JOIN (
    SELECT paid_by, SUM(amount) as total_paid
    FROM expenses
    WHERE group_id = ?
    GROUP BY paid_by
) paid
ON paid.paid_by = u.id


LEFT JOIN (
    SELECT es.user_id, SUM(es.amount_owed) as total_owed
    FROM expense_splits es
    JOIN expenses e ON e.id = es.expense_id
    WHERE e.group_id = ?
    GROUP BY es.user_id
) owed
ON owed.user_id = u.id

WHERE gm.group_id = ?

ORDER BY balance DESC
");

$query->bind_param("iii",$group_id,$group_id,$group_id);
$query->execute();

$result = $query->get_result();

$balances = [];

while($row = $result->fetch_assoc()){
    $balances[] = $row;
}

echo json_encode([
    "status"=>true,
    "balances"=>$balances
]);