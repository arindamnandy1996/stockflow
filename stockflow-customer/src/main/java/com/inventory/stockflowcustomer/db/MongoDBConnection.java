package com.inventory.stockflowcustomer.db;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import org.bson.Document;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Singleton database connection manager for MongoDB in StockFlow.
 * Reads connection settings, credentials, and database name dynamically from .env file or environment variables.
 */
public class MongoDBConnection {

    private static final Logger LOGGER = Logger.getLogger(MongoDBConnection.class.getName());

    private static final Map<String, String> ENV_CONFIG = new HashMap<>();

    private static volatile MongoClient mongoClient = null;
    private static volatile MongoDatabase database = null;
    private static final AtomicBoolean SHUTDOWN_HOOK_REGISTERED = new AtomicBoolean(false);

    static {
        loadDotEnv();
    }

    private MongoDBConnection() {}

    /**
     * Loads key-value pairs from .env file if available in working directory, parent directory, or classpath.
     */
    public static synchronized void loadDotEnv() {
        if (!ENV_CONFIG.isEmpty()) {
            return;
        }

        String catalinaBase = System.getProperty("catalina.base");
        String catalinaHome = System.getProperty("catalina.home");
        String userDir = System.getProperty("user.dir");

        // Try locating .env in common locations
        String[] potentialPaths = {
            ".env",
            "../.env",
            userDir != null ? userDir + File.separator + ".env" : null,
            catalinaBase != null ? catalinaBase + File.separator + ".env" : null,
            catalinaBase != null ? catalinaBase + File.separator + "conf" + File.separator + ".env" : null,
            catalinaHome != null ? catalinaHome + File.separator + ".env" : null,
            catalinaHome != null ? catalinaHome + File.separator + "conf" + File.separator + ".env" : null
        };

        boolean loaded = false;
        for (String path : potentialPaths) {
            if (path == null) continue;
            File envFile = new File(path);
            if (envFile.exists() && envFile.isFile() && envFile.canRead()) {
                try (BufferedReader reader = new BufferedReader(new FileReader(envFile))) {
                    parseEnvReader(reader);
                    LOGGER.info("Loaded environment configuration from file: " + envFile.getAbsolutePath());
                    loaded = true;
                    break;
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Could not read .env from " + path, e);
                }
            }
        }

        // Fallback: try loading from classpath as a resource stream across multiple ClassLoaders
        if (!loaded) {
            InputStream is = null;
            try {
                ClassLoader contextCl = Thread.currentThread().getContextClassLoader();
                if (contextCl != null) {
                    is = contextCl.getResourceAsStream(".env");
                }
                if (is == null) {
                    is = MongoDBConnection.class.getClassLoader().getResourceAsStream(".env");
                }
                if (is == null) {
                    is = MongoDBConnection.class.getResourceAsStream("/.env");
                }
                if (is != null) {
                    try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                        parseEnvReader(reader);
                        LOGGER.info("Loaded environment configuration from classpath .env");
                        loaded = true;
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.FINE, "Could not load .env from classpath", e);
            } finally {
                if (is != null) {
                    try { is.close(); } catch (Exception ignored) {}
                }
            }
        }
    }

    /**
     * Helper to parse lines from a .env reader.
     */
    private static void parseEnvReader(BufferedReader reader) throws Exception {
        String line;
        while ((line = reader.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty() || line.startsWith("#")) {
                continue;
            }
            int eqIdx = line.indexOf('=');
            if (eqIdx > 0) {
                String key = line.substring(0, eqIdx).trim();
                String value = line.substring(eqIdx + 1).trim();
                if ((value.startsWith("\"") && value.endsWith("\"")) || (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.substring(1, value.length() - 1);
                }
                ENV_CONFIG.put(key, value);
            }
        }
    }

    /**
     * Retrieves a configuration property looking first in System environment variables,
     * then Java System properties, and finally the loaded .env configuration.
     */
    public static String getProperty(String key, String defaultValue) {
        // 1. System environment
        String val = System.getenv(key);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }

        // 2. System properties (exact key or dot-separated lowercase)
        val = System.getProperty(key);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        val = System.getProperty(key.toLowerCase().replace('_', '.'));
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }

