<% @Page Language="VB" Explicit="False" validateRequest="false"%>

<script runat="server" language="VB">
Sub Page_Load(ByVal Sender As System.Object, ByVal e As System.EventArgs) 

SLC.Client.MessageSave.SaveMessage(request.form("subject"), request.form("body"), request.form("filters"), request.form("currentid"), request.form("teachers").Split(","C).ToList(), request.form("students").Split(","C).ToList())
End Sub
</script>