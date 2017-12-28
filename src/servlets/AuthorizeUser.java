package servlets;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import managers.DBManager;
import objects.Group;
import objects.User;

@WebServlet("/LoginServlet")
public class AuthorizeUser extends HttpServlet {
	DBManager manager = DBManager.getInstance();
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) {

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		// uname pwd
		String username = request.getParameter("uname");
		String pwd = request.getParameter("pwd");
		User u = manager.verify(username, pwd);

		if (u != null) {

			request.getSession().setMaxInactiveInterval(600);
			if (u.getGroupID().equals("null")) {
				System.out.println("User group is null, setting user attr to user and group attr to null");
				request.getSession().setAttribute("Group", null);
				request.getSession().setAttribute("User", u);
			} else {
				System.out.println("User group is not null, setting user to obj in " + u.getGroupID());
				Group g = manager.getGroup(u.getGroupID());
				request.getSession().setAttribute("Group", g);
				request.getSession().setAttribute("User", g.getUserForID(u.getEmail()));
			}

			try {
				response.getWriter().println("1");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			try {
				response.getWriter().println("0");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}

}
