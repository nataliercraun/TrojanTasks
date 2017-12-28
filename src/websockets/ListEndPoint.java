package websockets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import objects.Group;

@ServerEndpoint(value = "/listendpoint")

public class ListEndPoint {
	private static Lock lock = new ReentrantLock();
	private static final Map<String,ArrayList<ListEndPoint> > clients = new HashMap<String,ArrayList<ListEndPoint> >();
	
	private Session session;
	private String groupid;
	private String name;
	
	
	public static void notifyChange(String id, Group g) {
		//generates html
	}
	
	private void sendWhoOnline(String groupid) {
		lock.lock();
		if(clients.containsKey(groupid)) {
			ArrayList<ListEndPoint> eps = clients.get(groupid);
			//generates list of who's online
			System.out.println(eps.size());
			for (Map.Entry<String,ArrayList<ListEndPoint> > entry : clients.entrySet()) {
				  String key = entry.getKey();
				  System.out.println("PEOPLE " + key + " " + entry.getValue().size());
				  //String value = entry.getValue();
				  // do stuff
				}
			String thoseOnline = new String();
			for(ListEndPoint ep : eps) {
				thoseOnline += ep.name;
				thoseOnline += ",";
			}
			System.out.println(thoseOnline);
			for(ListEndPoint ep: eps) {
				try {
					ep.session.getBasicRemote().sendText(thoseOnline);
				} catch (IOException e) {
				
					e.printStackTrace();
				}
			}
		}
		lock.unlock();
	}
	
	@OnOpen
	public void open(Session session) {
		lock.lock();
		System.out.println("opened session");
		this.session = session;
		lock.unlock();
	}
	
	@OnMessage
	public void onMessage(String message, Session session) {
		lock.lock();
		System.out.println(message);
		int fcomma = message.indexOf(',');
		groupid = message.substring(0,fcomma);
		name = message.substring(fcomma + 1);
		if(clients.containsKey(groupid)) {
			clients.get(groupid).add(this);
		}else {
			ArrayList<ListEndPoint> s = new ArrayList<ListEndPoint>();
			s.add(this);
			clients.put(groupid, s);
		}
		sendWhoOnline(groupid);
		lock.unlock();
	}
	
	@OnClose
	public void close(Session session) {
		lock.lock();
		boolean removed = false;
		if(groupid != null && clients.containsKey(groupid)) {
			removed = clients.get(groupid).remove(this);
		}else {
			
		}
		sendWhoOnline(groupid);
		System.out.println("closing connection. removed = " + removed);
		lock.unlock();
	}
	
	@OnError
	public void onError(Throwable error) {
		error.printStackTrace();
	}
	
}
