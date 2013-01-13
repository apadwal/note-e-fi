<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>

<%
	'Client ID and client secret are provided by the SLC.  Do not expose this in your application
	Dim CLIENT_ID as String = WebConfigurationManager.AppSettings("CLIENT_ID")
	Dim CLIENT_SECRET as String = WebConfigurationManager.AppSettings("CLIENT_SECRET")
	Dim REDIRECT_URI as String = "http://skd.local/callback.aspx"

	Dim requrl As String = "https://api.sandbox.slcedu.org/api/oauth/token?client_id=" & CLIENT_ID & "&client_secret=" & CLIENT_SECRET & "&grant_type=authorization_code&redirect_uri=" & Server.URLEncode(REDIRECT_URI) & "&code=" & request.querystring("code")
	
	'This is one way to deal with the second leg of the OAuth process. You can also redirect to a different page
	Dim client As New WebClient
	client.CachePolicy = New System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore)

	'use the provided code to get the access_token
	Dim resp As String = client.DownloadString(requrl)
	Dim foo as Newtonsoft.Json.Linq.JObject = Newtonsoft.Json.Linq.JObject.Parse(resp)
	Session("Token") = foo("access_token").toString()
	response.redirect("/")
%>


