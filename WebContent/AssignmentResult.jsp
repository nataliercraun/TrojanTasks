<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="objects.*" %>
<%@ page import="managers.*" %>
<%
	if(request.getAttribute("nameToNew") == null)
		return;
	Map<String,List<Task> > nameToNew = (Map<String,List<Task> >)request.getAttribute("nameToNew");
%>
<h2 style="margin-left: 110px">Assignment Results</h2><p/>
<table style="margin-left: 100px; margin-bottom: 50px">
	<tr>
		<th style="padding-left: 10px; padding-right:10px">Task</th>
		<th style="padding-left: 10px; padding-right:10px">Assignee</th>
	</tr>
	<%for(String name: nameToNew.keySet()) {
		for(Task task: nameToNew.get(name)) { %>
			<tr>
			<td style="padding-left: 10px; padding-right:10px"><%=task.getName() %></td>
			<td style="padding-left: 10px; padding-right:10px"><%=name %></td>
			</tr>
		<%}
	} %>
</table>