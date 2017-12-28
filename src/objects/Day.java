package objects;

import java.util.ArrayList;

public class Day {
    private String day;
    private ArrayList<Event> events = new ArrayList<Event>();

    public void insertEvent(Event e){
        Time time = e.getTime();
        String startTime = time.getStartTime();
        int index = 0;
        while(events.get(index).getTime().getStartTime().compareTo(startTime) < 0){
            index++;
        }
        events.add(index,e);
    }

    public void removeEvent(String id){
        for(int i = 0; i < events.size(); ++i){
            if(events.get(i).getId() == id){
                events.remove(i);
            }
        }
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public ArrayList<Event> getEvents() {
        return events;
    }

    public void setEvents(ArrayList<Event> events) {
        this.events = events;
    }
}
