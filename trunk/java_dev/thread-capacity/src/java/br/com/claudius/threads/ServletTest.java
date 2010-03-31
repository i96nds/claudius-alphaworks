
package br.com.claudius.threads;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

public class ServletTest extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String num = request.getParameter("num_threads");
        if (num != null && num.trim().length() > 0) {
            NumThreads.CR = "<br>";
            NumThreads.psout = new PrintStream(response.getOutputStream());
            NumThreads.print("<html><body>");
            try {
                NumThreads.main(new String[]{num});
                
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            NumThreads.print("</body></html>");
        }
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
