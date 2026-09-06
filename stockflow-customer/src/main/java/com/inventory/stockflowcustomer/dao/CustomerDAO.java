package com.inventory.stockflowcustomer.dao;

import com.inventory.stockflowcustomer.db.MongoDBConnection;
import com.inventory.stockflowcustomer.model.Customer;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

/**
 * Data Access Object for handling Customer persistence in MongoDB.
 */
public class CustomerDAO {

    private static final Logger LOGGER = Logger.getLogger(CustomerDAO.class.getName());
    public static final String COLLECTION_NAME = "tbl_customer_info";
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private static MongoCollection<Document> getCollection() {
        return MongoDBConnection.getDatabase().getCollection(COLLECTION_NAME);
    }

    /**
     * Checks if a customer record already exists with the given email address.
     */
    public static boolean existsByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        try {
            long count = getCollection().countDocuments(Filters.eq("email", email.trim().toLowerCase()));
            return count > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking email existence in MongoDB: " + email, e);
            throw new RuntimeException("Database error during email lookup: " + e.getMessage(), e);
        }
    }

    /**
     * Registers a new customer into the MongoDB collection.
     */
    public static Customer registerCustomer(String fullName,
                                            String companyName,
                                            String email,
                                            String plainPassword,
                                            String plan,
                                            String companySize,
                                            boolean termsAccepted) throws IllegalArgumentException {

        if (email == null || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            throw new IllegalArgumentException("Invalid email format");
        }
        if (plainPassword == null || plainPassword.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long");
        }

        String normalizedEmail = email.trim().toLowerCase();

        if (existsByEmail(normalizedEmail)) {
            throw new IllegalArgumentException("An account with this email already exists");
        }

        // 1. Hash the password with BCrypt
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

        // 2. Build Subscription with 14-day trial period
        Date now = new Date();
        Calendar cal = Calendar.getInstance();
        cal.setTime(now);
        cal.add(Calendar.DAY_OF_YEAR, 14);
        Date trialEndDate = cal.getTime();

        String normalizedPlan = (plan != null && !plan.trim().isEmpty()) ? plan.trim().toLowerCase() : "pro";
        Customer.Subscription subscription = new Customer.Subscription(
                normalizedPlan,
                "trial",
                now,
                trialEndDate,
                "monthly"
        );

        // 3. Build Customer Entity
        Customer customer = new Customer();
        customer.setFullName(fullName != null ? fullName.trim() : "");
        customer.setCompanyName(companyName != null ? companyName.trim() : "");
        customer.setCompanySize(companySize != null && !companySize.trim().isEmpty() ? companySize.trim() : "1-20");
        customer.setEmail(normalizedEmail);
        customer.setPasswordHash(hashedPassword);
        customer.setRole("customer");
        customer.setSubscription(subscription);
        customer.setTermsAccepted(termsAccepted);
        customer.setTermsAcceptedAt(now);
        customer.setLastLoginAt(now);
        customer.setCreatedAt(now);
        customer.setUpdatedAt(now);

        // 4. Convert to BSON Document and insert into MongoDB
        Document doc = customer.toDocument();
        getCollection().insertOne(doc);

        customer.setId(doc.getObjectId("_id"));
        LOGGER.info("Customer registered successfully in MongoDB. ID=" + customer.getCustomerId() + ", Email=" + normalizedEmail);

        return customer;
    }

    /**
     * Finds a customer by email address.
     */
    public static Customer findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        try {
            Document doc = getCollection().find(Filters.eq("email", email.trim().toLowerCase())).first();
            return Customer.fromDocument(doc);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error querying customer by email: " + email, e);
            return null;
        }
    }

    /**
     * Finds a customer by customerId string or ObjectId.
     */
    public static Customer findById(String customerId) {
        if (customerId == null || customerId.trim().isEmpty()) {
            return null;
        }
        try {
            Document doc = null;
            if (ObjectId.isValid(customerId.trim())) {
                doc = getCollection().find(Filters.or(
                        Filters.eq("_id", new ObjectId(customerId.trim())),
                        Filters.eq("customerId", customerId.trim())
                )).first();
            } else {
                doc = getCollection().find(Filters.eq("customerId", customerId.trim())).first();
            }
            return Customer.fromDocument(doc);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error querying customer by ID: " + customerId, e);
            return null;
        }
    }

    /**
     * Authenticates a customer against stored MongoDB credentials.
     */
    public static Customer authenticate(String email, String plainPassword) {
        if (email == null || plainPassword == null || plainPassword.trim().isEmpty()) {
            return null;
        }
        Customer customer = findByEmail(email.trim());
        if (customer != null && customer.getPasswordHash() != null) {
            try {
                if (BCrypt.checkpw(plainPassword, customer.getPasswordHash())) {
                    // Update last login timestamp
                    updateLastLogin(customer.getEmail());
                    return customer;
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Password check failed for: " + email, e);
            }
        }
        return null;
    }

    /**
     * Updates the lastLoginAt timestamp for a customer.
     */
    public static void updateLastLogin(String email) {
        if (email == null || email.trim().isEmpty()) return;
        try {
            getCollection().updateOne(
                    Filters.eq("email", email.trim().toLowerCase()),
                    Updates.set("lastLoginAt", new Date())
            );
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to update last login timestamp for: " + email, e);
        }
    }

    /**
     * Deletes a customer by email (useful for cleanup and test isolation).
     */
    public static boolean deleteByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        try {
            long deleted = getCollection().deleteOne(Filters.eq("email", email.trim().toLowerCase())).getDeletedCount();
            return deleted > 0;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to delete customer: " + email, e);
            return false;
        }
    }
}
