# StockFlow — Intelligent Inventory, Warehouse Fleet & Order Fulfillment Ecosystem

[![Java EE](https://img.shields.io/badge/Java%20EE-8.0.1-blue.svg)](https://jakarta.ee/)
[![Build Tool](https://img.shields.io/badge/Maven-3.8+-C71A36.svg)](https://maven.apache.org/)
[![Database](https://img.shields.io/badge/MongoDB-4.11.1-47A248.svg)](https://www.mongodb.com/)
[![Security](https://img.shields.io/badge/Security-BCrypt%2012--Rounds-orange.svg)](https://www.mindrot.org/)
[![Testing](https://img.shields.io/badge/Tests-JUnit%205.10.2-25A162.svg)](https://junit.org/junit5/)
[![Packaging](https://img.shields.io/badge/Packaging-WAR-blueviolet.svg)](#-deployment-instructions)
[![UI Design](https://img.shields.io/badge/UI-Modern%20Glassmorphic%20Dark-0ea5e9.svg)](#-sub-project-details)

**StockFlow** is an enterprise-grade, multi-portal inventory management, warehouse fleet intelligence, and order fulfillment ecosystem engineered for modern supply chains, multi-location logistics networks, 3PL distributors, and commercial client ordering flows.

The ecosystem is partitioned into two specialized web application modules:

1. [**`stockflow-customer`**](#1-stockflow-customer-enterprise-operations-warehouse-fleet--customer-portal): Enterprise SaaS marketing portal, self-service onboarding with automated 14-day trial calculation, salted BCrypt authentication, MongoDB persistence engine, real-time command center dashboard, and full-lifecycle **Warehouse Facility & Fleet Management** (fleet directory, edge IoT sensor telemetry modal, facility provisioning with architecture presets, dynamic zone partitioning, and CSV/JSON export).
2. [**`stockflow-user`**](#2-stockflow-user-smart-ordering--milestone-tracking-portal): Consumer & B2B ordering storefront featuring real-time hub inventory counts, category/SKU search filters, instant order placement simulation with feedback toasts, a 4-stage visual milestone order tracking simulator, and accessible modal authentication.

---

## 📑 Table of Contents

- [System Architecture](#-system-architecture)
  - [Architectural Topology](#architectural-topology)
  - [Customer Onboarding & Authentication Flow](#customer-onboarding--authentication-flow)
  - [Warehouse Fleet Provisioning & IoT Telemetry Flow](#warehouse-fleet-provisioning--iot-telemetry-flow)
  - [User Ordering & Milestone Tracking Flow](#user-ordering--milestone-tracking-flow)
- [Sub-Project Details](#-sub-project-details)
  - [1. `stockflow-customer`](#1-stockflow-customer-enterprise-operations-warehouse-fleet--customer-portal)
  - [2. `stockflow-user`](#2-stockflow-user-smart-ordering--milestone-tracking-portal)
- [Complete Repository Structure](#-complete-repository-structure)
- [Technology Stack Matrix](#-technology-stack-matrix)
- [Database Schema & Data Models](#-database-schema--data-models)
  - [Customer Document Schema (`tbl_customer_info`)](#customer-document-schema-tbl_customer_info)
  - [Warehouse Facility Data Model](#warehouse-facility-data-model)
  - [Automated MongoDB Indexes](#automated-mongodb-indexes)
- [Configuration & Environment Resolution](#-configuration--environment-resolution)
- [Application Endpoints & Routes](#-application-endpoints--routes)
- [Build & Testing Guide](#-build--testing-guide)
- [Deployment Instructions](#-deployment-instructions)
- [Demo Sandbox Credentials](#-demo-sandbox-credentials)
- [Roadmap & Planned Integrations](#-roadmap--planned-integrations)
- [License](#-license)

---

## 🏛 System Architecture

### Architectural Topology

The StockFlow ecosystem decouples administrative tenant/facility operations from end-user shopping and order telemetry streams:

```mermaid
flowchart TD
    subgraph ClientBrowsers ["Client & Operator Interfaces"]
        direction TB
        subgraph CustomerPortalUI ["stockflow-customer (Enterprise / Ops Portal)"]
            LP["Marketing Landing Page (/index.jsp)"]
            SU["Customer Registration (/customer/signup/signup.jsp)"]
            LG["Customer & Staff Login (/customer/login/login.jsp)"]
            DB["Operations Command Center (/customer/dashboard.jsp)"]
            WH_SHOW["Warehouse Fleet Directory (/warehouse/show-warehouses.jsp)"]
            WH_NEW["Facility Provisioning & Setup (/warehouse/new-warehouse.jsp)"]
        end

        subgraph UserPortalUI ["stockflow-user (Consumer / B2B Portal)"]
            STORE["Product Storefront & Catalog (/index.jsp)"]
            SEARCH["Live SKU / Hub Search & Filter"]
            ORDER["Instant Order Action & Feedback"]
            TRACK["Live Order Tracking Simulator"]
            AUTH_MODAL["Unified Login / Signup Modal"]
        end
    end

    subgraph ControllerTier ["Java EE Controller & Servlet Layer"]
        SignupSrv["SignupServlet (/signup-auth)"]
        LoginSrv["LoginServlet (/login-auth)"]
        LogoutSrv["LogoutServlet (/logout)"]
    end

    subgraph BusinessTier ["Business Logic & Data Access Layer"]
        CDAO["CustomerDAO (CRUD & Validation)"]
        BCryptEngine["jBCrypt Engine (12 Salt Rounds)"]
        ConnMgr["MongoDBConnection (Singleton & Env Parser)"]
        FleetState["Client-Side Fleet & Sensor Telemetry Store"]
    end

    subgraph PersistenceTier ["MongoDB Database (db_stockflow)"]
        CustColl[("tbl_customer_info / customers<br/>(Unique Indexes on email & customerId)")]
        EmpColl[("employees<br/>(Unique Indexes on email & employeeId)")]
    end

    %% stockflow-customer connections
    LP -->|Explore Plans| SU
    LP -->|Sign In| LG
    SU -->|POST Registration| SignupSrv
    LG -->|POST Authentication| LoginSrv
    DB -->|Manage Facilities| WH_SHOW
    DB -->|Provision Node| WH_NEW
    DB -->|Sign Out| LogoutSrv

    SignupSrv -->|1. Validate & Hash| BCryptEngine
    SignupSrv -->|2. Register Customer| CDAO
    LoginSrv -->|1. Authenticate Credentials| CDAO
    CDAO -->|Verify Salted Hash| BCryptEngine
    LogoutSrv -->|Invalidate Session| LG

    CDAO --> ConnMgr
    ConnMgr --> CustColl
    ConnMgr --> EmpColl

    WH_SHOW <-->|Fleet Topology, Presets & IoT Inspection| WH_NEW
    WH_SHOW --> FleetState

    %% stockflow-user connections
    STORE --> SEARCH
    STORE --> ORDER
    STORE --> TRACK
    STORE --> AUTH_MODAL
```

---

### Customer Onboarding & Authentication Flow

```mermaid
sequenceDiagram
    autonumber
    actor User as Enterprise Admin / Staff
    participant Browser as Web Browser
    participant Servlet as SignupServlet / LoginServlet
    participant DAO as CustomerDAO
    participant DB as MongoDB (tbl_customer_info)
    participant Session as HttpSession

    Note over User, DB: 1. Customer Self-Service Registration
    User->>Browser: Fill Registration Form (Name, Company, Email, Password, Plan)
    Browser->>Servlet: POST /signup-auth
    Servlet->>DAO: existsByEmail(normalizedEmail)
    DAO->>DB: countDocuments({ email: normalizedEmail })
    DB-->>DAO: 0 (Email Available)
    Servlet->>DAO: registerCustomer(name, company, email, pwd, plan, size, terms)
    DAO->>DAO: BCrypt.hashpw(plainPassword, gensalt(12))
    DAO->>DAO: Calculate 14-day trial period (trialStartDate, trialEndDate)
    DAO->>DB: insertOne(customerDocument)
    DB-->>DAO: Insert Success (ObjectId)
    DAO-->>Servlet: Customer Entity
    Servlet->>Session: setAttribute(user, customerId, company, role, plan, authTime)
    Servlet-->>Browser: Redirect 302 -> /customer/dashboard.jsp?status=registered
    Browser->>User: Display Command Center with Welcome Alert

    Note over User, DB: 2. Dual-Role Authentication (Customer & Staff)
    User->>Browser: Submit Login Form (Email, Password, Role)
    Browser->>Servlet: POST /login-auth
    Servlet->>DAO: authenticate(email, password)
    DAO->>DB: find({ email: normalizedEmail })
    DB-->>DAO: Customer Record
    DAO->>DAO: BCrypt.checkpw(plainPassword, passwordHash)
    DAO->>DB: updateOne({ email }, { $set: { lastLoginAt: now() } })
    DAO-->>Servlet: Authenticated Customer Entity
    Servlet->>Session: setAttribute(user, customerId, company, role, plan, authTime)
    Servlet-->>Browser: Redirect 302 -> /customer/dashboard.jsp
    Browser->>User: Render Live Command Center

    Note over User, DB: 3. Secure Session Teardown
    User->>Browser: Click Logout Action
    Browser->>Servlet: GET /logout
    Servlet->>Session: session.invalidate()
    Servlet-->>Browser: Redirect 302 -> /customer/login/login.jsp?msg=logged_out
    Browser->>User: Display Login Screen with Logout Confirmation
```

---

### Warehouse Fleet Provisioning & IoT Telemetry Flow

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Facility Manager / Ops Admin
    participant UI as Fleet Directory (show-warehouses.jsp)
    participant Telemetry as IoT Sensor Stream Simulator
    participant Form as Facility Setup (new-warehouse.jsp)
    participant Store as Fleet Store & Session Cache

    Admin->>UI: Navigate to Warehouse Directory (/warehouse/show-warehouses.jsp)
    UI->>Store: Load 13 default international warehouse nodes
    Store-->>UI: Render interactive cards/list with status pills
    
    Admin->>UI: Click "Inspect Telemetry" on facility card (e.g., WH-CHI-01)
    UI->>Telemetry: Request live environmental & gate telemetry
    Telemetry-->>UI: Stream sensor metrics (Temp: 20.4°C, Humidity: 42.8%, Occupancy: 74.2%, RFID events)
    UI->>Admin: Open Live Telemetry & Specifications Modal

    Admin->>UI: Click "Provision New Facility"
    UI->>Form: Navigate to /warehouse/new-warehouse.jsp?action=create
    Admin->>Form: Click Preset (e.g., "Cold-Chain Pharma Depot")
    Form->>Form: Auto-populate 45,000 sq ft, 3,200 pallets, 2°C-8°C climate, and cold racking zones
    Form->>Admin: Dynamic Live Topology Preview Card updates instantly
    Admin->>Form: Add custom partition zone & click "Provision Facility & Deploy Node"
    Form->>Store: Validate & save facility record
    Store-->>Form: Provisioning successful
    Form->>Admin: Display success toast & redirect to Warehouse Fleet Directory
```

---

### User Ordering & Milestone Tracking Flow

```mermaid
sequenceDiagram
    autonumber
    actor Client as Consumer / B2B Buyer
    participant UI as Storefront (index.jsp)
    participant Catalog as Product Catalog & Hub Index
    participant Tracker as Order Milestone Tracker

    Client->>UI: Open Storefront (/stockflow-user/index.jsp)
    Client->>UI: Search SKU "HW-8830" or filter by "Electronics"
    UI->>Catalog: Filter matching items
    Catalog-->>UI: Display "Pro Workstation Ultra M3" (142 in stock at Hub North)
    
    Client->>UI: Click "Order" button
    UI->>UI: Trigger animated toast notification ("Order queued for Hub North")
    
    Client->>UI: Scroll to Live Order Tracking section
    Client->>UI: Enter Order Reference ID (e.g., "ORD-8924") & click "Track"
    UI->>Tracker: Fetch milestone progress for ORD-8924
    Tracker-->>UI: Current stage: "In Transit" (Order Placed -> Packed -> In Transit -> Delivered)
    UI->>Client: Render animated 4-stage visual progress stepper
```

---

## 📦 Sub-Project Details

### 1. `stockflow-customer` (Enterprise Operations, Warehouse Fleet & Customer Portal)

The `stockflow-customer` module is a Jakarta EE / Java EE 8 web application providing enterprise customer onboarding, role-based authentication, MongoDB data access, operational command dashboards, and comprehensive warehouse fleet management.

#### ✨ Key Features
- **SaaS Marketing & Conversion Frontend (`index.jsp`)**: Modern dark-themed landing page featuring warehouse velocity mockups, 4-stage operational workflows, dynamic annual/monthly pricing calculator with automated 20% discount switch, customer testimonials, and interactive FAQ accordions.
- **Enterprise Authentication & Session Security**:
  - [`SignupServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/customer/SignupServlet.java) (`/signup-auth`): Validates input contracts, enforces terms acceptance, hashes passwords with BCrypt (12 salt rounds), calculates 14-day trial subscriptions, persists into MongoDB `tbl_customer_info`, and sets authenticated session attributes.
  - [`LoginServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/customer/LoginServlet.java) (`/login-auth`): Supports dual login modes (`customer` vs `staff`) against live MongoDB records with fallback demo credentials for offline evaluation.
  - [`LogoutServlet`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/customer/LogoutServlet.java) (`/logout`): Invalidates HTTP sessions and safely redirects with status confirmation.
- **Operations Command Center (`customer/dashboard.jsp`)**:
  - Live KPI metrics (Active SKUs, Inventory Valuation, Fulfillment Velocity %, Low Stock alerts).
  - Multi-facility warehouse telemetry table (Central Hub Bay A-12, East Coast Bay B-08, West Coast Bay C-02).
  - Real-time warehouse activity feed (Inbound PO receipts, courier dispatches, AI demand rebalancing).
  - Sidebar navigation with collapsible submenus for Warehouses and Employees.
  - XSS-sanitized dynamic attributes using HTML escaping.
- **Warehouse Fleet Management (`warehouse/show-warehouses.jsp`)**:
  - **Connected Fleet Directory**: Multi-node directory covering 13 global fulfillment facilities across USA, Canada, UK, Germany, Singapore, and Australia.
  - **Live Search & Filter Pills**: Filter by facility type (Regional Fulfillment, Distribution Center, Micro-Fulfillment, Cold Storage, Cross-Dock, Bonded Customs, Bulk Cargo) and multi-attribute sorting.
  - **IoT Sensor Telemetry Modal**: Real-time inspection of ambient temperature, relative humidity, bay occupancy %, dock door utilization, and simulated RFID gate scan logs.
  - **Facility Specifications Modal**: Comprehensive physical infrastructure breakdown (total area, pallet capacity, dock doors, clear height, climate control, storage zones, manager contact, shift schedules).
  - **Fleet Data Export**: One-click export of complete warehouse network data in **CSV** or **JSON** format.
- **Facility Provisioning & Topology Configuration (`warehouse/new-warehouse.jsp`)**:
  - **Multi-Section Provisioning Form**: Identification & Classification, Geo-Logistics, Structural Capacity, Partitioned Storage Zones, Management & Shifts, Capabilities & Certifications.
  - **Instant Architecture Presets**:
    - *Automated E-Commerce Mega-Hub* (120,000 sq ft, 8,500 pallets, 16 dock doors)
    - *Cold-Chain Pharma Depot* (45,000 sq ft, 3,200 pallets, chilled refrigeration 2°C–8°C)
    - *Urban Micro-Fulfillment Center* (18,000 sq ft, 1,400 pallets, high-velocity pick modules)
    - *Maritime Bonded Cross-Dock* (95,000 sq ft, 7,000 pallets, customs bonded)
  - **Live Dynamic Topology Preview Card**: Real-time visual card updating dynamically with user inputs.
  - **Interactive Zone Builder**: Add, edit, or remove custom storage zones (e.g., Heavy Racking, Mezzanine Bins, Biometric Vaults).
  - **Lifecycle Management**: Supports `action=create`, `action=update`, and `action=decommission` modes with audit reason tracking.
- **Dynamic Configuration & Resilience (`MongoDBConnection.java`)**:
  - Cascading environment resolution (`System.getenv` -> `System.getProperty` -> `.env` file discovery across root, parent, user directory, Catalina base/home, and classpath).
  - Registers JVM shutdown hooks to cleanly dispose of MongoClient connection pools.
  - Automatically ensures unique sparse indexes on `email`, `customerId`, and `employeeId`.
- **Unit Test Coverage (`src/test/java`)**:
  - [`CustomerModelTest`](file:///F:/stockflow/stockflow-customer/src/test/java/com/inventory/stockflowcustomer/CustomerModelTest.java): BSON document serialization/deserialization, subscription mapping, null-safety, and BCrypt verification tests.
  - [`MongoDBConnectionTest`](file:///F:/stockflow/stockflow-customer/src/test/java/com/inventory/stockflowcustomer/MongoDBConnectionTest.java): Environment variable resolution, property fallbacks, and connection URI validation tests.

---

### 2. `stockflow-user` (Smart Ordering & Milestone Tracking Portal)

The `stockflow-user` module is dedicated to end-users, corporate procurement managers, and commercial clients seeking rapid inventory ordering with full supply-chain visibility.

#### ✨ Key Features
- **Live Stock & Catalog Browser (`index.jsp`)**:
  - Real-time stock counts across regional distribution hubs (Hub North, Hub Central, Hub West).
  - Dynamic client-side category filters (**All Products**, **Electronics**, **Office & Ergonomics**, **Accessories**).
  - Instant SKU and keyword search filter with smooth scrolling to matching product cards.
- **Express Order Placement Simulation**:
  - 1-click order action buttons on catalog items with interactive toast notification feedback.
- **Live 4-Stage Milestone Order Tracker**:
  - Visual 4-stage milestone pipeline: **Order Placed** ➔ **Packed** ➔ **In Transit** ➔ **Delivered**.
  - Dynamic tracking lookup by Order Reference ID / Waybill number (e.g., `ORD-8924`).
- **Interactive Auth Modals & Mobile Drawer**:
  - Tabbed modal for Login and Sign Up with Google SSO triggers and client-side validation.
  - Mobile responsive drawer navigation with hamburger toggle.
- **Extensible Architecture**:
  - Configured CDI [`beans.xml`](file:///F:/stockflow/stockflow-user/src/main/resources/META-INF/beans.xml) and JPA [`persistence.xml`](file:///F:/stockflow/stockflow-user/src/main/resources/META-INF/persistence.xml) for future business extensions (`db/`, `order/`, `user/`).

---

## 📂 Complete Repository Structure

```
stockflow/
├── README.md                                       # Root Documentation (this file)
├── .gitignore                                      # Global git ignore rules
│
├── stockflow-customer/                             # Enterprise, Warehouse & Customer Management Module
│   ├── pom.xml                                     # Maven descriptor (Java EE 8, MongoDB, BCrypt, JUnit 5)
│   ├── mvnw / mvnw.cmd                             # Maven Wrapper executables
│   ├── README.md                                   # Module-specific workflow documentation
│   ├── .env                                        # Environment configuration (MongoDB URI & database)
│   ├── .gitignore                                  # Module git ignore rules
│   └── src/
│       ├── main/
│       │   ├── java/com/inventory/stockflowcustomer/
│       │   │   ├── customer/
│       │   │   │   ├── LoginServlet.java           # Authentication controller (/login-auth)
│       │   │   │   ├── LogoutServlet.java          # Session invalidation controller (/logout)
│       │   │   │   └── SignupServlet.java          # Customer onboarding controller (/signup-auth)
│       │   │   ├── dao/
│       │   │   │   └── CustomerDAO.java            # MongoDB DAO, BCrypt hashing & query operations
│       │   │   ├── db/
│       │   │   │   └── MongoDBConnection.java      # Singleton client, .env parser & index initializer
│       │   │   └── model/
│       │   │       └── Customer.java               # Customer & Subscription entity with BSON mapping
│       │   ├── resources/
│       │   │   └── META-INF/
│       │   │       └── beans.xml                   # CDI descriptor
│       │   └── webapp/
│       │       ├── WEB-INF/
│       │       │   └── web.xml                     # Servlet 4.0 configuration & cookie hardening
│       │       ├── index.jsp                       # SaaS Marketing Landing Page & Pricing Calculator
│       │       ├── dashboard.jsp                   # Root forwarder -> /customer/dashboard.jsp
│       │       ├── login.jsp                       # Root forwarder -> /customer/login/login.jsp
│       │       ├── signup.jsp                      # Root forwarder -> /customer/signup/signup.jsp
│       │       ├── customer/
│       │       │   ├── dashboard.jsp               # Operations Command Center Dashboard
│       │       │   ├── login.jsp                   # Forwarder to login/login.jsp
│       │       │   ├── signup.jsp                  # Forwarder to signup/signup.jsp
│       │       │   ├── css/
│       │       │   │   ├── login.css               # Glassmorphic styling for login screen
│       │       │   │   ├── signup.css              # Multi-step signup & strength meter styling
│       │       │   │   └── style.css               # Global dashboard design system, sidebar & tables
│       │       │   ├── js/
│       │       │   │   ├── login.js                # Role toggling, demo fill & client validation
│       │       │   │   ├── main.js                 # Navigation drawer, FAQ accordion & UI interactions
│       │       │   │   └── signup.js               # Password strength analyzer & signup validation
│       │       │   ├── login/
│       │       │   │   ├── index.jsp               # Login view alias
│       │       │   │   └── login.jsp               # Customer & Staff login portal
│       │       │   └── signup/
│       │       │       ├── index.jsp               # Signup view alias
│       │       │       └── signup.jsp              # Customer registration & trial plan selection
│       │       └── warehouse/
│       │           ├── show-warehouses.jsp         # Warehouse Fleet Directory, IoT Telemetry & Export
│       │           ├── new-warehouse.jsp           # Facility Provisioning, Presets & Zone Editor
│       │           ├── css/
│       │           │   ├── show-warehouses.css     # Fleet directory layout, cards, filters & modals
│       │           │   └── warehouse.css           # Facility setup form, zones & live preview panel
│       │           └── js/
│       │               ├── show-warehouses.js      # Fleet search, filter, CSV/JSON export & IoT streams
│       │               └── warehouse.js            # Architecture presets, zone builder & submit logic
│       └── test/
│           └── java/com/inventory/stockflowcustomer/
│               ├── CustomerModelTest.java          # BSON serialization, equals/hashCode & BCrypt tests
│               └── MongoDBConnectionTest.java      # Dynamic environment resolution & URI parsing tests
│
└── stockflow-user/                                 # Consumer & B2B Ordering Storefront
    ├── pom.xml                                     # Maven descriptor (Java EE 8, JUnit 5)
    ├── mvnw / mvnw.cmd                             # Maven Wrapper executables
    ├── .gitignore                                  # Module git ignore rules
    └── src/
        ├── main/
        │   ├── resources/
        │   │   └── META-INF/
        │   │       ├── beans.xml                   # CDI descriptor
        │   │       └── persistence.xml             # JPA persistence unit configuration
        │   └── webapp/
        │       ├── WEB-INF/
        │       │   └── web.xml                     # Servlet 4.0 configuration & welcome file list
        │       ├── index.jsp                       # Ordering Storefront, Catalog & Milestone Tracker
        │       ├── css/
        │       │   └── style.css                   # Storefront dark theme, hero cards & modal styles
        │       └── js/
        │           └── main.js                     # Catalog filter, SKU search, toast & tracking simulator
        └── test/                                   # Module test suite directory
```

---

## 🛠 Technology Stack Matrix

| Layer / Component | Technology | Version / Spec | Sub-Module | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Language & Platform** | Java (JDK) | 1.8+ / 11 / 17 / 21 | Both | Core backend programming language |
| **Enterprise Standard** | Java EE / Jakarta EE API | 8.0.1 (Servlet 4.0, JSP 2.3) | Both | Web request dispatching, sessions, filters, and JSP rendering |
| **Build & Dependency Tool** | Apache Maven | 3.8+ | Both | Build automation, packaging, and dependency lifecycle management |
| **NoSQL Database** | MongoDB & MongoDB Atlas | 4.4 - 7.0+ | `customer` | Document persistence for customers, subscriptions, and telemetry |
| **Database Driver** | MongoDB Java Sync Driver | 4.11.1 | `customer` | Thread-safe synchronous connection pooling and BSON operations |
| **Password Cryptography** | jBCrypt | 0.4 | `customer` | 12-round salted Blowfish cryptographic password hashing |
| **Unit Testing** | JUnit Jupiter (JUnit 5) | 5.10.2 | Both | Unit testing and domain contract validation |
| **Enterprise Config** | CDI & JPA | 2.0 / 2.2 | Both | Context and Dependency Injection (`beans.xml`, `persistence.xml`) |
| **Frontend Styling** | Custom CSS3 | Modern Glassmorphic | Both | Dark-mode design system, responsive grids, and modal overlays |
| **Typography & Icons** | Plus Jakarta Sans, JetBrains Mono, FontAwesome | FA 6.4 - 6.5.1 | Both | Enterprise typography, monospace metrics, and crisp visual glyphs |
| **Client Scripting** | Vanilla JavaScript | ES6+ | Both | Dynamic DOM rendering, IoT sensor streams, CSV/JSON export, tracking |

---

## 🗄 Database Schema & Data Models

### Customer Document Schema (`tbl_customer_info`)

Each customer document maps to the [`Customer`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/model/Customer.java) Java class:

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

Warehouse facility records encapsulate physical geo-logistics, structural capacities, climate controls, and storage zones:

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
  "notes": "Primary Midwest automated cross-dock hub.",
  "features": ["Hazmat Certified", "RFID Gates", "Customs Bonded", "IoT Sensor Mesh"],
  "zones": [
    { "name": "Zone A: High Velocity Pallets", "type": "Heavy Racking (Pallet-In Pallet-Out)", "capacity": 4500 },
    { "name": "Zone B: Case & Tote Pick Module", "type": "Mezzanine Shelving & Bins", "capacity": 2500 },
    { "name": "Zone C: Secure Vault / High-Value", "type": "Biometric Enclosed Caging", "capacity": 1500 }
  ]
}
```

### Automated MongoDB Indexes

On initial database access, [`MongoDBConnection.ensureIndexes()`](file:///F:/stockflow/stockflow-customer/src/main/java/com/inventory/stockflowcustomer/db/MongoDBConnection.java) automatically provisions unique sparse indexes:

| Collection | Indexed Field | Index Properties | Purpose |
| :--- | :--- | :--- | :--- |
| `tbl_customer_info` | `email` | Ascending, Unique, Sparse | Fast customer lookup & prevent duplicate email registration |
| `tbl_customer_info` | `customerId` | Ascending, Unique, Sparse | Unique identity indexing |
| `customers` | `email`, `customerId` | Ascending, Unique, Sparse | Alternate customer collection indexing |
| `employees` | `email`, `employeeId` | Ascending, Unique, Sparse | Worker and staff uniqueness enforcement |

---

## ⚙ Configuration & Environment Resolution

The `MongoDBConnection` manager resolves connection parameters through a resilient cascading hierarchy:

1. **Operating System Environment Variables** (`System.getenv()`)
2. **Java System Properties** (`System.getProperty()`, e.g., `-Dmongodb.uri=...` or `-Dmongodb_database=...`)
3. **Local `.env` File Discovery** (searches application working dir, parent dir `../.env`, Catalina base/home, and classpath)

### Sample `.env` Configuration File

Create a `.env` file in the project root or within `stockflow-customer/`:

```ini
# =============================================================================
# StockFlow MongoDB Atlas Configuration
# =============================================================================

# Full MongoDB Connection URI (Atlas SRV or Local Replica Set)
MONGODB_URI=mongodb+srv://stockflow_admin:SecurePassword123@cluster0.abcde.mongodb.net/?retryWrites=true&w=majority&appName=StockFlowCluster

# Target Database Name
MONGODB_DATABASE=db_stockflow

# Optional Disaggregated Credentials (if MONGODB_URI is not provided)
MONGODB_USER=stockflow_admin
MONGODB_PASSWORD=SecurePassword123
MONGODB_HOST=cluster0.abcde.mongodb.net
```

---

## 🌐 Application Endpoints & Routes

| Sub-Module | Path / URL Pattern | Method | Purpose | Access Scope |
| :--- | :--- | :--- | :--- | :--- |
| **Customer** | `/stockflow-customer/` | `GET` | SaaS Product Landing Page & Pricing Calculator | Public |
| **Customer** | `/stockflow-customer/customer/signup/signup.jsp` | `GET` | Customer Registration & Trial Plan Picker | Public |
| **Customer** | `/stockflow-customer/customer/login/login.jsp` | `GET` | Customer & Staff Login Portal with 1-Click Demo Fill | Public |
| **Customer** | `/stockflow-customer/signup-auth` | `POST` | Processes registration, hashes password, saves to MongoDB | Public |
| **Customer** | `/stockflow-customer/login-auth` | `POST` | Authenticates customer/staff credentials & starts session | Public |
| **Customer** | `/stockflow-customer/customer/dashboard.jsp` | `GET` | Operations Command Center (SKUs, telemetry, metrics) | Authenticated |
| **Customer** | `/stockflow-customer/warehouse/show-warehouses.jsp` | `GET` | Warehouse Fleet Directory, IoT Telemetry Modal & Export | Authenticated |
| **Customer** | `/stockflow-customer/warehouse/new-warehouse.jsp` | `GET` | Facility Provisioning, Presets, Zone Editor & Decommission | Authenticated |
| **Customer** | `/stockflow-customer/logout` | `GET` | Invalidates session and redirects to login | Authenticated |
| **User** | `/stockflow-user/` | `GET` | Ordering Storefront, Live SKU Catalog & Order Tracking | Public |
| **User** | `/stockflow-user/index.jsp#catalog` | `GET` | Real-time stock filter by category & regional hub | Public |
| **User** | `/stockflow-user/index.jsp#tracking` | `GET` | Live 4-Stage Milestone Order Tracking Simulator | Public |

*(Note: Context paths `/stockflow-customer` and `/stockflow-user` assume deployment with matching WAR names on Tomcat).*

---

## 🔨 Build & Testing Guide

### Prerequisites
- **Java Development Kit (JDK)**: Version 8 or higher (JDK 11, 17, or 21 fully supported)
- **Apache Maven 3.8+** (or use the included cross-platform `mvnw` / `mvnw.cmd` wrapper scripts)
- **Servlet Container**: Apache Tomcat 9.x+ (or Java EE 8 / Jakarta EE compatible container)
- **MongoDB**: MongoDB Atlas cluster or local MongoDB instance (v4.4+)

### 1. Build Both Sub-Projects

From the repository root, build each module:

```bash
# Build stockflow-customer WAR
cd stockflow-customer
./mvnw clean package

# Build stockflow-user WAR
cd ../stockflow-user
./mvnw clean package
```

*(On Windows, use `.\mvnw.cmd clean package`)*

### 2. Run Unit Tests

Execute the JUnit Jupiter test suites:

```bash
# Test stockflow-customer
cd stockflow-customer
./mvnw test

# Test stockflow-user
cd ../stockflow-user
./mvnw test
```

---

## 🚀 Deployment Instructions

Both projects produce standard Web Application Archive (`.war`) files in their respective `target/` directories:
- `stockflow-customer/target/stockflowcustomer-1.0-SNAPSHOT.war`
- `stockflow-user/target/stockflowuser-1.0-SNAPSHOT.war`

### Deploying to Apache Tomcat (9.x / 10.x):
1. **Copy WAR files** to your Tomcat `webapps/` directory:
   ```bash
   # Linux / macOS
   cp stockflow-customer/target/stockflowcustomer-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/stockflow-customer.war
   cp stockflow-user/target/stockflowuser-1.0-SNAPSHOT.war $CATALINA_HOME/webapps/stockflow-user.war
   ```
   ```powershell
   # Windows (PowerShell)
   Copy-Item .\stockflow-customer\target\stockflowcustomer-1.0-SNAPSHOT.war "$env:CATALINA_HOME\webapps\stockflow-customer.war"
   Copy-Item .\stockflow-user\target\stockflowuser-1.0-SNAPSHOT.war "$env:CATALINA_HOME\webapps\stockflow-user.war"
   ```
2. **Configure Environment**: Place your `.env` file in the Tomcat root directory or set the `MONGODB_URI` environment variable.
3. **Start Tomcat**:
   ```bash
   # Linux / macOS
   $CATALINA_HOME/bin/startup.sh

   # Windows
   %CATALINA_HOME%\bin\startup.bat
   ```
4. **Access the Portals**:
   - **Enterprise & Warehouse Portal**: `http://localhost:8085/stockflow-customer/` (or port `8080`)
   - **Ordering & Tracking Storefront**: `http://localhost:8085/stockflow-user/` (or port `8080`)

---

## 🔑 Demo Sandbox Credentials

For offline demonstrations, evaluations, and testing without an active MongoDB instance, `stockflow-customer` includes built-in 1-click sandbox demo accounts:

| Role | Username / Email | Password | Access Scope |
| :--- | :--- | :--- | :--- |
| **Customer Admin** | `alex.morgan@acmelogistics.com` | `StockFlow2026!` | Customer Dashboard, SKU Telemetry, Warehouse Fleet Directory, Provisioning |
| **Customer Admin (Alt)** | `alex.morgan@acmelogistics.com` | `StockFlow#2026` | Customer Dashboard, Warehouse Fleet Directory, Provisioning |
| **Warehouse Staff** | `admin@stockflow.internal` | `AdminPass2026!` | Multi-Warehouse Operations, Inbound POs & Logistics Fleet |
| **Warehouse Staff (Alt)** | `staff.sarah@stockflow.internal` | `StockFlow2026!` | Staff Operations, Picking & Dispatch Feed |

> **Tip**: On the login screen (`/customer/login/login.jsp`), click the **1-Click Demo Login** buttons to auto-populate these credentials.

---

## 🗺 Roadmap & Planned Integrations

- [x] **Multi-Node Warehouse Fleet Management**: Connected directory of 13 international facilities with search, filter pills, IoT telemetry streams, and CSV/JSON export.
- [x] **Facility Provisioning & Presets**: Dynamic architecture preset loader (E-Commerce Mega-Hub, Cold-Chain Pharma, Urban Micro-Fulfillment, Maritime Bonded) with live visual topology preview.
- [x] **Automated MongoDB Schema Indexing**: Automatic creation of sparse unique indexes on `tbl_customer_info`, `customers`, and `employees`.
- [ ] **Unified Cross-Portal Order Pipeline**: Real-time propagation of orders placed in `stockflow-user` to the `stockflow-customer` operations dashboard table.
- [ ] **RESTful API Services (JAX-RS)**: Secured JSON endpoints for third-party ERP synchronization (SAP, NetSuite, Shopify).
- [ ] **Live WebSockets Telemetry**: Push notifications for real-time sensor updates, restock triggers, and shipment milestone transitions.
- [ ] **Docker Compose Orchestration**: Single-command container orchestration bundling Tomcat web instances with a containerized MongoDB service.

---

## 📄 License

This project is proprietary software belonging to the StockFlow project contributors. All rights reserved.
