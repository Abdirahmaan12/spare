btnAction = "Insert";
fillcustomer();
fill_item();
fill_price();
fill_price2();
loadorder();

function fillcustomer() {

  let sendingData = {
    "action": "read_all_customer"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/order.php",
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

        $("#customer_id").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
  
}

function fill_item() {

  let sendingData = {
    "action": "read_all_items"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/item.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';

      if (status) {
        response.forEach(res => {
          html += `<option value="${res['item_id']}">${res['item_name']}</option>`;

        })

        $("#item_id").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}

$("#order_form").on("submit", function (event) {

  event.preventDefault();


  let customer_id = $("#customer_id").val();
  let item_id = $("#item_id").val();
  let price = $("#price").val();
  let quantity = $("#quantity").val();
  let balance = $("#balance").val();
  let id = $("#update_id").val();

  let sendingData = {}

  if (btnAction == "Insert") {
    sendingData = {
      "customer_id": customer_id,
      "item_id": item_id,
      "price": price,
      "quantity": quantity,
      "balance": balance,
      "action": "register_order"
    }

  } else {
    sendingData = {
      "order": id,
      "customer_id": customer_id,
      "item_id": item_id,
      "price": price,
      "quantity": quantity,
      "balance": balance,
      "action": "update_order"
    }
  }



  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/order.php",
    data: sendingData,
    success: function (data) {
      let status = data.status;
      let response = data.data;

      if (status) {
        swal("Good job!", response, "success");
        btnAction = "Insert";
        $("#order_form")[0].reset();
        loadorder();


      } else {
        employemessage("error", response);
      }

    },
    error: function (data) {
      employemessage("error", data.responseText);

    }

  })

})

$("#order_form").on("change", "select.item_name", function () {
    let item_name = $(this).val();
    console.log("name", item_name);
    fill_price2(item_name);
    $("#quantity").val()==0;
  
  })


  
  $("#quantity").on("change", function () {
    let quantity = $(this).val();
   let item_id = $("#item_id").val();
    fill_price(item_id, quantity);
    console.log("quantity",quantity);
    console.log("item_id",item_id);

})



function fill_price2(item_id, quantity) {
    
    let sendingData = {
      "action": "read_item_price",
      "item_id": item_id

      
  
    }

  
    $.ajax({
      method: "POST",
      dataType: "JSON",
      url: "Api/order.php",
      data: sendingData,
  
      success: function (data) {
        let status = data.status;
        let response = data.data;
        console.log("name", response)
        let html = '';
        let tr = '';
  
        if (status) {
  
          response.forEach(res => {
            $("#price").val(res['price']);
            $("#balance").val(res['price']);
  
          })
  
  
  
        } else {
          displaymessage("error", response);
        }
  
      },
      error: function (data) {
  
      }
  
    })
  }
  
function fill_price(item_id, quantity) {
    
    let sendingData = {
      "action": "read_item_price",
      "item_id": item_id

      
  
    }

  
    $.ajax({
      method: "POST",
      dataType: "JSON",
      url: "Api/order.php",
      data: sendingData,
  
      success: function (data) {
        let status = data.status;
        let response = data.data;
        console.log("name", response)
        let html = '';
        let tr = '';
  
        if (status) {
  
          response.forEach(res => {
            $("#price").val(res['price']*quantity);
            $("#balance").val(res['price']*quantity);
  
          })
  
  
  
        } else {
          displaymessage("error", response);
        }
  
      },
      error: function (data) {
  
      }
  
    })
  }


function loadorder() {
  $("#order_table tbody").html('');
  $("#order_table thead").html('');

  let sendingData = {
    "action": "read_all_order"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/order.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';
      let th = '';

      if (status) {
        response.forEach(res => {
          th = "<tr>";
          for (let r in res) {
            th += `<th>${r}</th>`;
          }

          th += "<td>Action</td></tr>";




          tr += "<tr>";
          for(let r in res){

           
            if(r=="price"){
              tr += `<td>$${res[r]}</td>`;

            }else if(r=="balance"){
              tr += `<td>$${res[r]}</td>`;


            }

           else if(r == "status"){
              if(res[r] == "paid"){
                  tr += `<td><span class="btn btn-success btn-sm">${res[r]}</span></td>`;
              }else{
                  tr += `<td><span class="btn btn-danger btn-sm">${res[r]}</span></td>`;
              }
          }
            
            else{
              tr += `<td>${res[r]}</td>`;
            }

      }
        tr += `<td <div class="dropdown">
        <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
            <i class="bx bx-dots-vertical-rounded"></i>
        </button>
        <div class="dropdown-menu">
            <a class="dropdown-item  update_info" href="javascript:void(0);" update_id=${res['order']}><i class="bx bx-edit-alt me-1"></i> Edit</a>
        </div>
    </div></td>`
        tr += "</tr>"

        })
        $("#order_table thead").append(th);
        $("#order_table tbody").append(tr);
      }

    },
    error: function (data) {

    }

  })
}

function get_order_info(order_id) {

  let sendingData = {
    "action": "get_order_info",
    "order_id": order_id
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/order.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;


      if (status) {

        btnAction = "update";

        $("#update_id").val(response['order_id']);
        $("#customer_id").val(response['customer_id']);
        $("#item_id").val(response['item_id']);
        $("#price").val(response['price']);
        $("#quantity").val(response['quantity']);
        $("#balance").val(response['balance']);
        $("#order_modal").modal('show');




      } else {
        employemessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}



$("#order_table").on('click', "a.update_info", function () {
  let id = $(this).attr("update_id");
  get_order_info(id)
})

