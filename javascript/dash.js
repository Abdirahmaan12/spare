 let tempTotalincome = 0;
 let tempTotalexpense = 0;
loadtop_payments();
load_all_pending();
 get_total_customers();
 get_total_income();
get_total_employe();
get_total_expense();




function get_total_income() {

    let sendingData = {
        "action": "get_total_income"

    }

    $.ajax({
        method: "POST",
        dataType: "JSON",
        url: "Api/income.php",
        data: sendingData,
        async: false,
        success: function (data) {
            let status = data.status;
            let response = data.data;


            if (status) {


                document.querySelector("#totalincome").innerText = response['total'];

                tempTotalincome = response['total'];

            } else {

            }

        },
        error: function (data) {

        }

    })
}


function get_total_expense() {

    let sendingData = {
        "action": "get_total_expense"
  
    }
  
    $.ajax({
        method: "POST",
        dataType: "JSON",
        url: "Api/income.php",
        data: sendingData,
        async: false,
        success: function (data) {
            let status = data.status;
            let response = data.data;
  
  
            if (status) {
  
  
                document.querySelector("#total_expenses").innerText = response['total'];
  
                tempTotalexpense = response['total'];
  
            } else {
  
            }
  
        },
        error: function (data) {
  
        }
  
    })
  }



function get_total_employe() {

    let sendingData = {
        "action": "get_total_employe"

    }

    $.ajax({
        method: "POST",
        dataType: "JSON",
        url: "Api/income.php",
        data: sendingData,

        success: function (data) {
            let status = data.status;
            let response = data.data;


            if (status) {


                document.querySelector("#total_employe").innerText = response['employee']


            } else {

            }

        },
        error: function (data) {

        }

    })
}

function get_total_customers() {

    let sendingData = {
        "action": "get_total_customers"

    }

    $.ajax({
        method: "POST",
        dataType: "JSON",
        url: "Api/income.php",
        data: sendingData,

        success: function (data) {
            let status = data.status;
            let response = data.data;


            if (status) {


                document.querySelector("#total_customers").innerText = response['customers']


            } else {

            }

        },
        error: function (data) {

        }

    })
}

