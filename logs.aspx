<html>
<head>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap-wysihtml5.css"></link>
    <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="/css/crappydesign.css">
    <script src="/js/wysihtml5-0.3.0.min.js"></script>

    
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/scripts/course-widget.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/scripts/select2/select2.js"></script>
    <link href="/scripts/select2/select2.css" rel="stylesheet"/>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/bootstrap-wysihtml5.js"></script>
        <style type="text/css">
    .element {s
    height: 23px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;

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
    margin-top: 9px;
    padding: 4px;
    vertical-align: top;

    }
    </style>
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

        randomStats();
            $('#go').live("click", function() {
                 randomStats();
                 $('.element').show();
                 $('.element').each(function(i,item){
                    if((Math.floor((Math.random()*10)+1))>=6) {
                        $(this).hide();
                    }   
                 })               
            })
            $('#filterGroup button').live("click", function() {

                if ($(this).attr('id') == "all") {
                    $('.element').show()
                }
                else {
                    if ($(this).hasClass("filter")) {
                        var term = $(this).data('filter')
                        $('.element:not(.' + term + ')').hide();
                    }
                }

            })


            $('i.icon-trash').live("click",function(){
                $(this).closest('span').remove();
                getStats();
                showTranslationCounts();
            })

            $('i.icon-pencil').live("click",function(){
                courseWidget.load( $(this).attr("id") );
              

            })






        });

function randomStats() {
    $('.badge-warning').each(function(i,item){
        $(this).html(Math.floor((Math.random()*10)+1));
    })
};
        







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
	<div class="navbar">
			<div class="navbar-inner">
				<a class="brand" href="#">NOTE-e-FI</a>
				<ul class="nav">
				  <li><a href="#">Home</a></li>
				  <li><a href="#">Inbox</a></li>
				  <li><a href="/">New Message</a></li>
                  <li class="active"><a href="#">Messaging Logs</a></li>
				</ul>
				<ul class="nav pull-right">
					 <li><a href="#">Welcome, Linda!</a></li> 
					 <li><a href="/logout.aspx">Logout</a></li>
				</ul>
			</div>
	</div>
    <div class="container" style="min-height: 400px;">


            <div class="option-combo">
              <h2>Filter:</h2>
<select>
        <option>All</option>
        <option>   Course Data</option>
        <option>   *   Today's Attendance</option>
        <option>   *   Overall Attendance Percentage</option>
        <option>   *   State Assessment Scores</option>
        <option>   *   Benchmark Scores</option>
        <option>   *   Course Grade</option>
        <option>   My Groups</option>
        <option>   *   Afterschool Intervention Group</option>
        <option>   *   Reading Group</option>
        <option>   School Groups:</option>
        <option>   *   Bowling Team</option>
        <option>   *   Chess Club</option>
        <option>   *   Lowest Third</option>
        <option>   *   College Bound Crew</option>
        <option>   Flag Indicators</option>
        <option>   *   Grade Level</option>
        <option>   *   Cohort Year</option>
        <option>   *   Meal Status</option>
        <option>   *   ELL Status</option>
        <option>   *   SWD Status</option>
</select>
<div class="input-append" style="display:inline; margin:0px;">
<input type="text" style="height:30px" placeholder="ex: <= 60, absent, etc."></input>
<button id="go" class="btn">Go</button>
</div>
        <!--<div id="filterGroup" class="btn-group" data-toggle="buttons-radio">
          <button type="button" class="btn active" id="all">All</button>  
          <button type="button" class="btn filter" data-filter="failing">Failing Students</button>
        </div>-->
    </div>

    
      
          
    <div class="element student span3" data-symbol="Mg" data-category="alkaline-earth" id="ad3b5ff5fdead15d573bfa17fc9414aee29dac3a_id">
      <i class="icon-user number"></i>
      Brisendine, Dominic
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="001a69e6ce0920f532701047aea4a9bfc0d784de_id">
      <i class="icon-user number"></i>
    Maultsby, Alton
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="554b5f1600f2139f4ed470b6a059d7c858969ed0_id">
      <i class="icon-user number"></i>
      Raunsaville, Gerardo
      <span class="badge badge-warning pull-right"></span>
    </div>    
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="b314acce06ac5353710b5dd9ded97b086b507519_id">
      <i class="icon-user number"></i>
      Herriman, Verda
      <span class="badge badge-warning pull-right"></span>
    </div> 
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="0f2002d7ce2ab49802e7a0cbe35838ae58190cef_id">
      <i class="icon-user number"></i>
      Rudesill, Karrie
      <span class="badge badge-warning pull-right"></span>
    </div> 
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="639caad4eaca87ad6de687b44fc86939864cf951_id">
      <i class="icon-user number"></i>
        Scorzelli, Samantha
        <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="c1246e8cba2390d2e96f314a4a1c97ceafab69a7_id">
      <i class="icon-user number"></i>
        Consla, Lyn
        <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="0fdff62505febf149ec5a1f6d90a03f294985c98_id">
      <i class="icon-user number"></i>
