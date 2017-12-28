package jsonObjects;

import objects.Event;

public class CalendarUpdateRequest 
{
	String type;
	Event event;
	
	public void setType(String type)
	{
		this.type = type;
	}
	
	public String getType()
	{
		return type;
	}
	
	public void setEvent(Event event)
	{
		this.event =  event;
	}
	
	public Event getEvent()
	{
		return event;
	}
}
