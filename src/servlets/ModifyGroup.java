package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import managers.DBManager;
import objects.Group;
import objects.User;

/**
 * Servlet implementation class ModifyGroup
 */
@WebServlet("/ModifyGroup")
public class ModifyGroup extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ModifyGroup() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type = request.getParameter("req");
		String userEmail = request.getParameter("email");
		DBManager dbManager = DBManager.getInstance();
	
		String success = null;
		
		if(type.equals("join")) {
			String groupid = request.getParameter("ID");
			System.out.println("in modify group servlet " + type + userEmail +groupid);
			success = dbManager.addUserToGroup(groupid,userEmail,request.getSession());
		}else if(type.equals("create")) {
			String gname = request.getParameter("name");
			System.out.println(gname);
			success = dbManager.addUserToNewGroup(userEmail,gname,request.getSession());
		}else if(type.equals("leave")) {
			//success = dbManager.removeGroupFromUser(userEmail,request.getSession());
		}
		
		if(success != null) {
			print(response.getWriter(),success);
//			Group g = dbManager.getInstance().getGroup(userEmail);
//			request.getSession().setAttribute("Group",g);
//			request.getSession().setAttribute("User",g.getUserForID(userEmail));
		}else {
			System.out.println("HI");
			response.getWriter().println("0");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	
	private void print(PrintWriter pw, String id) {
		Group g = DBManager.getInstance().getGroup(id);
		pw.println(String.format("<tr> \r\n" + 
				"			<td> %s</td>	\r\n" + 
				"		</tr>\r\n" + 
				"		<tr> \r\n" + 
				"			<td> Members </td><td> ", g.getName()));
		
		for(User u : g.getUsers()) {
			pw.println(u.getName() + ",");
		}
		pw.println("</td></tr>");
		
	}
	

}
