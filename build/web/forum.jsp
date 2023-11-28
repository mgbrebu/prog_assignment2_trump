<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="dbconnection.DBConnect"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.apache.commons.text.StringEscapeUtils"%> <!-- Import for escaping HTML -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <title>We Love Trump!</title>
    </head>
    <%
        Connection con = new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));
        if (session.getAttribute("isLoggedIn") != null && session.getAttribute("isLoggedIn").equals("1")) {
            out.print("Hello " + StringEscapeUtils.escapeHtml4((String) session.getAttribute("user")) + ", Welcome to Our Forum !");
        }
    %>
    <body>

        <div id="container">
            <div id="mainpic">         
            </div>   

            <div id="menu">
                <ul>
                    <li class="menuitem"><a href="index.jsp">Home</a></li>
                    <li class="menuitem"><a href="quotes.jsp">Quotes</a></li>
                    <li class="menuitem"><a href="news.jsp">News</a></li>
                    <li class="menuitem"><a href="profile.jsp?id=<% if(session.getAttribute("userid")!=null){ out.print(session.getAttribute("userid"));} %>">Profile</a></li>
                    <li class="menuitem"><a href="forum.jsp">Members Forum</a></li>
                    <li class="menuitem"><a href="ValidateLogout">Logout</a></li>
                </ul>
            </div>

            <div id="content">
                <h3>Create Post:</h3>
                <form action="forum.jsp" method="POST">
                    Title : <input type="text" name="title" value="" size="50"/><br/>
                    Message: <br/><textarea name="content" rows="2" cols="50"></textarea>
                    <input type="hidden" name="user" value="<% if (session.getAttribute("user") != null) {
               out.print(session.getAttribute("user"));
           } else {
               out.print("Anonymous");
           } %>"/><br/>
                    <input type="submit" value="Post" name="post"/>
                </form>

                <%

                <%
                    if (request.getParameter("post") != null) {                                             // Check if post button is clicked
                        String user = StringEscapeUtils.escapeHtml4(request.getParameter("user"));          // Get values from form
                        String content = StringEscapeUtils.escapeHtml4(request.getParameter("content"));    // Get values from form
                        String title = StringEscapeUtils.escapeHtml4(request.getParameter("title"));        // Get values from form

                        if (con != null && !con.isClosed()) {   // Check if connection is not null and not closed
                            PreparedStatement pstmt = con.prepareStatement("INSERT INTO posts(content, title, user) VALUES (?, ?, ?)");     // Prepare SQL statement
                            pstmt.setString(1, content);        // Set values for SQL statement
                            pstmt.setString(2, title);          // Set values for SQL statement
                            pstmt.setString(3, user);           // Set values for SQL statement
                            pstmt.executeUpdate();              // Execute SQL statement
                            out.print("Successfully posted");   // Print success message
                        }
                    }
                %>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <h3>List of Posts:</h3> 
                <%        
                    if (con != null && !con.isClosed()) {      // Check if connection is not null and not closed
                        PreparedStatement pstmt = con.prepareStatement("SELECT * FROM posts");    // Prepare SQL statement
                        ResultSet rs = pstmt.executeQuery();     // Execute SQL statement
                        out.println("<table border='1' width='80%'>");  // Print table
                        while (rs.next()) {    // Loop through result set
                            out.print("<tr>"); // Print table row
                            out.print("<td><a href='forumposts.jsp?postid=" + StringEscapeUtils.escapeHtml4(rs.getString("id")) + "'>" + StringEscapeUtils.escapeHtml4(rs.getString("title")) + "</a></td>"); // Print table data
                            out.print("<td> - Posted By "); // Print table data
                            out.print(StringEscapeUtils.escapeHtml4(rs.getString("user"))); // Print table data
                            out.println("</td></tr>"); // Print table data
                        }
                        out.println("</table>");
                    }
                %>

                <!-- [Footer Content] -->
            </div>
        </div>
    </body>
</html>
