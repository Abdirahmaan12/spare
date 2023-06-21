btnAction = "Insert";
loade_Category();



$("#Categorymodal").on("submit", function (event) {

  event.preventDefault();


  let modal = $("#modal").val();
  let id = $("#update_id").val();

  let sendingData = {}

  if (btnAction == "Insert") {
    sendingData = {
      "modal": modal,
      "action": "register_Category"
    }

  } else {
    sendingData = {
      "Category_modal_id": id,
      "modal": modal,
    }
  }



  $.ajax({
    method: "POST",
    dataType: "JSON",
    url: "Api/Category.php",
    data: sendingData,
    success: function (data) {
      let status = data.status;
      let response = data.data;

      if (status) {
        swal("Good job!", response, "success");
        btnAction = "Insert";
        $("#CategoryForm")[0].reset();
        loade_Category();


      } else {
        employemessage("error", response);
      }

    },
    error: function (data) {
      employemessage("error", data.responseText);

    }

  })

})

function loade_Category() {
  $("#CategoryTable tbody").html('');
  $("#CategoryTable thead").html('');

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
      let th = '';

      if (status) {
        response.forEach(res => {
          th = "<tr>";
          for (let r in res) {
            th += `<th>${r}</th>`;
          }

        //   th += "<td>Action</td></tr>";




          tr += "<tr>";
          for (let r in res) {


            tr += `<td>${res[r]}</td>`;


          }
        //   tr += `<td> <a class="btn btn-info update_info"  update_id=${res['employe_id']}><i class="mdi mdi-grease-pencil" style="color: #fff"></i></a>&nbsp;&nbsp <a class="btn btn-danger delete_info" delete_id=${res['employe_id']}><i class="mdi mdi-close-box
        //   " style="color: #fff"></i></a> </td>`
          tr += "</tr>"

        })
        $("#CategoryTable thead").append(th);
        $("#CategoryTable tbody").append(tr);
      }

    },
    error: function (data) {

    }

  })
}
