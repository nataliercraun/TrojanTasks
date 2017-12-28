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

<%@ page import="managers.DBManager" %>

<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.Iterator" %>



<% 

	if ((session.getId() == null) || 
			(session.getAttribute("User") == null))
	{
		if(session.getId() == null)
			System.out.println("Redirecting because session is expired");
		else
			System.out.println("Redirection because user attribute is null");
		request.getRequestDispatcher("Login.jsp").forward(request, response);
		return;
	}

	DBManager dbm = DBManager.getInstance();
	
	User user = (User)session.getAttribute("User");
	Group group = (Group)session.getAttribute("Group");
	
	if(group != null)
	{
		System.out.println("Group wasn't null, reloading group from database");
		System.out.println(user.getGroupID());
		
		group = dbm.getGroup(user.getGroupID());
		if(group != null)
		{
			System.out.println("db group wasn't null, reloading user from group");
			user = group.getUserForID(user.getEmail());
			session.setAttribute("User",user);
			session.setAttribute("Group",group);
			
		}else{
			System.out.println("working");
		}
	}
	
	System.out.println("Why is it here ");
	Map<String, String> groupTasks = null; 
	Map<String, String> completeGroupTasks = null; 
	if (group != null) {
		System.out.println("Why is it here2 ");
		ArrayList<User> groupUsers = group.getUsers();
		groupTasks = new HashMap<String, String>();
		completeGroupTasks = new HashMap<String,String>();
		
		// Fill map with group's tasks -- each task maps to a user 
			System.out.println("HOME PAGE TASKS:");
		%><script>var idToTask = {};</script> <%
		System.out.println("populating tasks " + groupUsers.size());
		for (int i = 0; i < groupUsers.size(); i++) {
			ArrayList<Task> userTasks = groupUsers.get(i).getTasklist();
			for (int j = 0; j < userTasks.size(); j++) {
 				System.out.println("Task: " + userTasks.get(j).getName() + " Completed: " + userTasks.get(j).getCompleted());
				if (userTasks.get(j).getCompleted() == true) { 
					completeGroupTasks.put(userTasks.get(j).getName(), groupUsers.get(i).getName());
				} else {
					groupTasks.put(userTasks.get(j).getName(), groupUsers.get(i).getName());
				}
				%>
				<script>
	  			idToTask["<%=userTasks.get(j).getName()%>"] = {
	  					"name": "<%=userTasks.get(j).getName()%>",
	  					"description": "<%=userTasks.get(j).getDescription()%>",
	  					"ID":"<%=userTasks.get(j).getID()%>",
	  					"completed":"<%=userTasks.get(j).getCompleted()%>"
	  					};
	  			console.log(idToTask);
	  			
	  			</script>
	  			<%
			}
		}
		System.out.println("END HOME PAGE TASKS");
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
		
		<!-- Better looking buttons  -->
        <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
        <!--  <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script> -->

		<script src="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
		<!--  <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css"> -->
	
	    <!-- My stylesheet -->
	    <link rel="stylesheet" href="css/styles.css">

	    <!-- Jquery  -->
	   	<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
        <!-- <script src="https://code.jquery.com/jquery-1.10.2.js"></script> -->
        <!-- <script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script> -->

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
	            <li class="active"> <a href="Home.jsp"> Home </a> </li>
	            <li> <a href="Profile.jsp"> Profile </a> </li>
	            <li> <a href="ChoreAssigner.jsp"> Chore Assigner </a> </li>
	            <li> <a href="Lists.jsp"> Lists </a> </li>
        			</ul>
	        	</div>
  		</nav>
  	</div>
  	
  	<script> 
  		function reloadList()
  		{
  			
  		}
  	
  		function complete() {
  			xhttp.open("GET", "updateTasks?searchData=" + document.searchForm.staff.value, false);
   	 	 	xhttp.send();
  		}
  		
  		function updateTask(task)
		{
			console.log("Name: " + task.name);
			console.log("ID: " + task.value);
			var xhttp = new XMLHttpRequest();
			xhttp.onreadystatechange = function() {
				console.log("AJAX update task state change");
			}
			
			var taskreq = {
							"type": "update",
							"tasks": []
						};
			var jsonTaskObj = {"name":"test", "description":"desc", "ID":0, "completed":0};
			
			jsonTaskObj = idToTask[task.value];
			jsonTaskObj["completed"] = "1";
			console.log(jsonTaskObj);
			taskreq["tasks"].push(jsonTaskObj);
			
			
			xhttp.open("POST","./updateTasks",true);
			xhttp.setRequestHeader("Content-type","application/json");
			xhttp.send(JSON.stringify(taskreq));
		}
  		
  		function removeTask(task)
  		{
  			var xhttp = new XMLHttpRequest();
  			xhttp.onreadystatechange = function() 
  			{
  				console.log("AJAX remove task state change");
  			}
  			
  			var taskreq = {
					"type": "remove",
					"tasks": []
				};
			var jsonTaskObj = {"name":"test", "description":"desc", "ID":0, "completed":0};
  			
  			jsonTaskObj = idToTask[task.value];
  			
  			taskreq["tasks"].push(jsonTaskObj);
  			
  			console.log("Requesting removal of task: ");
  			console.log(taskreq);
  			
  			xhttp.open("POST", "./updateTasks",true);
  			xhttp.setRequestHeader("Content-type", "application/json");
  			xhttp.send(JSON.stringify(taskreq));
  		}
  		
  	</script> 
  		
	<div class="container">
		<section class="col-md-6"> 
	  <h2>Your Tasks</h2>
	  <table class="table">
	    <thead>
	      <tr>
	        <th>Task</th>
	        <th> Complete?</th>
	      </tr>
	    </thead>
		    <tbody> 
		    <%  
		    ArrayList<Task> completeTasks = new ArrayList<>();
		    if (user != null ) { 
		    		for (int i = 0; i < user.getTasklist().size(); i++) {
		    %>
	    		 	<tr>
	    		 		<% 
	    		 			// Check if task is complete 
	    		 			System.out.println("Task: " + user.getTasklist().get(i).getName() + " Completed: " + user.getTasklist().get(i).getCompleted() + " Eq: " + (user.getTasklist().get(i).getCompleted()==true));
	    		 			if (user.getTasklist().get(i).getCompleted() == true) {
	    		 				// If complete, add to completed task array
	    		 				completeTasks.add(user.getTasklist().get(i));
	    		 				System.out.println("Added task to copmplete");
	    		 			}
	    		 			else {
	    		 				// If not complete, print with button 
	    		 				%><td> <%= user.getTasklist().get(i).getName() %></td> <% 
	    		 				// FIGURE OUT HOW TO SET TASK=COMPLETE %>
	    				        <td> 
	    							<form name="completeForm">
	    						  		<input class="taskButton" 
	    						  			type="radio" 
	    						  			value= "<%=user.getTasklist().get(i).getName() %>" 
	    						  			name="<%=user.getTasklist().get(i).getName() %>" 
	    						  			onclick="updateTask(this);">
	    						  		<!--<script>
	    						  			idToTask["<%=user.getTasklist().get(i).getName()%>"] = {
	    						  					"name": "<%=user.getTasklist().get(i).getName()%>",
	    						  					"description": "<%=user.getTasklist().get(i).getDescription()%>",
	    						  					"ID":"<%=user.getTasklist().get(i).getID()%>",
	    						  					"completed":"<%=user.getTasklist().get(i).getCompleted()%>"
	    						  					};
	    						  			console.log(idToTask);
	    						  			
	    						  		</script>-->
	    							</form>
	    						</td>
	    		 			<% } %> 
		      	</tr>
		      <% } %> <!-- End of loop through User tasks -->
		      <% for (int j = 0; j < completeTasks.size(); j++) { %>
		      	<tr> 
		      		<td> <%= completeTasks.get(j).getName() %> </td>
		      		<td> Complete </td>
		      	</tr>
		      <% } %> <!-- End of loop through complete User tasks -->
	    		<% }%> <!-- Close if statement -->
		    </tbody>
	  </table>
	  </section>
	  <section class="col-md-6"> 
	  <h2>Group Tasks</h2>
	  <table class="table">
	    <thead>
	      <tr>
	        <th>Task</th>
	        <th>Assigned To: </th>
	        <th>Complete? </th>
	        <th>Remove? </th>
	      </tr>
	    </thead>
		    <tbody> 
		    		<% if (groupTasks != null) { Iterator it = groupTasks.entrySet().iterator(); 
		    		while (it.hasNext()) {
		    			Map.Entry pair = (Map.Entry)it.next();
		    		%>
	    		 	<tr>
			        <td> <%= pair.getKey() %></td>
			        <td> <%= pair.getValue() %> </td>
			        <td> No </td>
			        <td>
			        		<form name="removeForm">
	    						  		<input class="taskButton" 
	    						  			type="radio" 
	    						  			value= "<%=pair.getKey() %>" 
	    						  			name="<%=pair.getKey() %>" 
	    						  			onclick="removeTask(this);">
	    							</form>
			        </td>
		      	</tr>
		      	<% } %> <!-- Loop through map -->
		    	<% }%> <!-- if statement -->	
	    			<% if (completeGroupTasks != null) { Iterator it = completeGroupTasks.entrySet().iterator(); 
	    			while (it.hasNext()) {
	    				Map.Entry pair = (Map.Entry)it.next();
	    			%>
    		 		<tr>
			        <td> <%= pair.getKey() %></td>
			        <td> <%= pair.getValue() %> </td>
			        <td> Yes </td>
			        <td>
			        		<form name="removeForm">
	    						  		<input class="taskButton" 
	    						  			type="radio" 
	    						  			value= "<%=pair.getKey() %>" 
	    						  			name="<%=pair.getKey() %>" 
	    						  			onclick="removeTask(this);">
	    							</form>
			        </td>
	      		</tr>
	      		<% } %> <!-- Loop through map -->
	    		<% }%> <!-- if statement -->
		    </tbody>
	  </table>
	  </section>
	</div>

	<!-- FOOTER SECTION - Before closing </body> tag -->
	
	<!-- jQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	
	<!-- Minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	
	<!-- My script -->
	<script> src="js/script.js" </script>
	</body>
</html>


