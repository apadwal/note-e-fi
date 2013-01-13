<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%

'this is the first leg of OAuth. Specify a callback page to handle the code and resubmit for the access_token
Dim CLIENT_ID as String = WebConfigurationManager.AppSettings("CLIENT_ID")
Dim CALLBACK_PAGE as String = "http://skd.local/callback.aspx"
response.redirect("https://api.sandbox.slcedu.org/api/oauth/authorize?reponse_type=code&client_id="  & CLIENT_ID & "&redirect_uri=" & Server.URLEncode(CALLBACK_PAGE) )

%>