Iskra, Damon
<span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="680ec1d25872edcbe69ec3409e8cf7754a1eea75_id">
      <i class="icon-user number"></i>
      Muchow, Preston
      <span class="badge badge-warning pull-right"></span>
    </div> 
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="c22213a34b3e0f137e19ee092f74fbbe2d688f40_id">
      <i class="icon-user number"></i>
      Merryweather, Preston
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="1f8c611fddadf5446eb8d72c0bd89ab16f0da650_id">
      <i class="icon-user number"></i>
      McCanse, Merry
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="68f4c7e29b5d5f32874c3ee15153580843a23654_id">
      <i class="icon-user number"></i>
      Borc, Mayme
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="cb77cec7e799f5e0488bfa62a779f4503c2f6564_id">
      <i class="icon-user number"></i>
      Ausiello, Alton
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="23d6835ed78ceb3ca1edbd81745cdc3360dc048a_id">
      <i class="icon-user number"></i>
      Bavinon, Dominic
      <span class="badge badge-warning pull-right"></span>
    </div>                               
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="79bd99f85134e3de11c745bddcb88c39374fda6c_id">
      <i class="icon-user number"></i>
    Saltazor, Gerardo
    <span class="badge badge-warning pull-right"></span>
    </div> 
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="cb8d3b50016393e9436180a78c595c96b890c6d5_id">
      <i class="icon-user number"></i>
        Hose, Lettie
        <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="25e13bb92dfd4b56e542207b4711eb97e38130a4_id">
      <i class="icon-user number"></i> 
      Aldama, Lashawn
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="883cbbb863a16ad1a4d7c80a176ae98cb8221ee1_id">
      <i class="icon-user number"></i>
        Costillo, Malcolm
        <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 failing" data-symbol="Mg" data-category="alkaline-earth" id="8fd5d781db8bfd47800debc0f5805b27ad74ff5d_id">
      <i class="icon-user number"></i>
    Wierzbicki, Felipe
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="3d0eddf6981dd1872459dffce2303080784e4736_id">
      <i class="icon-user number"></i>
    Simmer, Oralia
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="a2d2a18f0a4baf2da8c1d2357ef39b39a8e47244_id">
      <i class="icon-user number"></i>
    Giaquinto, Gerardo
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="44f0a9a2962c4fa6fd511a21c90d907e1f54917e_id">
      <i class="icon-user number"></i>
    Franz, Holloran
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="a7fed9d42b6c9b32a3633e1f033395780a8c3fbc_id">
      <i class="icon-user number"></i>
        Cianciolo, Felipe
        <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="4c04381340f22fdd386107ca34448b0b460dd3f9_id">
      <i class="icon-user number"></i>
    Cleaveland, Tomasa
    <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="4d26346724200f3dcea3485be4847f0a57f41809_id">
      <i class="icon-user number"></i>
      Taite, Lashawn
      <span class="badge badge-warning pull-right"></span>
    </div>
    <div class="element student span3 " data-symbol="Mg" data-category="alkaline-earth" id="5117dcea29547f74b99ec66abbede8e0ed150a6e_id">
      <i class="icon-user number"></i>
      Sollars, Matt
      <span class="badge badge-warning pull-right"></span>
    </div>
    <br><br>                                                         
</div>

	<footer class="footer">
	  <div class="container">
		<p>Built by the CaseNEX team</p>
		<p>Code licensed under <a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">Apache License v2.0</a>.</p>
	  </div>
	</footer>
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