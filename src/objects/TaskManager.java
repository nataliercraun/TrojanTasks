package objects;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import managers.DBManager;

public class TaskManager {
	
	public void updateTask(Task task)
	{
		String id = task.getID();
		//call database method and pass in new task object for the task id
		DBManager dbm = DBManager.getInstance();
		
	}
	
	public void markTasks(User user, List<Task> tasks)
	{
		for(Task task: tasks)
		{
			markTask(user.getEmail(), task);
		}
	}
	
	public void markTask(User user, Task task)
	{
		markTask(user.getEmail(),task);
	}
	
	public void markTask(String username, Task task)
	{	
		task.setCompleted(true);
		DBManager dbm = DBManager.getInstance();
		dbm.markUserTaskAsDone(username, task.getID());
		boolean success = dbm.markUserTaskAsDone(username, task.getID());
		if(!success)
		{
			System.out.println("Unable to mark task: " + task.getName() + " id: " + task.getID() + " completed: " + task.getCompleted());
			System.out.println("For user: " + username);
		}
		else
		{
			System.out.println("Successfully marked task: " + task.getName() + " id: " + task.getID() + " completed: " + task.getCompleted());
			System.out.println("For user: " + username);
		}
	}
	
	public void updateTasks(List<Task> tasks)
	{
		for(Task task: tasks)
		{
			updateTask(task);
		}
	}
	
	public Map<String,List<Task>> randomAnonymousAssignment(List<String> users, List<Task> tasks)
	{
		Map<String,List<Task>> nameToTasks = new HashMap<String,List<Task>>();
		for(String user: users)
		{
			nameToTasks.put(user, new ArrayList<Task>());
		}
		
		Collections.shuffle(tasks);
		Iterator<Task> taskIt = tasks.iterator();
		
		int i = 0;
		String user = users.get(i);
		while(taskIt.hasNext())
		{
			List<Task> uTasks = nameToTasks.get(user);
			uTasks.add(taskIt.next());
			i = (i+1)%users.size();
		}
		
		return nameToTasks;
	}
	
    public void randomAssignment(ArrayList<User> users, Task task) {
    	
    		if(!users.isEmpty())
    		{
    			int minTasks = users.get(0).getTasklist().size();
	    		for(User user: users)
	    		{
	    			if(user.getTasklist().size() < minTasks)
	    			{
	    				minTasks = user.getTasklist().size();
	    			}
	    		}
	    		
	    		ArrayList<User> potential = new ArrayList<User>();
	    		for(User user: users)
	    		{
	    			if(user.getTasklist().size() == minTasks)
	    			{
	    				potential.add(user);
	    			}
	    		}
	    		
	    		potential.get((int)(Math.random() * potential.size())).assignTask(task);
    		}
    }

    public void addTaskToUser(User user, Task task) {
    		user.assignTask(task);
    }
    
    public void removeTaskFromUser(User user, Task task)
    {
    		//probably just call some databasemanager method to remove the task
    		removeTaskFromUser(user.getEmail(), task);
    }
    
    public void removeTaskFromUser(String username, Task task)
    {
    		DBManager dbm = DBManager.getInstance();
    		dbm.removeTaskFromUser(username, task.getID());
    }
    
    public void removeTasksFromUser(User user, List<Task> tasks)
    {
	    	removeTasksFromUser(user.getEmail(), tasks);
    }
    
    public void removeTasksFromUser(String username, List<Task> tasks)
    {
    		for(Task task: tasks)
    		{
    			removeTaskFromUser(username,task);
    		}
    }
    
    public boolean removeTasksFromGroup(Group group, List<Task> tasks)
    {
    		System.out.println("Removing multiple tasks");
    		for(Task task: tasks)
    		{
    			for(User user: group.getUsers())
    			{
    				Task target = null;
    				for(Task st: user.getTasklist())
    				{
    					if(st.getID().equals(st.getID()))
    					{
    						target = st;
    					}
    				}
    				if(target != null)
    				{
    					System.out.println("Removing task " + task.getName() + "," + task.getID() + " from " + user.getEmail());
    					removeTaskFromUser(user,task);
    				}
    			}
    		}
    		
    		return true;
    }
    
    
    
//    public void removeTasks(List<Task> tasks)
//    {
//    		boolean success = false;
//    		boolean totalSuccess = false;
//    		DBManager dbm = DBManager.getInstance();
//    		for(Task task: tasks)
//    		{
//    			removeTask(task);
//    		}
//    }
    
    public Map<String,List<Task>> assignTasks(Group group, List<Task> tasks)
    {
    		System.out.println("Assigning " + tasks.size() + " tasks to group");
    		List<User> users = group.getUsers();
    		Collections.shuffle(tasks);
    		int maxTasks = users.get(0).getTasklist().size();
    		
    		Map<String,List<Task>> nameToAssigned = new HashMap<String,List<Task>>(); 
    		
    		for(User user: users)
    		{
    			nameToAssigned.put(user.getName(), new ArrayList<Task>());
    			if(user.getTasklist().size() > maxTasks)
    			{
    				maxTasks = user.getTasklist().size();
    			}
    		}
    		
    		users.sort(new Comparator<User>() {

				@Override
				public int compare(User o1, User o2) {
					if(o1.getTasklist().size() < o2.getTasklist().size())
					{
						return -1;
					}
					else if(o1.getTasklist().size() > o2.getTasklist().size())
					{
						return 1;
					}
					return 0;
				}
    		});
    		
    		DBManager dbm = DBManager.getInstance();
    		
    		//goes throught the tasks and assigns them starting with the first user in the list
    		//if the index is the last in the array, 
    		int i = 0;
    		User user;
    		boolean success = true;
    		for(Task task: tasks)
    		{
    			user = users.get(i);
    			boolean completed = dbm.addTaskToUser(user.getEmail(), task);
    			if(!completed)
    			{
    				success = false;
    				System.out.println("unable to assign task");
    			}
    			else
    			{
    				nameToAssigned.get(user.getName()).add(task);
    				System.out.println("successfully assigned task");
    			}
    			
    			user.assignTask(task);
    			if(i == users.size() - 1)
    			{
    				i = 0;
    			}
    			else if(users.get(i+1).getTasklist().size() > users.get(i).getTasklist().size())
    			{
    				i = 0;
    			}
    			else
    			{
    				i++;
    			}
    		}
    		
    		return nameToAssigned;
    }
    
    
    
}


