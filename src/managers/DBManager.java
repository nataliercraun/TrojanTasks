package managers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.bson.BsonArray;
import org.bson.BsonString;
import org.bson.Document;
import org.bson.types.ObjectId;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;

import objects.Group;
import objects.Task;
import objects.TaskList;
import objects.User;

public class DBManager {
    private static DBManager dbManager;
    private MongoDatabase database;
    private MongoCollection<Document> userCollection;
    private MongoCollection<Document> groupCollection;

    public static DBManager getInstance(){
        if(dbManager == null){
            dbManager = new DBManager();
        }
        return dbManager;
    }
    private DBManager(){
    	String mongolink = "mongodb://intermsof:faYTqllD0OSmpTc4@cluster0-shard-00-00-ulaib.mongodb.net:27017,cluster0-shard-00-01-ulaib.mongodb.net:27017,cluster0-shard-00-02-ulaib.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin";
        MongoClientURI uri = new MongoClientURI(mongolink);
        MongoClient mongoClient = new MongoClient(uri);
        database = mongoClient.getDatabase("trojanTask");
        userCollection = database.getCollection("user");
        groupCollection = database.getCollection("groups");
    }

    //verifies that a user with the provided email is in the database
    //and that the password matches. If it does, then it returns the 
    //appropriate user object, otherwise, it returns null
    public User verify(String email, String password){
        Document user = findById(email,userCollection);
        if(user == null) {
        	System.out.println("coudlnt find");
        }
        if(user != null){
        	User userObj = parseUser(user);
            String correctPW = user.getString("password").toString();

            if(password.equals(correctPW)){
                return userObj;
            }
        }
        return null;
    }
    
    //adds the task to the database and sets the ID for the task
    //You still need to add the java task object into the user object in
    //the session
    public boolean addTaskToUser(String username, Task task) {
    	if(userCollection.count(Filters.eq("_id",username)) == 0) {
    		return false;
    	}
    	ObjectId oId = new ObjectId();
    	task.setID(oId.toString());
    	
    	//convert task to document
    	Document taskDoc = new Document("complete",false)
    			.append("name", task.getName())
    			.append("description", task.getDescription())
    			.append("_id", oId);
    	
    	userCollection.updateOne(
    			new Document("_id", username), 
    			new Document("$push",new Document("tasks",taskDoc)));
    	
    	return true;
    }
    
    //remvoes a task from the user based on the taskid
    //checks whether the user exists and whether the taskid is a valid id
    public boolean removeTaskFromUser(String username, String taskId) {
    	if(userCollection.count(Filters.eq("_id",username)) == 0 
    			|| !ObjectId.isValid(taskId)) {
    		return false;
    	}
    	userCollection.updateOne(
    			new Document("_id", username),
    			new Document("$pull",new Document("tasks",new Document("_id",new ObjectId(taskId)))));
    	return true;
    }
    
    //marks a task as complete. If the task is already complete, nothing will change
    public boolean markUserTaskAsDone(String username, String taskId) {
    	if(userCollection.count(Filters.eq("_id",username)) == 0
    			|| !ObjectId.isValid(taskId)) {
    		return false;
    	}
    	userCollection.updateOne(
    			new Document("_id", username).append("tasks._id", new ObjectId(taskId)), 
    			new Document("$set",new Document("tasks.$.complete",true)));
    	
    	return true;
    }
    
    public boolean createUser(String name, String email, String password) {
		if(findById(email,userCollection) != null) {
			System.out.println("Shit");
			return false;
		}
    	userCollection.insertOne(
				new Document("_id",email)
				.append("password", password)
				.append("name", name)
				.append("groupid", "null")
				.append("tasks", new BsonArray()));
    	
    	return true;
		 
	}
    
    
    public String addUserToGroup(String groupid, String userEmail, HttpSession session) {
    	System.out.println(groupid);
		if(!ObjectId.isValid(groupid) || findByOId(groupid,groupCollection) == null
				|| findById(userEmail,userCollection) == null) {
			return null;
		}
		
		userCollection.updateOne(
				Filters.eq("_id",userEmail), 
				new Document("$set",new Document("groupid",groupid)));
		
		groupCollection.updateOne(
				Filters.eq("_id",new ObjectId(groupid)), 
				new Document("$addToSet",new Document("users",userEmail)));
		
		Group g = getGroup(groupid);
		User correctUser = null;
		if(g != null) {
			List<User> users = g.getUsers();
			for(User u : users) {
				if(u.getEmail().equals(userEmail)) {
					correctUser = u;
				}
				System.out.println("WHAT WE NEED HERE " + u.getName());
				System.out.println("WHAT WE NEED HERE " + u.getGroupID());
			}
		}else {
			System.out.println("group is null :(((");
		}
		
		session.setAttribute("Group", getGroup(groupid));
		session.setAttribute("User", correctUser);
	
		return groupid;
	}