        // 3. Loaded .env properties (ensure dot env is loaded)
        if (ENV_CONFIG.isEmpty()) {
            loadDotEnv();
        }
        val = ENV_CONFIG.get(key);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }

        return defaultValue;
    }

    /**
     * Resolves the MongoDB connection URI from environment or credentials.
     */
    private static String resolveMongoUri() {
        // Direct URI check
        String uri = getProperty("MONGODB_URI", null);
        if (uri != null && !uri.trim().isEmpty()) {
            return uri.trim();
        }

        // Build from individual credentials if provided
        String user = getProperty("MONGODB_USER", null);
        String pass = getProperty("MONGODB_PASSWORD", null);
        String host = getProperty("MONGODB_HOST", null);

        if (user != null && pass != null && host != null) {
            return String.format("mongodb+srv://%s:%s@%s/", user, pass, host);
        }

        throw new IllegalStateException(
            "MongoDB URI is not configured. Please define MONGODB_URI (or MONGODB_USER, MONGODB_PASSWORD, MONGODB_HOST) in your .env file or environment variables."
        );
    }

    /**
     * Resolves the MongoDB database name from environment or .env configuration.
     */
    private static String resolveDatabaseName(ConnectionString connectionString) {
        String dbName = getProperty("MONGODB_DATABASE", null);
        if (dbName != null && !dbName.trim().isEmpty()) {
            return dbName.trim();
        }

        if (connectionString != null && connectionString.getDatabase() != null && !connectionString.getDatabase().trim().isEmpty()) {
            return connectionString.getDatabase().trim();
        }

        throw new IllegalStateException(
            "MongoDB database name is not configured. Please define MONGODB_DATABASE in your .env file or environment variables."
        );
    }

    /**
     * Retrieves the MongoDatabase instance, initializing the client if needed.
     */
    public static MongoDatabase getDatabase() {
        if (database == null) {
            synchronized (MongoDBConnection.class) {
                if (database == null) {
                    init();
                }
            }
        }
        return database;
    }

    /**
     * Convenience method to retrieve a specific MongoCollection.
     */
    public static MongoCollection<Document> getCollection(String collectionName) {
        return getDatabase().getCollection(collectionName);
    }

    /**
     * Initializes MongoDB client and sets up collection indexes.
     */
    private static void init() {
        try {
            String uriStr = resolveMongoUri();
            ConnectionString connectionString = new ConnectionString(uriStr);
            String dbName = resolveDatabaseName(connectionString);

            LOGGER.info("Connecting to MongoDB database: " + dbName);

            MongoClientSettings settings = MongoClientSettings.builder()
                    .applyConnectionString(connectionString)
                    .applyToSocketSettings(builder ->
                            builder.connectTimeout(5, TimeUnit.SECONDS)
                                   .readTimeout(10, TimeUnit.SECONDS))
                    .applyToClusterSettings(builder ->
                            builder.serverSelectionTimeout(5, TimeUnit.SECONDS))
                    .build();

            mongoClient = MongoClients.create(settings);
            database = mongoClient.getDatabase(dbName);

            ensureIndexes();

            // Register JVM shutdown hook once to close client cleanly
            if (SHUTDOWN_HOOK_REGISTERED.compareAndSet(false, true)) {
                Runtime.getRuntime().addShutdownHook(new Thread(MongoDBConnection::close));
            }
            LOGGER.info("MongoDB connection successfully initialized.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize MongoDB connection", e);
            throw new RuntimeException("MongoDB initialization failure: " + e.getMessage(), e);
        }
    }

    /**
     * Ensures necessary unique indexes are present in the MongoDB collections.
     */
    private static void ensureIndexes() {
        if (database == null) return;
        try {
            // Customer collections (supports both tbl_customer_info and customers)
            String[] customerCollections = {"tbl_customer_info", "customers"};
            for (String collName : customerCollections) {
                try {
                    MongoCollection<Document> collection = database.getCollection(collName);
                    collection.createIndex(Indexes.ascending("email"), new IndexOptions().unique(true).sparse(true));
                    collection.createIndex(Indexes.ascending("customerId"), new IndexOptions().unique(true).sparse(true));
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Index setup note for " + collName + ": " + e.getMessage());
                }
            }

            // Employee collection
            try {
                MongoCollection<Document> employees = database.getCollection("employees");
                employees.createIndex(Indexes.ascending("email"), new IndexOptions().unique(true).sparse(true));
                employees.createIndex(Indexes.ascending("employeeId"), new IndexOptions().unique(true).sparse(true));
            } catch (Exception e) {
                LOGGER.log(Level.FINE, "Index setup note for employees: " + e.getMessage());
            }

            LOGGER.info("MongoDB schema indexes checked/ensured successfully.");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Note: Index creation deferred or already exists: " + e.getMessage());
        }
    }

    /**
     * Closes the MongoDB client connection.
     */
    public static void close() {
        if (mongoClient != null) {
            try {
                mongoClient.close();
                mongoClient = null;
                database = null;
                LOGGER.info("MongoDB connection closed.");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error closing MongoDB client", e);
            }
        }
    }
}
