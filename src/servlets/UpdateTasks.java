package servlets;


import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import jsonObjects.RequestTask;
import jsonObjects.UpdateTasksRequest;
import objects.Group;
import objects.Task;
import objects.TaskManager;
import objects.User;

@WebServlet("/updateTasks")
@MultipartConfig()
public class UpdateTasks extends HttpServlet{
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		HttpSession session = request.getSession();		
		if(session.getId() == null ||
				session.getAttribute("User") == null)
		{
			//forward to login page
			try {
				request.getRequestDispatcher("Login.jsp").forward(request, response);
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		
		User user = (User) session.getAttribute("User");
		if(user == null)
		{
			//do something to handle, probably just forward to login
			System.out.println("Null user attribute");
		}
		else
		{
			System.out.println("User: " + user.getName() + " ID: " + user.getId());
		}
		
		Group group = (Group) session.getAttribute("Group");
		if(group == null)
		{
			//do something to handle, probably forward to login
			System.out.println("Null group attribute");
			return;
		}
		else
		{
			System.out.println("Group: " + group.getName() + " ID: " + group.getGroupID());
		}
		
		
		System.out.println("\nTasks:");
		for(Task t: user.getTasklist())
		{
			System.out.println("Name: " + t.getName() + " ID: " + t.getID() + " Completed: " + t.getCompleted());
			System.out.println("Desc: " + t.getDescription() + "\n");
		}
		
		System.out.println("Post to update tasks");
		//should check content type to ensure that it's json, but for now will forego in favor
		//of actually building functionality
		Enumeration<String > attributeNames = request.getAttributeNames();
		Enumeration<String> parameterNames = request.getParameterNames();
		try {
			
			ServletInputStream sis = request.getInputStream();
			InputStreamReader isr = new InputStreamReader(sis);
			Gson gson = new Gson();
			
			UpdateTasksRequest utr;
			utr = gson.fromJson(isr,UpdateTasksRequest.class);
			System.out.println("Type: " + utr.getType());
			System.out.println("Requested Tasks: ");
			
			ArrayList<Task> uTasks = new ArrayList<Task>();
			ArrayList<Task> rTasks = new ArrayList<Task>();
			System.out.println("Request Tasks Size: " + utr.getTasks());
			for(RequestTask rt: utr.getTasks())
			{
				System.out.println("Name: " + rt.getName() + " ID: " + rt.getID() + " Completed: " + rt.getCompleted());
				System.out.println("Desc: " + rt.getDescription() + "\n");
				System.out.println("String val: " + rt.getCompleted() + " vs bool val: " + Boolean.valueOf(rt.getCompleted()));
				
				boolean completed;
				if(rt.getCompleted().equals("1"))
					completed = true;
				else
					completed = false;
				
				boolean inUser = false;
				for(Task task: user.getTasklist())
				{
					if(task == null)
						System.out.println("null task what");
					if(task.getID() == null)
						System.out.println("null id how even");
					else if(task.getID().equals(rt.getID()))
					{
						uTasks.add(task);
						rTasks.add(task);
						inUser = true;
					}
				}
				if(!inUser)
				{
					rTasks.add(new Task(rt.getName(), rt.getDescription(), rt.getID(), completed));
				}
			}
			for(Task task: uTasks)
			{
				System.out.println("Name: " + task.getName() + " ID: " + task.getID() + " Completed: " + task.getCompleted());
				System.out.println("Desc: " + task.getDescription() + "\n");
			}
			
			if(utr.getType().equalsIgnoreCase("assign"))
			{
				//was the code when there was a different jsonObject class for tasks in requests,
				//currently using the regular Task object and having the front end send
				//complete information instead of accepting incomplete information
				
				//assign tasks to users
				TaskManager tm = new TaskManager();
				Map<String, List<Task>> nameToNew = tm.assignTasks(group, rTasks);
				
				//pass to a jsp to generate the results to return to the user
				request.setAttribute("nameToNew", nameToNew);
				//TODO: next need to pass off to jsp
				try {
					request.getRequestDispatcher("AssignmentResult.jsp").forward(request, response);
				} catch (ServletException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(utr.getType().equalsIgnoreCase("update"))
			{
				TaskManager tm = new TaskManager();
				if(!utr.getTasks().isEmpty())
				{
					tm.markTasks(user, uTasks);
					tm.updateTasks(uTasks);
				}
				System.out.println("\n\nTasks after updating:");
				for(Task t: user.getTasklist())
				{
					System.out.println("Task: " + t.getName() + " Completed: " + t.getCompleted());
				}
			}
			else if(utr.getType().equalsIgnoreCase("remove"))
			{
				
				TaskManager tm = new TaskManager();
				if(!utr.getTasks().isEmpty())
				{
					tm.removeTasksFromUser(user, uTasks);
				}
				for(Task task: rTasks)
				{
					for(User u: group.getUsers())
					{
						if(!u.getEmail().equalsIgnoreCase(user.getEmail()))
						{
							for(Task userTask: u.getTasklist())
							{
								if(userTask.getID().equals(task.getID()))
								{
									tm.removeTaskFromUser(u, userTask);
								}
							}
						}
					}
				}
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("Parameter Names: ");
		while(parameterNames.hasMoreElements())
		{
			System.out.println(parameterNames.nextElement());
		}
		
		System.out.println("Attribute Names: ");
		while(attributeNames.hasMoreElements())
		{
			System.out.println(attributeNames.nextElement());
		}
		
		
//		try {
//			Collection<Part> parts = request.getParts();
//			for(Part part: parts)
//			{
//				System.out.println(part.getName() + ": " + part.getContentType());
//			}
//		} 
//		catch (IOException e) 
//		{
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} 
//		catch (ServletException e) 
//		{
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	{
		System.out.println("Get on update tasks");
	}
}
