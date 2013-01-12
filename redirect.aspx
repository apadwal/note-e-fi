<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>

<%


Dim CLIENT_ID as String = WebConfigurationManager.AppSettings("CLIENT_ID")
Dim CLIENT_SECRET as String = WebConfigurationManager.AppSettings("CLIENT_SECRET")
Dim REDIRECT_URI as String = "http://skd.local/redirect.aspx"

Dim requrl As String = "https://api.sandbox.slcedu.org/api/oauth/token?client_id=" & CLIENT_ID & "&client_secret=" & CLIENT_SECRET & "&grant_type=authorization_code&redirect_uri=" & Server.URLEncode(REDIRECT_URI) & "&code=" & request.querystring("code")
Dim client As New WebClient

client.CachePolicy = New System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore)
'client.Headers.Add("Authorization", "bearer " & Token)
client.Headers.Add("Content-Type", "application/vnd.slc+json")
client.Headers.Add("Accept", "application/vnd.slc+json")
Dim resp As String = client.DownloadString(requrl)
Dim foo as Newtonsoft.Json.Linq.JObject = Newtonsoft.Json.Linq.JObject.Parse(resp)
Session("Token") = foo("access_token").toString()

response.write(Session("Token"))
response.redirect("/")
%>
<a href="/">Back to home</a>



