/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package validate;

import dbconnection.DBConnect;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;


//--------------
// VULN 4 | Trust Boundary Violation / Part.1
import java.sql.PreparedStatement;
//--------------


import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author stephen
 */
public class ValidateLogin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user=request.getParameter("username").trim();
        String pass=request.getParameter("password").trim();

        try
             {
                 Connection con=new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));
                    if(con!=null && !con.isClosed())
                               {
                                   
                                   
                                   //--------------
                                   // VULN 4 | Trust Boundary Violation / Part.2
                                    PreparedStatement pstmt = null; // Initialize PreparedStatement variable
                                    ResultSet rs=null; // Initialize ResultSet variable
                                   
                                    String query = "SELECT * FROM users WHERE username=? AND password=?"; // Create PreparedStatement string
                                    pstmt = con.prepareStatement(query); // Prepare the prepared statement
                                    pstmt.setString(1, user); // Set the first parameter as the 'user'
                                    pstmt.setString(2, pass); // Set the second parameter as the 'pass'

                                    rs = pstmt.executeQuery(); // Execute the prepared statement
                                    //--------------
                                    
                                    
                                    if(rs != null && rs.next()){
                                        HttpSession session=request.getSession();
                                        session.setAttribute("userid", rs.getString("id"));
                                        session.setAttribute("user", rs.getString("username"));
                                        session.setAttribute("isLoggedIn", "1");
                                        
                                        
                                        //--------------
                                        // VULN 1 and VULN 2 | Cookie HttpOnly Flag / Cookie Secure Attribute
                                        Cookie privilege=new Cookie("privilege", getMD5(user));
                                        privilege.setHttpOnly(true);  // Set HttpOnly Flag
                                        privilege.setSecure(true);  // Set Secure Flag
                                        //--------------
                                        
                                        
                                        response.addCookie(privilege);
                                        response.sendRedirect("members.jsp");
                                   }
                                    
                               }
                }
               catch(Exception ex)
                {
                           response.sendRedirect("login.jsp");
                 }
        
        
    }
    
    private String getMD5(String user) {

        MessageDigest mdAlgorithm = null;
        
        
        //--------------
        // VULN 3 | Insufficient Hash
        try {
            mdAlgorithm = MessageDigest.getInstance("SHA-256");  // Change hashing algorithm from MD5 to SHA-256
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(ValidateLogin.class.getName()).log(Level.SEVERE, null, ex);
        }
        //--------------
        
        
        mdAlgorithm.update(user.getBytes());

        byte[] digest = mdAlgorithm.digest();
        StringBuffer hexString = new StringBuffer();

        for (int i = 0; i < digest.length; i++) {
            user = Integer.toHexString(0xFF & digest[i]);

            if (user.length() < 2) {
                user = "0" + user;
            }

            hexString.append(user);
        }

return hexString.toString();

        
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
