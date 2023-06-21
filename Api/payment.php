<?php
header("content-type: application/json");
include '../config/conn.php';
// $action = $_POST['action'];


function register_payment($conn)
{
    extract($_POST);
    $data = array();
    $query = "INSERT INTO payment(customer_id, amount, Account_id, p_method_id)
     values('$customer', '$amount','$Accountt_id', '$p_method_id')";

    $result = $conn->query($query);


    if ($result) {


        $data = array("status" => true, "data" => "successfully Registered 😂😊😒😎");
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}

function read_customer_amount($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "CALL read_amount('$customer')";
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

function read_customer_order($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT c.customer_id, concat(c.frist_name,' ',c.last_name) AS customer_name FROM orders o JOIN customers c ON o.customer_id=c.customer_id WHERE status='pending'";
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



function read_all_payment_statement($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "CALL payment_statement('$tellphone')";
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

function read_all_payment($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT p.payment_id,concat(c.frist_name, ' ', c.last_name) as customer_name,p.amount, ac.bank_name,pm.name as method,p.date from payment p JOIN customers c on p.customer_id=c.customer_id JOIN account ac on p.account_id=ac.Account_id JOIN payment_method pm on p.p_method_id=pm.p_method_id";
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




// function update_payment($conn)
// {
//     extract($_POST);

//     $data = array();

//     $query = "UPDATE payment set customer_id = '$customer_idd', amount = '$amount', Account_id = '$Account_id', p_method_id = '$p_method_id' WHERE payment_id= '$payment_id'";

//     $result = $conn->query($query);


//     if ($result) {

//         $data = array("status" => true, "data" => "successfully updated 😂😊😒😎");
//     } else {
//         $data = array("status" => false, "data" => $conn->error);
//     }

//     echo json_encode($data);
// }


// function Delete_payment($conn){
//     extract($_POST);
//     $data = array();
//     $array_data = array();
//    $query ="DELETE FROM payment where payment_id= '$payment_id'";
//     $result = $conn->query($query);


//     if($result){


//         $data = array("status" => true, "data" => "successfully Deleted😎");


//     }else{
//         $data = array("status" => false, "data"=> $conn->error);

//     }

//     echo json_encode($data);
// }

if (isset($_POST['action'])) {
    $action = $_POST['action'];
    $action($conn);
} else {
    echo json_encode(array("status" => false, "data" => "Action Required....."));
}
