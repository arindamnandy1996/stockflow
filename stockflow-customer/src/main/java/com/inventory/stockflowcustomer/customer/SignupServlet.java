package com.inventory.stockflowcustomer.customer;

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
 * Handles new customer registration and trial onboarding for StockFlow,
 * persisting customer records into MongoDB.
 */
@WebServlet(name = "SignupServlet", urlPatterns = {"/signup-auth"})
public class SignupServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SignupServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String companyName = request.getParameter("companyName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String plan = request.getParameter("plan");
        String companySize = request.getParameter("companySize");
        String terms = request.getParameter("terms");

        if (plan == null || plan.trim().isEmpty()) {
            plan = "pro";
        }

        // Validate basic signup parameters
        boolean validFullName = fullName != null && fullName.trim().length() >= 2;
        boolean validCompany = companyName != null && !companyName.trim().isEmpty();
        boolean validEmail = email != null && email.contains("@") && email.contains(".");
        boolean validPassword = password != null && password.length() >= 8;
        boolean passwordMatch = validPassword && password.equals(confirmPassword);
        boolean agreedTerms = "on".equalsIgnoreCase(terms) || "true".equalsIgnoreCase(terms) || Boolean.parseBoolean(terms);

        if (!passwordMatch) {
            response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=password_mismatch");
            return;
        }

        if (!agreedTerms) {
            response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=terms");
            return;
        }

        if (!validFullName || !validCompany || !validEmail) {
            response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=invalid");
            return;
        }

        try {
            // Check for existing customer email
            if (CustomerDAO.existsByEmail(email.trim())) {
                LOGGER.warning("Signup failed: Email already registered -> " + email);
                response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=exists");
                return;
            }

            // Persist the customer into MongoDB
            Customer customer = CustomerDAO.registerCustomer(
                    fullName.trim(),
                    companyName.trim(),
                    email.trim(),
                    password,
                    plan.trim(),
                    companySize != null ? companySize.trim() : "1-20",
                    true
            );

            // Establish authenticated customer session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", customer.getFullName());
            session.setAttribute("customerId", customer.getCustomerId());
            session.setAttribute("role", customer.getRole());
            session.setAttribute("company", customer.getCompanyName());
            session.setAttribute("email", customer.getEmail());
            session.setAttribute("plan", customer.getSubscription() != null ? customer.getSubscription().getPlan() : plan);
            session.setAttribute("companySize", customer.getCompanySize());
            session.setAttribute("authTime", System.currentTimeMillis());

            LOGGER.info("Customer registration successful: " + customer.getEmail() + " [ID: " + customer.getCustomerId() + "]");

            // Redirect straight into customer portal dashboard
            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp?status=registered");

        } catch (IllegalArgumentException ex) {
            LOGGER.log(Level.WARNING, "Registration validation error: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=" + (ex.getMessage().contains("already exists") ? "exists" : "invalid"));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Database error during customer registration", ex);
            response.sendRedirect(request.getContextPath() + "/customer/signup/signup.jsp?error=db_error");
        }
    }
}
