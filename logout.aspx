<%@ Page Language="VB" Explicit="False" %>
<%
	'This only logs you out of the local application. 
	Session.Abandon()
%>

<a href="/login.aspx">Log In Again</a>


