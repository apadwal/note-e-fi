<html>
<head>
    <link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="/js/bootstrap.min.js">

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
                  <input class="span6" type="text" id="inputRecipients" placeholder="Email">
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputSubject">Subject</label>
                <div class="controls">
                  <input class="span6" type="text" id="inputSubject" placeholder="Subject">
                </div>
              </div>
              <div class="control-group">
                <label class="control-label" for="inputBody">Message Body</label>
                <div class="controls">
                  <textarea class="span6" name="inputBody" rows="3"></textarea>
                </div>
              </div>
              <div class="control-group">
                <div class="controls">
                  <label class="checkbox span4">
                    <input type="checkbox"> Send from my emails (john.doe@gmail.com)
                  </label>
                  <button type="submit" style="display:block"class="btn btn-primary btn-large span2">Send</button>
                </div>
              </div>
            </form>
        </div>
    </div>
</body>