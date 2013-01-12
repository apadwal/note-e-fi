<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%

Dim CLIENT_ID as String = WebConfigurationManager.AppSettings("CLIENT_ID")
Dim REDIRECT_URI as String = "http://skd.local/redirect.aspx"
response.redirect("https://api.sandbox.slcedu.org/api/oauth/authorize?reponse_type=code&client_id="  & CLIENT_ID & "&redirect_uri=" & Server.URLEncode(REDIRECT_URI) )

%>





