# StockFlow — Intelligent Inventory & Warehouse Management Ecosystem

[![Java EE](https://img.shields.io/badge/Java%20EE-8.0.1-blue.svg)](https://jakarta.ee/)
[![Build Tool](https://img.shields.io/badge/Maven-3.8+-C71A36.svg)](https://maven.apache.org/)
[![Database](https://img.shields.io/badge/MongoDB-4.11.1-47A248.svg)](https://www.mongodb.com/)
[![Security](https://img.shields.io/badge/Security-BCrypt%2012--Rounds-orange.svg)](https://www.mindrot.org/)
[![Testing](https://img.shields.io/badge/Tests-JUnit%205.10.2-25A162.svg)](https://junit.org/junit5/)
[![Packaging](https://img.shields.io/badge/Packaging-WAR-blueviolet.svg)](#deployment)

**StockFlow** is an enterprise-grade multi-portal inventory management and order fulfillment ecosystem designed for modern supply chains, multi-location distribution hubs, and client ordering flows. The ecosystem is split into two specialized web application modules:

1. [**`stockflow-customer`**](#1-stockflow-customer-enterprise-operations--customer-portal): Full-featured enterprise SaaS landing page, customer onboarding/authentication, MongoDB persistence engine, and operations command center dashboard.
2. [**`stockflow-user`**](#2-stockflow-user-smart-ordering--tracking-portal): Consumer & B2B ordering storefront featuring real-time SKU search, live hub inventory status, express ordering simulation, and shipment milestone tracking telemetry.

---

## 📑 Table of Contents

- [System Architecture](#-system-architecture)
- [Sub-Project Details](#-sub-project-details)
  - [1. stockflow-customer](#1-stockflow-customer-enterprise-operations--customer-portal)
  - [2. stockflow-user](#2-stockflow-user-smart-ordering--tracking-portal)
- [Repository Structure](#-repository-structure)
- [Technology Stack](#-technology-stack)
- [Database Schema & Data Models](#-database-schema--data-models)
- [Configuration & Environment Variables](#-configuration--environment-variables)
- [Build & Testing Guide](#-build--testing-guide)
- [Deployment Instructions](#-deployment-instructions)
- [Demo Credentials](#-demo-credentials-sandbox-mode)
- [Roadmap & Planned Integrations](#-roadmap--planned-integrations)

---

## 🏛 System Architecture

The StockFlow architecture separates the administrative/tenant lifecycle management from the end-user shopping and order telemetry stream:

```
                      +------------------------------------------+
                      |         StockFlow Cloud / Cluster        |
                      +------------------------------------------+
                                    |               |
             +----------------------+               +----------------------+
             |                                                             |
             v                                                             v
+------------------------------------+                    +------------------------------------+
|        stockflow-customer          |                    |          stockflow-user            |
|   (Enterprise / Tenant Portal)     |                    |    (Ordering & Tracking Portal)    |
+------------------------------------+                    +------------------------------------+
| - Landing Page & Plan Selection    |                    | - Real-Time SKU Catalog            |
| - BCrypt Secured Authentication    |                    | - Multi-Warehouse Inventory Status |
| - MongoDB Sync (tbl_customer_info) |                    | - Live Order Tracking Simulator    |
| - Multi-Hub Warehouse Dashboard    |                    | - Instant Order Placement Flow     |
| - Dynamic Configuration Loader     |                    | - Client Self-Service Onboarding   |
+------------------------------------+                    +------------------------------------+
                   \                                                         /
                    \                                                       /
                     +-------------------> MongoDB <-----------------------+
                                    (db_stockflow)
                                - tbl_customer_info
                                - customers / employees
                                - (Future: orders / skus)
```

---

## 📦 Sub-Project Details

### 1. `stockflow-customer` (Enterprise Operations & Customer Portal)

The `stockflow-customer` sub-project is a Jakarta EE / Java EE 8 web application providing enterprise customer registration, secure login, MongoDB data access objects, and a multi-warehouse operations telemetry command center.

#### ✨ Key Features
- **SaaS Marketing & Conversion Frontend (`index.jsp`)**: Modern dark-themed landing page showcasing live warehouse mockup telemetry, 4-stage operational workflows, dynamic annual/monthly pricing calculator with a 20% discount switch, customer testimonials, and interactive FAQ accordions.
- **Enterprise Authentication & Session Management**:
  - [`SignupServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/SignupServlet.java) (`/signup-auth`): Validates user inputs, verifies terms acceptance, hashes passwords via BCrypt (12 salt rounds), initializes 14-day trial subscriptions, persists into MongoDB, and provisions authenticated session state.
  - [`LoginServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/LoginServlet.java) (`/login-auth`): Supports dual login modes (Customer Portal & Warehouse Staff) against live MongoDB records with fallback demo credentials for sandbox evaluation.
  - [`LogoutServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/LogoutServlet.java) (`/logout`): Invalidation of HTTP sessions and secure redirection.
- **Enterprise Operations Dashboard (`customer/dashboard.jsp`)**:
  - KPI Metrics (Active SKUs, Inventory Valuation, Fulfillment Velocity %, Low Stock alerts).
  - Multi-facility warehouse telemetry table (Central Hub Bay A-12, East Coast Bay B-08, West Coast Bay C-02).
  - Real-time warehouse activity feed (PO stowing, courier dispatch batches, AI auto-replenishment).
- **Dynamic Configuration & Resilience (`MongoDBConnection.java`)**:
  - Automatically discovers and loads properties from `.env` files in root, parent, working directory, Catalina base, or classpath, with fallback to JVM/System environment variables.
  - Registers JVM shutdown hooks to cleanly dispose of MongoClient connection pools.
  - Automatically initializes unique sparse indexes on `email` and `customerId`.
- **Unit Test Coverage (`src/test/java`)**:
  - [`CustomerModelTest`](file:///F:/stockflow/stockflow-customer/src/test/java/com/inventory/stockflowcustomer/CustomerModelTest.java): Thorough BSON serialization/deserialization, subscription mapping, null-safety, and BCrypt validation tests.
  - [`MongoDBConnectionTest`](file:///F:/stockflow/stockflow-customer/src/test/java/com/inventory/stockflowcustomer/MongoDBConnectionTest.java): Environment variable resolution and MongoDB URI scheme validation.

---

### 2. `stockflow-user` (Smart Ordering & Tracking Portal)

The `stockflow-user` sub-project is dedicated to end-users, procurement managers, and commercial clients seeking fast inventory ordering with complete supply-chain visibility.

#### ✨ Key Features
- **Live Stock & Catalog Browser (`index.jsp`)**:
  - Real-time stock counts across regional fulfillment hubs (North, Central, West).
  - Dynamic client-side category filters (**Electronics**, **Office & Ergonomics**, **Peripherals & Accessories**).
  - Instant SKU and keyword search filter with smooth scrolling to matching product cards.
- **Order Placement Simulation**:
  - Quick-order trigger actions on catalog items with interactive toast notification feedback.
- **Live Order Tracking Simulator**:
  - Visual 4-stage milestone tracker: **Order Placed** ➔ **Packed** ➔ **In Transit** ➔ **Delivered**.
  - Dynamic tracking lookup by Order ID / Waybill number (e.g., `ORD-8924`).
- **Interactive Auth Modals & Mobile Navigation**:
  - Accessible tabbed login/signup modal with Google SSO triggers and client-side validation.
  - Mobile responsive drawer navigation with hamburger toggle.
- **Modular Package Scaffolding**:
  - Prepared Java packages for future business service extensions:
    - `com.inventory.stockflowuser.db`
    - `com.inventory.stockflowuser.order`
    - `com.inventory.stockflowuser.user`
  - Jakarta JPA [`persistence.xml`](file:///F:/stockflow/stockflow-user/src/main/resources/META-INF/persistence.xml) and CDI [`beans.xml`](file:///F:/stockflow/stockflow-user/src/main/resources/META-INF/beans.xml).

---

## 📂 Repository Structure

```
stockflow/
├── README.md                                  # Root Documentation (this file)
│
├── stockflow-customer/                        # Enterprise & Customer Management Module
│   ├── pom.xml                                # Maven configuration (Java EE 8, MongoDB, BCrypt, JUnit 5)
│   ├── mvnw / mvnw.cmd                        # Maven Wrapper executables
│   └── src/
│       ├── main/
│       │   ├── java/com/inventory/stockflowcustomer/
│       │   │   ├── LoginServlet.java          # Authentication endpoint (/login-auth)
│       │   │   ├── LogoutServlet.java         # Session cleanup endpoint (/logout)
│       │   │   ├── SignupServlet.java         # Onboarding & registration endpoint (/signup-auth)
│       │   │   ├── dao/
│       │   │   │   └── CustomerDAO.java       # MongoDB Data Access Object & query operations
│       │   │   ├── db/
│       │   │   │   └── MongoDBConnection.java # Singleton client, .env parser & index creator
│       │   │   └── model/
│       │   │       └── Customer.java          # Domain entity with nested Subscription BSON mapping
│       │   ├── resources/
│       │   │   └── META-INF/beans.xml         # CDI marker
│       │   └── webapp/
│       │       ├── WEB-INF/web.xml            # Servlet 4.0 configuration & session cookies
│       │       ├── index.jsp                  # Main SaaS landing & pricing page
│       │       ├── login.jsp / signup.jsp     # Root portal alias redirects
│       │       ├── dashboard.jsp              # Root dashboard alias redirect
│       │       └── customer/
│       │           ├── dashboard.jsp          # Enterprise inventory operations command center
│       │           ├── login.jsp              # Customer & staff login page
│       │           ├── signup.jsp             # Customer registration & trial plan selection
│       │           ├── css/                   # Stylesheets (style.css, login.css, signup.css)
│       │           └── js/                    # Interactive JS (main.js, login.js, signup.js)
│       └── test/
│           └── java/com/inventory/stockflowcustomer/
│               ├── CustomerModelTest.java     # Model BSON, equals, hashcode & BCrypt tests
│               └── MongoDBConnectionTest.java # Environment resolution tests
│
└── stockflow-user/                            # Consumer & B2B Ordering Storefront
    ├── pom.xml                                # Maven configuration (Java EE 8, JUnit 5)
    ├── mvnw / mvnw.cmd                        # Maven Wrapper executables
    └── src/
        ├── main/
        │   ├── java/com/inventory/stockflowuser/
        │   │   ├── db/                        # Future user-side persistence package
        │   │   ├── order/                     # Future order service package
        │   │   └── user/                      # Future user profile package
        │   ├── resources/
        │   │   └── META-INF/
        │   │       ├── beans.xml              # CDI configuration
        │   │       └── persistence.xml        # JPA persistence unit configuration
        │   └── webapp/
        │       ├── WEB-INF/web.xml            # Servlet 4.0 configuration
        │       ├── index.jsp                  # Ordering storefront & live tracking portal
        │       ├── css/style.css              # Custom styling, dark UI & responsive grids
        │       └── js/main.js                 # Catalog filter, tracking simulation & modal logic
        └── test/
            ├── java/                          # Test package directory
            └── resources/                     # Test resources directory
```

---

## 🛠 Technology Stack

| Layer / Component | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Language** | Java (JDK) | 1.8+ / 11 / 17 / 21 | Core backend programming language |
| **Enterprise Standard** | Java EE / Jakarta EE API | 8.0.1 (Servlet 4.0, JSP 2.3) | Web requests, sessions, filters, and rendering |
| **Build & Dependency Tool** | Apache Maven | 3.8+ | Build automation, packaging, and dependency management |
| **NoSQL Database** | MongoDB Sync Driver | 4.11.1 | Document storage, persistence, and indexing |
| **Password Security** | jBCrypt | 0.4 | 12-round salted cryptographic password hashing |
| **Unit Testing** | JUnit Jupiter (JUnit 5) | 5.10.2 | Unit testing and domain contract validation |
| **Frontend UI / Presentation** | JSP, HTML5, CSS3, ES6+ | Modern Standard | Responsive, high-performance UI without heavy frameworks |
| **Typography & Icons** | Plus Jakarta Sans, FontAwesome | 6.5.1 | Design system, visual indicators, and status badges |

---

## 🗄 Database Schema & Data Models

### MongoDB Collection: `tbl_customer_info`

Each customer document maps to the [`Customer`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/model/Customer.java) Java class:

```json
{
  "_id": ObjectId("65e8a1f2b4c1a23d4e5f6789"),
  "customerId": "65e8a1f2b4c1a23d4e5f6789",
  "fullName": "Jordan Vance",
  "companyName": "Apex Distro LLC",
  "companySize": "21-100",
  "email": "jordan.vance@apexdistro.com",
  "passwordHash": "$2a$12$e8xO9...hashedBCryptValue...",
  "role": "customer",
  "subscription": {
    "plan": "pro",
    "status": "trial",
    "trialStartDate": ISODate("2026-09-06T00:00:00.000Z"),
    "trialEndDate": ISODate("2026-09-20T00:00:00.000Z"),
    "billingCycle": "monthly"
  },
  "ssoProvider": {
    "provider": "local"
  },
  "termsAccepted": true,
  "termsAcceptedAt": ISODate("2026-09-06T00:00:00.000Z"),
  "lastLoginAt": ISODate("2026-09-06T12:00:00.000Z"),
  "createdAt": ISODate("2026-09-06T00:00:00.000Z"),
  "updatedAt": ISODate("2026-09-06T00:00:00.000Z")
}
```

#### Automated Indexes
- `email`: Ascending, Unique, Sparse
- `customerId`: Ascending, Unique, Sparse

---

## ⚙ Configuration & Environment Variables

The `MongoDBConnection` manager in `stockflow-customer` reads configuration values with hierarchical precedence:
1. **Operating System Environment Variables** (`System.getenv()`)
2. **Java System Properties** (`System.getProperty()`, e.g., `-Dmongodb.uri=...`)
3. **`.env` configuration file** in application root, parent directory, or classpath.

### Example `.env` Configuration File

Create a `.env` file in the root of the project or in `stockflow-customer`:

```env
# MongoDB Direct Connection URI (Atlas or Self-Hosted)
MONGODB_URI=mongodb+srv://<username>:<password>@<cluster-url>/db_stockflow?retryWrites=true&w=majority

# Target Database Name
MONGODB_DATABASE=db_stockflow

# Optional Disaggregated Credentials (if MONGODB_URI is not provided)
MONGODB_USER=your_db_username
MONGODB_PASSWORD=your_db_password
MONGODB_HOST=cluster0.example.mongodb.net
```

---

## 🔨 Build & Testing Guide

### Prerequisites
- **JDK 8 or higher** (JDK 11, 17, or 21 supported)
- **Apache Maven 3.8+** (or use the included `mvnw` wrapper scripts)

### 1. Build Both Sub-Projects

From the root directory, navigate into each sub-project and execute Maven package:

```bash
# Build stockflow-customer WAR
cd stockflow-customer
./mvnw clean package

# Build stockflow-user WAR
cd ../stockflow-user
./mvnw clean package
```

### 2. Run Unit Tests

Execute the test suites via Maven:

```bash
cd stockflow-customer
./mvnw test
```

---

## 🚀 Deployment Instructions

Both projects produce standard Web Application Archive (`.war`) files located in their respective `target/` directories:
- `stockflow-customer/target/stockflowcustomer-1.0-SNAPSHOT.war`
- `stockflow-user/target/stockflowuser-1.0-SNAPSHOT.war`

### Deploying to Apache Tomcat 9+ / 10+ (with Jakarta EE Migration tool or native Java EE 8):
1. Copy the generated `.war` files to the Tomcat `webapps/` folder:
   ```bash
   cp stockflow-customer/target/stockflowcustomer-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/stockflow-customer.war
   cp stockflow-user/target/stockflowuser-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/stockflow-user.war
   ```
2. Start Tomcat:
   ```bash
   # Linux / macOS
   $CATALINA_HOME/bin/startup.sh

   # Windows
   %CATALINA_HOME%\bin\startup.bat
   ```
3. Access the portals:
   - **Customer & Ops Portal**: `http://localhost:8085/stockflow-customer/`
   - **User Ordering Portal**: `http://localhost:8085/stockflow-user/`

---

## 🧪 Demo Credentials (Sandbox Mode)

For testing and offline evaluation without a live MongoDB instance, `stockflow-customer` includes built-in 1-click sandbox demo accounts:

| Role | Username / Email | Password | Access Scope |
| :--- | :--- | :--- | :--- |
| **Customer Admin** | `alex.morgan@acmelogistics.com` | `StockFlow2026!` | Customer Dashboard, SKU Telemetry, Replenishment |
| **Warehouse Staff** | `admin@stockflow.internal` | `AdminPass2026!` | Multi-Warehouse Operations, Picking & Dispatch Feed |

*(Use the **1-Click Demo Logins** buttons on the `/customer/login/login.jsp` page to auto-fill these credentials).*

---

## 🗺 Roadmap & Planned Integrations

- [ ] **Unified Order Flow**: Real-time propagation of orders placed in `stockflow-user` to the `stockflow-customer` operations dashboard table.
- [ ] **RESTful API Services**: JAX-RS / JSON endpoints for SKU inventory query and third-party ERP synchronization (NetSuite, Shopify, SAP).
- [ ] **Live WebSockets**: Push notifications for instantaneous milestone tracking updates and stock level deductions.
- [ ] **Automated Docker Compose**: Single command container orchestration running Tomcat instances alongside a local MongoDB service.

---

## 📄 License

This project is proprietary software belonging to the StockFlow project contributors. All rights reserved.
