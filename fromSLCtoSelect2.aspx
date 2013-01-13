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
         
                
            $.getJSON('proxy.aspx?p=/api/rest/v1/sections/962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id/studentSectionAssociations/students', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": data[i].id, "name": data[i].name.lastSurname + ", " + data[i].name.firstName, "type": "Students" , "count":  1 } )
                    });
            });

            $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/bac78264188155695c8a34f09189b6c637b465ad_id/teacherSectionAssociations/sections', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": "962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id", "name": data[i].uniqueSectionCode , "type": "Courses" , "count":  27 } )
                    });
            });

            $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/', function(data) {
                    $.each(data, function(i) {
                        select2JSON.results.push( {"id": data[i].id, "name": data[i].name.personalTitlePrefix + ". " + data[i].name.lastSurname,"type": "Teachers", "count":  1  } )
                    });
            });

            $("#foo button").live("click", function() {
                doButtons($(this).attr("data-url"))
            })

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

            }

            $("#reciplist").select2({
              minimumInputLength: 2,
              multiple:true,
              width:"resolve",
              placeholder: "Search for Teacher, Parent, Student, or Class",
              ajax: {
                type: "POST",
                url: "/Ajax/ajax.aspx",
                dataType: 'json',
                data: function (term, page) {
                    return ('action=search&search=' + escape(term));
                },
                results: function (data, page) { ;
                    return {results: data.results, more: false};
                }
              },
              formatResult: recipFormatResults,
              formatSelection: recipFormatSelection
            });
        });
        
        function recipFormatResults(result) {
            var markup = "<table class=''><tr>";
            markup += "<td><div class='user-name'>" + result.name + "</div></td>";
            markup += "<td><div class='user-email'>" + result.email + "</div></td>";
            markup += "<td><div class='user-type'>" + result.type + "</div></td>";
            markup += "</tr></table>";
            return markup;              
        }

        function recipFormatSelection(result) {
              $("#badges").append("<span class='label label-success'>" + result.name + "<i class='icon-pencil icon-white';></i> <i class='icon-trash icon-white'></i></span>");
              return result.email;
        }
    </script>
</head>
<body style="background:whiteSmoke">
    <%
    %>
    <p>

    </p>
    <p><%=Session("Token")%></p>
    <a href="/logout.aspx">logout</a>
    <a href="/proxy.aspx">Show proxy</a>
    <button class="btn" data-url="/api/rest/v1/home" id="Start" onclick="alert(JSON.stringify(select2JSON))">GET SELECT2 from SLC</button>
    <div id="foo"></div>
    <div class="container-fluid">
        <div class="row-fluid">
            <h3>Compose a Message</h3>
            <form class="form-horizontal span12">
              <div class="control-group">
                <label class="control-label" for="inputRecipients">Recipients</label>
                <div class="controls">
                <div class="span12">
                    <input class="span6" type="hidden" id="reciplist" multiple="multiple" />
                    <button class="btn btn-primary" type="button" id="filters">More</button>
                </div>
                  <br>
                  <div class="span12" id="badges" style="margin-top: 8px">
                    <span class="label label-success">Art 2 <i class="icon-pencil icon-white"></i> <i class="icon-trash icon-white"></i></span>
                  </div>
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputSubject">Subject</label>
                <div class="controls">
                  <input class="span10" type="text" id="inputSubject" placeholder="Subject">
                  <input class="span8" type="text" id="inputSubject" placeholder="Subject">
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                  <textarea id="mainarea" class="span10" name="inputBody" rows="3"></textarea>
                </div>
                <script type="text/javascript">
                    $('#mainarea').wysihtml5();
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
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
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