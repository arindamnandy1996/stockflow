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
    <title>Customer Dashboard &bull; StockFlow Intelligence Portal</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css?v=2.2">
    
    <style>
        .dashboard-layout {
            display: grid;
            grid-template-columns: 260px 1fr;
            min-height: 100vh;
            background: #0b0f19;
        }

        /* Dashboard Sidebar */
        .dash-sidebar {
            background: rgba(17, 24, 39, 0.95);
            border-right: 1px solid var(--border-subtle);
            padding: 24px 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .dash-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.3rem;
            font-weight: 800;
            margin-bottom: 36px;
            text-decoration: none;
            color: var(--text-main);
        }

        .dash-nav {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .dash-nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 0.92rem;
            font-weight: 600;
            color: var(--text-muted);
            text-decoration: none;
            transition: var(--transition);
            background: transparent;
            border: 1px solid transparent;
            cursor: pointer;
            width: 100%;
            text-align: left;
            font-family: inherit;
            box-sizing: border-box;
            outline: none;
        }

        .dash-nav-item:hover, .dash-nav-item.active {
            background: rgba(79, 70, 229, 0.15);
            color: #818cf8;
            border: 1px solid rgba(129, 140, 248, 0.2);
        }

        .dash-nav-item i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
            flex-shrink: 0;
        }

        /* Sidebar Nav Dropdown */
        .dash-nav-dropdown {
            display: flex;
            flex-direction: column;
            width: 100%;
            box-sizing: border-box;
        }

        .dash-dropdown-toggle {
            justify-content: space-between;
            background: transparent;
            border: 1px solid transparent;
            cursor: pointer;
            font-family: inherit;
            text-align: left;
            width: 100%;
            box-sizing: border-box;
            color: var(--text-muted);
        }

        .dash-dropdown-toggle:hover,
        .dash-dropdown-toggle.active,
        .dash-nav-dropdown.open > .dash-dropdown-toggle {
            background: rgba(79, 70, 229, 0.15);
            color: #818cf8;
            border-color: rgba(129, 140, 248, 0.2);
        }

        .dash-dropdown-toggle .nav-item-content {
            display: flex;
            align-items: center;
            gap: 12px;
            flex: 1;
            min-width: 0;
        }

        .dash-dropdown-toggle .dropdown-arrow {
            font-size: 0.72rem;
            color: var(--text-dim);
            transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            margin-left: auto;
            width: auto;
            flex-shrink: 0;
        }

        .dash-nav-dropdown.open .dash-dropdown-toggle .dropdown-arrow,
        .dash-dropdown-toggle[aria-expanded="true"] .dropdown-arrow {
            transform: rotate(180deg);
            color: #818cf8;
        }

        .dash-dropdown-menu {
            display: none;
            flex-direction: column;
            gap: 3px;
            margin: 4px 0 6px 14px;
            padding: 4px 0 4px 12px;
            border-left: 2px solid rgba(99, 102, 241, 0.28);
            box-sizing: border-box;
            animation: fadeInDropdown 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .dash-dropdown-menu.show,
        .dash-nav-dropdown.open > .dash-dropdown-menu {
            display: flex;
        }

        @keyframes fadeInDropdown {
            from {
                opacity: 0;
                transform: translateY(-4px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dash-dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.83rem;
            font-weight: 500;
            color: var(--text-muted);
            text-decoration: none;
            white-space: nowrap;
            transition: var(--transition);
            cursor: pointer;
            background: transparent;
            border: 1px solid transparent;
            text-align: left;
            font-family: inherit;
            width: 100%;
            box-sizing: border-box;
            outline: none;
        }

        .dash-dropdown-item:hover,
        .dash-dropdown-item.active {
            background: rgba(79, 70, 229, 0.12);
            color: #818cf8;
            border-color: rgba(129, 140, 248, 0.2);
            transform: translateX(3px);
        }

        .dash-dropdown-item i {
            font-size: 0.85rem;
            width: 16px;
            text-align: center;
            color: var(--text-dim);
            flex-shrink: 0;
        }

        .dash-dropdown-item:hover i,
        .dash-dropdown-item.active i {
            color: #38bdf8;
        }

        .dash-user-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 14px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .dash-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4f46e5, #06b6d4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            color: white;
            flex-shrink: 0;
        }

        .dash-user-details h5 {
            font-size: 0.88rem;
            font-weight: 700;
            color: var(--text-main);
        }

        .dash-user-details p {
            font-size: 0.75rem;
            color: var(--text-dim);
        }

        /* Dashboard Main Area */
        .dash-main {
            padding: 32px 40px;
            overflow-y: auto;
        }

        .dash-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }

        .dash-title h1 {
            font-size: 1.8rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .dash-title p {
            color: var(--text-muted);
            font-size: 0.92rem;
        }

        .dash-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 32px;
        }

        .kpi-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-md);
            padding: 22px;
            position: relative;
            overflow: hidden;
            transition: var(--transition);
        }

        .kpi-card:hover {
            border-color: rgba(99, 102, 241, 0.4);
            transform: translateY(-2px);
        }

        .kpi-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .kpi-label {
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-dim);
        }

        .kpi-icon {
            font-size: 1.1rem;
            color: #818cf8;
        }

        .kpi-val {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-main);
            margin-bottom: 6px;
        }

        .kpi-badge {
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .kpi-positive { color: #10b981; }
        .kpi-warning { color: #f59e0b; }

        /* Content Grid */
        .dash-content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }

        .content-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: var(--radius-lg);
            padding: 24px;
        }

        .card-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--border-subtle);
        }

        .card-heading h3 {
            font-size: 1.1rem;
            font-weight: 700;
        }

        @media (max-width: 1024px) {
            .dashboard-layout {
                grid-template-columns: 1fr;
            }
            .dash-sidebar {
                display: none;
            }
            .dash-kpi-grid {
                grid-template-columns: 1fr 1fr;
            }
            .dash-content-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

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
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="dash-nav-item active">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>Overview</span>
                    </a>

                    <a href="#" class="dash-nav-item">
                        <i class="fa-solid fa-barcode"></i>
                        <span>Inventory &amp; SKUs</span>
                    </a>

                    <!-- Warehouses Nav Item with Collapsible Submenu Dropdown -->
                    <div class="dash-nav-dropdown" id="warehouseNavDropdown">
                        <button type="button" class="dash-nav-item dash-dropdown-toggle" id="whDropdownToggle" onclick="toggleNavDropdown('warehouseNavDropdown')" aria-expanded="false">
                            <div class="nav-item-content">
                                <i class="fa-solid fa-warehouse"></i>
                                <span>Warehouses</span>
                            </div>
                            <i class="fa-solid fa-chevron-down dropdown-arrow"></i>
                        </button>
                        <div class="dash-dropdown-menu" id="warehouseDropdownMenu">
                            <a href="${pageContext.request.contextPath}/warehouse/new-warehouse.jsp?action=create" class="dash-dropdown-item" id="navAction-create">
                                <i class="fa-solid fa-plus"></i>
                                <span>create new</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/warehouse/show-warehouses.jsp" class="dash-dropdown-item" id="navAction-show">
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

                    <a href="#" class="dash-nav-item">
                        <i class="fa-solid fa-truck-ramp-box"></i>
                        <span>Inbound / POs</span>
                    </a>

                    <a href="#" class="dash-nav-item">
                        <i class="fa-solid fa-dolly"></i>
                        <span>Picking &amp; Dispatch</span>
                    </a>

                    <a href="#" class="dash-nav-item">
                        <i class="fa-solid fa-bolt"></i>
                        <span>AI Demand Forecast</span>
                    </a>

                    <a href="#" class="dash-nav-item">
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
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline btn-sm" style="flex: 1; font-size: 0.78rem;">
                        <i class="fa-solid fa-house"></i> Home
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="flex: 1; font-size: 0.78rem; color: #ef4444; border-color: rgba(239, 68, 68, 0.3);">
                        <i class="fa-solid fa-power-off"></i> Logout
                    </a>
                </div>
            </div>
        </aside>

        <!-- Main Dashboard View Area -->
        <main class="dash-main">
            <!-- Header -->
            <header class="dash-header">
                <div class="dash-title">
                    <h1>Enterprise Inventory Command Center</h1>
                    <p>Connected to <strong><%= escapeHtml(userCompany) %></strong> &bull; Plan: <span class="badge badge-primary" style="padding: 2px 8px; font-size: 0.75rem;"><%= escapeHtml(userPlan) %></span> &bull; Account ID: <code><%= escapeHtml(customerId) %></code></p>
                </div>
                <div style="display: flex; gap: 12px;">
                    <button type="button" class="btn btn-outline btn-sm" onclick="showToast('Exporting real-time telemetry and inventory reports...', 'info')">
                        <i class="fa-solid fa-download"></i> Export Reports
                    </button>
                    <a href="${pageContext.request.contextPath}/warehouse/show-warehouses.jsp" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-warehouse"></i> Warehouse Fleet
                    </a>
                </div>
            </header>

            <!-- KPI Metric Cards Grid -->
            <div class="dash-kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Active SKUs</span>
                        <i class="fa-solid fa-boxes-stacked kpi-icon"></i>
                    </div>
                    <div class="kpi-val">14,280</div>
                    <span class="kpi-badge kpi-positive"><i class="fa-solid fa-arrow-up"></i> +48 added this week</span>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Stock Valuation</span>
                        <i class="fa-solid fa-vault kpi-icon" style="color: #38bdf8;"></i>
                    </div>
                    <div class="kpi-val">$2,845,920</div>
                    <span class="kpi-badge kpi-positive"><i class="fa-solid fa-shield-check"></i> 100% Insured</span>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Fulfillment Rate</span>
                        <i class="fa-solid fa-truck-fast kpi-icon" style="color: #10b981;"></i>
                    </div>
                    <div class="kpi-val">99.8%</div>
                    <span class="kpi-badge kpi-positive"><i class="fa-solid fa-bolt"></i> Avg pick: 12 mins</span>
                </div>

                <div class="kpi-card">
                    <div class="kpi-header">
                        <span class="kpi-label">Low Stock Alerts</span>
                        <i class="fa-solid fa-triangle-exclamation kpi-icon" style="color: #f59e0b;"></i>
                    </div>
                    <div class="kpi-val">3 Items</div>
                    <span class="kpi-badge kpi-warning"><i class="fa-solid fa-clock"></i> Auto-PO queued</span>
                </div>
            </div>

            <!-- Content Grid -->
            <div class="dash-content-grid">
                <!-- Live Warehouse Stock Levels Table -->
                <div class="content-card">
                    <div class="card-heading">
                        <div>
                            <h3>Real-Time SKU Location &amp; Telemetry</h3>
                            <p style="font-size: 0.8rem; color: var(--text-dim);">Live synchronization across Central, East Coast, and West Coast facilities.</p>
                        </div>
                        <span class="badge badge-success"><span class="pulse-dot"></span> LIVE TELEMETRY</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table-mini">
                            <thead>
                                <tr>
                                    <th>SKU &amp; Product</th>
                                    <th>Warehouse Bay</th>
                                    <th>Available Qty</th>
                                    <th>Unit Cost</th>
                                    <th>Reorder Level</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: #f8fafc;">Enterprise Server Blade X4</div>
                                        <div style="font-size: 0.75rem; color: var(--text-dim);"><code style="font-family: 'JetBrains Mono', monospace;">SKU-BLADE-992</code></div>
                                    </td>
                                    <td>Central Hub &bull; Bay A-12</td>
                                    <td style="font-weight: 700; color: #f8fafc;">1,420 Units</td>
                                    <td>$840.00</td>
                                    <td>150 Units</td>
                                    <td><span class="badge badge-success" style="padding: 2px 8px; font-size: 0.72rem;">Optimal</span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: #f8fafc;">100G Fiber Transceiver Module</div>
                                        <div style="font-size: 0.75rem; color: var(--text-dim);"><code style="font-family: 'JetBrains Mono', monospace;">SKU-FIB-100G</code></div>
                                    </td>
                                    <td>East Coast &bull; Bay B-08</td>
                                    <td style="font-weight: 700; color: #f8fafc;">8,950 Units</td>
                                    <td>$125.50</td>
                                    <td>500 Units</td>
                                    <td><span class="badge badge-success" style="padding: 2px 8px; font-size: 0.72rem;">Optimal</span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: #f8fafc;">Thermal Scanner Pro</div>
                                        <div style="font-size: 0.75rem; color: var(--text-dim);"><code style="font-family: 'JetBrains Mono', monospace;">SKU-THRM-442</code></div>
                                    </td>
                                    <td>West Coast &bull; Bay C-02</td>
                                    <td style="font-weight: 700; color: #f59e0b;">24 Units</td>
                                    <td>$310.00</td>
                                    <td>50 Units</td>
                                    <td><span class="badge badge-warning" style="padding: 2px 8px; font-size: 0.72rem;">Reorder Triggered</span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; color: #f8fafc;">Industrial IoT Gateway Node</div>
                                        <div style="font-size: 0.75rem; color: var(--text-dim);"><code style="font-family: 'JetBrains Mono', monospace;">SKU-IOT-881</code></div>
                                    </td>
                                    <td>Central Hub &bull; Bay D-19</td>
                                    <td style="font-weight: 700; color: #f8fafc;">3,110 Units</td>
                                    <td>$45.00</td>
                                    <td>200 Units</td>
                                    <td><span class="badge badge-success" style="padding: 2px 8px; font-size: 0.72rem;">Optimal</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Recent Dispatch & Live Activity Stream -->
                <div class="content-card">
                    <div class="card-heading">
                        <h3>Warehouse Activity Feed</h3>
                        <i class="fa-solid fa-wave-square" style="color: #818cf8;"></i>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <div style="display: flex; gap: 12px; align-items: flex-start;">
                            <div style="width: 32px; height: 32px; border-radius: 8px; background: rgba(16, 185, 129, 0.15); color: #10b981; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <i class="fa-solid fa-check"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.85rem; font-weight: 700; color: #f8fafc;">PO #4892 Received &amp; Stowed</div>
                                <div style="font-size: 0.75rem; color: var(--text-dim);">Central Hub &bull; 2 mins ago</div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 12px; align-items: flex-start;">
                            <div style="width: 32px; height: 32px; border-radius: 8px; background: rgba(56, 189, 248, 0.15); color: #38bdf8; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <i class="fa-solid fa-truck-fast"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.85rem; font-weight: 700; color: #f8fafc;">Batch #9901 Dispatched</div>
                                <div style="font-size: 0.75rem; color: var(--text-dim);">FedEx Priority &bull; 14 mins ago</div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 12px; align-items: flex-start;">
                            <div style="width: 32px; height: 32px; border-radius: 8px; background: rgba(245, 158, 11, 0.15); color: #f59e0b; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <i class="fa-solid fa-robot"></i>
                            </div>
                            <div>
                                <div style="font-size: 0.85rem; font-weight: 700; color: #f8fafc;">AI Auto-Replenish Sent</div>
                                <div style="font-size: 0.75rem; color: var(--text-dim);">To Supplier MicroCore &bull; 1 hr ago</div>
                            </div>
                        </div>
                    </div>

                    <!-- Sandbox Status Box -->
                    <div style="margin-top: 24px; padding: 14px; background: rgba(79, 70, 229, 0.1); border: 1px solid rgba(129, 140, 248, 0.3); border-radius: var(--radius-md);">
                        <div style="font-size: 0.82rem; font-weight: 700; color: #818cf8; margin-bottom: 4px;">
                            <i class="fa-solid fa-circle-info"></i> Trial Sandbox Active
                        </div>
                        <p style="font-size: 0.76rem; color: var(--text-muted); line-height: 1.4;">
                            Your 14-day full enterprise trial is active. You have full access to MongoDB inventory sync, barcode scanning, and multi-location management.
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Toast Container -->
    <div class="toast-container" id="toastContainer"></div>

    <!-- Dashboard Sidebar & Navigation Controller Scripts -->
    <script>
        // Toggle Sidebar Dropdown Menu
        function toggleNavDropdown(dropdownId) {
            const dropdown = document.getElementById(dropdownId);
            if (!dropdown) return;
            dropdown.classList.toggle('open');
            const menu = dropdown.querySelector('.dash-dropdown-menu');
            const btn = dropdown.querySelector('.dash-dropdown-toggle');
            if (menu) {
                menu.classList.toggle('show');
            }
            if (btn) {
                const isOpen = dropdown.classList.contains('open');
                btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            }
        }

        // Handle Employee Management Submenu Actions
        function handleEmployeeAction(action, e) {
            if (e) e.preventDefault();
            const actionMessages = {
                'create': 'Opening Employee Onboarding wizard...',
                'see-all': 'Displaying active organization personnel & warehouse operators...',
                'update': 'Select an employee profile to update credentials & permissions...',
                'release': 'Employee offboarding & access revocation protocol selected...'
            };
            showToast(actionMessages[action] || 'Employee management selected.', 'info');
        }

        // Toast Notification System
        function showToast(message, type = 'info') {
            const container = document.getElementById('toastContainer');
            if (!container) return;
            const toast = document.createElement('div');
            toast.className = 'toast';
            const icon = type === 'success' ? 'fa-circle-check' : (type === 'error' ? 'fa-triangle-exclamation' : 'fa-circle-info');
            const color = type === 'success' ? '#10b981' : (type === 'error' ? '#ef4444' : '#38bdf8');
            toast.innerHTML = `<i class="fa-solid ${icon}" style="color: ${color}; font-size: 1.1rem;"></i><span>${message}</span>`;
            container.appendChild(toast);
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transform = 'translateX(100%)';
                toast.style.transition = 'all 0.4s ease';
                setTimeout(() => toast.remove(), 400);
            }, 3500);
        }
    </script>
</body>
</html>