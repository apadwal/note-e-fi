<html>
<head>
    <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/scripts/select2/select2.min.js"></script>
    <link href="/scripts/select2/select2.css" rel="stylesheet"/>

    <script type="text/javascript">
        $(document).ready(function() {
            $("#Start").bind("click", function() {
                console.log($(this).attr("data-url"))
                doButtons($(this).attr("data-url"))
            })

            $("#foo button").live("click", function() {
                doButtons($(this).attr("data-url"))
            })

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
              minimumInputLength: 2,
              width:"resolve",
              placeholder: "Search for Teacher, Parent, Student, or Class",
              formatSelection: recipFormatSelection
            });
        });
        
        function recipFormatResults(result) {


        }

        function recipFormatSelection(result) {
              return result.id;
              $("#badges").append("<span class='label label-success'>Art 2 <i class='icon-pencil icon-white;></i> <i class='icon-trash icon-white'></i></span>");
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
    <button class="btn" data-url="/api/rest/v1/home" id="Start">Start Here</button>
    <div id="foo"></div>
    <div class="container-fluid">
        <div class="row-fluid">
            <h3>Compose a Message</h3>
            <form class="form-horizontal span12">
              <div class="control-group">
                <label class="control-label" for="inputRecipients">Recipients</label>
                <div class="controls">
                <div class="span12">
                    <select class="span6" id="reciplist" multiple="multiple">
                      <option>hi</option>
                      <option>low</option>
                    </select>
                    <button class="btn btn-primary" type="button">More</button>
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
                  <input class="span8" type="text" id="inputSubject" placeholder="Subject">
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                  <textarea class="span8" name="inputBody" rows="3"></textarea>
                </div>
              </div>
              <div class="control-group">
                <div class="controls">
                  <label class="checkbox span4">
                    <input type="checkbox"> Send from my emails (john.doe@gmail.com)
                  </label>
                  <button type="submit" style="display:block"class="btn btn-success btn-large span2">Send</button>
                </div>
              </div>
            </form>
        </div>
    </div>
</body>