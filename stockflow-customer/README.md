# StockFlow Customer & Warehouse Intelligence Portal (`stockflow-customer`)

> **Next-Generation Inventory, Warehouse Fleet & Logistics Management System**  
> Enterprise Customer Onboarding, Role-Based Authentication, Real-Time SKU Telemetry, and Multi-Node Warehouse Facility Command.

---

## 📌 Table of Contents
1. [Overview](#-overview)
2. [Key Capabilities](#-key-capabilities)
   - [Marketing & Onboarding Portal](#marketing--onboarding-portal)
   - [Customer Intelligence Command Center](#customer-intelligence-command-center)
   - [Warehouse Facility & Fleet Management](#warehouse-facility--fleet-management)
   - [Authentication & Security](#authentication--security)
3. [Technology Stack](#-technology-stack)
4. [Architecture & Workflow](#-architecture--workflow)
   - [Architectural Topology](#architectural-topology)
   - [End-to-End Registration & Auth Flow](#end-to-end-registration--auth-flow)
   - [Warehouse Provisioning & Fleet Telemetry Flow](#warehouse-provisioning--fleet-telemetry-flow)
5. [Database Design & Data Models](#-database-design--data-models)
   - [Customer Document Schema (`tbl_customer_info`)](#customer-document-schema-tbl_customer_info)
   - [Warehouse Facility Data Model](#warehouse-facility-data-model)
   - [Auto-Configured MongoDB Indexes](#auto-configured-mongodb-indexes)
6. [Project Structure](#-project-structure)
7. [Configuration & Environment Variables](#-configuration--environment-variables)
8. [Getting Started & Local Setup](#-getting-started--local-setup)
   - [Prerequisites](#prerequisites)
   - [Building the Application](#building-the-application)
   - [Running Unit Tests](#running-unit-tests)
   - [Deployment on Apache Tomcat](#deployment-on-apache-tomcat)
   - [Application Endpoints & Routes](#application-endpoints--routes)
9. [Demo Sandbox Accounts](#-demo-sandbox-accounts)
10. [Security Implementation](#-security-implementation)

---

## 📖 Overview

**`stockflow-customer`** is the enterprise customer-facing and facility operations web portal of the **StockFlow** logistics and supply chain ecosystem. Built on high-performance Java EE Servlet technology, modern vanilla JavaScript, and backed by MongoDB Atlas, it equips B2B organizations, 3PL providers, warehouse supervisors, and retail operators with complete control over inventory, customer onboarding, multi-node warehouse facilities, and IoT edge telemetry.

### Core Objectives
* **Seamless Onboarding**: Self-service signup with automated 14-day Pro/Enterprise trial provisioning.
* **Granular Security**: Enterprise-grade password hashing with salted **BCrypt** and secure session management.
* **Operational Command Center**: Real-time SKU visibility, turnover tracking, restock triggers, and carrier dispatches.
* **Multi-Node Fleet Control**: Multi-facility configuration, zone partitioning, environmental climate regulation, and live IoT sensor telemetry feeds.

---

## 🚀 Key Capabilities

### Marketing & Onboarding Portal
* **Enterprise Landing Page (`/index.jsp`)**:
  * Product capability showcase (multi-warehouse visibility, barcode & RFID scanning, AI demand forecasting).
  * Interactive pricing calculator supporting monthly and annual billing (with automatic 20% discount calculation).
  * Interactive SKU movement preview and live warehouse velocity telemetry.
  * Customer case studies, social proof metrics, and collapsible FAQ accordion.
* **Self-Service Registration (`/signup-auth`, `/customer/signup/signup.jsp`)**:
  * Real-time password strength analyzer with constraint validation.
  * Plan selection (Starter, Pro, Enterprise) with instant 14-day trial period calculation (`trialStartDate` and `trialEndDate`).
  * Automated document persistence to MongoDB collection `tbl_customer_info`.

### Customer Intelligence Command Center
* **Operational Dashboard (`/customer/dashboard.jsp`)**:
  * Real-time KPI summaries: Total Active SKUs, Stock Valuation ($3.42M+), Fulfillment Velocity (99.8%), and Low Stock Restock Alerts.
  * Live SKU Location & Telemetry table featuring bay allocations, stock levels, safety thresholds, and replenishment status flags.
  * Real-time warehouse activity feed (Inbound PO receipts, carrier dispatch notifications, AI demand adjustments).
  * Safe XSS escaping across all dynamic session attributes and company metadata.

### Warehouse Facility & Fleet Management
* **Connected Warehouse Fleet Directory (`/warehouse/show-warehouses.jsp`)**:
  * Global multi-facility directory across 6+ international corridors (USA, Canada, UK, Germany, Singapore, Australia).
  * Live search, classification filtering (Regional Fulfillment, Distribution Centers, Micro-Fulfillment, Cold Storage, Cross-Dock, Bonded FTZ), and multi-attribute sorting.
  * **IoT Sensor Telemetry Modal**: Live inspection of ambient temperature, relative humidity, bay occupancy, dock door utilization, and real-time RFID gate portal scanning stream.
  * **Facility Specifications Modal**: Comprehensive breakdown of structural dimensions, clear heights, pallet capacities, zoned storage partitions, and facility manager contact details.
  * **Fleet Data Export**: One-click export of complete warehouse fleet data in **CSV** or **JSON** format.
* **Facility Provisioning & Configuration (`/warehouse/new-warehouse.jsp`)**:
  * Multi-section facility setup: Identification, Geo-Logistics, Structural Capacity, Partitioned Storage Zones, and Shift Management.
  * **Instant Architecture Presets**:
    * *Automated E-Commerce Mega-Hub* (120,000 sq ft, 8,500 pallets, 16 dock doors)
    * *Cold-Chain Pharma Depot* (45,000 sq ft, 3,200 pallets, chilled refrigeration 2°C–8°C)
    * *Urban Micro-Fulfillment Center* (18,000 sq ft, 1,400 pallets, high-velocity pick modules)
    * *Maritime Bonded Cross-Dock* (95,000 sq ft, 7,000 pallets, customs bonded)
  * Real-time topology preview card updating dynamically with user inputs.
  * Interactive zone manager (add/remove storage partitions, high-velocity racks, mezzanine bins, biometric vaults).
  * In-place update mode and safe facility decommissioning workflows with audit reason tracking.

### Authentication & Security
* **Multi-Role Authentication (`/login-auth`, `/customer/login/login.jsp`)**:
  * Dual-portal role selection (`customer` vs `staff`).
  * MongoDB credential verification using salted BCrypt.
  * In-memory demo account fallbacks for offline sandbox demonstration and quick reviews.
  * Automatic `lastLoginAt` auditing in MongoDB.
  * Secure session handling with `HttpOnly` cookies and 60-minute inactivity expiration.

---

## 🛠 Technology Stack

| Layer | Technology | Version / Spec | Purpose |
| :--- | :--- | :--- | :--- |
| **Language & Platform** | Java | Java SE 8 (1.8) / Java EE 8 | Core runtime, business logic, and web tier |
| **Servlet Container** | Java Servlet / JSP | Servlet 4.0, JSP 2.3 | Request handling, routing, and view rendering |
| **Database** | MongoDB & MongoDB Atlas | v4.4 - v7.0+ | Document store for customers, telemetry, and facilities |
| **Database Driver** | MongoDB Java Sync Driver | `4.11.1` | Native thread-safe synchronous database driver |
| **Cryptography / Security** | jBCrypt | `0.4` | Salted Blowfish-based password hashing (12 rounds) |
| **Build & Packaging** | Apache Maven | Maven 3.6+ (`war` packaging) | Dependency resolution, packaging, and lifecycle management |
| **Unit Testing** | JUnit Jupiter | `5.10.2` | Test execution framework for models and configuration |
| **Frontend Styling** | Modern CSS3 | Custom Glassmorphism | Dark theme, responsive grid layouts, responsive navigation |
| **Typography & Icons** | Google Fonts & FontAwesome | Plus Jakarta Sans, JetBrains Mono, FA 6.5.1 | Enterprise aesthetics and crisp data visualization |
| **Client Scripting** | Vanilla JavaScript | ES6+ | Real-time calculations, sensor simulation, dynamic DOM, exports |

---

## 🔄 Architecture & Workflow

### Architectural Topology

```mermaid
flowchart TD
    subgraph ClientLayer ["Client Browser Layer"]
        LP["Landing Page<br/>(/index.jsp)"]
        SU["Signup Portal<br/>(/customer/signup/signup.jsp)"]
        LG["Login Portal<br/>(/customer/login/login.jsp)"]
        DB["Customer Dashboard<br/>(/customer/dashboard.jsp)"]
        WH_SHOW["Fleet Directory<br/>(/warehouse/show-warehouses.jsp)"]
        WH_NEW["Facility Setup<br/>(/warehouse/new-warehouse.jsp)"]
    end

    subgraph ControllerLayer ["Java EE Servlet Controller Layer"]
        SignupSrv["SignupServlet<br/>(/signup-auth)"]
        LoginSrv["LoginServlet<br/>(/login-auth)"]
        LogoutSrv["LogoutServlet<br/>(/logout)"]
    end

    subgraph BusinessLayer ["Data Access & Business Layer"]
        CDAO["CustomerDAO"]
        BCryptEngine["BCrypt Cryptographic Engine<br/>(12 Salt Rounds)"]
        ConnMgr["MongoDBConnection<br/>(Thread-Safe Singleton)"]
        EnvLoader["DotEnv & SysEnv Loader"]
    end

    subgraph PersistenceLayer ["MongoDB Database"]
        CustTbl[("tbl_customer_info / customers<br/>(User Credentials & Subscriptions)")]
        EmpTbl[("employees<br/>(Staff & Worker Profiles)")]
    end

    LP -->|Explore Plans| SU
    LP -->|Sign In| LG
    SU -->|POST Registration| SignupSrv
    LG -->|POST Authentication| LoginSrv
    DB -->|Manage Facilities| WH_SHOW
    DB -->|Provision Hub| WH_NEW
    DB -->|Sign Out| LogoutSrv

    SignupSrv -->|1. Validate & Hash| BCryptEngine
    SignupSrv -->|2. Register Customer| CDAO
    LoginSrv -->|1. Authenticate Credentials| CDAO
    CDAO -->|Verify Salted Hash| BCryptEngine
    LogoutSrv -->|Invalidate Session| LG

    CDAO --> ConnMgr
    ConnMgr --> EnvLoader
    ConnMgr -->|Read / Write Documents| CustTbl
    ConnMgr -->|Ensure Unique Indexes| EmpTbl

    SignupSrv -->|Create Session & Redirect| DB
    LoginSrv -->|Create Session & Redirect| DB
    WH_SHOW <-->|Fleet Topology & IoT Sensors| WH_NEW
```

---

### End-to-End Registration & Auth Flow

```mermaid
sequenceDiagram
    autonumber
    actor User as Customer / User
    participant Browser as Client Browser
    participant Servlet as SignupServlet / LoginServlet
    participant DAO as CustomerDAO
    participant DB as MongoDB (tbl_customer_info)
    participant Session as HttpSession

    Note over User, DB: 1. Self-Service Customer Registration Flow
    User->>Browser: Submit Signup Form (Name, Email, Password, Company, Plan)
    Browser->>Servlet: POST /signup-auth
    Servlet->>DAO: existsByEmail(email)
    DAO->>DB: countDocuments({ email: normalizedEmail })
    DB-->>DAO: 0 (No existing account)
    Servlet->>DAO: registerCustomer(name, company, email, pwd, plan, size, terms)
    DAO->>DAO: BCrypt.hashpw(password, gensalt(12))
    DAO->>DAO: Calculate 14-day trial end date
    DAO->>DB: insertOne(customerDocument)
    DB-->>DAO: Insert Success (ObjectId)
    DAO-->>Servlet: Customer Entity
    Servlet->>Session: setAttribute(user, customerId, company, role, plan)
    Servlet-->>Browser: Redirect 302 -> /customer/dashboard.jsp?status=registered
    Browser->>User: Render Dashboard with Welcome Alert

    Note over User, DB: 2. Customer Authentication Flow
    User->>Browser: Submit Login Form (Email, Password, Role)
    Browser->>Servlet: POST /login-auth
    Servlet->>DAO: authenticate(email, password)
    DAO->>DB: find({ email: normalizedEmail })
    DB-->>DAO: Customer Document
    DAO->>DAO: BCrypt.checkpw(password, passwordHash)
    DAO->>DB: updateOne({ email }, { $set: { lastLoginAt: now() } })
    DAO-->>Servlet: Authenticated Customer Entity
    Servlet->>Session: setAttribute(user, customerId, company, role, plan, authTime)
    Servlet-->>Browser: Redirect 302 -> /customer/dashboard.jsp
    Browser->>User: Render Command Center Dashboard

    Note over User, DB: 3. Session Teardown Flow
    User->>Browser: Click Logout
    Browser->>Servlet: GET /logout
    Servlet->>Session: session.invalidate()
    Servlet-->>Browser: Redirect 302 -> /customer/login/login.jsp?msg=logged_out
    Browser->>User: Render Login Screen with Logout Confirmation
```

---

### Warehouse Provisioning & Fleet Telemetry Flow

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Customer Admin / Facility Manager
    participant UI as Warehouse UI (JSP + JS)
    participant Fleet as Fleet Store (Local & Session State)
    participant Edge as Edge IoT Simulator (Sensors & RFID)

    Admin->>UI: Navigate to Warehouse Directory (/warehouse/show-warehouses.jsp)
    UI->>Fleet: Load active warehouse nodes (13 default facilities)
    Fleet-->>UI: Render grid & list views with live status tags

    Admin->>UI: Click "Inspect Telemetry" on a Warehouse Node
    UI->>Edge: Query live telemetry for facility code (e.g. WH-CHI-01)
    Edge-->>UI: Stream sensor metrics (Temp: 20.4°C, Humidity: 42.8%, RFID Scan Stream)
    UI->>Admin: Display interactive Telemetry Inspector Modal

    Admin->>UI: Click "Provision New Facility" (/warehouse/new-warehouse.jsp)
    Admin->>UI: Select Preset (e.g. "Cold-Chain Pharma Depot")
    UI->>UI: Auto-populate zones, climate (-20°C to -10°C), clear height & pallet counts
    Admin->>UI: Adjust capacity / add custom partition zone
    Admin->>UI: Click "Provision Facility & Deploy Node"
    UI->>Fleet: Validate inputs & save new facility record
    Fleet-->>UI: Save Success
    UI->>Admin: Show success toast notification & redirect to Fleet Directory
```

---

## 🗄 Database Design & Data Models

### Customer Document Schema (`tbl_customer_info`)

Customer records are stored as flexible BSON documents with strict unique constraints on identity keys:

```json
{
  "_id": { "$oid": "66db81f21a4e123456789abc" },
  "customerId": "66db81f21a4e123456789abc",
  "fullName": "Jordan Vance",
  "companyName": "Apex Distro & Logistics LLC",
  "companySize": "21-100",
  "email": "jordan.vance@apexdistro.com",
  "passwordHash": "$2a$12$e8Yx9p1K0qZb...",
  "role": "customer",
  "subscription": {
    "plan": "pro",
    "status": "trial",
    "trialStartDate": { "$date": "2026-09-06T16:00:00.000Z" },
    "trialEndDate": { "$date": "2026-09-20T16:00:00.000Z" },
    "billingCycle": "monthly"
  },
  "ssoProvider": {
    "provider": "local"
  },
  "termsAccepted": true,
  "termsAcceptedAt": { "$date": "2026-09-06T16:00:00.000Z" },
  "lastLoginAt": { "$date": "2026-09-07T14:32:00.000Z" },
  "createdAt": { "$date": "2026-09-06T16:00:00.000Z" },
  "updatedAt": { "$date": "2026-09-06T16:00:00.000Z" }
}
```

### Warehouse Facility Data Model

Warehouse facility records encapsulate geo-logistics, structural capacities, environmental metrics, and partitioned bay zones:

```json
{
  "id": "wh-001",
  "name": "Central Logistics Hub",
  "code": "WH-CHI-01",
  "type": "Distribution Center",
  "status": "Active & Operational",
  "address": "7420 North Port Boulevard, Suite 100",
  "city": "Chicago",
  "state": "IL",
  "zip": "60666",
  "country": "United States",
  "zone": "Midwest Freight Hub • I-90",
  "area": 110000,
  "pallets": 8500,
  "docks": 16,
  "clearHeight": 36,
  "climate": "Standard Ambient (15°C - 25°C)",
  "manager": "Marcus Rivera",
  "email": "m.rivera@stockflow.io",
  "phone": "+1 (312) 555-0199",
  "shifts": "24/7 Continuous (3 Shifts)",
  "features": ["Hazmat Certified", "RFID Gates", "Customs Bonded", "IoT Sensor Mesh"],
  "zones": [
    { "name": "Zone A: High Velocity Pallets", "type": "Heavy Racking (Pallet-In Pallet-Out)", "capacity": 4500 },
    { "name": "Zone B: Case & Tote Pick Module", "type": "Mezzanine Shelving & Bins", "capacity": 2500 },
    { "name": "Zone C: Secure Vault / High-Value", "type": "Biometric Enclosed Caging", "capacity": 1500 }
  ]
}
```

### Auto-Configured MongoDB Indexes
On bootstrap, `MongoDBConnection.ensureIndexes()` automatically provisions unique sparse indexes to guarantee data integrity:
* `tbl_customer_info`: `email` (Ascending, Unique, Sparse), `customerId` (Ascending, Unique, Sparse)
* `customers`: `email` (Ascending, Unique, Sparse), `customerId` (Ascending, Unique, Sparse)
* `employees`: `email` (Ascending, Unique, Sparse), `employeeId` (Ascending, Unique, Sparse)

---

## 📂 Project Structure

```
stockflow-customer/
├── .env                                         # Environment variables & MongoDB connection config
├── .gitignore                                   # Git ignore rules
├── pom.xml                                      # Maven project descriptor & dependency configuration
├── mvnw / mvnw.cmd                              # Maven Wrapper executables (cross-platform)
├── README.md                                    # Comprehensive system documentation
├── src/
│   ├── main/
│   │   ├── java/com/inventory/stockflowcustomer/
│   │   │   ├── customer/
│   │   │   │   ├── LoginServlet.java            # POST /login-auth controller (BCrypt & demo auth)
│   │   │   │   ├── LogoutServlet.java           # GET /logout session invalidation controller
│   │   │   │   └── SignupServlet.java           # POST /signup-auth customer onboarding controller
│   │   │   ├── dao/
│   │   │   │   └── CustomerDAO.java             # MongoDB data access, BCrypt hashing, and queries
│   │   │   ├── db/
│   │   │   │   └── MongoDBConnection.java       # Singleton client manager, .env parser & indexer
│   │   │   └── model/
│   │   │       └── Customer.java                # Customer & Subscription domain entity with BSON mapping
│   │   ├── resources/
│   │   │   └── META-INF/
│   │   │       └── beans.xml                    # CDI configuration descriptor
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                      # Deployment descriptor (session timeout, cookie security)
│   │       ├── index.jsp                        # StockFlow Product Landing Page & Pricing Calculator
│   │       ├── dashboard.jsp                    # Root forwarder -> /customer/dashboard.jsp
│   │       ├── login.jsp                        # Root forwarder -> /customer/login/login.jsp
│   │       ├── signup.jsp                       # Root forwarder -> /customer/signup/signup.jsp
│   │       ├── customer/
│   │       │   ├── dashboard.jsp                # Customer Intelligence Command Center Dashboard
│   │       │   ├── login.jsp                    # Forwarder to login/login.jsp
│   │       │   ├── signup.jsp                   # Forwarder to signup/signup.jsp
│   │       │   ├── css/
│   │       │   │   ├── login.css                # Glassmorphic styling for login portal
│   │       │   │   ├── signup.css               # Multi-step styling for signup portal
│   │       │   │   └── style.css                # Global design system, sidebar, KPIs, tables
│   │       │   ├── js/
│   │       │   │   ├── login.js                 # Role toggling, demo fill, and client validation
│   │       │   │   ├── main.js                  # Navigation drawer, FAQ accordion, smooth scrolling
│   │       │   │   └── signup.js                # Password strength analyzer & signup validation
│   │       │   ├── login/
│   │       │   │   ├── index.jsp                # Login view alias
│   │       │   │   └── login.jsp                # Customer & Staff login portal
│   │       │   └── signup/
│   │       │       ├── index.jsp                # Signup view alias
│   │       │       └── signup.jsp               # Customer registration and trial selection view
│   │       └── warehouse/
│   │           ├── new-warehouse.jsp            # Facility provisioning, presets & topology editor
│   │           ├── show-warehouses.jsp          # Fleet directory, IoT telemetry modal & exports
│   │           ├── css/
│   │           │   ├── show-warehouses.css      # Grid/list views, filter pills, and modal styling
│   │           │   └── warehouse.css            # Facility form layout, zone cards, and preview panel
│   │           └── js/
│   │               ├── show-warehouses.js       # Fleet search, filter, CSV/JSON export, live telemetry
│   │               └── warehouse.js             # Preset templates, zone builder, and update logic
│   └── test/
│       └── java/com/inventory/stockflowcustomer/
│           ├── CustomerModelTest.java           # Model serialization, equals/hashCode, and BCrypt tests
│           └── MongoDBConnectionTest.java       # .env resolution and environment fallback tests
```

---

## ⚙ Configuration & Environment Variables

The application resolves database connection parameters using a cascading resolution hierarchy:
1. **Operating System Environment Variables** (`System.getenv`)
2. **Java System Properties** (`System.getProperty`)
3. **Local `.env` File** (automatically discovered from working directory, parent paths, Tomcat `conf/`, or classpath)

### Sample `.env` Configuration
Create a `.env` file in the project root or your Tomcat execution directory:

```ini
# =============================================================================
# StockFlow MongoDB Atlas Configuration
# =============================================================================

# Full MongoDB Connection URI (Atlas SRV or Standard)
MONGODB_URI=mongodb+srv://stockflow_admin:SecurePassword123@cluster0.abcde.mongodb.net/?retryWrites=true&w=majority&appName=StockFlowCluster

# Target Database Name
MONGODB_DATABASE=db_stockflow

# Optional Component Parameters (used if MONGODB_URI is not supplied)
# MONGODB_USER=stockflow_admin
# MONGODB_PASSWORD=SecurePassword123
# MONGODB_HOST=cluster0.abcde.mongodb.net
```

---

## 🚀 Getting Started & Local Setup

### Prerequisites
* **Java Development Kit (JDK)**: Version 8 or higher (Java 8, 11, 17, or 21 supported)
* **Maven**: Version 3.6+ (or use the packaged `./mvnw` / `mvnw.cmd`)
* **Servlet Container**: Apache Tomcat 9.x+ (or any Java EE 8 / Jakarta EE compatible container)
* **MongoDB**: MongoDB Atlas Cluster or local MongoDB instance (v4.4+)

### Building the Application
To compile all Java classes, validate resources, execute tests, and package the WAR artifact:

```bash
# On Windows (PowerShell / CMD)
.\mvnw.cmd clean package

# On Linux / macOS
./mvnw clean package
```

The compiled web application archive will be placed at:
```
target/stockflowcustomer-1.0-SNAPSHOT.war
```

### Running Unit Tests
Execute the JUnit Jupiter test suite:

```bash
# On Windows
.\mvnw.cmd test

# On Linux / macOS
./mvnw test
```

### Deployment on Apache Tomcat
1. Copy the generated `target/stockflowcustomer-1.0-SNAPSHOT.war` (or rename to `stockflowcustomer.war` / `ROOT.war`) into the Tomcat `webapps/` folder.
2. Place your `.env` configuration file in the Tomcat root directory or export the `MONGODB_URI` environment variable.
3. Start Tomcat:
   ```bash
   # Windows
   bin\catalina.bat run

   # Linux / macOS
   bin/catalina.sh run
   ```

### Application Endpoints & Routes

| Path | Purpose | Access |
| :--- | :--- | :--- |
| `http://localhost:8085/stockflowcustomer/` | Marketing & Product Landing Page | Public |
| `http://localhost:8085/stockflowcustomer/customer/signup/signup.jsp` | Customer Registration & Trial Onboarding | Public |
| `http://localhost:8085/stockflowcustomer/customer/login/login.jsp` | Customer & Staff Authentication Screen | Public |
| `http://localhost:8085/stockflowcustomer/customer/dashboard.jsp` | Customer Intelligence Command Center | Authenticated |
| `http://localhost:8085/stockflowcustomer/warehouse/show-warehouses.jsp` | Connected Warehouse Fleet Directory & Telemetry | Authenticated |
| `http://localhost:8085/stockflowcustomer/warehouse/new-warehouse.jsp` | Facility Provisioning & Topology Configuration | Authenticated |
| `http://localhost:8085/stockflowcustomer/logout` | Session Invalidation & Logout | Authenticated |

*(Note: Port `8085` or `8080` depends on your Tomcat `conf/server.xml` HTTP connector configuration).*

---

## 🔑 Demo Sandbox Accounts

For offline evaluation, automated demos, and sandbox reviews without an active database connection, the application supports pre-configured credentials:

| Role | Username / Email | Password | Access Scope |
| :--- | :--- | :--- | :--- |
| **Customer (Admin)** | `alex.morgan@acmelogistics.com` | `StockFlow2026!` | Customer Dashboard, Warehouse Directory, Facility Provisioning |
| **Customer (Admin Alt)** | `alex.morgan@acmelogistics.com` | `StockFlow#2026` | Customer Dashboard, Warehouse Directory, Facility Provisioning |
| **Staff / Operations** | `admin@stockflow.internal` | `AdminPass2026!` | Customer & Staff Management, System Telemetry |
| **Staff / Operations** | `staff.sarah@stockflow.internal` | `StockFlow2026!` | Staff Operations, Inbound POs & Logistics Fleet |

> **Tip**: On the login screen (`/customer/login/login.jsp`), you can click the quick-demo buttons to instantly populate these credentials.

---

## 🔒 Security Implementation

* **Salted BCrypt Password Hashing**: Passwords are never stored in plaintext. They are salted and hashed with `BCrypt.gensalt(12)` before writing to MongoDB.
* **Input Sanitization & Validation**:
  * Strict email regex validation (`^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$`).
  * Minimum 8-character password enforcement with matching confirmation checks.
  * Explicit terms and conditions acceptance verification.
* **XSS Prevention**: JSP scriptlets utilize custom HTML escaping (`escapeHtml`) on all user-controlled session variables (`user`, `company`, `role`, `customerId`).
* **Session Hardening**:
  * `web.xml` enforces `<http-only>true</http-only>` session cookies to prevent client-side script interception.
  * Inactive session timeout automatically set to 60 minutes (`<session-timeout>60</session-timeout>`).
* **Database Unique Constraints**: Unique sparse indexes on `email` and `customerId` prevent concurrency race conditions during onboarding.
