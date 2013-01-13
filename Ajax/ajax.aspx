<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>
<script runat="server" language="VB">
Dim connStr As String 
Dim strSQL As String 
Dim XMLRecipients as new StringBuilder
   
Public Class JsonResults
    Public Sub New()
        'MyBase.New()
        'results = New List(Of Dictionary(Of String, String))
        isMore = False
    End Sub
    Public Property more As Boolean
        Set(ByVal Value As Boolean)
            isMore = Value
        End Set
        Get
            isMore = False
            Return isMore
        End Get
    End Property
    Public results As New List(Of Dictionary(Of String, String))

    public function append(byval new_item as Dictionary(of String, String))
        results.Add(new_item)
    end function
End Class
</script>

<%

Dim requestAction As String = Request.Form("action")
If requestAction = "search" then
    Dim search As String = Request.Form("search")
    Dim returnString As JsonResults
    returnString = New JsonResults()
    returnString.more = False
    returnString.results = New List(Of Dictionary(Of String, String))

    'This needs optimization, a bit slower than I'd like it.

    returnedData = New Dictionary(Of String, String)
    returnedData.Add("id","myEmail@Email.com")
    returnedData.Add("name","Peterson, Kellen")
    returnedData.Add("email","myEmail@Email.com")
    returnedData.Add("type","Teacher")
    returnString.append(returnedData)
    
    returnJSON = Newtonsoft.Json.JsonConvert.SerializeObject(returnString)
    Response.ContentType = "application/json"
    Response.Write(returnJSON)
    Response.End()

else

    
End If





%>