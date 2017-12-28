<%@ page import="objects.Calendar" %>
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
	
	ArrayList<TaskList> list = new ArrayList<TaskList>();
	if (group != null) {
		list = group.getLists();
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
	
	    <!-- Optional IE8 Support -->
	    <!--[if lt IE 9]>
	    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	    <![endif]-->

	 <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>

	    
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
	            <li> <a href="Profile.jsp"> Profile </a> </li>
	            <li> <a href="ChoreAssigner.jsp"> Chore Assigner </a> </li>
	            <li class="active"> <a href="Lists.jsp"> Lists </a> </li>
        			</ul>
	        	</div>
  		</nav>
	</div>
	<div id="peopleonline" style="margin-left:75px">Currently online: Alex, Natalie, Ian</div>
	<div class="container">
		<section class="col-md-6"> 
	  	<h2> Current Lists</h2>
	  	</br> 
	  	<table class="table">
	    <thead>
	      <tr>
	      	<th> List  </th>
	        <th>  </th>
	        <th>  </th>
	      </tr>
	    </thead>
		    <tbody id="listNames"> 
				<% for (int i = 0; i < list.size(); i++) { %>	
			      	<tr id="ListRow<%=list.get(i).getID()%>"> 
			      		<td> 
			      		<button id="listBtn<%=list.get(i).getID()%>" type="button" class="btn btn-info" data-toggle="collapse" data-target="#demo<%=i%>"> <%= list.get(i).getName() %></button>
			      		<% ArrayList<String> items = list.get(i).getItems(); %>
					    <div id="demo<%=i%>" class="collapse">
					    <% for (int j = 0; j < items.size(); j++) { %> 
						      <li><a href="#"><%=items.get(j) %></a></li> 
					   <% } %>
					   </div>
					   <td> <% 
					   String x = list.get(i).getID();
					   System.out.println("hiiiii" + x);%>
					   <td> <button id="listBtnRemove<%=list.get(i).getID()%>" type="button" onClick="removeList('<%=x%>')"> Remove </button> </td>
			      	</tr>
			      <% } %>
		    </tbody>
	  </table>
	  </section>

	  
	  <section class="col-md-3">
		  <h2>Add List</h2>
		  <br> 
		  <form name="listForm">
			  <input id="name" name="name" type="text" placeholder="List Name"> </br> </br> 
			  <input id="item" type="text" placeholder="Item Name"> 
		  </form>
		  <br>
		  <button id="addBtn">Add Item</button>
		  <button id="clearBtn">Clear</button> <br> <br> 
		  <button id="addListBtn" onClick="addList()">Create List</button>
	  </section>
	  <section class="col-md-3">
	  		<h2> Items </h2>
	        <ul id="dialog" title="Add List" class="list-group">
	            <ul id=listItem>
	            </ul>     
	        </ul>
	  </section>
	</div>
	<script> 
		var items = [];
		$(document).ready(function(){
	        var $appendItemsToList;
	        $("#addBtn").click(function() {
	        	 var bla = $("#item").val();
	            $("#dialog").append("<li style=\"margin-left:10px\">" + bla + "</li>");
	            //$("#dialog ul").append("<br>");
	            //$("#dialog ul").append("<br>");
	            items.push(bla);
	            console.log("pushing " + bla);
	        });
	        
	        $("#clearBtn").click(function() {
	            $( "#dialog" ).empty();
				items=[];
        		});
	    });
		
		function addList() {
			
			var itemString = "";
			var add = "add";
			for (i = 0; i < items.length; i++) { 
				itemString+= items[i];
				itemString+= ",";	
				
			}	
			
			var xhttp = new XMLHttpRequest();
			xhttp.open("GET", "ListServlet?name=" + document.listForm.name.value + "&items=" + itemString + "&req=" + add, false);
   	 	 	xhttp.send();
   	 	 	
   	 		var response = xhttp.responseText; 
   	 		if (response == "0") {
   	 			// fail
   	 		} else {
   	 			document.getElementById("listNames").innerHTML = response;
   	 			document.getElementById("dialog").innerHTML = "";
   	 			document.getElementById("item").value = "";
   	 			document.getElementById("name").value = "";
   	 		}
		}
		
		function removeList(listID) {
			
			console.log("List ID: " + listID);
			
			var itemString = "";
			var remove = "remove";
			
		
			var xhttp = new XMLHttpRequest();
			xhttp.open("GET", "ListServlet?ID=" + listID + "&items=" + itemString + "&req=" + remove, false);
   	 	 	xhttp.send();
   	 	 	
   	 		var response = xhttp.responseText; 
	 		if (response == "0") {
	 			// fail
	 		} else {
	 			document.getElementById("listNames").innerHTML = response;
	 		}
		}
		
		
		
		(function(){
			var ep = "/TrojanTasks/listendpoint";
			var socket;

			socket = new WebSocket("ws://" + window.location.host + ep);
			var m = "<%=group.getGroupID()%>,<%=user.getName()%>";
			socket.onopen = function(event){
				socket.send(m);
			};
			
			socket.onmessage = function(message) {
				var people = message.data;
				people = people.slice(0, people.length - 1);
				document.getElementById("peopleonline").innerHTML = "Currently Online: " + people;
			}

		})()
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