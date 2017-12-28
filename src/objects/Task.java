package objects;

public class Task {

    String name;
    String description;
    String ID;
    boolean completed;
    
    public Task()
    {
    		
    }
    
    public Task(String name, String description, String ID)
    {
    		this.name=  name;
    		this.description = description;
    		this.ID = ID;
    		this.completed = false;
    }
    
    public Task(String name, String description, String ID, boolean completed)
    {
    		this.name = name;
    		this.description = description;
    		this.ID = ID;
    		this.completed = completed;
    }
    
    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String getID() {
        return ID;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setID(String ID) {
        this.ID = ID;
    }
    
    public void setCompleted(boolean completed)
    {
    		this.completed = completed;
    }
    
    public boolean getCompleted()
    {
    		return completed;
    }
}
