<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Log In</title>
		<link rel="stylesheet" href="css/login.css"> 
		<link rel="stylesheet" href="css/styles.css"> 
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!-- Viewport -->
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- Minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<!-- Optional Theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
		
		<script>
			function validate(){
				var access = false;
				var uname = document.myform.uname.value;
				var pwd = document.myform.pwd.value;
				
				
				var xhttp = new XMLHttpRequest();
				// the open function sets the parameters
				xhttp.open("GET", "/"+window.location.pathname.split("/")[1]+"/LoginServlet?uname="+ uname + "&pwd="+ pwd, false);
				xhttp.send();
				
				var status = document.getElementById("status");
				
				if (xhttp.responseText.trim().length > 0) {
					var message = xhttp.responseText.trim();
					if(message == 0){ // something is wrong
						//display error message
						status.textContent = "That is not a valid combination of Username and Password."
					}
					else if(message == 1){ //login info validated, go to home page
						access = true;
					}
				}
				return access;
			}
			
			
		</script>
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
	    
	<div class="container"> 
	  <section class="col-md-6"> 
		<div id="login"> 
		
		<h2>Login</h2>
			<form name="myform" method="POST" action="Home.jsp" onsubmit="return validate()">
				<label for="uname"><b>Email</b></label>
				<input type="text" name="uname" placeholder="Enter Username">
				<label for="pwd"><b>Password</b></label>
				<input type="password" name="pwd" placeholder="Enter Password">
				<div id="lower">
					<input type="submit" value="Log In">
					<a href="CreateAccount.jsp" id="ll" style="width:125px"> Create Account </a>
					<!--  <button id="create" value="Create Account">Create Account</button> -->
				</div> 
			</form>
			<span id="status" style="color:red"></span>
		</div> 	
	  
	 </section> <!-- first column -->  
	
	<!-- TASK ASSIGNER BUTTON COLUMN -->
	  <section class="col-md-6"> 
		<div id="taskassign">
			<form id="task" name="task" method="POST" action="RandomTaskAssigner.jsp">
				<button id="task" value="Random Task Assigner"> Random Task Assigner </button>
			</form>
			Click here to randomly assign tasks without logging in or creating an account.
		</div>
	  </section> <!-- second column -->
	  
	</div> <!-- /container -->
	
	</div> <!-- services container -->
	
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<!-- Minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
	<!-- My script -->
	<script> src="js/script.js" </script>
	</body>
</html>