<%@ page import="objects.Day" %>
<%@ page import="objects.Event" %>
<%@ page import="objects.Group" %>
<%@ page import="objects.Task" %>
<%@ page import="objects.TaskManager" %>
<%@ page import="objects.Time" %>
<%@ page import="objects.User" %>
<%@ page import="objects.TaskList" %>

<%@ page import="jsonObjects.UpdateTasksRequest" %>
<%@ page import="jsonObjects.CalendarUpdateRequest" %>
<%@ page import="jsonObjects.RequestTask" %>

<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.Iterator" %>

<% 
	if ((session.getId() == null) || 
			(session.getAttribute("User") == null))
	{
		request.getRequestDispatcher("Login.jsp").forward(request, response);
		return;
	}

	User user = (User)session.getAttribute("User");
	Group group = (Group)session.getAttribute("Group");
	Map<String, String> groupTasks = null; 
	ArrayList<User> groupUsers = null;
	if (group != null) {
		groupUsers = group.getUsers();
		groupTasks = new HashMap<String, String>();
	}
	
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
	    
	    <!-- Better looking buttons  -->
        <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
        <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>

		<script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
		<link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
		
	    <!-- My stylesheet -->
	    <link rel="stylesheet" href="css/styles.css">
	    
	    	<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <script src="https://code.jquery.com/jquery-1.10.2.js"></script>
        <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	    <title>Chore Assigner</title>
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
	            <li> <a href="Profile.jsp"> Profile </a> </li>
	            <li class="active"> <a href="ChoreAssigner.jsp"> Chore Assigner </a> </li>
	            <li> <a href="Lists.jsp"> Lists </a> </li>
        			</ul>
	        	</div>
  		</nav>
	</div>
	
	<div class="container">
		<section class="col-md-6"> 
	  	<h2> Group Members</h2>
	  	<br /> 
	  	<table class="table">
	    <thead>
	      <tr>
	      	<th> Members  </th>
	        <th>  </th>
	        <th>  </th>
	      </tr>
	    </thead>
		    <tbody id="members"> 
				<% for (int i = 0; i < groupUsers.size(); i++) { %>
			      	<td>
			      		<%= groupUsers.get(i).getName()  %>
			      	</td>
			      <%} %>  
		    </tbody>
	  </table>
	  </section>
	
	<section class="col-md-3">
		  <h2>Add Task</h2>
		  <br> 
		  <form name="taskForm">
		  	  <label for="item"><b>Task Name:</b></label> <br />
			  <input id="item" type="text" placeholder="Task Name"> 
			  <label for="itemDescription"><b>Task Description:</b></label>
			  <input id="itemDescription" type="text" width="100px" placeholder="Task Description">
		  </form>
		  <br>
		  <button id="addBtn">Add Task</button>
		  <button id="clearBtn" onclick="clear();">Clear</button> <br> <br> 
		  <button id="assignBtn" onClick="assign()">Assign Tasks</button>
	  </section>
	  <section class="col-md-3">
	  		<h2> Tasks </h2>
	        <ul id="dialog" title="Add List" class="list-group">
	            <ul id=listItem></ul>     
	        </ul>
	  </section>
	</div>
	
	<br>
	<div id="results">
	</div>
	
	<script> 
		var items = [];
		var descriptions = [];
		$(document).ready(function(){
	        var $appendItemsToList;
	        $("#addBtn").click(function() {
	        	 	var bla = $("#item").val();
	        	 	var dah = $("#itemDescription").val();
	            $("#dialog ul").append(bla);
	            $("#dialog ul").append(": ");
	            $("#dialog ul").append(dah);
	            $("#dialog ul").append("<br>");
	            $("#dialog ul").append("<br>");
	            items.push(bla);
	            descriptions.push(dah);
	            $("#item").val("");
	            $("#itemDescription").val("");
	        });
	        
	        $("#clearBtn").click(function() {
	            $( "#dialog ul" ).empty();
        		});
	    });
		
		function assign (){
			var tasks = [];
			for(var i=0; i<items.length; i++){
				var task = {
					"name": items[i],
					"description": descriptions[i],
					"completed":0,
					"id:": null,
				}
				tasks.push(task);
			}
			var taskreq = {
				"type": "assign",
				"tasks": tasks
			};
			
			
			var xhttp = new XMLHttpRequest();
			xhttp.open("POST", "./updateTasks", true);
			xhttp.setRequestHeader("Content-type","application/json");
			xhttp.onreadystatechange =  function(){
				if(this.responseText.trim().length > 0){
					document.getElementById("results").innerHTML = this.responseText;
					clear();
				}
			};
			xhttp.send(JSON.stringify(taskreq));
		}
		
		function clear(){
			console.log("on clear");
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