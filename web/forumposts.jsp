<%-- 
    Document   : forumposts
    Created on : 10-Dec-2016, 16:11:57
    Author     : Stephen
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="dbconnection.DBConnect"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <title>We Love Trump!</title>
    </head>

    <body>
        <!-- Other HTML content -->

        <div id="content">
            <%
                // HTML ESCAPING METHOD - START
                // Method to escape HTML special chars
                private String escapeHtml(String input) {   // Method to escape HTML special chars
                    if(input == null) {                     // If input = null, return empty str
                        return "";
                    }
                    return input.replace("&", "&amp;")      // Replace special chars with HTML ents
                                .replace("<", "&lt;")       // to prevent XSS attacks
                                .replace(">", "&gt;")       // by escaping the input
                                .replace("\"", "&quot;")    // before displaying it
                                .replace("'", "&#x27;")     // on the page
                                .replace("/", "&#x2F;");    //
                    }
                // HTML ESCAPING METHOD - END

                Connection con = new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));
                String postid = request.getParameter("postid");
                if (postid != null) {
                    int postIdInt = Integer.parseInt(postid);
                    PreparedStatement pstmt = con.prepareStatement("SELECT * FROM posts WHERE id=?");
                    pstmt.setInt(1, postIdInt);
                    ResultSet rs = pstmt.executeQuery();
                    if (rs != null && rs.next()) {

                        // ORIGINAL CODE - START
                        // out.print("<b style='font-size:22px'>Title:" + rs.getString("title") + "</b>");
                        // out.print("<br/>-  Posted By " + rs.getString("user"));
                        // out.print("<br/><br/>Content:<br/>" + rs.getString("content"));
                        // ORIGINAL CODE - END

                        // CHANGED CODE FOR XSS MITIGATION - START
                        out.print("<b style='font-size:22px'>Title:" + escapeHtml(rs.getString("title")) + "</b>");     // Escape HTML special chars
                        out.print("<br/>-  Posted By " + escapeHtml(rs.getString("user")));                             // before
                        out.print("<br/><br/>Content:<br/>" + escapeHtml(rs.getString("content")));                     // displaying 
                        // CHANGED CODE FOR XSS MITIGATION - END
                    }  
                } else {
                    out.print("ID Parameter is Missing");
                }

                out.print("<br/><br/><a href='forum.jsp'>Return to Forum &gt;&gt;</a>");
            %>
        </div>
    </body>
</html>

