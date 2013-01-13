<% 
    If Session("Token") Is Nothing
		Response.Redirect("/login.aspx")
    End If
%>