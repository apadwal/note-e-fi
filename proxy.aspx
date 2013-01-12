<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%
Dim Token As String = Session("Token") '"t-83bed305-e7d9-43ff-9aeb-96fb1fae2bc1" '"t-7e7863f0-755a-4a68-a841-16f39601f943" '"c-1348a1b5-5a06-4f2e-b82d-3aa220af73a3"
	'/api/rest/v1/home
	dim req as string  = request.querystring("p")
	if req = "" then
		req = "/api/rest/v1/home"
	end if

		'try
	        Dim requrl As String = "https://api.sandbox.slcedu.org/" & req
	        Dim client As New WebClient

	        client.CachePolicy = New System.Net.Cache.RequestCachePolicy(System.Net.Cache.RequestCacheLevel.NoCacheNoStore)
	        client.Headers.Add("Authorization", "bearer " & Token)
	        client.Headers.Add("Content-Type", "application/vnd.slc+json")
	        client.Headers.Add("Accept", "application/vnd.slc+json")
	        
	        Dim resp As String = client.DownloadString(requrl)
	        resp = resp.replace("https://api.sandbox.slcedu.org/", "http://skd.local/proxy.aspx?p=/")
	        

	        if request.querystring("format") = "xml" then
		        Dim root As XmlDocument = JsonConvert.DeserializeXmlNode(resp, "slc")
		        response.contenttype = "text/xml"
		        response.write( root.OuterXML )
	        else
	        	response.contenttype="application/json"
	        	response.write(resp)
	        end if

		'catch ex as exception
		'	response.write("Error: " & ex.message)
		'end try

%>
