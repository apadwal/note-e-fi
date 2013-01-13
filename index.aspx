<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-wysihtml5.css"></link>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
    <script src="/js/wysihtml5-0.3.0.min.js"></script>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/scripts/select2/select2.js"></script>
    <link href="/scripts/select2/select2.css" rel="stylesheet"/>

    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/bootstrap-wysihtml5.js"></script>


    <script type="text/javascript">
    var select2JSON = {"results":[],"more":false};
        $(document).ready(function() {

            /* populate data for select 2 */
            $.getJSON('proxy.aspx?p=/api/rest/v1/sections/962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id/studentSectionAssociations/students', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": data[i].id, "text": data[i].name.lastSurname + ", " + data[i].name.firstName, "name": data[i].name.lastSurname + ", " + data[i].name.firstName, "type": "Students" , "count":  1 } )
                    });
            });

            $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/bac78264188155695c8a34f09189b6c637b465ad_id/teacherSectionAssociations/sections', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": "962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id", "text": data[i].uniqueSectionCode, "name": data[i].uniqueSectionCode, "type": "Courses" , "count":  27 } )
                    });
            });

            $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": data[i].id, "text": data[i].name.personalTitlePrefix + ". " + data[i].name.lastSurname, "name": data[i].name.personalTitlePrefix + ". " + data[i].name.lastSurname, "type": "Teachers", "count":  1  } )
                    });
            });


            $('i.icon-trash').live("click",function(){
                $(this).closest('span').remove();
            })

            $('i.icon-pencil').live("click",function(){
                raiseModal($(this).parent().text());
            })
            $('button#filters').live("click",function(){
                raiseModal();
            })

            function raiseModal(input) {
                if (input) {$('#myModal .modal-header #myModalLabel').text("Editing " + input)}
                    else {$('#myModal .modal-header #myModalLabel').text("Select Filters")}
                $('#myModal').modal('show');
            }

            function doButtons(u) {
                $.getJSON('proxy.aspx?p=' + u, function(data) {
                        console.log(data)
                        $.each(data.links, function(index) {
                            var url = data.links[index].href;
                            url = url.substring(url.indexOf("/api/"))
                            $("#foo").append('<button data-url="' + url + '">' + data.links[index].rel + '</button>')
                        });
                });
            }

            $("#reciplist").select2({
              width:"resolve",
              placeholder: "Search for Teacher, Parent, Student, or Class",
              data: select2JSON.results,
              formatResult: recipFormatResults,
              formatSelection: recipFormatSelection
            });

            $("#reciplist").on("change", function(e) {
              $(".select2-choice").html("<span style='color: #999999;!important'>Search for Teacher, Parent, Student, or Class</span>"); 
            });

        });
        
        function recipFormatResults(result) {
            var markup = "<table class=''><tr>";
            markup += "<td><div class='user-name'>" + result.name + "</div></td>";
            markup += "<td><div class='user-type'>" + result.type + "</div></td>";
            markup += "</tr></table>";
            return markup;              
        }

        function recipFormatSelection(result) {
          $(".select2-choice").html("<span style='color: #999999;!important'>Search for Teacher, Parent, Student, or Class</span>"); 
          var myId = result.id.replace(/[^\w\s]/gi, '');
            if (result.type == "Courses") {
                $("#badges").append("<span class='label label-success'>" + result.name + " <i id='" + myId + "' data-type='" + result.type + "' data-id=" + result.id + " data-count='" + result.count + "' class=' icon-pencil icon-white' onClick='win.show('" + result.id + "');></i> <i class='icon-trash icon-white'></i></span> ");
                return result.email;            
            } else {
              if ($("#" + myId).length == 0) {
                $("#badges").append("<span class='label label-success'>" + result.name + " <i id='" + myId + "' data-type='" + result.type + "' data-id=" + result.id + " class='icon-trash icon-white'></i></span> ");
                return result.email;
              } else {
                return result.email;
              };
            }
        }




    </script>

    <style>

    .user-name {
        text-align: left;
        width: 150px;
        margin-right: 35px;
    }
    .user-type {
        text-align: right;
        width:200px;
        float:right;
    }
    .user-email {
        text-align: left;
        width: 200px;
        margin-right: 35px;
    }
    </style>
</head>
<body style="background:whiteSmoke">
    <%
    %>
    <p>

    </p>
    <p style="display: none"><%=Session("Token")%></p>
    <a href="/logout.aspx">Logout</a>
    <div id="foo"></div>
    <div class="container-fluid">
        <div class="row-fluid">
            <h3>Compose a Message</h3>
            <form class="form-horizontal span12">
              <div class="control-group">
                <label class="control-label" for="inputRecipients">Recipients</label>
                <div class="controls">
                    <input class="span10" type="hidden" id="reciplist" multiple="multiple" />
                  <br>
                  <div class="span10" id="badges" style="margin-top: 8px">
                  </div>
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputSubject">Subject</label>
                <div class="controls">
                  <input class="span10" type="text" id="inputSubject" placeholder="Subject">
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                  <textarea id="mainarea" class="span10" name="inputBody" rows="3"></textarea>
                </div>
                <script type="text/javascript">
                    $('#mainarea').wysihtml5({
                        "link": false, //Button to insert a link. Default true
                        "image": false, //Button to insert an image. Default true,
                    });
                </script>
              </div>
              <div class="control-group">
                <div class="controls">
                  <label class="checkbox span4">
                    <input type="checkbox"> Send from my emails (john.doe@gmail.com)
                  </label>
                  <label class="checkbox span4">
                    <input type="checkbox"> Translate for non-English families
                  </label>                  
                  <button type="submit" style="display:block"class="btn btn-success btn-large span2">Send</button>
                </div>
              </div>
            </form>
        </div>
    </div>
    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">Modal header</h3>
        </div>
        <div class="modal-body">
            <p>One fine body…</p>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            <button class="btn btn-primary">Save changes</button>
        </div>
    </div>
</body>