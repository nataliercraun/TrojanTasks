package objects;

import java.util.ArrayList;

public class TaskList {

	private String name;
	private String type;
	private ArrayList<String> items;
	private String ID;

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public TaskList() {
		items = new ArrayList<String>();
	}

	public void addItem(String item) {
		items.add(item);
	}

	public void crossOff(String item) {
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ArrayList<String> getItems() {
		return items;
	}

	public void setItems(ArrayList<String> items) {
		this.items = items;
	}
}