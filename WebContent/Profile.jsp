<%@ page import="objects.Calendar" %>
<%@ page import="objects.Day" %>
<%@ page import="objects.Event" %>
<%@ page import="objects.Group" %>
<%@ page import="objects.Task" %>
<%@ page import="objects.TaskManager" %>
<%@ page import="objects.Time" %>
<%@ page import="objects.User" %>

<%@page import="java.util.ArrayList" %>

<% 
	
	if ((session.getId() == null) || 
			(session.getAttribute("User") == null))
	{
		request.getRequestDispatcher("Login.jsp").forward(request, response);
		return;
	}

	User user = (User)session.getAttribute("User");
	Group group = (Group)session.getAttribute("Group");

%> 

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/html">
	<head>
	    <meta charset="UTF-8">
	
	    <!-- BOOTSTRAP HEAD SECTION -->
	    <!-- IE Edge Meta Tag -->
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	
	    <!-- Viewport -->
	    <meta name="viewport" content="width=device-width, initial-scale=1">
	
	    <!-- Minified CSS -->
	    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	
	    <!-- Optional Theme -->
	    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
	
	    <!-- Optional IE8 Support -->
	    <!--[if lt IE 9]>
	    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	    <![endif]-->
	    
	     <!-- jquery for pop-up form -->
	    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
		<script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
		<link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
			
		<!-- Better looking buttons  -->
        <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
        <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
		<script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
		<link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
	
	    <!-- My stylesheet -->
	    <link rel="stylesheet" href="css/styles.css">

	    <!-- Jquery  -->
	   	<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
        <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

	    <title>Home</title>
	</head>
	<body>
	<div class="services container">
	    <div class="row">
	        <section class="col-md-12">
	            <h1>
				  <span class="redh1">Trojan</span>
				  <span class="blackh1">Tasks!</span>
				</h1>
	        </section>
	    </div>
  		<nav class="navbar navbar-default">
	  		<div class="container"> 
  				<ul class="nav navbar-nav">
	            <li> <a href="Home.jsp"> Home </a> </li>
	            <li class="active"> <a href="Profile.jsp"> Profile </a> </li>
	            <li> <a href="ChoreAssigner.jsp"> Chore Assigner </a> </li>
	            <li> <a href="Lists.jsp"> Lists </a> </li>
        			</ul>
	        	</div>
  		</nav>
  		
  		<div class="row"> 
  			<section class="col-md-4">	
	  			<div class="img-holder">
	  				<% if (user.getImage() != null) { %>
				    		<img alt="Responsive image" class="avatar width-full rounded-2" height="230" src="<% if (user != null) { %> <%=user.getImage() %> <% } %>" width="230">
					<% } %>
				</div>
				<br> 
  				<div class="row">
  					<section class="col-md-4">
  						<h2> <% if (user != null) { %> <%=user.getName() %> <% } %></h2>
  						<h3 id="emailElement"><% if (user != null) { %> <%=user.getEmail() %> <% } %> </h3>
  					</section>
  				</div>
  			</section>
  			<section class="col-md-8">
  				<h2> Group </h2>
  				<% if (group != null) { %>
  				<table id="groupTable" style="border: solid black 2px;"> 
  					<tr> 
  						<td style="border: solid black 2px; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px"> <%=group.getName() %></td>	
  						<td style="border: solid black 2px; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px"> <%=group.getGroupID() %> </td>
  					</tr>
  					<tr> 
  						<td style="border: solid black 2px; 
  									padding-left: 5px; 
  									padding-right: 5px; 
  									padding-top: 2px; 
  									padding-bottom:2px"> Members </td>
  						<td style="border: solid black 2px; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px"> 
  						<% ArrayList<User> users = new ArrayList<User>(); %>
  						<% if (group != null) { 
  							users = group.getUsers();
  							for (int i = 0; i < users.size(); i++) { %>
  								<%= users.get(i).getName() %>
  								<% if (i < users.size()-1) { %>
  									<%="," %>
  								<% } %>
  							<% } 
  							} %> 
  						</td>
   					</tr>
  				</table>
  				<br> 
  			<% } 	
  			 else { %>
  			 <table id="groupTable" BORDER="10" BORDERCOLOR="red" > 
  			 </table>
  			 	<div id="buttons"> 
	  			 	<table id="buttonTable"> 
	  			 		<tr> 
			  			 	<div data-role="main" class="ui-content">
							    <a href="#myPopup" data-rel="popup" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-left">Create Group</a>
							    <div data-role="popup" id="myPopup" class="ui-content" style="min-width:250px;">
							      <form>
							        <div>
							          <label for="usrnm" class="ui-hidden-accessible">Name:</label>
							          <input id="createInput" type="text" name="user" placeholder="Name">
							        </div>
							      </form>
							      <button type="button" onClick="createGroup(); toggle_visibility();"> Create </button>
						    </div>
						</tr>
						<tr> 
			  			 	<div data-role="main" class="ui-content">
							    <a href="#myPopup2" data-rel="popup" class="ui-btn ui-btn-inline ui-corner-all ui-icon-check ui-btn-icon-left">Join Group</a>
							    <div data-role="popup" id="myPopup2" class="ui-content" style="min-width:250px;">
							      <form>
							        <div>
							          <label for="usrnm" class="ui-hidden-accessible">Name:</label>
							          <input id="joinInput" type="text" name="user" placeholder="ID">
							        </div>
							      </form>
							      <button type="button" onClick="joinGroup()"> Join </button>
						    </div>
						</tr>
				    </table>
				</div>
  			<% } %>
  			</section>
  		</div>
  	</div>
  	
  	<style> 
  		table {
  			padding: 10px; 
  		}
  	
  	</style>
  	
  	<script> 
  	
	  	function toggle_visibility() {
	        var e = document.getElementById("buttonTable");
	        if(e.style.display == 'block')
	           e.style.display = 'none';
	        else
	           e.style.display = 'block';
	        
	        location.reload(true);
	    }
	  	
  		function createGroup() {
  			
  			var groupName = document.getElementById("createInput").value;  			
  			var type = "create";
  			<% if (user != null) { %> 
  				var email = "<%=user.getEmail() %>";
  			<%}%>
  			var xhttp = new XMLHttpRequest();
			xhttp.open("GET", "ModifyGroup?req=" + type + "&email=" + email + "&name=" + groupName, false);
   	 	 	xhttp.send();
   	 	 	
   	 		var response = xhttp.responseText; 
   	 		if (response == "0") {
   	 			// fail
   	 		} else {
   	 			console.log(response);
   	 			document.getElementById("groupTable").innerHTML = response;
   	 			document.getElementById("buttonTable").style.visibility='hidden' ;
   	 		}
  		}
  		
  		function joinGroup() {
  			
  			var groupID = document.getElementById("joinInput").value;
  			var type = "join";
  			<% if (user != null) { %> 
				var email = "<%=user.getEmail() %>";
			<%}%>
  			var xhttp = new XMLHttpRequest();
			xhttp.open("GET", "ModifyGroup?req=" + type + "&email=" + email + "&ID=" + groupID, false);
   	 	 	xhttp.send();
   	 	 	
   	 		var response = xhttp.responseText; 
   	 		if (response == "0") {
   	 			// fail
   	 		} else {
   	 			document.getElementById("groupTable").innerHTML = response;
   	 			var table = document.getElementById("buttonTable");
   	 			if (table) table.parentNode.removeChild(table);
   	 		}
  		}
  		
  	</script>
  
	<!-- FOOTER SECTION - Before closing </body> tag -->
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	
	<!-- Minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	
	<!-- My script -->
	<script> src="js/script.js" </script>
	</body>
</html>