package com.inventory.stockflowcustomer.model;

import org.bson.Document;
import org.bson.types.ObjectId;

import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

/**
 * Customer domain model mapped to the MongoDB customer collection.
 */
public class Customer implements Serializable {

    private static final long serialVersionUID = 1L;

    private ObjectId id;
    private String customerId;
    private String fullName;
    private String companyName;
    private String companySize;
    private String email;
    private String passwordHash;
    private String role;
    private Subscription subscription;
    private boolean termsAccepted;
    private Date termsAcceptedAt;
    private Date lastLoginAt;
    private Date createdAt;
    private Date updatedAt;

    public Customer() {
        this.id = new ObjectId();
        this.customerId = this.id.toHexString();
        this.role = "customer";
        this.companySize = "1-20";
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    public Customer(String fullName, String companyName, String email, String passwordHash) {
        this();
        this.fullName = fullName;
        this.companyName = companyName;
        this.email = email != null ? email.trim().toLowerCase() : null;
        this.passwordHash = passwordHash;
    }

    // --- Inner Subscription Class ---
    public static class Subscription implements Serializable {
        private static final long serialVersionUID = 1L;

        private String plan; // starter, pro, enterprise
        private String status; // trial, active, past_due, cancelled
        private Date trialStartDate;
        private Date trialEndDate;
        private String billingCycle; // monthly, annual

        public Subscription() {
            this.plan = "pro";
            this.status = "trial";
            this.trialStartDate = new Date();
            this.billingCycle = "monthly";
        }

        public Subscription(String plan, String status, Date trialStartDate, Date trialEndDate, String billingCycle) {
            this.plan = (plan != null && !plan.trim().isEmpty()) ? plan.toLowerCase().trim() : "pro";
            this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "trial";
            this.trialStartDate = trialStartDate != null ? trialStartDate : new Date();
            this.trialEndDate = trialEndDate;
            this.billingCycle = (billingCycle != null && !billingCycle.trim().isEmpty()) ? billingCycle.trim() : "monthly";
        }

        public Document toDocument() {
            Document doc = new Document();
            doc.append("plan", plan != null ? plan.toLowerCase() : "pro");
            doc.append("status", status != null ? status : "trial");
            doc.append("trialStartDate", trialStartDate != null ? trialStartDate : new Date());
            doc.append("trialEndDate", trialEndDate);
            doc.append("billingCycle", billingCycle != null ? billingCycle : "monthly");
            return doc;
        }

        public static Subscription fromDocument(Document doc) {
            if (doc == null) return null;
            Subscription sub = new Subscription();
            String p = doc.getString("plan");
            String s = doc.getString("status");
            String b = doc.getString("billingCycle");
            if (p != null) sub.setPlan(p);
            if (s != null) sub.setStatus(s);
            if (b != null) sub.setBillingCycle(b);
            sub.setTrialStartDate(doc.getDate("trialStartDate"));
            sub.setTrialEndDate(doc.getDate("trialEndDate"));
            return sub;
        }

        public String getPlan() { return plan; }
        public void setPlan(String plan) {
            this.plan = (plan != null && !plan.trim().isEmpty()) ? plan.toLowerCase().trim() : "pro";
        }

        public String getStatus() { return status; }
        public void setStatus(String status) {
            this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "trial";
        }

        public Date getTrialStartDate() { return trialStartDate; }
        public void setTrialStartDate(Date trialStartDate) { this.trialStartDate = trialStartDate; }

        public Date getTrialEndDate() { return trialEndDate; }
        public void setTrialEndDate(Date trialEndDate) { this.trialEndDate = trialEndDate; }

        public String getBillingCycle() { return billingCycle; }
        public void setBillingCycle(String billingCycle) {
            this.billingCycle = (billingCycle != null && !billingCycle.trim().isEmpty()) ? billingCycle.trim() : "monthly";
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Subscription that = (Subscription) o;
            return Objects.equals(plan, that.plan) &&
                    Objects.equals(status, that.status) &&
                    Objects.equals(billingCycle, that.billingCycle);
        }

        @Override
        public int hashCode() {
            return Objects.hash(plan, status, billingCycle);
        }

        @Override
        public String toString() {
            return "Subscription{" +
                    "plan='" + plan + '\'' +
                    ", status='" + status + '\'' +
                    ", billingCycle='" + billingCycle + '\'' +
                    '}';
        }
    }

    /**
     * Converts this Customer object to a MongoDB Document.
     */
    public Document toDocument() {
        Document doc = new Document();
        if (id == null) {
            if (customerId != null && ObjectId.isValid(customerId)) {
                id = new ObjectId(customerId);
            } else {
                id = new ObjectId();
                customerId = id.toHexString();
            }
        }
        doc.append("_id", id);
        doc.append("customerId", customerId != null ? customerId : id.toHexString());
        doc.append("fullName", fullName != null ? fullName : "");
        doc.append("companyName", companyName != null ? companyName : "");
        doc.append("companySize", companySize != null ? companySize : "1-20");
        doc.append("email", email != null ? email.toLowerCase().trim() : null);
        doc.append("passwordHash", passwordHash);
        doc.append("role", role != null ? role : "customer");

        if (subscription != null) {
            doc.append("subscription", subscription.toDocument());
        }

        doc.append("ssoProvider", new Document("provider", "local"));
        doc.append("termsAccepted", termsAccepted);
        doc.append("termsAcceptedAt", termsAcceptedAt != null ? termsAcceptedAt : new Date());
        doc.append("lastLoginAt", lastLoginAt != null ? lastLoginAt : new Date());
        doc.append("createdAt", createdAt != null ? createdAt : new Date());
        doc.append("updatedAt", updatedAt != null ? updatedAt : new Date());

        return doc;
    }

    /**
     * Creates a Customer object from a MongoDB Document.
     */
    public static Customer fromDocument(Document doc) {
        if (doc == null) return null;
        Customer c = new Customer();
        ObjectId docId = doc.getObjectId("_id");
        if (docId != null) {
            c.setId(docId);
            c.setCustomerId(docId.toHexString());
        } else {
            String custId = doc.getString("customerId");
            c.setCustomerId(custId);
            if (custId != null && ObjectId.isValid(custId)) {
                c.setId(new ObjectId(custId));
            }
        }
        c.setFullName(doc.getString("fullName"));
        c.setCompanyName(doc.getString("companyName"));
        String size = doc.getString("companySize");
        c.setCompanySize(size != null ? size : "1-20");
        c.setEmail(doc.getString("email"));
        c.setPasswordHash(doc.getString("passwordHash"));
        String r = doc.getString("role");
        c.setRole(r != null ? r : "customer");

        Document subDoc = (Document) doc.get("subscription");
        if (subDoc != null) {
            c.setSubscription(Subscription.fromDocument(subDoc));
        }

        Boolean terms = doc.getBoolean("termsAccepted");
        c.setTermsAccepted(terms != null && terms);
        c.setTermsAcceptedAt(doc.getDate("termsAcceptedAt"));
        c.setLastLoginAt(doc.getDate("lastLoginAt"));
        c.setCreatedAt(doc.getDate("createdAt"));
        c.setUpdatedAt(doc.getDate("updatedAt"));

        return c;
    }

    // --- Getters & Setters ---
    public ObjectId getId() {
        if (id == null && customerId != null && ObjectId.isValid(customerId)) {
            id = new ObjectId(customerId);
        }
        return id;
    }

    public void setId(ObjectId id) {
        this.id = id;
        if (id != null) {
            this.customerId = id.toHexString();
        }
    }

    public String getCustomerId() {
        if (customerId == null && id != null) {
            this.customerId = id.toHexString();
        }
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
        if (customerId != null && ObjectId.isValid(customerId)) {
            this.id = new ObjectId(customerId);
        }
    }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getCompanySize() { return companySize; }
    public void setCompanySize(String companySize) { this.companySize = companySize; }

    public String getEmail() { return email; }
    public void setEmail(String email) {
        this.email = email != null ? email.toLowerCase().trim() : null;
    }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Subscription getSubscription() { return subscription; }
    public void setSubscription(Subscription subscription) { this.subscription = subscription; }

    public boolean isTermsAccepted() { return termsAccepted; }
    public void setTermsAccepted(boolean termsAccepted) { this.termsAccepted = termsAccepted; }

    public Date getTermsAcceptedAt() { return termsAcceptedAt; }
    public void setTermsAcceptedAt(Date termsAcceptedAt) { this.termsAcceptedAt = termsAcceptedAt; }

    public Date getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Date lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Customer customer = (Customer) o;
        if (email != null && customer.email != null) {
            return email.equalsIgnoreCase(customer.email);
        }
        if (customerId != null && customer.customerId != null) {
            return customerId.equals(customer.customerId);
        }
        return Objects.equals(id, customer.id);
    }

    @Override
    public int hashCode() {
        if (email != null) {
            return email.toLowerCase().hashCode();
        }
        if (customerId != null) {
            return customerId.hashCode();
        }
        return Objects.hashCode(id);
    }

    @Override
    public String toString() {
        return "Customer{" +
                "id=" + id +
                ", customerId='" + customerId + '\'' +
                ", fullName='" + fullName + '\'' +
                ", companyName='" + companyName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
