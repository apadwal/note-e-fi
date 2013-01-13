<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-wysihtml5.css"></link>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
    <script src="/js/wysihtml5-0.3.0.min.js"></script>
    
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/scripts/course-widget.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/scripts/select2/select2.js"></script>
    <link href="/scripts/select2/select2.css" rel="stylesheet"/>

    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/bootstrap-wysihtml5.js"></script>

    <script type="text/javascript">

    var select2JSON = {"results":[],"more":false};
    var list = {"course": []};
    function getStudents() {
        var s = {"students":[],"totalespanol": 0};
        /* populate data for select 2 */
        $.getJSON('proxy.aspx?p=/api/rest/v1/sections/962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id/studentSectionAssociations/students', function(data) {
                $.each(data, function(i) {
                    s.students.push(data[i].id)
                    select2JSON.results.push( {"id": data[i].id, "text": data[i].name.lastSurname + ", " + data[i].name.firstName, "name": data[i].name.lastSurname + ", " + data[i].name.firstName, "type": "Students" , "count":  1, "csv": data[i].id, "totalespanol": (data[i].hispanicLatinoEthnicity) ? 1 : 0  } )
                    if ( data[i].hispanicLatinoEthnicity ) {
                        s.totalespanol = s.totalespanol + 1;
                    }
                });
        });


        getTheRest(s) 
    }

    function getTheRest(s) {
        csv = s.students.join(",")
       $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/bac78264188155695c8a34f09189b6c637b465ad_id/teacherSectionAssociations/sections', function(data) {
                $.each(data, function(i) {
                    select2JSON.results.push( {"id": "962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id", "text": data[i].uniqueSectionCode, "name": data[i].uniqueSectionCode, "type": "Courses" , "count":  27, "csv": csv, "totalespanol": 5 } )
                });
        });

        $.getJSON('proxy.aspx?p=/api/rest/v1/teachers/', function(data) {
                $.each(data, function(i) {
                    select2JSON.results.push( {"id": data[i].id, "text": data[i].name.personalTitlePrefix + ". " + data[i].name.lastSurname, "name": data[i].name.personalTitlePrefix + ". " + data[i].name.lastSurname, "type": "Teachers", "count":  1, "csv": csv, "totalespanol": 0  } )
                });
        });

    }

    $(document).ready(function() {


        getStudents()


            $('i.icon-trash').live("click",function(){
                $(this).closest('span').remove();
                getStats();
                showTranslationCounts();
            })

            $('i.icon-pencil').live("click",function(){
                courseWidget.load( $(this).attr("id") );
              

            })

            function raiseModal(name, recips) {

                $('#myModal .modal-header #myModalLabel').text("Editing " + name); 
                $('#myModal').modal('show');
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
              getStats(); 
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
                $("#badges").append("<span data-espanol='" + result.totalespanol + "' data-type='" + result.type + "' data-id=" + result.id + " data-count='" + result.count + "' data-csv='" + result.csv + "' class='label label-success'>" + result.name + " <i id='" + myId + "'  class=' icon-pencil icon-white'></i> <i class='icon-trash icon-white'></i></span> ");
            } else {
              if ($("#" + myId).length == 0) {
                $("#badges").append("<span data-espanol='" + result.totalespanol + "' data-count='" + result.count + "'  data-csv='" + result.csv + "' data-csv='" + result.csv + "' data-type='" + result.type + "' data-id=" + result.id + " class='label label-success'>" + result.name + " <i id='" + myId + "'  class='icon-trash icon-white'></i></span> ");
              }
            }

            showTranslationCounts()
            return result.email;  
        }


        function getStats() {
            var students = 0;
            var teachers = 0;
            var parents = 0;
            $('span.label').each(function(i,item) {
                var type = $(this).data('type');
                if (type == "Students" || type == "Courses") {
                    students += $(this).data('count');
                }
                else if (type == "Teachers") {
                    teachers += $(this).data('count');
                }     
            })
            $('#stats').html('Sending To: <span class="badge badge-info">' + students + '</span> Students <span class="badge badge-info">' + teachers + '</span> Teachers <span class="badge badge-info">' + parents + '</span> Parents')
        }
        function showTranslationCounts() {
            var totalEsp = 0; 
            $("#badges > span").each(function() {
                totalEsp += parseInt($(this).attr("data-espanol"));
            })
            if (totalEsp == 0) {
                $("#totalLang").empty();
                $("#totalLang").append("No Foreign Lang");
                return;    
            }
            var a = $("<a href='#'>Total Spanish: " + totalEsp + "</a>")
            $(a).bind("click", function () {
                var txt = $("#mainarea").val()
                $.ajax({
                    type: "POST",
                    url: "/translate/translate.aspx",
                    data: "txt=" + txt + "&lang=es",
                    error: function (xhr, status) {
                        alert("No Translation Found")
                    },
                    success: function (result) {
                        $("#tranlation div.modal-body").html("<p>" +result + "</p>")
                        $("#tranlation").modal("show")
                    }
                })
            })
            $("#totalLang").empty();
            $("#totalLang").append(a);
            
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


    <a href="/logout.aspx">Logout</a>

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
                  <div class="span10" id="stats" style="">
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
                  <textarea id="mainarea" class="span10" name="inputBody" rows="9">Your child was absent today from math class today.  Regular attendance at school is an important part of every student's success and is necessary in order to gain the greatest benefit from the educational experience. Students who are frequently absent from school miss direct instruction and regular contact with their teachers. When absences accumulate, it may ultimately result in academic difficulty.

We have the final exam next week so attendance is very important to be successful on the exam.  Please know that your child is responsible for the work covered today.

If you have any questions, please call my office at or the guidance office at so that we may work together to ensure your child's educational success.

Sincerely,
Ms. Kim</textarea>
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
                  <label class="checkbox span4" id="totalLang">
                    
                  </label>
                  <label class="checkbox span4">
                    <input type="checkbox" id="translate"> Translate for non-English families
                  </label>                  
                  <button type="submit" style="display:block"class="btn btn-success btn-large span2">Send</button>
                </div>
              </div>
            </form>
        </div>
    </div>

    <div id="course-widget-container" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3 id="myModalLabel">Modal header</h3>
        </div>
        <div id="course-widget-body" class="modal-body">
            <p>One fine body…</p>
        </div>
        <script id="course-widget-li" type="text/html">
            <li>
                <input type="checkbox" class="course-student" data-id="[id]" />
                <span>[name]</span>
                <input type="checkbox" class="course-parent" data-send="false" />
                <span>Include Parent</span>
            </li>
        </script>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
            <button id="course-widget-btn-save" class="btn btn-primary">Save changes</button>
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
    <div id="tranlation" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
            <h3 id="myModalLabel">Translation Preview</h3>
        </div>
        <div class="modal-body">
            <p>One fine body…</p>
        </div>
        <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
        </div>
    </div>
</body>