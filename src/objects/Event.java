package objects;

import java.util.ArrayList;

public class Event {
    private String name;
    private String id;
    private String type;
    private ArrayList<String> userInvolved = new ArrayList<String>();
    private String description;
    private Time time;
    private String creator;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public ArrayList<String> getUserInvolved() {
        return userInvolved;
    }

    public void setUserInvolved(ArrayList<String> userInvolved) {
        this.userInvolved = userInvolved;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public String getCreator() {
        return creator;
    }

    public void setCreator(String creator) {
        this.creator = creator;
    }
}
