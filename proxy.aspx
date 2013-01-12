<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%
Dim Token As String = Session("Token") 
	'/api/rest/v1/home
	dim req as string  = request.querystring("p")
	if req = "" then
		req = "/api/rest/v1/home"
	end if
	dim mycontenttype = "application/vnd.slc+json"
	if request.querystring("format") = "xml" then
		mycontenttype = "application/vnd.slc+xml"
	end if

		'try
	        Dim requrl As String = "https://api.sandbox.slcedu.org/" & req
	        Dim client As New WebClient

	        client.CachePolicy = New System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore)
	        client.Headers.Add("Authorization", "bearer " & Token)
	        client.Headers.Add("Content-Type", mycontenttype)
	        client.Headers.Add("Accept", mycontenttype)
	        
	        Dim resp As String = client.DownloadString(requrl)
	      
	        

	        if request.querystring("format") = "xml" then
	        	resp = resp.replace("https://api.sandbox.slcedu.org/", "http://skd.local/proxy.aspx?format=xml&p=/")
		        response.contenttype = "text/xml"
		        response.write(resp)
	        else
	        	resp = resp.replace("https://api.sandbox.slcedu.org/", "http://skd.local/proxy.aspx?p=/")
	        	response.contenttype="application/json"
	        	response.write(resp)
	        end if

		'catch ex as exception
		'	response.write("Error: " & ex.message)
		'end try

%>
