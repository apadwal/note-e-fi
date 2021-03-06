<%@ Page Language="VB" Explicit="False"  %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%

'This queries microsoft translation api

Dim txtToTranslate As String = request.Form("txt")
Session("TranslateToken") = "" 'force a new session

Dim AzureClientID As String = WebConfigurationManager.AppSettings("AzureClientID")
Dim AzureSecret As String = WebConfigurationManager.AppSettings("AzureSecret")

if Session("TranslateToken") = "" then

		'Prepare OAuth request 
		Dim webRequest As WebRequest = WebRequest.Create("https://datamarket.accesscontrol.windows.net/v2/OAuth2-13")
		webRequest.ContentType = "application/x-www-form-urlencoded"
		webRequest.Method = "POST"
		Dim bytes As Byte() = Encoding.ASCII.GetBytes("grant_type=client_credentials&client_id=" & HttpUtility.UrlEncode(AzureClientID) & "&client_secret=" & HttpUtility.UrlEncode(AzureSecret) & "&scope=http://api.microsofttranslator.com")
		webRequest.ContentLength = bytes.Length
		Using outputStream As Stream = webRequest.GetRequestStream()
			outputStream.Write(bytes, 0, bytes.Length)
		End Using

		Dim responseText As String = ""
		Using webResponse As WebResponse = webRequest.GetResponse()
			Using reader = New System.IO.StreamReader(webResponse.GetResponseStream())
				responseText = reader.ReadToEnd()
			End Using
		End Using

		if responseText <> "" then
			Dim foo as Newtonsoft.Json.Linq.JObject = Newtonsoft.Json.Linq.JObject.Parse(responseText)
			Session("TranslateToken") = foo("access_token").toString()
		end if

end if


Dim uri As String = "http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + System.Web.HttpUtility.UrlEncode(txtToTranslate) + "&from=en&to=" & request.form("lang")

Dim translationWebRequest As System.Net.WebRequest = System.Net.WebRequest.Create(uri)
translationWebRequest.Headers.Add("Authorization", "Bearer " & Session("TranslateToken"))
Dim response1 As System.Net.WebResponse = Nothing

response1 = translationWebRequest.GetResponse()

Dim stream As System.IO.Stream = response1.GetResponseStream()

Dim encode As System.Text.Encoding = System.Text.Encoding.GetEncoding("utf-8")

Dim translatedStream As New System.IO.StreamReader(stream, encode)

Dim xTranslation As New System.Xml.XmlDocument()

xTranslation.LoadXml(translatedStream.ReadToEnd())

response.write( xTranslation.InnerText )


%>
