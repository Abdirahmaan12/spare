<?php

header("content-type: application/json");
include '../config/conn.php';
// $action = $_POST['action'];

function register_items($conn)
{
    extract($_POST);
    $data = array();
    $query = "INSERT INTO item(item_name, Category_id, size, suplier_id, unit_price,price)
     values('$item_name', '$Category_id', '$size', '$suplier_id', '$unit_price','$price')";

    $result = $conn->query($query);


    if ($result) {


        $data = array("status" => true, "data" => "successfully Registered");
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}

function read_all_items($conn)
{
    $data = array();
    $array_data = array();
    $query = "CALL read_all_items";
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

function get_item_info($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "SELECT *FROM item where item_id= '$item_id'";
    $result = $conn->query($query);


    if ($result) {
        $row = $result->fetch_assoc();

        $data = array("status" => true, "data" => $row);
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}

function update_item($conn)
{
    extract($_POST);
    $data = array();
    $query = "UPDATE item set item_name = '$item_name', Category_id= '$Category_id',  size = '$size', suplier_id= '$suplier_id', unit_price= '$unit_price', price= '$price' WHERE item_id = '$item_id'";
    $result = $conn->query($query);


    if ($result) {

        $data = array("status" => true, "data" => "successfully updated 😂😊😒😎");
    } else {
        $data = array("status" => false, "data" => $conn->error);
    }

    echo json_encode($data);
}
function Delete_item($conn)
{
    extract($_POST);
    $data = array();
    $array_data = array();
    $query = "DELETE FROM item where item_id= '$item_id'";
    $result = $conn->query($query);


    if ($result) {


        $data = array("status" => true, "data" => "successfully Deleted😎");
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
