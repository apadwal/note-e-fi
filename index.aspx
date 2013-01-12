<html>
<head>
    <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function() {
            $("#Start").bind("click", function() {
                console.log($(this).attr("data-url"))
                doButtons($(this).attr("data-url"))
            })

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
                $.getJSON('proxy.aspx?p=' + u, function(data) {
                        console.log(data)
                        $.each(data.links, function(index) {
                            var url = data.links[index].href;
                            url = url.substring(url.indexOf("/api/"))
                            $("#foo").append('<button data-url="' + url + '">' + data.links[index].rel + '</button>')
                        });
                });
            }
        });
    </script>
</head>
<body style="background:whiteSmoke">
    <%
        If Session("Token") = "" then
            response.redirect("/callback.aspx" )
        end if
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
                <div class="input-append span10">
                    <input class="span12" type="text" id="inputRecipients" placeholder="Email">
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
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                  <textarea class="span10" name="inputBody" rows="3"></textarea>
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