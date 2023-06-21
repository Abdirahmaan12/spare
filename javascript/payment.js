fill_customer_order();
fillaccoun();
fill_p_method();
fill_customer_amount();
loadpayment();

function fill_customer_order() {

  let sendingData = {
    "action": "read_customer_order"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/payment.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';

      if (status) {
        response.forEach(res => {
          html += `<option value="${res['customer_id']}">${res['customer_name']}</option>`;

        })

        $("#customer").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}

function fillaccoun() {

  let sendingData = {
    "action": "read_all_account"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/account.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';

      if (status) {
        response.forEach(res => {
          html += `<option value="${res['Account_id']}">${res['bank_name']}</option>`;

        })

        $("#Accountt_id").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}

function fill_p_method() {

  let sendingData = {
    "action": "read_all_p_method"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/pe_method.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';

      if (status) {
        response.forEach(res => {
          html += `<option value="${res['p_method_id']}">${res['name']}</option>`;

        })

        $("#p_method_id").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}

btnAction = "Insert";

$("#paymentform").on("submit", function (event) {

  event.preventDefault();


  let customer = $("#customer").val();
  let amount = $("#amount").val();
  let Accountt_id = $("#Accountt_id").val();
  let p_method_id = $("#p_method_id").val();
  let id = $("#update_id").val();

  let sendingData = {}

  if (btnAction == "Insert") {
    sendingData = {
      "customer": customer,
      "amount": amount,
      "Accountt_id": Accountt_id,
      "p_method_id": p_method_id,
      "action": "register_payment"
    }

  
  }



  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/payment.php",
    data: sendingData,
    success: function (data) {
      let status = data.status;
      let response = data.data;

      if (status) {
        swal("Good job!", response, "success");
        btnAction = "Insert";
        $("#paymentform")[0].reset();
        loadpayment();





      } else {
        swal("NOW!", response, "error");
      }

    },
    error: function (data) {
      swal("NOW!", response, "error");

    }

  })

})





$("#customer").on("change", function(){
  if($("#customer").val()== 0){
   $("#amount").val("");
  }else{
   console.log("kkkkk");
  }
   
 
   
 })
 
 
 $("#paymentform").on("change", "select.customers",  function(){
 
   let customers=$(this).val();
 
   console.log('soo buuxin');
 
   fill_customer_amount(customers);
 })


function fill_customer_amount(customer) {
  let sendingData = {
    "action": "read_customer_amount",
    "customer": customer

  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/payment.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      console.log("name", response)
      let html = '';
      let tr = '';

      if (status) {

        response.forEach(res => {
          $("#amount").val(res['balance']);

        })



      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}




function loadpayment() {
  $("#paymentTable tbody").html('');
  $("#paymentTable thead").html('');

  let sendingData = {
    "action": "read_all_payment"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/payment.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';
      let th = '';


      if (status) {
        response.forEach(res => {
          tr += "<tr>";
          th = "<tr>";
          for (let r in res) {
            th += `<th>${r}</th>`;

            if(r=="Total_amount"){
              tr += `<td>$${res[r]}</td>`;

            }else if(r=="amount_paid"){
              tr += `<td>$${res[r]}</td>`;


            }

            else if (r == "balance") {
              if (res[r] == 0) {
                tr += `<td><span class="btn btn-success btn-sm">✔</span></td>`;
              } else {
                tr += `<td><span class="btn btn-danger btn-sm">💲${res[r]}</span></td>`;
              }
            } else {
              tr += `<td>${res[r]}</td>`;
            }

          }

          tr += "</tr>"

        })

        $("#paymentTable thead").append(th);
        $("#paymentTable tbody").append(tr);
      }



    },
    error: function (data) {

    }

  })
}


