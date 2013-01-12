<html>
<head>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
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
<body>
    <%
        If Session("Token") = "" then

            Dim CLIENT_ID as String = "xJfxkzClOm" '"ITSGvvMgzq"
            Dim REDIRECT_URI as String = "http://skd.local/redirect.aspx"
            response.redirect("https://api.sandbox.slcedu.org/api/oauth/authorize?reponse_type=code&client_id="  & CLIENT_ID & "&redirect_uri=" & Server.URLEncode(REDIRECT_URI) )

        end if
    %>
    <p>

    </p>
    <p><%=Session("Token")%></p>
    <a href="/logout.aspx">logout</a>
    <a href="/proxy.aspx">Show proxy</a>
    <button data-url="/api/rest/v1/home" id="Start">Start Here</button>
    <div id="foo"></div>
</body>