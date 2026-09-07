<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>
<%
    // Session Verification
    String userName = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
    String userCompany = (String) session.getAttribute("company");
    String userPlan = (String) session.getAttribute("plan");
    String customerId = (String) session.getAttribute("customerId");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "Jordan Vance";
    }
    if (userCompany == null || userCompany.trim().isEmpty()) {
        userCompany = "Apex Distro & Logistics LLC";
    }
    if (userRole == null || userRole.trim().isEmpty()) {
        userRole = "Customer (Admin)";
    }
    if (userPlan == null || userPlan.trim().isEmpty()) {
        userPlan = "Enterprise Trial";
    }
    if (customerId == null || customerId.trim().isEmpty()) {
        customerId = "CUST-8849-ORD";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Control &amp; Facility Setup &bull; StockFlow Intelligence</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css?v=2.2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/warehouse/css/warehouse.css?v=2.2">

    <style>
        /* Standalone Form & Grid Layout Guarantees */
        .form-grid {
            display: grid;
            gap: 16px;
            margin-bottom: 16px;
        }
        .form-grid-2 {
            grid-template-columns: repeat(2, 1fr);
        }
        .form-grid-3 {
            grid-template-columns: repeat(3, 1fr);
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #94a3b8;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .form-label span.req {
            color: #ef4444;
            margin-left: 2px;
        }
        .form-input,
        .form-control,
        .form-select,
        .form-textarea {
            width: 100%;
            background: rgba(15, 23, 42, 0.75) !important;
            border: 1px solid rgba(255, 255, 255, 0.12) !important;
            border-radius: 10px !important;
            padding: 12px 16px !important;
            color: #f8fafc !important;
            font-size: 0.92rem !important;
            font-family: inherit !important;
            outline: none !important;
            box-sizing: border-box !important;
            transition: all 0.25s ease !important;
        }
        .form-input::placeholder,
        .form-textarea::placeholder {
            color: rgba(148, 163, 184, 0.45) !important;
        }
        .form-input:focus,
        .form-control:focus,
        .form-select:focus,
        .form-textarea:focus {
            border-color: #818cf8 !important;
            box-shadow: 0 0 0 3px rgba(129, 140, 248, 0.25) !important;
            background: rgba(30, 41, 59, 0.95) !important;
            color: #ffffff !important;
        }
        .form-select option {
            background: #111827;
            color: #f8fafc;
        }
        .zone-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .zone-item {
            display: grid;
            grid-template-columns: 2fr 2fr 1fr 40px;
            gap: 10px;
            align-items: center;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            padding: 10px 12px;
        }
        .zone-item .form-input {
            padding: 9px 12px !important;
            font-size: 0.88rem !important;
        }
        .btn-zone-del {
            height: 40px;
            width: 40px;
            border-radius: 8px;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.25);
            color: #ef4444;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 0.88rem;
            padding: 0;
            flex-shrink: 0;
        }
        .btn-zone-del:hover {
            background: rgba(239, 68, 68, 0.25);
            border-color: #ef4444;
            color: #ffffff;
        }
        @media (max-width: 768px) {
            .form-grid-2, .form-grid-3 {
                grid-template-columns: 1fr;
            }
            .zone-item {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

    <!-- Toast Notification Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Live Telemetry Inspector Modal -->
    <div class="modal-overlay" id="telemetryModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-satellite-dish" style="color: #38bdf8;"></i> <span id="modalFacilityTitle">Central Logistics Hub</span> Telemetry</h3>
                <button class="modal-close-btn" onclick="closeTelemetryModal()">&times;</button>
            </div>
            <div>
                <p style="font-size: 0.84rem; color: var(--text-muted); margin-bottom: 16px;">
                    Real-time IoT sensors synchronized with StockFlow Warehouse Edge Node.
                </p>

                <div class="sensor-stream-grid">
                    <div class="sensor-tile">
                        <div class="sensor-tile-label"><i class="fa-solid fa-temperature-half" style="color: #f59e0b;"></i> Ambient Temp</div>
                        <div class="sensor-tile-val" id="sensorTemp">20.4 &deg;C</div>
                    </div>
                    <div class="sensor-tile">
                        <div class="sensor-tile-label"><i class="fa-solid fa-droplet" style="color: #38bdf8;"></i> Relative Humidity</div>
                        <div class="sensor-tile-val" id="sensorHumidity">42.8 %</div>
                    </div>
                    <div class="sensor-tile">
                        <div class="sensor-tile-label"><i class="fa-solid fa-boxes-packing" style="color: #10b981;"></i> Current Bay Occupancy</div>
                        <div class="sensor-tile-val" id="sensorOccupancy">74.2 %</div>
                    </div>
                    <div class="sensor-tile">
                        <div class="sensor-tile-label"><i class="fa-solid fa-truck-fast" style="color: #818cf8;"></i> Active Loading Docks</div>
                        <div class="sensor-tile-val" id="sensorDocks">6 / 14 In Use</div>
                    </div>
                </div>

                <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--wh-border); border-radius: var(--radius-md); padding: 14px; margin-bottom: 20px;">
                    <div style="display: flex; justify-content: space-between; font-size: 0.8rem; margin-bottom: 6px;">
                        <span style="color: var(--text-dim);">RFID Gate Portal Activity (Live)</span>
                        <span style="color: #10b981; font-weight: 700;"><span class="pulse-dot" style="display: inline-block; margin-right: 4px;"></span> Online &amp; Scanning</span>
                    </div>
                    <div style="font-family: 'JetBrains Mono', monospace; font-size: 0.76rem; color: #94a3b8; line-height: 1.5;" id="sensorLogStream">
                        [14:48:02] Dock Door #04 &bull; Pallet Tag #TAG-9921 scanned (Blade X4)<br>
                        [14:48:19] Zone B-08 &bull; Handheld Scanner #HH-02 cycle-count verified
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="refreshSensorData()">
                        <i class="fa-solid fa-arrows-rotate"></i> Refresh Telemetry
                    </button>
                    <button type="button" class="btn btn-primary btn-sm" onclick="closeTelemetryModal()">
                        Done
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Decommission Facilities Modal -->
    <div class="modal-overlay" id="decommissionModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fa-solid fa-triangle-exclamation" style="color: #ef4444;"></i> Decommission Warehouse Hub</h3>
                <button class="modal-close-btn" onclick="closeDecommissionModal()">&times;</button>
            </div>
            <div>
                <p style="font-size: 0.84rem; color: var(--text-muted); margin-bottom: 16px;">
                    Select a connected warehouse facility to decommission from your active fleet network.
                </p>

                <div class="decom-list" id="decommissionList">
                    <!-- Populated dynamically -->
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="closeDecommissionModal()">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="dashboard-layout">
        <!-- Sidebar Navigation -->
        <aside class="dash-sidebar">
            <div>
                <a href="${pageContext.request.contextPath}/index.jsp" class="dash-brand">
                    <div class="logo-icon">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>
                    <span>Stock<span style="color: #38bdf8;">Flow</span></span>
                </a>

                <nav class="dash-nav">
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="dash-nav-item">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Overview</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp#inventory" class="dash-nav-item">
                        <i class="fa-solid fa-barcode"></i>
                        <span>Inventory &amp; SKUs</span>
                    </a>
                    
                    <!-- Warehouses Nav Item with Collapsible Submenu Dropdown -->
                    <div class="dash-nav-dropdown open" id="warehouseNavDropdown">
                        <button type="button" class="dash-nav-item dash-dropdown-toggle active" id="whDropdownToggle" onclick="toggleNavDropdown('warehouseNavDropdown')" aria-expanded="true">
                            <div class="nav-item-content">
                                <i class="fa-solid fa-warehouse"></i>
                                <span>Warehouses ( <span id="navWhCount">3</span> )</span>
                            </div>
                            <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                        </button>
                        <div class="dash-dropdown-menu show" id="warehouseDropdownMenu">
                            <button type="button" class="dash-dropdown-item active" id="navAction-create" onclick="handleNavAction('create', event)">
                                <i class="fa-solid fa-plus"></i>
                                <span>create new</span>
                            </button>
                            <button type="button" class="dash-dropdown-item" id="navAction-show" onclick="handleNavAction('show', event)">
                                <i class="fa-solid fa-table-list"></i>
                                <span>show warehouses</span>
                            </button>
                            <button type="button" class="dash-dropdown-item" id="navAction-update" onclick="handleNavAction('update', event)">
                                <i class="fa-solid fa-pen-to-square"></i>
                                <span>Update a warehouse</span>
                            </button>
                            <button type="button" class="dash-dropdown-item" id="navAction-decommission" onclick="handleNavAction('decommission', event)">
                                <i class="fa-solid fa-trash-can"></i>
                                <span>Decommission warehouse</span>
                            </button>
                        </div>
                    </div>

                    <!-- Employees Nav Item with Collapsible Submenu Dropdown -->
                    <div class="dash-nav-dropdown" id="employeeNavDropdown">
                        <button type="button" class="dash-nav-item dash-dropdown-toggle" id="empDropdownToggle" onclick="toggleNavDropdown('employeeNavDropdown')" aria-expanded="false">
                            <div class="nav-item-content">
                                <i class="fa-solid fa-users"></i>
                                <span>Employees</span>
                            </div>
                            <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                        </button>
                        <div class="dash-dropdown-menu" id="employeeDropdownMenu">
                            <a href="javascript:void(0)" class="dash-dropdown-item" id="empAction-create" onclick="handleEmployeeAction('create', event)">
                                <i class="fa-solid fa-user-plus"></i>
                                <span>create new</span>
                            </a>
                            <a href="javascript:void(0)" class="dash-dropdown-item" id="empAction-see-all" onclick="handleEmployeeAction('see-all', event)">
                                <i class="fa-solid fa-users-viewfinder"></i>
                                <span>see all employees</span>
                            </a>
                            <a href="javascript:void(0)" class="dash-dropdown-item" id="empAction-update" onclick="handleEmployeeAction('update', event)">
                                <i class="fa-solid fa-user-pen"></i>
                                <span>update employee</span>
                            </a>
                            <a href="javascript:void(0)" class="dash-dropdown-item" id="empAction-release" onclick="handleEmployeeAction('release', event)">
                                <i class="fa-solid fa-user-xmark"></i>
                                <span>release employee</span>
                            </a>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp#inbound" class="dash-nav-item">
                        <i class="fa-solid fa-truck-ramp-box"></i>
                        <span>Inbound / POs</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp#dispatch" class="dash-nav-item">
                        <i class="fa-solid fa-dolly"></i>
                        <span>Picking &amp; Dispatch</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp#ai-forecast" class="dash-nav-item">
                        <i class="fa-solid fa-bolt"></i>
                        <span>AI Demand Forecast</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp#settings" class="dash-nav-item">
                        <i class="fa-solid fa-gear"></i>
                        <span>Settings &amp; Team</span>
                    </a>
                </nav>
            </div>

            <div>
                <div class="dash-user-card" style="margin-bottom: 12px;">
                    <div class="dash-avatar">
                        <%= escapeHtml((userName != null && !userName.isEmpty()) ? userName.substring(0, Math.min(2, userName.length())).toUpperCase() : "US") %>
                    </div>
                    <div class="dash-user-details" style="overflow: hidden;">
                        <h5 style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= escapeHtml(userName) %></h5>
                        <p style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= escapeHtml(userCompany) %></p>
                    </div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn btn-outline btn-sm" style="flex: 1; font-size: 0.78rem;">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="flex: 1; font-size: 0.78rem; color: #ef4444; border-color: rgba(239, 68, 68, 0.3);">
                        <i class="fa-solid fa-power-off"></i> Logout
                    </a>
                </div>
            </div>
        </aside>

        <!-- Main Content Area -->
        <main class="dash-main">
            <!-- Breadcrumbs -->
            <div class="dash-breadcrumbs">
                <a href="${pageContext.request.contextPath}/customer/dashboard.jsp"><i class="fa-solid fa-house"></i> Dashboard</a>
                <i class="fa-solid fa-chevron-right"></i>
                <a href="javascript:void(0)" onclick="handleNavAction('show', event)">Warehouses</a>
                <i class="fa-solid fa-chevron-right"></i>
                <span class="current">Facility Management &amp; Setup</span>
            </div>

            <!-- Page Header -->
            <header class="dash-header">
                <div class="dash-title">
                    <h1>Warehouse Facility Command &amp; Setup</h1>
                    <p>Register new multi-node logistics facilities and monitor connected warehouse hubs for <strong><%= escapeHtml(userCompany) %></strong></p>
                </div>
                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <button type="button" class="btn btn-outline btn-sm" onclick="exportWarehouseData('json')">
                        <i class="fa-solid fa-file-code"></i> Export JSON
                    </button>
                    <button type="button" class="btn btn-outline btn-sm" onclick="exportWarehouseData('csv')">
                        <i class="fa-solid fa-file-csv"></i> Export CSV
                    </button>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn btn-secondary btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Customer Dashboard
                    </a>
                </div>
            </header>

            <!-- Quick Preset Bar for instant fill -->
            <div class="preset-bar">
                <span class="preset-label"><i class="fa-solid fa-wand-magic-sparkles"></i> Quick Presets:</span>
                <button type="button" class="preset-chip" onclick="applyPreset('mega-dc')">
                    <i class="fa-solid fa-bolt" style="color: #818cf8;"></i> Automated E-Commerce Mega-Hub
                </button>
                <button type="button" class="preset-chip" onclick="applyPreset('cold-pharma')">
                    <i class="fa-solid fa-snowflake" style="color: #38bdf8;"></i> Cold-Chain Pharma Depot
                </button>
                <button type="button" class="preset-chip" onclick="applyPreset('micro-urban')">
                    <i class="fa-solid fa-city" style="color: #10b981;"></i> Urban Micro-Fulfillment Center
                </button>
                <button type="button" class="preset-chip" onclick="applyPreset('bonded-port')">
                    <i class="fa-solid fa-ship" style="color: #f59e0b;"></i> Maritime Bonded Cross-Dock
                </button>
                <button type="button" class="preset-chip" style="margin-left: auto; color: #ef4444; border-color: rgba(239, 68, 68, 0.3);" onclick="cancelEditWarehouse()">
                    <i class="fa-solid fa-rotate-left"></i> Reset Form
                </button>
            </div>

            <!-- Warehouse Quick KPI Strip -->
            <div class="wh-stats-strip">
                <div class="wh-stat-card">
                    <div class="wh-stat-icon">
                        <i class="fa-solid fa-warehouse"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="statTotalCount">3 Hubs</h4>
                        <p>Active Locations</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(6, 182, 212, 0.15); color: #38bdf8;">
                        <i class="fa-solid fa-maximize"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="statTotalArea">245,000 sq ft</h4>
                        <p>Total Fleet Capacity</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(16, 185, 129, 0.15); color: #10b981;">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4>78.4%</h4>
                        <p>Avg Fleet Utilization</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(245, 158, 11, 0.15); color: #f59e0b;">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="statTotalPallets">18,100</h4>
                        <p>Total Pallet Positions</p>
                    </div>
                </div>
            </div>

            <!-- Main Form and Live Preview Layout Grid -->
            <div class="wh-grid-container">
                <!-- Facility Configuration Form Card -->
                <div class="wh-card">
                    <!-- Edit Mode Banner -->
                    <div class="edit-mode-banner" id="editModeBanner">
                        <div class="edit-mode-info">
                            <i class="fa-solid fa-pen-to-square"></i>
                            <span>Currently Updating: <strong id="editingWarehouseName">Central Logistics Hub</strong> (<code id="editingWarehouseCode">WH-CHI-01</code>)</span>
                        </div>
                        <button type="button" class="btn btn-outline btn-sm" onclick="cancelEditWarehouse()" style="background: rgba(255, 255, 255, 0.1); border-color: rgba(255, 255, 255, 0.2);">
                            <i class="fa-solid fa-xmark"></i> Cancel Update Mode
                        </button>
                    </div>

                    <div class="wh-card-header">
                        <h2><i class="fa-solid fa-building-circle-arrow-right" style="color: #818cf8;"></i> Facility Provisioning</h2>
                        <span class="badge badge-primary"><i class="fa-solid fa-cloud-arrow-up"></i> Real-Time Topology Sync</span>
                    </div>

                    <form id="newWarehouseForm" onsubmit="handleWarehouseSubmit(event)">
                        <!-- Section 1: Identification -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-info-circle"></i> 1. Identification &amp; Classification
                            </div>
                            <div class="form-grid form-grid-3">
                                <div class="form-group" style="grid-column: span 2;">
                                    <label class="form-label" for="whName">Facility Name <span class="req">*</span></label>
                                    <input type="text" id="whName" class="form-input" placeholder="e.g. Chicago Metro Logistics Hub" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whCode">Facility Code / Node ID <span class="req">*</span></label>
                                    <input type="text" id="whCode" class="form-input" placeholder="e.g. WH-ORD-04" required oninput="updatePreview()">
                                </div>
                            </div>
                            <div class="form-grid form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="whType">Facility Classification <span class="req">*</span></label>
                                    <select id="whType" class="form-select" required onchange="updatePreview()">
                                        <option value="Regional Fulfillment Center" selected>Regional Fulfillment Center (RFC)</option>
                                        <option value="Distribution Center">Central Distribution Center (CDC)</option>
                                        <option value="Micro-Fulfillment Center">Micro-Fulfillment Center (MFC)</option>
                                        <option value="Cold Storage & Reefer">Cold Storage &amp; Temperature-Controlled Reefer</option>
                                        <option value="Cross-Dock Terminal">High-Velocity Cross-Dock Terminal</option>
                                        <option value="Bonded Customs Warehouse">Bonded Customs &amp; Foreign Trade Zone</option>
                                        <option value="Bulk Storage & Heavy Goods">Bulk Storage &amp; Heavy Cargo Facility</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whStatus">Operational Status</label>
                                    <select id="whStatus" class="form-select" onchange="updatePreview()">
                                        <option value="Active & Operational" selected>Active &amp; Operational</option>
                                        <option value="In Setup / Pre-Launch">In Setup / Pre-Launch</option>
                                        <option value="Under Maintenance">Under Scheduled Maintenance</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Section 2: Location -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-map-location-dot"></i> 2. Location &amp; Geo-Logistics
                            </div>
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label class="form-label" for="whAddress">Street Address <span class="req">*</span></label>
                                <input type="text" id="whAddress" class="form-input" placeholder="e.g. 7420 North Port Boulevard, Suite 100" required oninput="updatePreview()">
                            </div>
                            <div class="form-grid form-grid-3">
                                <div class="form-group">
                                    <label class="form-label" for="whCity">City <span class="req">*</span></label>
                                    <input type="text" id="whCity" class="form-input" placeholder="e.g. Chicago" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whState">State / Province <span class="req">*</span></label>
                                    <input type="text" id="whState" class="form-input" placeholder="e.g. IL" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whZip">Postal / ZIP Code <span class="req">*</span></label>
                                    <input type="text" id="whZip" class="form-input" placeholder="e.g. 60666" required>
                                </div>
                            </div>
                            <div class="form-grid form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="whCountry">Country <span class="req">*</span></label>
                                    <select id="whCountry" class="form-select" onchange="updatePreview()">
                                        <option value="United States" selected>United States (USA)</option>
                                        <option value="Canada">Canada</option>
                                        <option value="United Kingdom">United Kingdom</option>
                                        <option value="Germany">Germany</option>
                                        <option value="Singapore">Singapore</option>
                                        <option value="Australia">Australia</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whZone">Logistics Corridor / Zone</label>
                                    <input type="text" id="whZone" class="form-input" placeholder="e.g. Midwest Freight Hub &bull; I-90" oninput="updatePreview()">
                                </div>
                            </div>
                        </div>

                        <!-- Section 3: Capacity & Physical Dimensions -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-cube"></i> 3. Capacity &amp; Structural Dimensions
                            </div>
                            <div class="form-grid form-grid-3">
                                <div class="form-group">
                                    <label class="form-label" for="whArea">Total Area (sq ft) <span class="req">*</span></label>
                                    <input type="number" id="whArea" class="form-input" placeholder="85000" min="1000" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whPallets">Pallet Storage Capacity <span class="req">*</span></label>
                                    <input type="number" id="whPallets" class="form-input" placeholder="6200" min="100" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whDocks">Loading Dock Doors <span class="req">*</span></label>
                                    <input type="number" id="whDocks" class="form-input" placeholder="14" min="1" required oninput="updatePreview()">
                                </div>
                            </div>
                            <div class="form-grid form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="whClearHeight">Clear Ceiling Height (ft)</label>
                                    <input type="number" id="whClearHeight" class="form-input" placeholder="36" min="12" oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whClimate">Environmental Climate Control</label>
                                    <select id="whClimate" class="form-select" onchange="updatePreview()">
                                        <option value="Standard Ambient (15&deg;C - 25&deg;C)" selected>Standard Ambient (15&deg;C - 25&deg;C)</option>
                                        <option value="Air-Conditioned Precision (18&deg;C - 22&deg;C)">Air-Conditioned Precision (18&deg;C - 22&deg;C)</option>
                                        <option value="Chilled Refrigeration (2&deg;C - 8&deg;C)">Chilled Refrigeration (2&deg;C - 8&deg;C)</option>
                                        <option value="Deep Freeze (-20&deg;C to -10&deg;C)">Deep Freeze (-20&deg;C to -10&deg;C)</option>
                                        <option value="Ultra-Low Cryo (-80&deg;C)">Ultra-Low Cryo (-80&deg;C)</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Section 4: Zone Partitions -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-network-wired"></i> 4. Storage Zones &amp; Bay Allocation
                            </div>
                            <p style="font-size: 0.8rem; color: var(--text-dim); margin-bottom: 12px;">
                                Configure storage partitions for automated SKU placement routing algorithms.
                            </p>
                            <div class="zone-list" id="zoneListContainer">
                                <div class="zone-item">
                                    <input type="text" class="form-input zone-name-input" value="Zone A: High Velocity Pallets" placeholder="Zone Name">
                                    <input type="text" class="form-input zone-type-input" value="Heavy Racking (Pallet-In Pallet-Out)" placeholder="Zone Type">
                                    <input type="number" class="form-input zone-cap-input" value="3200" placeholder="Pallet Cap" oninput="updatePreview()">
                                    <button type="button" class="btn-zone-del" onclick="removeZone(this)" title="Delete Zone"><i class="fa-solid fa-xmark"></i></button>
                                </div>
                                <div class="zone-item">
                                    <input type="text" class="form-input zone-name-input" value="Zone B: Case &amp; Tote Pick Module" placeholder="Zone Name">
                                    <input type="text" class="form-input zone-type-input" value="Mezzanine Shelving &amp; Bins" placeholder="Zone Type">
                                    <input type="number" class="form-input zone-cap-input" value="2000" placeholder="Pallet Cap" oninput="updatePreview()">
                                    <button type="button" class="btn-zone-del" onclick="removeZone(this)" title="Delete Zone"><i class="fa-solid fa-xmark"></i></button>
                                </div>
                                <div class="zone-item">
                                    <input type="text" class="form-input zone-name-input" value="Zone C: Secure Vault / High-Value" placeholder="Zone Name">
                                    <input type="text" class="form-input zone-type-input" value="Biometric Enclosed Caging" placeholder="Zone Type">
                                    <input type="number" class="form-input zone-cap-input" value="1000" placeholder="Pallet Cap" oninput="updatePreview()">
                                    <button type="button" class="btn-zone-del" onclick="removeZone(this)" title="Delete Zone"><i class="fa-solid fa-xmark"></i></button>
                                </div>
                            </div>
                            <button type="button" class="btn btn-outline btn-sm" onclick="addCustomZone()" style="margin-top: 10px;">
                                <i class="fa-solid fa-plus"></i> Add Storage Zone Partition
                            </button>
                        </div>

                        <!-- Section 5: Management -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-user-shield"></i> 5. Facility Management &amp; Operations
                            </div>
                            <div class="form-grid form-grid-3">
                                <div class="form-group">
                                    <label class="form-label" for="whManager">Facility General Manager <span class="req">*</span></label>
                                    <input type="text" id="whManager" class="form-input" placeholder="e.g. Marcus Rivera" required oninput="updatePreview()">
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whEmail">Operations Contact Email <span class="req">*</span></label>
                                    <input type="email" id="whEmail" class="form-input" placeholder="e.g. m.rivera@stockflow.io" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whPhone">Emergency Dispatch Phone <span class="req">*</span></label>
                                    <input type="tel" id="whPhone" class="form-input" placeholder="e.g. +1 (312) 555-0199" required>
                                </div>
                            </div>
                            <div class="form-grid form-grid-2">
                                <div class="form-group">
                                    <label class="form-label" for="whShifts">Operating Shifts Schedule</label>
                                    <select id="whShifts" class="form-select">
                                        <option value="24/7 Continuous (3 Shifts)" selected>24/7 Continuous (3 Shifts &bull; 8 hrs each)</option>
                                        <option value="2 Shifts (16 Hours/Day)">2 Shifts (16 Hours / Day &bull; 6am - 10pm)</option>
                                        <option value="Standard Business (8 Hours/Day)">Standard Business (8 Hours / Day &bull; 8am - 5pm)</option>
                                        <option value="Weekend Surge Only">Weekend Surge Fulfillment Only</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="whBays">Total Discrete Pick Bays</label>
                                    <input type="number" id="whBays" class="form-input" placeholder="6200" min="10">
                                </div>
                            </div>
                        </div>

                        <!-- Section 6: Capabilities & Badges -->
                        <div class="wh-form-section">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-shield-halved"></i> 6. Capabilities &amp; Certifications
                            </div>
                            <div class="toggle-cards-grid">
                                <label class="toggle-card active" id="toggleHazmat">
                                    <div class="toggle-card-header">
                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                        <span>Hazmat &amp; Chemical Enclosure</span>
                                    </div>
                                    <div class="custom-switch">
                                        <input type="checkbox" id="checkHazmat" checked onchange="toggleCardStyle('toggleHazmat', this)">
                                        <span class="custom-slider"></span>
                                    </div>
                                </label>

                                <label class="toggle-card active" id="toggleRFID">
                                    <div class="toggle-card-header">
                                        <i class="fa-solid fa-barcode"></i>
                                        <span>Automated RFID Portal Gates</span>
                                    </div>
                                    <div class="custom-switch">
                                        <input type="checkbox" id="checkRFID" checked onchange="toggleCardStyle('toggleRFID', this)">
                                        <span class="custom-slider"></span>
                                    </div>
                                </label>

                                <label class="toggle-card" id="toggleCustoms">
                                    <div class="toggle-card-header">
                                        <i class="fa-solid fa-passport"></i>
                                        <span>Bonded Customs Quarantine</span>
                                    </div>
                                    <div class="custom-switch">
                                        <input type="checkbox" id="checkCustoms" onchange="toggleCardStyle('toggleCustoms', this)">
                                        <span class="custom-slider"></span>
                                    </div>
                                </label>

                                <label class="toggle-card active" id="toggleIoT">
                                    <div class="toggle-card-header">
                                        <i class="fa-solid fa-temperature-arrow-up"></i>
                                        <span>Continuous IoT Sensor Telemetry</span>
                                    </div>
                                    <div class="custom-switch">
                                        <input type="checkbox" id="checkIoT" checked onchange="toggleCardStyle('toggleIoT', this)">
                                        <span class="custom-slider"></span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Section 7: Notes -->
                        <div class="wh-form-section" style="margin-bottom: 24px;">
                            <div class="wh-section-title">
                                <i class="fa-solid fa-notes-medical"></i> 7. Special Dispatch Instructions
                            </div>
                            <div class="form-group">
                                <textarea id="whNotes" class="form-textarea" placeholder="Enter gate access security codes, preferred carrier dispatch bays, or automated AS/RS protocols..."></textarea>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div style="display: flex; gap: 14px; align-items: center; justify-content: flex-end; padding-top: 16px; border-top: 1px solid var(--wh-border);">
                            <button type="button" class="btn btn-outline" onclick="cancelEditWarehouse()">
                                Clear
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="saveAsDraft()">
                                <i class="fa-solid fa-floppy-disk"></i> Save Draft
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitWarehouseBtn">
                                <i class="fa-solid fa-plus-circle"></i> Commission Facility
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Live Facility Preview Sidebar -->
                <aside>
                    <div class="preview-card">
                        <div class="preview-badge">
                            <i class="fa-solid fa-satellite-dish"></i> LIVE TELEMETRY PREVIEW
                        </div>

                        <div class="preview-header">
                            <h3 class="preview-title" id="prevName">Chicago Metro Logistics Hub</h3>
                            <div style="display: flex; align-items: center; gap: 8px; margin-top: 6px; flex-wrap: wrap;">
                                <span class="preview-code" id="prevCode">WH-ORD-04</span>
                                <span class="badge badge-success" id="prevStatus" style="font-size: 0.72rem; padding: 2px 8px;">Active &amp; Operational</span>
                            </div>
                        </div>

                        <!-- Computational Real-time Telemetry Stats -->
                        <div class="preview-calc-grid">
                            <div class="calc-box-item">
                                <span class="calc-box-label">Cubic Volume</span>
                                <span class="calc-box-val" id="calcCubicVol">3.06M ft&sup3;</span>
                            </div>
                            <div class="calc-box-item">
                                <span class="calc-box-label">Pallet Density</span>
                                <span class="calc-box-val" id="calcDensity">72.9 / kft&sup2;</span>
                            </div>
                            <div class="calc-box-item">
                                <span class="calc-box-label">Est. Peak Docks</span>
                                <span class="calc-box-val" id="calcThroughput">336 Plts/hr</span>
                            </div>
                            <div class="calc-box-item">
                                <span class="calc-box-label">Zone Partitions</span>
                                <span class="calc-box-val" id="calcZoneCount">3 Zones</span>
                            </div>
                        </div>

                        <div class="preview-meta-list">
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-layer-group" style="width: 18px;"></i> Classification</span>
                                <span class="preview-meta-val" id="prevType">Regional Fulfillment Center</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-location-dot" style="width: 18px;"></i> Location</span>
                                <span class="preview-meta-val" id="prevLocation">Chicago, IL (USA)</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-ruler-combined" style="width: 18px;"></i> Floor Space</span>
                                <span class="preview-meta-val" id="prevArea">85,000 sq ft</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-dolly" style="width: 18px;"></i> Pallet Capacity</span>
                                <span class="preview-meta-val" id="prevPallets">6,200 Pallets</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-truck-ramp-box" style="width: 18px;"></i> Loading Docks</span>
                                <span class="preview-meta-val" id="prevDocks">14 Docks</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-user-gear" style="width: 18px;"></i> Site Lead</span>
                                <span class="preview-meta-val" id="prevManager">Marcus Rivera</span>
                            </div>
                            <div class="preview-meta-item">
                                <span class="preview-meta-label"><i class="fa-solid fa-temperature-three-quarters" style="width: 18px;"></i> Climate</span>
                                <span class="preview-meta-val" id="prevClimate" style="max-width: 160px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">Standard Ambient</span>
                            </div>
                        </div>

                        <!-- Radar Locator -->
                        <div class="radar-box">
                            <div class="radar-pulse-dot"></div>
                            <div class="radar-text">
                                Geo-corridor: <strong id="prevCorridor">Midwest Freight Hub &bull; I-90</strong>
                            </div>
                        </div>
                    </div>
                </aside>
            </div>
        </main>
    </div>

    <!-- External Warehouse Controller Script -->
    <script src="${pageContext.request.contextPath}/warehouse/js/warehouse.js?v=2.2"></script>
</body>
</html>
