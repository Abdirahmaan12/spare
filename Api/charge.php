<?php
header("content-type: application/json");
include '../config/conn.php';
// $action = $_POST['action'];

function register_charge($conn)
{
    extract($_POST);
    $data = array();
    $query = "CALL charge_month('$month', '$year', '$description', '$Acount_id', '$users_id')";

    $result = $conn->query($query);


    if ($result) {

        $row = $result->fetch_assoc();
        if ($row['msg'] == 'Deny') {
            $data = array("status" => false, "data" => "Insuficance Balance😜");
        } elseif ($row['msg'] == 'Registered') {
            $data = array("status" => true, "data" => "transaction successfully ✅");
        } elseif ($row['msg'] == 'NOt') {
            $data = array("status" => false, "data" => "Horay Ayaa loogu dalacay lacagta bishaan '$month'❌");
        }
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}

function read_all_charge($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT ch.charge_id,concat(e.frist_name, ' ', e.last_name) as employe_name,ch.Amount, m.month_name,ch.year,ac.bank_name,ch.description,ch.user_id as user, ch.active,ch.date from charge  ch JOIN  employe e on ch.employee_id=e.employee_id JOIN month m on ch.month=m.month_id JOIN account ac on ch.Account_id=ac.Account_id";
    $result = $conn->query($query);


    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $array_data[] = $row;
        }
        $data = array("status" => true, "data" => $array_data);
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}


function read_all_monthes($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT * from month";
    $result = $conn->query($query);


    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $array_data[] = $row;
        }
        $data = array("status" => true, "data" => $array_data);
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}


if (isset($_POST['action'])) {
    $action = $_POST['action'];
    $action($conn);
} else {
    echo json_encode(array("status" => false, "data" => "Action Required....."));
}
