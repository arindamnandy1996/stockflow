package com.inventory.stockflowcustomer;

import com.inventory.stockflowcustomer.db.MongoDBConnection;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit test verifying MongoDBConnection configuration and environment resolution.
 */
public class MongoDBConnectionTest {

    @Test
    @DisplayName("Test Property Resolution from .env file or environment")
    public void testDotEnvPropertyResolution() {
        String mongoUri = MongoDBConnection.getProperty("MONGODB_URI", null);
        assertNotNull(mongoUri, "MONGODB_URI should be resolved from .env or environment");
        assertTrue(mongoUri.startsWith("mongodb"), "MONGODB_URI should be a valid MongoDB URI scheme");

        String dbName = MongoDBConnection.getProperty("MONGODB_DATABASE", null);
        assertNotNull(dbName, "MONGODB_DATABASE should be resolved from .env or environment");
        assertEquals("db_stockflow", dbName);

        String user = MongoDBConnection.getProperty("MONGODB_USER", null);
        assertNotNull(user, "MONGODB_USER should be resolved from .env");
        assertEquals("anandyaws1996_db_user", user);
    }
}
