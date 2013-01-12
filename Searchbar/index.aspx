<%@ Page Language="VB" Explicit="False" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System.Web.Configuration" %>

<html>
<head>
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
        <script type="text/javascript" src="/scripts/select2/select2.min.js"></script>
		<script type="text/javascript" src="/scripts/script.js"></script>
		<link href="/scripts/select2/select2.css" rel="stylesheet"/>
</head>


<body>
<div>Recipients
<select style="width:80%" id="reciplist" placeholder="Search for Teacher, Parent, Student, or Class" multiple="multiple">
	<option>hi</option>
	<option>low</option>

</select>
</div>
</body>
</html>