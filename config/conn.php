<?php

$conn = new mysqli("localhost", "root", "", "spares");

if($conn->connect_error){
    echo $conn->error;
}