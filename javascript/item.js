btnAction = "Insert";
fill_item_modal();
fill_suplier();
loadeitems();

function fill_item_modal() {

  let sendingData = {
    "action": "read_all_Category"
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/Category.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;
      let html = '';
      let tr = '';

      if (status) {
        response.forEach(res => {
          html += `<option value="${res['Category_id']}">${res['modal']}</option>`;

        })

        $("#Category_id").append(html);


      } else {
        displaymessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}


function fill_suplier() {

    let sendingData = {
      "action": "read_all_supliers"
    }
  
    $.ajax({
      method: "POST",
      dataType: "JSON",
      url: "Api/supliers.php",
      data: sendingData,
  
      success: function (data) {
        let status = data.status;
        let response = data.data;
        let html = '';
        let tr = '';
  
        if (status) {
          response.forEach(res => {
            html += `<option value="${res['suplier_id']}">${res['company_name']}</option>`;
  
          })
  
          $("#suplier_id").append(html);
  
  
        } else {
          displaymessage("error", response);
        }
  
      },
      error: function (data) {
  
      }
  
    })
  }
  



$("#itemForm").on("submit", function (event) {

  event.preventDefault();


  let item_name = $("#item_name").val();
  let Category_id = $("#Category_id").val();
  let size = $("#size").val();
  let suplier_id = $("#suplier_id").val();
  let unit_price = $("#unit_price").val();
  let price = $("#price").val();
  let id = $("#update_id").val();

  let sendingData = {}

  if (btnAction == "Insert") {
    sendingData = {
      "item_name": item_name,
      "Category_id": Category_id,
      "size": size,
      "suplier_id": suplier_id,
      "unit_price": unit_price,
      "price": price,
      "action": "register_items"
    }

  } else {
    sendingData = {
      "item_id": id,
      "item_name": item_name,
      "Category_id": Category_id,
      "size": size,
      "suplier_id": suplier_id,
      "unit_price": unit_price,
      "price": price,
      "action": "update_item"
    }
  }



  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/item.php",
    data: sendingData,
    success: function (data) {
      let status = data.status;
      let response = data.data;

      if (status) {
        swal("Good job!", response, "success");
        btnAction = "Insert";
        $("#itemForm")[0].reset();
        loadeitems();


      } else {
        employemessage("error", response);
      }

    },
    error: function (data) {
      employemessage("error", data.responseText);

    }

  })

})


function loadeitems() {
  $("#itemTable tbody").html('');
  $("#itemTable thead").html('');

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
      let th = '';

      if (status) {
        response.forEach(res => {
          th = "<tr>";
          for (let r in res) {
            th += `<th>${r}</th>`;
          }

          th += "<td>Action</td></tr>";




          tr += "<tr>";
          for (let r in res) {


            tr += `<td>${res[r]}</td>`;


          }

          tr += `<td> <a class="btn btn-info update_info" update_id=${res['item_id']}><i class="fas fa-edit" style="color:#fff;"></i></a>&nbsp;&nbsp;<a class="btn btn-danger delete_info" delete_id=${res['item_id']}><i class="fas fa-trash" style="color:#fff;"></i></a> </td>`;

          tr += "</tr>"


        })
        $("#itemTable thead").append(th);
        $("#itemTable tbody").append(tr);
      }

    },
    error: function (data) {

    }

  })
}

function get_item_info(item_id) {

  let sendingData = {
    "action": "get_item_info",
    "item_id": item_id
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/item.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;


      if (status) {

        btnAction = "update";

        $("#update_id").val(response['item_id']);
        $("#item_name").val(response['item_name']);
        $("#Category_id").val(response['Category_id']);
        $("#size").val(response['size']);
        $("#suplier_id").val(response['suplier_id']);
        $("#unit_price").val(response['unit_price']);
        $("#price").val(response['price']);
        $("#itemmodal").modal('show');




      } else {
        employemessage("error", response);
      }

    },
    error: function (data) {

    }

  })
}


function Delete_item(item_id) {

  let sendingData = {
    "action": "Delete_item",
    "item_id": item_id
  }

  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/item.php",
    data: sendingData,

    success: function (data) {
      let status = data.status;
      let response = data.data;


      if (status) {

        swal("Good job!", response, "success");
        loadeitems();


      } else {
        swal(response);
      }

    },
    error: function (data) {

    }

  })
}



$("#itemTable").on('click', "a.update_info", function () {
  let id = $(this).attr("update_id");
  get_item_info(id)
})


$("#itemTable").on('click', "a.delete_info", function () {
  let id = $(this).attr("delete_id");
  if (confirm("Are you sure To Delete")) {
    Delete_item(id)

  }

})