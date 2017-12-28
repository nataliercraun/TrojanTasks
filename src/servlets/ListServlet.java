package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import managers.DBManager;
import objects.Group;
import objects.TaskList;

/**
 * Servlet implementation class ListServlet
 */
@WebServlet("/ListServlet")
public class ListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("hi");
		String req = request.getParameter("req");
		DBManager dbManager = DBManager.getInstance();
		
		if(req.equals("add")) {
			String name = request.getParameter("name");
			String items = request.getParameter("items");
			System.out.println(items);
			ArrayList<String> itemsArray = new ArrayList<String>();
			int last = -1;
			for(int i = 0; i < items.length(); ++i) {
				if(items.charAt(i) == ',') {
					if(i != last + 1) {
						String item = items.substring(last + 1, i);
						itemsArray.add(item);
						System.out.println(item);
						last = i;
					}else {
						last++;
					}
				}
			}
			System.out.println(!name.isEmpty());
			System.out.println();
			
			if(!name.isEmpty() && itemsArray.size() != 0) {
				TaskList list = new TaskList();
				list.setName(name);
				list.setItems(itemsArray);
				Group g = (Group)request.getSession().getAttribute("Group");
				
				
				dbManager.addListToGroup(g.getGroupID(), list);
				g.getLists().add(list);
				printstuff(g.getLists(),response.getWriter());
			}else {
				response.getWriter().println("0");
			}
		}else if(req.equals("remove")){
			String ID = request.getParameter("ID");
			System.out.println(ID);
			if(ID.isEmpty()) {
				response.getWriter().println("0");
			}else {
				Group g = (Group)request.getSession().getAttribute("Group");
				ArrayList<TaskList> lists = g.getLists();
				for(int i = 0; i < lists.size();++i) {
					if(lists.get(i).getID().equals(ID)) {
						lists.remove(i);
					}
				}
				dbManager.removeListFromGroup(g.getGroupID(),ID);
				printstuff(g.getLists(),response.getWriter());
			}	
		}
		

		

	
	}
	
	private void printstuff(ArrayList<TaskList> lists, PrintWriter pw) {
		for(int i = 0; i < lists.size(); ++i) {
			pw.println("<tr><td>");
			
			pw.println(String.format("<button type=\"button\" class=\"btn btn-info\""
					+ " data-toggle=\"collapse\" data-target=\"#demo%d\"> %s</button>", i,lists.get(i).getName()));
			
			pw.println(String.format("<div id=\"demo%d\" class=\"collapse\">", i));
			
			ArrayList<String> stuff = lists.get(i).getItems();
			
			for(int j = 0; j < stuff.size(); ++j) {
				pw.println(String.format(" <li><a href=\"#\">%s</a></li> ", stuff.get(j)));
			}
			
			
			pw.println(String.format("	   <td> \r\n" + 
					"		   <td> <button type=\"button\" onClick=\"removeList('%s')\"> Remove </button> </td>\r\n" + 
					"      	</tr>", lists.get(i).getID()));
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
