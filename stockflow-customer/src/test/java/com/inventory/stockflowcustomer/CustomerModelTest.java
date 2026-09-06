package com.inventory.stockflowcustomer;

import com.inventory.stockflowcustomer.model.Customer;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit test suite verifying Customer domain model, BSON conversions,
 * subscription mapping, equality contracts, and password hashing security.
 */
public class CustomerModelTest {

    @Test
    @DisplayName("Test Customer Document BSON Serialization and Deserialization")
    public void testCustomerDocumentSerialization() {
        Customer customer = new Customer();
        ObjectId testId = new ObjectId();
        customer.setId(testId);
        customer.setFullName("Jordan Vance");
        customer.setCompanyName("Apex Distro LLC");
        customer.setCompanySize("21-100");
        customer.setEmail("jordan.vance@apexdistro.com");

        String plainPassword = "SecurePassword#2026";
        String hashed = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
        customer.setPasswordHash(hashed);

        customer.setRole("customer");
        customer.setTermsAccepted(true);
        customer.setTermsAcceptedAt(new Date());

        Customer.Subscription sub = new Customer.Subscription("pro", "trial", new Date(), new Date(), "monthly");
        customer.setSubscription(sub);

        Document doc = customer.toDocument();

        assertNotNull(doc);
        assertEquals(testId, doc.getObjectId("_id"));
        assertEquals(testId.toHexString(), doc.getString("customerId"));
        assertEquals("Jordan Vance", doc.getString("fullName"));
        assertEquals("Apex Distro LLC", doc.getString("companyName"));
        assertEquals("21-100", doc.getString("companySize"));
        assertEquals("jordan.vance@apexdistro.com", doc.getString("email"));
        assertTrue(BCrypt.checkpw(plainPassword, doc.getString("passwordHash")));
        assertEquals("customer", doc.getString("role"));
        assertTrue(doc.getBoolean("termsAccepted"));

        // Test Deserialization
        Customer reconstructed = Customer.fromDocument(doc);
        assertNotNull(reconstructed);
        assertEquals(testId, reconstructed.getId());
        assertEquals(testId.toHexString(), reconstructed.getCustomerId());
        assertEquals(customer.getEmail(), reconstructed.getEmail());
        assertEquals(customer.getCompanyName(), reconstructed.getCompanyName());
        assertEquals(customer.getCompanySize(), reconstructed.getCompanySize());
        assertEquals(customer.getSubscription().getPlan(), reconstructed.getSubscription().getPlan());
        assertEquals("monthly", reconstructed.getSubscription().getBillingCycle());
    }

    @Test
    @DisplayName("Test Subscription Model Defaults, Serialization, and Equality")
    public void testSubscriptionModel() {
        Customer.Subscription subDefault = new Customer.Subscription();
        assertEquals("pro", subDefault.getPlan());
        assertEquals("trial", subDefault.getStatus());
        assertEquals("monthly", subDefault.getBillingCycle());
        assertNotNull(subDefault.getTrialStartDate());

        Date now = new Date();
        Date trialEnd = new Date(now.getTime() + 14L * 24 * 60 * 60 * 1000);
        Customer.Subscription subCustom = new Customer.Subscription("enterprise", "active", now, trialEnd, "annual");
        assertEquals("enterprise", subCustom.getPlan());
        assertEquals("active", subCustom.getStatus());
        assertEquals("annual", subCustom.getBillingCycle());

        Document subDoc = subCustom.toDocument();
        assertNotNull(subDoc);
        assertEquals("enterprise", subDoc.getString("plan"));
        assertEquals("active", subDoc.getString("status"));
        assertEquals("annual", subDoc.getString("billingCycle"));

        Customer.Subscription fromDoc = Customer.Subscription.fromDocument(subDoc);
        assertNotNull(fromDoc);
        assertEquals(subCustom, fromDoc);
        assertEquals(subCustom.hashCode(), fromDoc.hashCode());
        assertEquals(subCustom.toString(), fromDoc.toString());
    }

    @Test
    @DisplayName("Test Customer Default Values and Null Safety")
    public void testCustomerDefaultsAndNullSafety() {
        Customer customer = new Customer("Alex Morgan", "Acme Logistics", "alex.morgan@acmelogistics.com", "hash123");
        assertNotNull(customer.getId());
        assertNotNull(customer.getCustomerId());
        assertEquals("customer", customer.getRole());
        assertEquals("Alex Morgan", customer.getFullName());
        assertEquals("Acme Logistics", customer.getCompanyName());
        assertEquals("alex.morgan@acmelogistics.com", customer.getEmail());
        assertEquals("1-20", customer.getCompanySize());
        assertNotNull(customer.getCreatedAt());
        assertNotNull(customer.getUpdatedAt());

        assertNull(Customer.fromDocument(null));
        assertNull(Customer.Subscription.fromDocument(null));
    }

    @Test
    @DisplayName("Test Customer Equals and HashCode Consistency")
    public void testCustomerEqualsAndHashCode() {
        Customer c1 = new Customer("Alex Morgan", "Acme Logistics", "alex@acme.com", "hash");
        Customer c2 = new Customer("Alex M.", "Acme Corp", "alex@acme.com", "otherHash");
        Customer c3 = new Customer("Other User", "Other Corp", "other@acme.com", "hash");

        assertEquals(c1, c2);
        assertEquals(c1.hashCode(), c2.hashCode());
        assertNotEquals(c1, c3);
        assertNotEquals(c1, null);
        assertNotEquals(c1, "some-string");
    }

    @Test
    @DisplayName("Test BCrypt Password Hashing and Verification Logic")
    public void testBCryptPasswordVerification() {
        String plain = "StockFlow2026!";
        String hash = BCrypt.hashpw(plain, BCrypt.gensalt(10));

        assertTrue(BCrypt.checkpw(plain, hash));
        assertFalse(BCrypt.checkpw("WrongPassword", hash));
    }

    @Test
    @DisplayName("Test Customer Setters Normalization")
    public void testCustomerSettersNormalization() {
        Customer customer = new Customer();
        customer.setEmail("  TEST.USER@Domain.COM  ");
        assertEquals("test.user@domain.com", customer.getEmail());

        ObjectId oid = new ObjectId();
        customer.setCustomerId(oid.toHexString());
        assertEquals(oid, customer.getId());
        assertEquals(oid.toHexString(), customer.getCustomerId());
    }
}
