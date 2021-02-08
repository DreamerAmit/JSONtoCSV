<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Convert.aspx.cs" Inherits="WebApplication1.Convert" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>Export JSON to CSV in ASP.NET using Javascript and Bootstrap 4</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <center> 
    <h2 >JSON to CSV by Amit</h2> 
   </center>

 
<div class="row">
    Flatten Input:
    <asp:TextBox ID="txtinput" CssClass='form-control' runat="server"></asp:TextBox>
</div>
<div class="row">
    Flatten Output:
    <asp:TextBox ID="txtoutput" CssClass='form-control' TextMode="MultiLine" Height="150" runat="server"></asp:TextBox>
</div>
<br/>
<button id="process" class="btn btn-primary">Process</button>
<br/>
<br/>

            <div class="row">
                ReportName:
                <asp:TextBox ID="txtReportName" CssClass='form-control' runat="server"></asp:TextBox>
            </div>
            <br />
            <div class="row">
                JSON String:
                <asp:TextBox ID="txtJson" CssClass='form-control' TextMode="MultiLine" Height="150" runat="server"></asp:TextBox>
            </div>
            <br />
            <div>
                <asp:Button ID="btnCSV" CssClass='form-control btn btn-primary' runat="server" Text="Convert to CSV" />
            </div>
        </div>
    </form>

    <script type="text/javascript">

        $("#process").click(function () {


            JSON.flatten = function (data) {
                var result = {};

                function recurse(cur, prop) {
                    if (Object(cur) !== cur) {
                        result[prop] = cur;
                    } else if (Array.isArray(cur)) {
                        for (var i = 0, l = cur.length; i < l; i++)
                            recurse(cur[i], prop + "[" + i + "]");
                        if (l == 0) result[prop] = [];
                    } else {
                        var isEmpty = true;
                        for (var p in cur) {
                            isEmpty = false;
                            recurse(cur[p], prop ? prop + "." + p : p);
                        }
                        if (isEmpty && prop) result[prop] = {};
                    }
                }
                recurse(data, "");
                return result;
            };

            var result = JSON.stringify(JSON.flatten(JSON.parse($("#txtinput").val())));

            $("#txtoutput").val(result);

        });

        $(document).ready(function () {

          
            $('#btnCSV').click(function () {
                var JsonData = $('#txtJson').val();
                var ReportName = $('#txtReportName').val();

               
                if (ReportName == '') {
                    alert("Report Name should not Empty, Please Enter Report Name.");
                    return;
                }
                if (JsonData == '') {
                    alert("JSON string Should not Empty, Please Enter JSON String.");
                    return;
                }

                JSON.flatten = function (data) {
                    var result = {};

                    function recurse(cur, prop) {
                        if (Object(cur) !== cur) {
                            result[prop] = cur;
                        } else if (Array.isArray(cur)) {
                            for (var i = 0, l = cur.length; i < l; i++)
                                recurse(cur[i], prop + "["  + i + "]");
                            if (l == 0) result[prop] = [];
                        } else {
                            var isEmpty = true;
                            for (var p in cur) {
                                isEmpty = false;
                                recurse(cur[p], prop ? prop + "." + p : p);
                            }
                            if (isEmpty && prop) result[prop] = {};
                        }
                    }
                    recurse(data, "");
                    return result;
                };

              //  var JsonData1 = ("[" + JsonData + "]");
               // var result = JSON.stringify(JSON.flatten(JSON.parse(JsonData1)));
                //Testing Github
               var result = JSON.stringify(JSON.flatten(JSON.parse($("#txtJson").val())));
               var result1 = ("[" + result + "]");
 
                Export_JSON_to_CSV(JsonData , ReportName, true);
              
            });
        });
 
        function Export_JSON_to_CSV(JSONString, ReportName, isShowHeader) {
            var arrJsonData = typeof JSONString != 'object' ? JSON.parse(JSONString) : JSONString;
            // var arrJsonData =  JSONString ;
            var CSV = '';
            //  CSV += ReportName + '\r\n\n';
            if (isShowHeader) {
                var row = "";

                for (var index in arrJsonData[0]) {

                    row += index + ',';

                }


                // row = row.slice(-1, 0);
                CSV += row + '\r\n';
            }   
            for (var i = 0; i < arrJsonData.length; i++){
                var row = "";
                for (var index in arrJsonData[i]) {
                    row += '"' + arrJsonData[i][index] + '",';                                       
                }
              //  row.slice(0, row.length - 1);

                    CSV += row + '\r\n';                              
            }
            if (CSV == '') {
                alert("Invalid JsonData");
                return;
            }

            var fileName = "CSV_";
            fileName += ReportName.replace(/ /g, "_");
            var uri = 'Data:text/csv;charset=utf-8,' + escape(CSV);
            var link = document.createElement("a");
            link.href = uri;
            link.style = "visibility:hidden";
            link.download = fileName + ".csv";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
 
        </script>

</body>
</html>
