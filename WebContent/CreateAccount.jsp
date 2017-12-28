<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Create Account</title>
		<link rel="stylesheet" href="css/login.css">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!-- Viewport -->
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- Minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
		<!-- Optional Theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css">
		
		<script>
			function validate(){
				
				var success = false;
				var fname = document.signup.fname.value;
				var lname = document.signup.lname.value;
				var email = document.signup.email.value;
				var pw = document.signup.pwd.value;
				
				var xhttp = new XMLHttpRequest();
				xhttp.open("GET", "/"+window.location.pathname.split("/")[1]+"/CreateUser?name=" + fname + " " + lname
						+ "&email=" + email + "&pw=" + pw, false);
				xhttp.send();
				
				var status = document.getElementById("status");
				
				if(xhttp.responseText.trim().length > 0){
					var message = xhttp.responseText.trim();
					
					if(message == "0"){ //error
						status.textContent = "That email is already taken. Please enter a different email."
					}
					else if (message == "1"){ //success
						status.textContent = "Successfully created account. Please go to the Login page."
						success = true;
					}
				}
				return false;
			}
		
		
		</script>
	</head>
	<body>
		<div class="row">
	        <section class="col-md-12">
	            <h1>
				  <span class="redh1">Trojan</span>
				  <span class="blackh1">Tasks!</span>
				</h1>
	        </section>
	    </div>
	    <div class="container" style="width:500px" >
		  	<section class="col-md-12">  
		  	
			<div id="createAccount" >
				 
				<h2>Sign Up</h2>	
				<form name="signup" method="POST" onsubmit="return validate();">
					<label for="fname"><b>First Name: </b></label>
					<input type="text" name="fname" placeholder="Enter First Name"> <br />
					<label for="lname"><b>Last Name: </b></label>
					<input type="text" name="lname" placeholder="Enter Last Name"> <br />
					<label for="email"><b>E-Mail: </b></label>
					<input type="email" id="email" name="email" placeholder="Enter Email"> <br />
					<label for="pwd"><b>Password: </b></label>
					<input type="password" name="pwd" placeholder="Enter Password">
				<div id="lower">
					<input type="submit" id="createbutton" value="Create Account">
					<a href="Login.jsp" id="ll" >Login</a>
				</div> 
				</form>
				<span id="status" style="color:red"></span>
			</div>  
			
				
			</section> <!-- /col-md-6 -->
		</div> <!-- /container -->
	</body>
</html>