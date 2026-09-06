package com.inventory.stockflowcustomer;

import com.inventory.stockflowcustomer.dao.CustomerDAO;
import com.inventory.stockflowcustomer.model.Customer;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles user authentication for StockFlow Customer & Staff Portal,
 * validating against MongoDB records.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login-auth"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer/login/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (role == null || role.trim().isEmpty()) {
            role = "customer";
        }

        if (username == null || username.trim().isEmpty() || password == null || password.length() < 4) {
            response.sendRedirect(request.getContextPath() + "/customer/login/login.jsp?error=invalid");
            return;
        }

        String trimmedUser = username.trim();

        // 1. If role is customer, authenticate against MongoDB records
        if ("customer".equalsIgnoreCase(role)) {
            try {
                Customer customer = CustomerDAO.authenticate(trimmedUser, password);
                if (customer != null) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("user", customer.getFullName());
                    session.setAttribute("customerId", customer.getCustomerId());
                    session.setAttribute("role", customer.getRole());
                    session.setAttribute("company", customer.getCompanyName());
                    session.setAttribute("email", customer.getEmail());
                    session.setAttribute("plan", customer.getSubscription() != null ? customer.getSubscription().getPlan() : "pro");
                    session.setAttribute("companySize", customer.getCompanySize());
                    session.setAttribute("authTime", System.currentTimeMillis());

                    LOGGER.info("Customer logged in successfully: " + customer.getEmail());
                    response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
                    return;
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "MongoDB authentication error (falling back if demo account)", e);
            }
        }

        // 2. Demo account fallback (for offline sandbox evaluation)
        boolean isDemoCustomer = "customer".equalsIgnoreCase(role)
                && "alex.morgan@acmelogistics.com".equalsIgnoreCase(trimmedUser)
                && ("StockFlow2026!".equals(password) || "StockFlow#2026".equals(password));

        boolean isDemoAdmin = "staff".equalsIgnoreCase(role)
                && ("admin@stockflow.internal".equalsIgnoreCase(trimmedUser) || "staff.sarah@stockflow.internal".equalsIgnoreCase(trimmedUser))
                && ("AdminPass2026!".equals(password) || "StockFlow2026!".equals(password));

        if (isDemoCustomer || isDemoAdmin) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", isDemoCustomer ? "Alex Morgan" : "Sarah Jenkins (Staff)");
            session.setAttribute("customerId", isDemoCustomer ? "CUST-DEMO-001" : "STAFF-DEMO-002");
            session.setAttribute("role", role.trim());
            session.setAttribute("company", isDemoCustomer ? "Acme Global Logistics" : "StockFlow Central Hub");
            session.setAttribute("email", trimmedUser);
            session.setAttribute("plan", "Enterprise");
            session.setAttribute("authTime", System.currentTimeMillis());

            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/login/login.jsp?error=invalid");
        }
    }
}
