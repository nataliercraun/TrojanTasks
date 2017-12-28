package jsonObjects;

import java.util.List;

public class UpdateTasksRequest 
{
	String type;
	List<RequestTask> tasks;
	
	public UpdateTasksRequest(String type, List<RequestTask> tasks)
	{
		this.type = type;
		this.tasks = tasks;
	}
	
	public void setType(String type)
	{
		this.type = type;
	}
	
	public String getType()
	{
		return type;
	}
	
	public void setTasks(List<RequestTask> tasks)
	{
		this.tasks = tasks;
	}
	
	public List<RequestTask> getTasks()
	{
		return tasks;
	}

}
