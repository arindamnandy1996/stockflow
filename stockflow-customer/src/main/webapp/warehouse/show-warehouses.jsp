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
    // Session Verification & Customer Profile
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
    <title>All Warehouses &bull; StockFlow Fleet Directory</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css?v=2.2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/warehouse/css/warehouse.css?v=2.2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/warehouse/css/show-warehouses.css?v=2.2">
</head>
<body>

    <!-- Toast Notification Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- =========================================================================
         MODAL 1: VIEW WAREHOUSE DETAILS & LIVE TELEMETRY
         ========================================================================= -->
    <div class="modal-overlay" id="viewDetailsModal">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3>
                    <i class="fa-solid fa-building-circle-check" style="color: #38bdf8;"></i>
                    Facility Specifications &amp; Telemetry
                </h3>
                <button class="modal-close-btn" onclick="closeDetailsModal()">&times;</button>
            </div>

            <div class="modal-wh-banner">
                <div>
                    <h2 id="detailsWhName">Central Logistics Hub</h2>
                    <div style="display: flex; gap: 8px; align-items: center; margin-top: 4px;">
                        <code id="detailsWhCode" style="font-family: 'JetBrains Mono', monospace; font-size: 0.85rem; color: #818cf8; background: rgba(129,140,248,0.15); padding: 3px 8px; border-radius: 4px;">WH-CHI-01</code>
                        <span style="color: var(--text-dim);">&bull;</span>
                        <span id="detailsWhType" style="color: var(--text-muted); font-size: 0.85rem; font-weight: 600;">Distribution Center</span>
                    </div>
                </div>
                <span class="badge badge-success" id="detailsWhStatus" style="font-size: 0.8rem; padding: 4px 12px;">Active &amp; Operational</span>
            </div>

            <!-- Live Sensor Data Strip -->
            <div class="sensor-stream-grid">
                <div class="sensor-tile">
                    <div class="sensor-tile-label"><i class="fa-solid fa-temperature-half" style="color: #f59e0b;"></i> Ambient Temp</div>
                    <div class="sensor-tile-val" id="detailsSensorTemp">20.4 &deg;C</div>
                </div>
                <div class="sensor-tile">
                    <div class="sensor-tile-label"><i class="fa-solid fa-droplet" style="color: #38bdf8;"></i> Relative Humidity</div>
                    <div class="sensor-tile-val" id="detailsSensorHumidity">42.8 %</div>
                </div>
                <div class="sensor-tile">
                    <div class="sensor-tile-label"><i class="fa-solid fa-boxes-packing" style="color: #10b981;"></i> Current Bay Occupancy</div>
                    <div class="sensor-tile-val" id="detailsSensorOccupancy">74.2 %</div>
                </div>
                <div class="sensor-tile">
                    <div class="sensor-tile-label"><i class="fa-solid fa-truck-fast" style="color: #818cf8;"></i> Active Dock Doors</div>
                    <div class="sensor-tile-val" id="detailsSensorDocks">6 / 16 In Use</div>
                </div>
            </div>

            <!-- Location & Specs Sections -->
            <div class="modal-section-box">
                <div class="modal-section-header">
                    <i class="fa-solid fa-map-location-dot"></i> Geo-Logistics &amp; Physical Infrastructure
                </div>
                <div class="modal-key-val-grid">
                    <div class="key-val-item">
                        <span class="key-val-label">Street Address</span>
                        <span class="key-val-data" id="detailsWhAddress">7420 North Port Boulevard</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">City, State &amp; Country</span>
                        <span class="key-val-data" id="detailsWhLocation">Chicago, IL 60666 (United States)</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Logistics Corridor</span>
                        <span class="key-val-data" id="detailsWhCorridor">Midwest Freight Hub &bull; I-90</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Climate Control Environment</span>
                        <span class="key-val-data" id="detailsWhClimate">Standard Ambient (15&deg;C - 25&deg;C)</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Total Floor Area</span>
                        <span class="key-val-data" id="detailsWhArea">110,000 sq ft</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Pallet Storage Positions</span>
                        <span class="key-val-data" id="detailsWhPallets">8,500 Pallet Positions</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Loading Dock Doors</span>
                        <span class="key-val-data" id="detailsWhDocks">16 Loading Dock Doors</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Clear Ceiling Height</span>
                        <span class="key-val-data" id="detailsWhHeight">36 ft Clear Height</span>
                    </div>
                </div>
            </div>

            <!-- Storage Zones Breakdown -->
            <div class="modal-section-box">
                <div class="modal-section-header">
                    <i class="fa-solid fa-network-wired"></i> Partitioned Storage Zones
                </div>
                <table class="modal-zones-table">
                    <thead>
                        <tr>
                            <th>Partition / Zone Name</th>
                            <th>Racking Architecture</th>
                            <th style="text-align: right;">Allocated Capacity</th>
                        </tr>
                    </thead>
                    <tbody id="detailsZonesTbody">
                        <!-- Populated dynamically by JS -->
                    </tbody>
                </table>
            </div>

            <!-- Operations & Contact -->
            <div class="modal-section-box">
                <div class="modal-section-header">
                    <i class="fa-solid fa-user-tie"></i> Facility Operations &amp; Management Contact
                </div>
                <div class="modal-key-val-grid">
                    <div class="key-val-item">
                        <span class="key-val-label">General Manager</span>
                        <span class="key-val-data" id="detailsWhManager">Marcus Rivera</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Direct Email</span>
                        <span class="key-val-data" id="detailsWhEmail">m.rivera@stockflow.io</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Operations Phone</span>
                        <span class="key-val-data" id="detailsWhPhone">+1 (312) 555-0199</span>
                    </div>
                    <div class="key-val-item">
                        <span class="key-val-label">Shift Scheduling</span>
                        <span class="key-val-data" id="detailsWhShifts">24/7 Continuous (3 Shifts)</span>
                    </div>
                </div>
                <div style="margin-top: 12px; font-size: 0.8rem; color: var(--text-dim);">
                    <strong>Notes:</strong> <span id="detailsWhNotes">Primary Midwest automated cross-dock hub.</span>
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeDetailsModal()">
                    Close
                </button>
                <button type="button" class="btn btn-primary btn-sm" onclick="closeDetailsModal(); openEditModal(selectedWhForAction.id)">
                    <i class="fa-solid fa-pen-to-square"></i> Edit Facility
                </button>
            </div>
        </div>
    </div>

    <!-- =========================================================================
         MODAL 2: EDIT WAREHOUSE MODAL
         ========================================================================= -->
    <div class="modal-overlay" id="editWarehouseModal">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3>
                    <i class="fa-solid fa-pen-to-square" style="color: #818cf8;"></i>
                    Edit Warehouse Facility
                </h3>
                <button class="modal-close-btn" onclick="closeEditModal()">&times;</button>
            </div>

            <form id="editWarehouseForm" onsubmit="handleEditWarehouseSubmit(event)">
                <input type="hidden" id="editWhId">

                <!-- Section 1: Identity -->
                <div class="wh-form-section">
                    <div class="wh-section-title">
                        <i class="fa-solid fa-info-circle"></i> 1. Identification &amp; Classification
                    </div>
                    <div class="form-grid form-grid-3">
                        <div class="form-group" style="grid-column: span 2;">
                            <label class="form-label" for="editWhName">Facility Name <span class="req">*</span></label>
                            <input type="text" id="editWhName" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhCode">Facility Code / Node ID <span class="req">*</span></label>
                            <input type="text" id="editWhCode" class="form-input" required>
                        </div>
                    </div>
                    <div class="form-grid form-grid-2">
                        <div class="form-group">
                            <label class="form-label" for="editWhType">Facility Classification <span class="req">*</span></label>
                            <select id="editWhType" class="form-select" required>
                                <option value="Regional Fulfillment Center">Regional Fulfillment Center (RFC)</option>
                                <option value="Distribution Center">Central Distribution Center (CDC)</option>
                                <option value="Micro-Fulfillment Center">Micro-Fulfillment Center (MFC)</option>
                                <option value="Cold Storage &amp; Reefer">Cold Storage &amp; Temperature-Controlled Reefer</option>
                                <option value="Cross-Dock Terminal">High-Velocity Cross-Dock Terminal</option>
                                <option value="Bonded Customs Warehouse">Bonded Customs &amp; Foreign Trade Zone</option>
                                <option value="Bulk Storage &amp; Heavy Goods">Bulk Storage &amp; Heavy Cargo Facility</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhStatus">Operational Status</label>
                            <select id="editWhStatus" class="form-select">
                                <option value="Active &amp; Operational">Active &amp; Operational</option>
                                <option value="In Setup / Pre-Launch">In Setup / Pre-Launch</option>
                                <option value="Under Maintenance">Under Maintenance</option>
                                <option value="Decommissioned / Inactive">Decommissioned / Inactive</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Section 2: Location -->
                <div class="wh-form-section">
                    <div class="wh-section-title">
                        <i class="fa-solid fa-map-location-dot"></i> 2. Location &amp; Geo-Logistics
                    </div>
                    <div class="form-group" style="margin-bottom: 14px;">
                        <label class="form-label" for="editWhAddress">Street Address <span class="req">*</span></label>
                        <input type="text" id="editWhAddress" class="form-input" required>
                    </div>
                    <div class="form-grid form-grid-3">
                        <div class="form-group">
                            <label class="form-label" for="editWhCountry">Country <span class="req">*</span></label>
                            <select id="editWhCountry" class="form-select" required>
                                <option value="United States">United States</option>
                                <option value="Canada">Canada</option>
                                <option value="United Kingdom">United Kingdom</option>
                                <option value="Germany">Germany</option>
                                <option value="Singapore">Singapore</option>
                                <option value="Australia">Australia</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhState">State / Province <span class="req">*</span></label>
                            <input type="text" id="editWhState" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhCity">City <span class="req">*</span></label>
                            <input type="text" id="editWhCity" class="form-input" required>
                        </div>
                    </div>
                    <div class="form-grid form-grid-2">
                        <div class="form-group">
                            <label class="form-label" for="editWhZip">Postal / ZIP Code <span class="req">*</span></label>
                            <input type="text" id="editWhZip" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhZone">Logistics Corridor / Zone</label>
                            <input type="text" id="editWhZone" class="form-input">
                        </div>
                    </div>
                </div>

                <!-- Section 3: Physical & Capacity -->
                <div class="wh-form-section">
                    <div class="wh-section-title">
                        <i class="fa-solid fa-cube"></i> 3. Capacity &amp; Physical Specifications
                    </div>
                    <div class="form-grid form-grid-3">
                        <div class="form-group">
                            <label class="form-label" for="editWhArea">Total Area (sq ft) <span class="req">*</span></label>
                            <input type="number" id="editWhArea" class="form-input" min="1000" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhPallets">Pallet Capacity <span class="req">*</span></label>
                            <input type="number" id="editWhPallets" class="form-input" min="50" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhDocks">Dock Doors <span class="req">*</span></label>
                            <input type="number" id="editWhDocks" class="form-input" min="1" required>
                        </div>
                    </div>
                    <div class="form-grid form-grid-2">
                        <div class="form-group">
                            <label class="form-label" for="editWhClearHeight">Clear Height (ft)</label>
                            <input type="number" id="editWhClearHeight" class="form-input" min="12">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhClimate">Climate Control</label>
                            <select id="editWhClimate" class="form-select">
                                <option value="Standard Ambient (15&deg;C - 25&deg;C)">Standard Ambient (15&deg;C - 25&deg;C)</option>
                                <option value="Air-Conditioned Precision (18&deg;C - 22&deg;C)">Air-Conditioned Precision (18&deg;C - 22&deg;C)</option>
                                <option value="Chilled Refrigeration (2&deg;C - 8&deg;C)">Chilled Refrigeration (2&deg;C - 8&deg;C)</option>
                                <option value="Deep Freeze (-20&deg;C to -10&deg;C)">Deep Freeze (-20&deg;C to -10&deg;C)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Section 4: Management & Notes -->
                <div class="wh-form-section">
                    <div class="wh-section-title">
                        <i class="fa-solid fa-user-shield"></i> 4. Facility Management &amp; Shifts
                    </div>
                    <div class="form-grid form-grid-3">
                        <div class="form-group">
                            <label class="form-label" for="editWhManager">Facility Manager <span class="req">*</span></label>
                            <input type="text" id="editWhManager" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhEmail">Contact Email <span class="req">*</span></label>
                            <input type="email" id="editWhEmail" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhPhone">Phone Number <span class="req">*</span></label>
                            <input type="text" id="editWhPhone" class="form-input" required>
                        </div>
                    </div>
                    <div class="form-grid form-grid-2">
                        <div class="form-group">
                            <label class="form-label" for="editWhShifts">Operating Shifts</label>
                            <select id="editWhShifts" class="form-select">
                                <option value="24/7 Continuous (3 Shifts)">24/7 Continuous (3 Shifts)</option>
                                <option value="2 Shifts (16 Hours/Day)">2 Shifts (16 Hours/Day)</option>
                                <option value="1 Shift Standard (8 Hours/Day)">1 Shift Standard (8 Hours/Day)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="editWhNotes">Operational Notes</label>
                            <input type="text" id="editWhNotes" class="form-input">
                        </div>
                    </div>
                </div>

                <!-- Features Flags -->
                <div class="wh-form-section">
                    <div class="wh-section-title">
                        <i class="fa-solid fa-shield-halved"></i> 5. Capabilities &amp; Certifications
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 0.82rem; color: var(--text-main); cursor: pointer;">
                            <input type="checkbox" id="editCheckHazmat"> Hazmat Certified
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 0.82rem; color: var(--text-main); cursor: pointer;">
                            <input type="checkbox" id="editCheckRFID"> RFID Gates
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 0.82rem; color: var(--text-main); cursor: pointer;">
                            <input type="checkbox" id="editCheckCustoms"> Customs Bonded
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 0.82rem; color: var(--text-main); cursor: pointer;">
                            <input type="checkbox" id="editCheckIoT"> IoT Sensor Mesh
                        </label>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--wh-border);">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="closeEditModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-floppy-disk"></i> Save Facility Updates
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- =========================================================================
         MODAL 3: DECOMMISSION CONFIRMATION MODAL
         ========================================================================= -->
    <div class="modal-overlay" id="decommissionConfirmModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="decomModalTitle">
                    <i class="fa-solid fa-triangle-exclamation" style="color: #ef4444;"></i>
                    Decommission Warehouse Hub
                </h3>
                <button class="modal-close-btn" onclick="closeDecomConfirmModal()">&times;</button>
            </div>
            <div>
                <p style="font-size: 0.88rem; color: var(--text-main); margin-bottom: 12px;">
                    Target Facility: <strong id="decomWhName" style="color: #f8fafc;">Central Logistics Hub</strong>
                    (<code id="decomWhCode" style="font-family: 'JetBrains Mono', monospace; color: #818cf8;">WH-CHI-01</code>)
                </p>
                <p style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 14px;">
                    Location: <span id="decomWhLocation">Chicago, IL (United States)</span>
                </p>

                <div style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.3); border-radius: var(--radius-md); padding: 14px; margin-bottom: 20px;">
                    <p style="font-size: 0.82rem; color: #fca5a5; line-height: 1.5;" id="decomWarningText">
                        Decommissioning will suspend all automated replenishment, picking routes, and edge IoT telemetry for this node in your active logistics network.
                    </p>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label class="form-label" for="decomReason">Reason for Decommissioning</label>
                    <select id="decomReason" class="form-select">
                        <option value="Network Fleet Consolidation">Network Fleet Consolidation &amp; Route Optimization</option>
                        <option value="Lease Term Expiration">Facility Lease Term Expiration</option>
                        <option value="Relocation to Expanded Node">Relocation to Larger Multi-Bay Node</option>
                        <option value="Emergency Maintenance / Retrofit">Emergency Maintenance / Automation Retrofit</option>
                    </select>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="closeDecomConfirmModal()">
                        Cancel
                    </button>
                    <button type="button" class="btn btn-outline btn-sm" id="decomConfirmBtn" onclick="executeDecommission()">
                        <i class="fa-solid fa-trash-can"></i> Confirm Decommission
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- =========================================================================
         APP LAYOUT: SIDEBAR & MAIN DASHBOARD
         ========================================================================= -->
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
                                <span>Warehouses ( <span id="navWhCount">13</span> )</span>
                            </div>
                            <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                        </button>
                        <div class="dash-dropdown-menu show" id="warehouseDropdownMenu">
                            <a href="${pageContext.request.contextPath}/warehouse/new-warehouse.jsp?action=create" class="dash-dropdown-item" id="navAction-create">
                                <i class="fa-solid fa-plus"></i>
                                <span>create new</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/show-warehouses.jsp" class="dash-dropdown-item active" id="navAction-show">
                                <i class="fa-solid fa-table-list"></i>
                                <span>show warehouses</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/new-warehouse.jsp?action=update" class="dash-dropdown-item" id="navAction-update">
                                <i class="fa-solid fa-pen-to-square"></i>
                                <span>Update a warehouse</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/new-warehouse.jsp?action=decommission" class="dash-dropdown-item" id="navAction-decommission">
                                <i class="fa-solid fa-trash-can"></i>
                                <span>Decommission warehouse</span>
                            </a>
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
                <a href="${pageContext.request.contextPath}/warehouse/show-warehouses.jsp">Warehouses</a>
                <i class="fa-solid fa-chevron-right"></i>
                <span class="current">Show Warehouses &bull; Multi-Node Fleet</span>
            </div>

            <!-- Page Header -->
            <header class="dash-header">
                <div class="dash-title">
                    <h1>Connected Warehouse Fleet Directory</h1>
                    <p>Comprehensive logistics facilities, multi-country nodes &amp; edge sensor telemetry for <strong><%= escapeHtml(userCompany) %></strong></p>
                </div>
                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <button type="button" class="btn btn-outline btn-sm" onclick="exportWarehouseFleet('csv')">
                        <i class="fa-solid fa-file-csv"></i> Export CSV
                    </button>
                    <button type="button" class="btn btn-outline btn-sm" onclick="exportWarehouseFleet('json')">
                        <i class="fa-solid fa-file-code"></i> Export JSON
                    </button>
                    <a href="${pageContext.request.contextPath}/warehouse/new-warehouse.jsp?action=create" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-plus-circle"></i> Provision New Facility
                    </a>
                </div>
            </header>

            <!-- KPI Stats Summary Strip -->
            <div class="wh-stats-strip">
                <div class="wh-stat-card">
                    <div class="wh-stat-icon">
                        <i class="fa-solid fa-warehouse"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="kpiTotalHubs">13 Hubs</h4>
                        <p>Total Fleet Nodes</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(16, 185, 129, 0.15); color: #10b981;">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="kpiOperationalHubs">12 Active</h4>
                        <p>Live Operational Hubs</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(6, 182, 212, 0.15); color: #38bdf8;">
                        <i class="fa-solid fa-maximize"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="kpiTotalArea">1,023,000 sq ft</h4>
                        <p>Total Fleet Floor Space</p>
                    </div>
                </div>

                <div class="wh-stat-card">
                    <div class="wh-stat-icon" style="background: rgba(245, 158, 11, 0.15); color: #f59e0b;">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>
                    <div class="wh-stat-info">
                        <h4 id="kpiTotalPallets">74,900</h4>
                        <p>Pallet Storage Positions</p>
                    </div>
                </div>
            </div>

            <!-- =========================================================================
                 CASCADING FILTER TOOLBAR: Country -> State -> City
                 ========================================================================= -->
            <div class="filter-toolbar">
                <div class="filter-toolbar-header">
                    <div class="filter-toolbar-title">
                        <i class="fa-solid fa-filter"></i>
                        <span>Geo-Logistics &amp; Facility Filtering</span>
                    </div>

                    <div class="filter-toolbar-actions">
                        <!-- View Mode Toggle (Table / Grid) -->
                        <div class="view-mode-toggle">
                            <button type="button" class="view-mode-btn active" id="viewModeTable" onclick="setViewMode('table')" title="Tabular Grid View">
                                <i class="fa-solid fa-table-list"></i> Table
                            </button>
                            <button type="button" class="view-mode-btn" id="viewModeGrid" onclick="setViewMode('grid')" title="Visual Cards View">
                                <i class="fa-solid fa-grip"></i> Cards
                            </button>
                        </div>

                        <button type="button" class="btn btn-outline btn-sm" onclick="resetAllFilters()" style="padding: 6px 12px; font-size: 0.8rem; color: #ef4444; border-color: rgba(239,68,68,0.25);">
                            <i class="fa-solid fa-rotate-left"></i> Reset Filters
                        </button>
                    </div>
                </div>

                <!-- Cascading Filter Row: Country -> State -> City + Type & Status -->
                <div class="cascading-filter-grid">
                    <!-- 1. Country Selector -->
                    <div class="filter-group">
                        <label class="filter-label" for="filterCountry">
                            <span class="filter-step">1</span>
                            <span>Country</span>
                        </label>
                        <select id="filterCountry" class="filter-select" onchange="handleCountryChange()">
                            <option value="all">All Countries (Global Fleet)</option>
                            <!-- Populated dynamically via JS -->
                        </select>
                    </div>

                    <!-- 2. State / Province Selector (Cascades from Country) -->
                    <div class="filter-group">
                        <label class="filter-label" for="filterState">
                            <span class="filter-step">2</span>
                            <span>State / Province</span>
                        </label>
                        <select id="filterState" class="filter-select" onchange="handleStateChange()">
                            <option value="all">All States / Provinces</option>
                            <!-- Populated dynamically via JS -->
                        </select>
                    </div>

                    <!-- 3. City Selector (Cascades from Country & State) -->
                    <div class="filter-group">
                        <label class="filter-label" for="filterCity">
                            <span class="filter-step">3</span>
                            <span>City</span>
                        </label>
                        <select id="filterCity" class="filter-select" onchange="handleCityChange()">
                            <option value="all">All Cities</option>
                            <!-- Populated dynamically via JS -->
                        </select>
                    </div>

                    <!-- 4. Classification Type Filter -->
                    <div class="filter-group">
                        <label class="filter-label" for="filterType">
                            <i class="fa-solid fa-tag" style="color: #818cf8; font-size: 0.75rem;"></i>
                            <span>Facility Type</span>
                        </label>
                        <select id="filterType" class="filter-select" onchange="applyFilters()">
                            <option value="all">All Classifications</option>
                            <option value="Distribution Center">Distribution Center (CDC)</option>
                            <option value="Regional Fulfillment Center">Regional Fulfillment Center (RFC)</option>
                            <option value="Micro-Fulfillment Center">Micro-Fulfillment Center (MFC)</option>
                            <option value="Cold Storage &amp; Reefer">Cold Storage &amp; Reefer</option>
                            <option value="Cross-Dock Terminal">Cross-Dock Terminal</option>
                            <option value="Bonded Customs Warehouse">Bonded Customs Warehouse</option>
                        </select>
                    </div>

                    <!-- 5. Operational Status Filter -->
                    <div class="filter-group">
                        <label class="filter-label" for="filterStatus">
                            <i class="fa-solid fa-signal" style="color: #10b981; font-size: 0.75rem;"></i>
                            <span>Status</span>
                        </label>
                        <select id="filterStatus" class="filter-select" onchange="applyFilters()">
                            <option value="all">All Statuses</option>
                            <option value="Operational">Operational / Active</option>
                            <option value="Setup">In Setup / Pre-Launch</option>
                            <option value="Maintenance">Under Maintenance</option>
                            <option value="Decommissioned">Decommissioned</option>
                        </select>
                    </div>
                </div>

                <!-- Secondary Filter Bar (Keyword Search & Active Filter Chips) -->
                <div class="filter-secondary-bar">
                    <div class="filter-search-box">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" id="filterKeyword" class="filter-input" placeholder="Search by name, code, manager, zone..." oninput="applyFilters()">
                    </div>

                    <!-- Active Filter Chips Area -->
                    <div class="active-filter-chips" id="activeFilterChips">
                        <!-- Populated dynamically -->
                    </div>
                </div>
            </div>

            <!-- Results Meta Bar -->
            <div class="results-meta-bar">
                <div class="results-meta-text">
                    Showing <strong id="filteredCount">13</strong> of <span id="totalCountBadge">13</span> warehouse facilities
                </div>
                <div style="font-size: 0.8rem; color: var(--text-dim);">
                    <i class="fa-solid fa-arrows-rotate" style="color: #38bdf8;"></i> Real-time fleet synchronization active
                </div>
            </div>

            <!-- =========================================================================
                 RESULTS VIEW 1: TABLE VIEW
                 ========================================================================= -->
            <div class="table-card" id="tableWrapper">
                <table class="wh-table">
                    <thead>
                        <tr>
                            <th class="sortable" id="th-name" onclick="sortTableBy('name')">
                                Facility &amp; Code <i class="fa-solid fa-sort sort-icon"></i>
                            </th>
                            <th class="sortable" id="th-city" onclick="sortTableBy('city')">
                                Location (City / State / Country) <i class="fa-solid fa-sort sort-icon"></i>
                            </th>
                            <th class="sortable" id="th-area" onclick="sortTableBy('area')">
                                Capacity &amp; Docks <i class="fa-solid fa-sort sort-icon"></i>
                            </th>
                            <th class="sortable" id="th-manager" onclick="sortTableBy('manager')">
                                Manager &amp; Shift <i class="fa-solid fa-sort sort-icon"></i>
                            </th>
                            <th class="sortable" id="th-status" onclick="sortTableBy('status')">
                                Status <i class="fa-solid fa-sort sort-icon"></i>
                            </th>
                            <th style="text-align: right;">Action Protocols</th>
                        </tr>
                    </thead>
                    <tbody id="warehousesTableBody">
                        <!-- Populated dynamically by show-warehouses.js -->
                    </tbody>
                </table>
            </div>

            <!-- =========================================================================
                 RESULTS VIEW 2: CARDS / GRID VIEW
                 ========================================================================= -->
            <div id="gridWrapper" style="display: none;">
                <div class="warehouse-cards-grid" id="warehousesCardsGrid">
                    <!-- Populated dynamically by show-warehouses.js -->
                </div>
            </div>

            <!-- Empty Results Placeholder Box -->
            <div class="empty-results-box" id="emptyResultsBox" style="display: none;">
                <div class="empty-results-icon">
                    <i class="fa-solid fa-warehouse"></i>
                </div>
                <div class="empty-results-title">No Warehouses Found</div>
                <div class="empty-results-desc">
                    No connected logistics facilities match the selected country, state, city, or keyword criteria.
                </div>
                <button type="button" class="btn btn-secondary btn-sm" onclick="resetAllFilters()">
                    <i class="fa-solid fa-rotate-left"></i> Reset Filter Criteria
                </button>
            </div>
        </main>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/warehouse/js/show-warehouses.js?v=2.2"></script>
</body>
</html>
