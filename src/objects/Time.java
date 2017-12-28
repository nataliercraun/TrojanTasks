package objects;

public class Time {
    private String startTime;
    private String endTime;
    private boolean am;

    public String toString(){
        String unit = am? "a" : "p";
        return String.format("%s %s - %s %s",startTime,unit,endTime,unit);
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }


}
