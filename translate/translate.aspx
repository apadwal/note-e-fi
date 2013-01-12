<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%
Dim txt As String = request.querystring("txt")
'Session("TranslateToken") = ""
if Session("TranslateToken") = "" then

		'Prepare OAuth request 
		Dim webRequest As WebRequest = WebRequest.Create("https://datamarket.accesscontrol.windows.net/v2/OAuth2-13")
		webRequest.ContentType = "application/x-www-form-urlencoded"
		webRequest.Method = "POST"
		Dim bytes As Byte() = Encoding.ASCII.GetBytes("grant_type=client_credentials&client_id=" & HttpUtility.UrlEncode("SLCTranslate") & "&client_secret=" & HttpUtility.UrlEncode("o72BIo3LHBH12enfHXbW6gQ1GrpjR0zzSqtAR2q4A/0=") & "&scope=http://api.microsofttranslator.com")
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
			'response.write( Session("TranslateToken") )
		end if


end if

'translate
Dim fromLang As String = "en"
Dim toLang As String = "de"

'Dim url As String = "http://api.microsofttranslator.com/v2/Http.svc/Translate?appId=Bearer%20" & Session("TranslateToken") &  "&text=" + System.Web.HttpUtility.UrlEncode("Use pixels to express measurements for padding and margins.") + "&from=" + fromLang + "&to=" + toLang + "&contentType=text/plain"
Dim txtToTranslate As String = "Use pixels to express measurements for padding and margins."
Dim uri As String = "http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + System.Web.HttpUtility.UrlEncode(txtToTranslate) + "&from=en&to=es"

Dim translationWebRequest As System.Net.WebRequest = System.Net.WebRequest.Create(uri)
translationWebRequest.Headers.Add("Authorization", "Bearer " & Session("TranslateToken"))
Dim response1 As System.Net.WebResponse = Nothing

response1 = translationWebRequest.GetResponse()

Dim stream As System.IO.Stream = response1.GetResponseStream()

Dim encode As System.Text.Encoding = System.Text.Encoding.GetEncoding("utf-8")

Dim translatedStream As New System.IO.StreamReader(stream, encode)

Dim xTranslation As New System.Xml.XmlDocument()

xTranslation.LoadXml(translatedStream.ReadToEnd())

response.write( "Your Translation is: " + xTranslation.InnerText)


%>
