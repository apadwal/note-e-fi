<%@ Page Language="VB" Explicit="False" %>
<!-- #include virtual ="/CheckSessionToken.aspx" -->
<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-wysihtml5.css"></link>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/css/crappydesign.css">
    <script src="/js/wysihtml5-0.3.0.min.js"></script>
    <script src="/js/base64.js"></script>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/scripts/course-widget.js?r=1"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/scripts/select2/select2.js"></script>
    <link href="/scripts/select2/select2.css" rel="stylesheet"/>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/bootstrap-wysihtml5.js"></script>

    <script type="text/javascript">

    var select2JSON = {"results":[],"more":false}; //hold student data for the dropdowns
    var list = {"course": []}; //list of students in the course-widget
    var templates = ["Your child was absent today from math class today.  Regular attendance at school is an important part of every student's success and is necessary in order to gain the greatest benefit from the educational experience. Students who are frequently absent from school miss direct instruction and regular contact with their teachers. When absences accumulate, it may ultimately result in academic difficulty.<br><br>We have the final exam next week so attendance is very important to be successful on the exam.  Please know that your child is responsible for the work covered today.<br><br>If you have any questions, please call my office at or the guidance office at so that we may work together to ensure your child's educational success.<br><br>Sincerely,<br><BR>Ms. Kim","Your child has been selected to receive tutoring services in the after-school program. Your child was selected by reviewing reading and/or math scores and first-quarter grades as well as teacher recommendation. This is an important opportunity to help your child improve in school. By sending your child to the after-school program you are showing support and helping your child to be a success in the years to come.<br><br>The emphasis of the program will be on reading/math and homework tutoring with enrichment opportunities. Students will receive a snack after school. Then they will report to a first hour academic class. During this time they will have homework assistance and then work on either math or reading lessons to help them improve in that area. After the academic hour, if students have completed their homework they will attend a 40-minute enrichment class. If students have not completed their homework they will be required to attend the homework center.<br><br>If your child has been referred it is very important that they attend the program. Your child’s teacher may offer extra credit in the subject they are attending for. Please fill out the attached permission slip and send it back me as soon as possible. It is very important that if you sign your child up they do not miss any days. After this first session is over, students will be reevaluated to determine if they need to continue services during the second semester. If you have any questions or concerns please do not hesitate to call me.<br><br>Thank You."];

    function getStudents() {
        //we are hardcodiing the course ID because only one course has students in the SLC
        var s = {"students":[],"totalespanol": 0};
        /* populate data for select 2 */
        $.getJSON('proxy.aspx?p=/api/rest/v1/sections/962f0a49fc8b8acd90be62aaa0a61c4e89083bbf_id/studentSectionAssociations/students', function(data) {
            $("li.loggedIn").show()
            $("li.loggedOut").hide()
            $("#overallContainer").show()

                $.each(data, function(i) {
                    s.students.push(data[i].id)
                    select2JSON.results.push( {"id": data[i].id, "text": data[i].name.lastSurname + ", " + data[i].name.firstName, "name": data[i].name.lastSurname + ", " + data[i].name.firstName, "type": "Students" , "count":  1, "csv": data[i].id, "totalespanol": (data[i].hispanicLatinoEthnicity) ? 1 : 0  } )
                    if ( data[i].hispanicLatinoEthnicity ) {
                        s.totalespanol = s.totalespanol + 1;
                    }
                });

                getTheRest(s) 

        }).error(function() { 
            $("li.loggedIn").hide()
            $("li.loggedOut").show()
            $("#overallContainer").hide()
        })


    }

    function getTheRest(s) {
        //now load up classes and teachers in the school
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

            //populate
            getStudents()

            $('#messageTemplate').live("change", function() {
                if ($(this).val() == 0) {

                }
                else {
                    var number = $(this).val() - 1;
                    //$('#mainarea').setValue(templates[number]);
                    $('iframe').contents().find('.wysihtml5-editor').html(templates[number]);
                } 
            })

            //bind events
            $("#course-widget-body li").live("click", function() {
                $(this).toggleClass("selected");
                $(this).find("i").toggleClass("icon-white")
            })

            $('i.icon-trash').live("click",function(){
                $(this).closest('span').remove();
                getStats();
                showTranslationCounts();
            })

            $('i.icon-pencil').live("click",function(){
                courseWidget.load( $(this).attr("id"), $(this).parent().attr("data-csv") );
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
            //display the results
            var markup = "<table class=''><tr>";
            markup += "<td><div class='user-name'>" + result.name + "</div></td>";
            markup += "<td><div class='user-type'>" + result.type + "</div></td>";
            markup += "</tr></table>";
            return markup;              
        }

        function recipFormatSelection(result) {
            //format the selected students
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

            if ( $("#badges span").size() == 0 ) {
                $("#stats").html("");
                return;
            }
            //update the tally of the students selected to be emailed
            var students = 0;
            var teachers = 0;
            var parents = 0;
            $('#badges span.label').each(function(i,item) {
                var type = $(this).data('type');
                if (type == "Students" ) {
                    students += 1;
                }
                if ( type == "Courses") {
                    students += (parseInt($(this).attr("data-count"))-1);
                    if ( $(this).attr("data-includeparents") == "1") {
                        parents += (parseInt($(this).attr("data-count"))-1);
                    }
                }
                else if (type == "Teachers") {
                    teachers += 1;
                }     
            })

            $('#stats').html('<span class="badge badge-info">' + students + '</span> Students <span class="badge badge-info">' + teachers + '</span> Teachers <span class="badge badge-info">' + parents + '</span> Parents')
        }
        function showTranslationCounts() {
            //update the counts of non english students
            //since the SLC dataset home lang attr is empty, we are faking it
            var totalEsp = 0; 
            $("#badges > span").each(function() {
                totalEsp += parseInt($(this).attr("data-espanol"));
            })
            if (totalEsp == 0) {
                $("#totalLang").empty();
                $("#totalLang").append("No Foreign Lang");
                return;    
            }
            var a = $("<a title='Show Translation'>Total Spanish: " + totalEsp + "</a>")
            $(a).bind("click", function () {
                var txt = $("#mainarea").val();
                var inner = $(txt).text();
                $.ajax({
                    type: "POST",
                    url: "/translate/translate.aspx",
                    data: "txt=" + inner + "&lang=es",
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


        function sendFunction() {
            var subject = $("#inputSubject").val();
            subject = subject.trim();
            subject = Base64.encode(escape(subject));
            var body = $("#mainarea").val();
            body = body.trim();
            body = Base64.encode(escape(body));            
            var students = "";
            var teachers = "";
            var activeFilters = "Overall Attendance Percentage";
            $("#badges span").each(function() {
                if ($(this).data("type") == "Teachers") {
                    teachers = teacher + $(this).data("id");
                } else if ($(this).data("type") == "Courses") {
                    students = students + $(this).data("csv");
                } else if ($(this).data("type") == "Students") {
                    students = students + $(this).data("id");
                }

            });
            var currentID = "bac78264188155695c8a34f09189b6c637b465ad_id";
            var dataString = "subject=" + subject + "&body=" + body + "&students=" + students + "&teachers=" + teachers + "&filters=" + activeFilters + "&currentid=" + currentID;

            $.ajax({
                type: "POST",
                url: "/post.aspx",
                data: dataString,
                dataType: "text",
                success: function (resp) {
                    $("#alertSuccess").show();
                },
                error: function (x, y, z) {

                }

            });
        }

            

        function SelectAll() {
            $("#course-widget-body li").addClass("selected")
            $("#course-widget-body li i").addClass("icon-white")
        }
        function SelectNone() {
            $("#course-widget-body li").removeClass("selected")
            $("#course-widget-body li i").removeClass("icon-white")
        }
        function SelectInvert() {
            $("#course-widget-body li").toggleClass("selected")
            $("#course-widget-body li i").toggleClass("icon-white")
        }

        function Rand() {
            //most data is missing, so lets randomize
            $("#course-widget-body li").each(function() {
                var blnToggle = true;
                if ( Math.random() >= 0.5 ) {
                    blnToggle = false;
                }
                if (blnToggle) {
                    $(this).attr("class", "selected")
                    $(this).find("i").attr("class", "icon-user icon-white")
                } else {
                    $(this).attr("class", "")
                    $(this).find("i").attr("class", "icon-user")
                }
            });
        }

        //Enable browser .trim support for weird/older browsers
        if (!String.prototype.trim) {
            String.prototype.trim = function () {
                return this.replace(/^\s+|\s+$/g, '');
            }
        }
    </script>

    <style>

    .user-name {
        text-align: left;
        margin-right: 35px;
        width: 300px;
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
    #course-widget-body {

    }

    #course-widget-body li.selected  {
        background-color: #63abf7;
        background-image: -webkit-linear-gradient(top,#63abf7,#5e99cd);
        background-image: -moz-linear-gradient(top,#63abf7,#5e99cd);
        background-image: -ms-linear-gradient(top,#63abf7,#5e99cd);
        background-image: -o-linear-gradient(top,#63abf7,#5e99cd);
        background-image: linear-gradient(top,#63abf7,#5e99cd);
        border: 1px solid #779;
        color: #fff;
    }
    #course-widget-body span {
        font-size: 10px !important;
    }

    #course-widget-body ol  {
        margin: 0;
    }
    #course-widget-body li  {
        float: left;
        height: 23px;
        list-style: none outside none;
        overflow: hidden;
        padding: 10px;
        text-overflow: ellipsis;
        white-space: nowrap;
        width: 25%;

        -webkit-border-radius: 6px;
        -moz-border-radius: 6px;
        border-radius: 6px;
        -webkit-box-shadow: 0 1px 0 #aaa;
        -moz-box-shadow: 0 1px 0 #aaa;
        box-shadow: 0 1px 0 #aaa;
        background-color: #f4f4f4;
        background-image: -webkit-linear-gradient(top,#fff,#f4f4f4);
        background-image: -moz-linear-gradient(top,#fff,#f4f4f4);
        background-image: -ms-linear-gradient(top,#fff,#f4f4f4);
        background-image: -o-linear-gradient(top,#fff,#f4f4f4);
        background-image: linear-gradient(top,#fff,#f4f4f4);
        filter: alpha(opacity=100);
        opacity: 1;
        border: 1px solid #ddd;
        margin: 9px;
        padding: 4px;
        position: relative;
        vertical-align: top;

    }

    #badges span {
        padding: 10px;
        margin: 10px 10px 10px 0px;
    }
    #badges, #stats {
        min-height: auto !important;
    }
    #mainarea-wysihtml5-toolbar a.btn {
        height: 20px !important;
    }

    #stats span.badge {
        margin-left: 10px
    }
    </style>
</head>
<body style="background:whiteSmoke">
	<div class="navbar">
			<div class="navbar-inner">
				<a class="brand" href="#">NOTE-e-FI</a>
				<ul class="nav">
				  <li><a href="#">Home</a></li>
				  <li><a href="#">Inbox</a></li>
				  <li class="active"><a href="#">New Message</a></li> 
                  <li><a href="logs.aspx">Messaging Logs</a></li>
				</ul>
				<ul class="nav pull-right">
					 <li class="loggedIn"><a href="#">Welcome, Linda!</a></li> 
					 <li class="loggedIn"><a href="/logout.aspx">Logout</a></li>
                     <li class="loggedOut"><a href="/callback.aspx">LogIn</a></li>
				</ul>
			</div>
	</div>

    <div class="container-fluid" id="overallContainer">
              <div id="alertSuccess" style="display:none;text-align: center; width:93%" class="alert alert-success span8">
                <button type="button" class="close" data-dismiss="alert-success">&times;</button>
                <strong>Success!</strong> Message has been posted
            </div>		
        <div class="row-fluid">
  
            <form onsubmit="return false;" class="form-horizontal span12">

              <div class="control-group">

                <label ></label>

                <div class="controls">

                  <h3>Compose a Message</h3>
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputRecipients">Recipients</label>
                <div class="controls">
                    <input class="span10" type="hidden" id="reciplist" multiple="multiple" />
                  <br>
                  <div class="span10" id="badges" style="margin-left: 0px; padding-top: 5px;">
                  </div>
                  <div class="span10" id="stats" style="margin-left: -10px;">
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
                  <label class="control-label" for="messageTemplate">Template</label>
                  <div class="controls">
                    <select class="span10" id="messageTemplate">
                      <option value="0">Select A Template</option>
                      <option value="1">Attendance Message</option> 
                      <option value="2">Tutoring</option>                                       
                    </select>
                  </div>
                </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                    <textarea id="mainarea" class="span10" name="inputBody" rows="13" style="">
                    </textarea>
                </div>
                <script type="text/javascript">
                
                    $('#mainarea').wysihtml5({
                        "link": false, //Button to insert a link. Default true
                        "image": false //Button to insert an image. Default true
                    });
                
                    
                </script>
              </div>
              <div class="control-group">
                <div class="controls">

                  <label class="checkbox span4" class="showTrans"  >
                    <input type="checkbox" id="translate"> Translate for non-English families
                  </label>          
                    <label class="checkbox span4" id="totalLang" style="padding-top: 6px;">
                  </label>

                    <button type="submit" style=""class="btn">Save Template</button>
                  <button onClick="sendFunction()" class="btn btn-success">Send <i class="icon-envelope icon-white"></i></button>  
                </div>
              </div>
            </form>
        </div>
    </div>
    
	<footer class="footer">
	  <div class="container">
		<p>Built by the CaseNEX team</p>
		<p>Code licensed under <a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">Apache License v2.0</a>.</p>
	  </div>
	</footer>
    <div id="course-widget-container" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-header">
        
            <h3 id="myModalLabel">Student Filter</h3>
            <select style="width: 100%" id="filter" onchange="Rand()">
                <option value=""></option>
                <optgroup label="Course Data">
                    <option value="Absent Today">Absent Today</option>
                    <option value="Overall Attendance Percentage">Overall Attendance Percentage</option>
                    <option value="State Assessment Scores">State Assessment Scores</option>
                    <option value="Benchmark Scores">Benchmark Scores</option>
                    <option value="Course Grade">Course Grade</option>
                </optgroup>
                <optgroup label="My Groups">
                    <option value="Afterschool Intervention Group">Afterschool Intervention Group</option>
                    <option value="Reading Group">Reading Group</option>
                </optgroup>
                <optgroup label="School Groups">
                    <option value="">Bowling Team</option>
                    <option value="">Chess Club</option>
                    <option value="">Lowest Third</option>
                    <option value="">College Bound Crew</option>
                </optgroup>
                <optgroup label="Flag Indicators">
                    <option value="">Grade Level</option>
                    <option value="">Cohort Year</option>
                    <option value="">Meal Status</option>
                    <option value="">ELL Status</option>
                    <option value="">SWD Status</option>
                </optgroup>
            </select>
        </div>
        <div id="course-widget-body" class="modal-body">
            <p>One fine body…</p>
        </div>
        <script id="course-widget-li" type="text/html">
            <li class="[class]" id="[id]">
                <label> 
                    <i class="icon-user" style="margin-top: 2px" />
                    <span>[name]</span>
                </label>
            </li>
        </script>
        <div class="modal-footer">

            <div style="width: 50%; float: left; text-align: left; ">
                <label style="" title="Include Parent">
                    <input type="checkbox" class="course-parent" data-send="false" id="doParent" style="margin-top: -3px"/> 
                    Include Parent In Email
                </label>
                Select: 
                    <a href="javascript:void(0)" onclick="SelectAll()" >All</a> |
                    <a href="javascript:void(0)" onclick="SelectNone()" >None</a> |
                    <a href="javascript:void(0)" onclick="SelectInvert()" >Invert</a>
            </div>
            <div style="width: 50%; float:left">
                <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
                <button id="course-widget-btn-save" class="btn btn-primary">Save changes</button>
            </div>

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