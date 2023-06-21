<?php
header("content-type: application/json");
include '../config/conn.php';
// $action = $_POST['action'];

function register_order($conn)
{
    extract($_POST);
    $data = array();
    $query = "INSERT INTO orders (customer_id, item_id,price, quantity, balance)
     values('$customer_id', '$item_id','$price', '$quantity', '$balance')";

    $result = $conn->query($query);


    if ($result) {


        $data = array("status" => true, "data" => "successfully Registered 😂😊😒😎");
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}

function read_all_order($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT o.order_id,concat(c.frist_name,' ',c.last_name) as Customer_name,i.item_name,o.price,o.quantity,o.balance,o.status,o.date FROM orders o JOIN customers c ON o.customer_id=c.customer_id JOIN item i ON o.item_id=i.item_id";
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

// function read_all_order_statement($conn)
// {
//     extract($_POST);
//     $data = array();
//     $array_data = array();
//     $query = "CALL read_sell_statement('$tellphone')";
//     $result = $conn->query($query);


//     if ($result) {
//         while ($row = $result->fetch_assoc()) {
//             $array_data[] = $row;
//         }
//         $data = array("status" => true, "data" => $array_data);
//     } else {
//         $data = array("status" => false, "data" => $conn->error);
//     }

//     echo json_encode($data);
// }

function read_item_price($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "CALL read_all_item_price('$item_id')";
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


function read_all_customer($conn)
{
    $data = array();
    $array_data = array();
    $query = "SELECT c.customer_id, concat(c.frist_name, ' ', c.last_name)  as customer_name  from customers c ";
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


function get_order_info($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "SELECT * FROM orders where order_id= '$order_id'";
    $result = $conn->query($query);


    if ($result) {
        $row = $result->fetch_assoc();

        $data = array("status" => true, "data" => $row);
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}


function update_order($conn)
{
    extract($_POST);
    $data = array();
    $query = "UPDATE orders set customer_id = '$customer_id', item_id= '$item_id', price= '$price', quantity = '$quantity', balance= '$balance' WHERE order_id = '$order_id'";
    $result = $conn->query($query);


    if ($result) {

        $data = array("status" => true, "data" => "successfully updated 😂😊😒😎");
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