    public String addUserToNewGroup(String userEmail,String groupName, HttpSession session) {
    	System.out.println("IS IT HERE " + userEmail);
		if(groupName.length() == 0) {
			System.out.println(findById(userEmail,userCollection).getString("groupid") != "null");
			System.out.println(groupName.length() == 0);
			System.out.println("entered here");
			return null;
		}
		ObjectId id = new ObjectId();
		BsonArray ba = new BsonArray();
		ba.add(new BsonString(userEmail));

		groupCollection.insertOne(new Document("name",groupName)
				.append("_id", id)
				.append("users", ba)
				.append("lists", new BsonArray()));
		
		userCollection.updateOne(
				new Document("_id",userEmail), 
				new Document("$set",new Document("groupid",id.toString())));
		
		System.out.println("hi");
		
		session.setAttribute("Group", getGroup(id.toString()));
		return id.toString();
	}
    
	public boolean removeGroupFromUser(String userEmail, HttpSession session) {
		if(userCollection.count(new Document("_id",userEmail)) == 0) {
			return false;
		}else {
			String groupId = findById(userEmail,userCollection).getString("groupid");
			if(findByOId(groupId,groupCollection) == null) {
				return false;
			}else {
				groupCollection.updateOne(
						new Document("_id",new ObjectId(groupId)),
						new Document("$pull", new Document("users",userEmail)));
				userCollection.updateOne(
						new Document("_id",userEmail), 
						new Document("$set", new Document("groupid","null")));
			}
		}
		
		session.setAttribute("Group", null);
		return true;
	}
    
    public String addListToGroup(String groupId, TaskList list) {
    	BsonArray items = new BsonArray();
    	for(String s : list.getItems()) {
    		items.add(new BsonString(s));
    	}
    	
    	ObjectId oId = new ObjectId();
    	list.setID(oId.toString());
    	Document listDoc = new Document("name",list.getName())
    			.append("items", items)
    			.append("_id", oId);
    	
    	groupCollection.updateOne(
    			new Document("_id",new ObjectId(groupId))
    			, new Document("$push",new Document("lists",listDoc)));
    	

    	return oId.toString();
    }
    
    public void removeListFromGroup(String groupId, String listId) {
    	if(!ObjectId.isValid(groupId) || !ObjectId.isValid(listId)) {
    		return;
    	}
    	
    	groupCollection.updateOne(
    			new Document("_id",new ObjectId(groupId)), 
    			new Document("$pull",new Document("lists",new Document("_id",new ObjectId(listId)))));
    }

    @SuppressWarnings("unchecked")
	public Group getGroup(String id){
        Document group = findByOId(id,groupCollection);
        
        //logic for turning document into object
        if(group != null){
            Group result = new Group();
            //string fields
            result.setGroupID(id);
            result.setName(group.getString("name"));
            //get users from array of user ids
            ArrayList<String> ids = (ArrayList<String>)group.get("users");
            for(String s : ids) {
            	result.getUsers().add(parseUser(findById(s,userCollection)));
            }
            //get list objects based on array of lists
            ArrayList<Document> lists = (ArrayList<Document>)group.get("lists");
            System.out.println(lists.size());
            for(Document d : lists) {
            	result.getLists().add(parseList(d));
            	System.out.println("found list");
            }

            return result;
        }

        return null;
    }

    
    
    @SuppressWarnings("unchecked")
	private TaskList parseList(Document d){
        if(d != null){
            TaskList result = new TaskList();
            result.setName(d.getString("name"));
            result.setItems((ArrayList<String>)d.get("items"));
            result.setID(d.get("_id").toString());
            //result.set
            return result;
        }
        return null;
    }

    //reuseable helper function for finding documents by string ID
    private Document findById(String id, MongoCollection<Document> collection) {
    	//if(collection.count(Filters.eq("_id",id)))
    	if(collection.count(Filters.eq("_id",id)) == 0) {
    		return null;
    	}
        return collection.find(Filters.eq("_id",id)).first();
    }
    
    //reuseable helper function for finding documents by Object ID
    private Document findByOId(String id, MongoCollection<Document> collection) {
    	if(!ObjectId.isValid(id)) {
    		return null;
    	}
    	
    	if(collection.count(Filters.eq("_id",new ObjectId(id))) == 0) {
    		return null;
    	}
        return collection.find(Filters.eq("_id",new ObjectId(id))).first();
    }
    
    //given a document of a user, it returns a user object
    private User parseUser(Document d) {
    	User result = new User();
        result.setEmail(d.getString("_id"));
        result.setName(d.getString("name"));
        result.setGroupID(d.getString("groupid"));

        @SuppressWarnings("unchecked")
		List<Document> tasks = (List<Document>)d.get("tasks");
        for(Document task : tasks){
        	System.out.println(task.getString("name"));
        	System.out.println(task.getString("description"));
        	System.out.println(task.get("_id").toString());
        	System.out.println(task.get("complete").toString());
        	result.getTasklist().add(new Task(task.getString("name"),task.getString("description")
                    ,task.get("_id").toString(), task.getBoolean("complete")));
        }
    	return result;
    }
	
	
	


}
