<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StockFlow | Intelligent Inventory & Warehouse Management System</title>
    <meta name="description" content="Next-generation inventory and warehouse management platform for enterprise companies. Real-time stock tracking, automated replenishment, and multi-channel fulfillment.">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css">
</head>
<body>

    <!-- Toast Notification Container -->
    <div class="toast-container"></div>

    <!-- Navigation Bar -->
    <header class="navbar">
        <div class="container nav-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                <div class="logo-icon">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>
                <span>Stock<span style="color: #38bdf8;">Flow</span></span>
            </a>

            <nav class="nav-menu">
                <a href="#features" class="nav-link">Features</a>
                <a href="#workflow" class="nav-link">Workflow</a>
                <a href="#solutions" class="nav-link">Solutions</a>
                <a href="#pricing" class="nav-link">Pricing</a>
                <a href="#testimonials" class="nav-link">Testimonials</a>
                <a href="#faq" class="nav-link">FAQ</a>
            </nav>

            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/customer/login/login.jsp" class="btn btn-outline btn-sm btn-login">Customer Portal</a>
                <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="btn btn-primary btn-sm">Get Started Free</a>
                <button class="mobile-toggle" id="mobileToggle" aria-label="Toggle navigation">
                    <i class="fa-solid fa-bars"></i>
                </button>
            </div>
        </div>
    </header>

    <!-- Mobile Nav Drawer (Hidden on Desktop) -->
    <div class="mobile-nav" id="mobileNav">
        <a href="#features" class="nav-link">Features</a>
        <a href="#workflow" class="nav-link">Workflow</a>
        <a href="#solutions" class="nav-link">Solutions</a>
        <a href="#pricing" class="nav-link">Pricing</a>
        <a href="#testimonials" class="nav-link">Testimonials</a>
        <a href="#faq" class="nav-link">FAQ</a>
        <a href="${pageContext.request.contextPath}/customer/login/login.jsp" class="btn btn-outline btn-sm" style="width: 100%; text-align: center;">Customer Portal</a>
        <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="btn btn-primary btn-sm" style="width: 100%; text-align: center;">Get Started Free</a>
    </div>

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="container">
            <div class="hero-grid">
                <div class="hero-content">
                    <div class="badge badge-primary">
                        <span class="pulse-dot"></span>
                        <span>StockFlow 3.2 Released &bull; AI Demand Forecasting</span>
                    </div>

                    <h1 class="hero-title">
                        Intelligent Inventory & <span class="gradient-text">Warehouse Ops</span> for Fast-Growing Companies
                    </h1>

                    <p class="hero-subtitle">
                        Automate stock replenishment, synchronize multi-warehouse locations in real time, eliminate costly stockouts, and streamline B2B & eCommerce fulfillment in one unified platform.
                    </p>

                    <div class="hero-buttons">
                        <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="btn btn-primary btn-lg">
                            <span>Start 14-Day Free Trial</span>
                            <i class="fa-solid fa-arrow-right"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/customer/login/login.jsp" class="btn btn-outline btn-lg">
                            <i class="fa-solid fa-right-to-bracket"></i>
                            <span>Sign In to Portal</span>
                        </a>
                    </div>

                    <div class="hero-stats">
                        <div class="stat-item">
                            <h4>99.9%</h4>
                            <p>Inventory Accuracy</p>
                        </div>
                        <div class="stat-item">
                            <h4>3.5x</h4>
                            <p>Faster Fulfillment</p>
                        </div>
                        <div class="stat-item">
                            <h4>$0</h4>
                            <p>Setup or Migration Fees</p>
                        </div>
                    </div>
                </div>

                <!-- Hero Visual / Live App Dashboard Mockup -->
                <div class="hero-visual" id="demo">
                    <!-- Floating Alert Badges -->
                    <div class="floating-badge floating-badge-1">
                        <i class="fa-solid fa-bell" style="color: #f59e0b; font-size: 1.1rem;"></i>
                        <div>
                            <div style="font-weight: 700; font-size: 0.8rem; color: #f8fafc;">Smart Restock Alert</div>
                            <div style="font-size: 0.72rem; color: var(--text-muted);">Auto-PO #7810 sent to Supplier</div>
                        </div>
                    </div>

                    <div class="floating-badge floating-badge-2">
                        <i class="fa-solid fa-circle-check" style="color: #10b981; font-size: 1.1rem;"></i>
                        <div>
                            <div style="font-weight: 700; font-size: 0.8rem; color: #f8fafc;">Batch Scan Complete</div>
                            <div style="font-size: 0.72rem; color: var(--text-muted);">2,450 Units assigned to Bin #C-14</div>
                        </div>
                    </div>

                    <div class="dashboard-mockup">
                        <div class="mockup-header">
                            <div class="mockup-dots">
                                <span></span>
                                <span></span>
                                <span></span>
                            </div>
                            <div style="font-size: 0.82rem; font-weight: 600; color: var(--text-muted); display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-warehouse" style="color: #818cf8;"></i>
                                <span>Central Distribution Hub</span>
                            </div>
                            <span class="badge badge-success" style="padding: 3px 8px; font-size: 0.7rem;">LIVE SYNC</span>
                        </div>

                        <div class="mockup-body">
                            <!-- Card 1 -->
                            <div class="mockup-card">
                                <div class="mockup-card-title">
                                    <span>Total Active SKUs</span>
                                    <i class="fa-solid fa-barcode" style="color: #818cf8;"></i>
                                </div>
                                <div class="mockup-number">28,490</div>
                                <span style="font-size: 0.78rem; color: #10b981; font-weight: 600;">&uarr; +12% this month</span>
                            </div>

                            <!-- Card 2 -->
                            <div class="mockup-card">
                                <div class="mockup-card-title">
                                    <span>Fulfillment Velocity</span>
                                    <i class="fa-solid fa-bolt" style="color: #38bdf8;"></i>
                                </div>
                                <div class="mockup-number">99.8%</div>
                                <span style="font-size: 0.78rem; color: #10b981; font-weight: 600;">Avg dispatch: 14 mins</span>
                            </div>

                            <!-- Full Card: Inventory Flow Activity -->
                            <div class="mockup-card mockup-card-full">
                                <div class="mockup-card-title">
                                    <span>7-Day Inventory Turnover Trend</span>
                                    <span style="font-size: 0.72rem; color: #38bdf8; font-weight: 600;">Units Shipped vs Received</span>
                                </div>
                                <div class="mockup-chart-bars">
                                    <div class="chart-bar" style="height: 45%;" title="Mon: 450 units"></div>
                                    <div class="chart-bar" style="height: 65%;" title="Tue: 650 units"></div>
                                    <div class="chart-bar" style="height: 40%;" title="Wed: 400 units"></div>
                                    <div class="chart-bar" style="height: 85%;" title="Thu: 850 units"></div>
                                    <div class="chart-bar" style="height: 70%;" title="Fri: 700 units"></div>
                                    <div class="chart-bar" style="height: 95%;" title="Sat: 950 units"></div>
                                    <div class="chart-bar" style="height: 80%;" title="Sun: 800 units"></div>
                                </div>
                            </div>

                            <!-- Live Movement Table -->
                            <div class="mockup-card mockup-card-full">
                                <div class="table-responsive">
                                    <table class="table-mini">
                                        <thead>
                                            <tr>
                                                <th style="width: 25%;">SKU ID</th>
                                                <th style="width: 35%;">Product</th>
                                                <th style="width: 20%; text-align: right;">Qty</th>
                                                <th style="width: 20%; text-align: right;">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>SKU-8921</code></td>
                                                <td>
                                                    <div style="font-weight: 600; font-size: 0.82rem;">Wireless Hub</div>
                                                    <div style="font-size: 0.72rem; color: var(--text-dim);">Bay B-04</div>
                                                </td>
                                                <td style="text-align: right; font-weight: 700; color: #f8fafc;">1,420</td>
                                                <td style="text-align: right;"><span class="badge badge-success" style="font-size: 0.68rem; padding: 2px 7px;">In Stock</span></td>
                                            </tr>
                                            <tr>
                                                <td><code>SKU-4409</code></td>
                                                <td>
                                                    <div style="font-weight: 600; font-size: 0.82rem;">Sensor Pack</div>
                                                    <div style="font-size: 0.72rem; color: var(--text-dim);">Bay D-09</div>
                                                </td>
                                                <td style="text-align: right; font-weight: 700; color: #f8fafc;">48</td>
                                                <td style="text-align: right;"><span class="badge badge-warning" style="font-size: 0.68rem; padding: 2px 7px;">Reorder</span></td>
                                            </tr>
                                            <tr>
                                                <td><code>SKU-1028</code></td>
                                                <td>
                                                    <div style="font-weight: 600; font-size: 0.82rem;">Fiber Terminal</div>
                                                    <div style="font-size: 0.72rem; color: var(--text-dim);">Bay A-02</div>
                                                </td>
                                                <td style="text-align: right; font-weight: 700; color: #f8fafc;">850</td>
                                                <td style="text-align: right;"><span class="badge badge-success" style="font-size: 0.68rem; padding: 2px 7px;">In Stock</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Trusted By Logos -->
    <section class="client-logos">
        <div class="container">
            <div class="logos-title">Trusted by industry leaders in logistics, manufacturing & retail</div>
            <div class="logos-grid">
                <div class="logo-brand"><i class="fa-solid fa-truck-moving"></i> Acme Logistics</div>
                <div class="logo-brand"><i class="fa-solid fa-industry"></i> Nova Manufacturing</div>
                <div class="logo-brand"><i class="fa-solid fa-shop"></i> Apex Retail Group</div>
                <div class="logo-brand"><i class="fa-solid fa-cubes"></i> PrimeDistro Worldwide</div>
                <div class="logo-brand"><i class="fa-solid fa-network-wired"></i> Quantum Supply</div>
            </div>
        </div>
    </section>

    <!-- Core Features Section -->
    <section class="section" id="features">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Enterprise Capabilities</span>
                <h2 class="section-title">Built for Modern Supply Chain & Multi-Warehouse Operations</h2>
                <p class="section-description">
                    Replace fragmented spreadsheets and legacy software with a high-performance inventory engine crafted for operational speed and zero downtime.
                </p>
            </div>

            <div class="features-grid">
                <!-- Feature 1 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-purple">
                        <i class="fa-solid fa-warehouse"></i>
                    </div>
                    <h3 class="feature-title">Multi-Warehouse Visibility</h3>
                    <p class="feature-text">
                        Control inventory across regional fulfillment centers, physical retail stores, and 3PL warehouses with instant multi-location balance synchronization.
                    </p>
                </div>

                <!-- Feature 2 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-blue">
                        <i class="fa-solid fa-barcode"></i>
                    </div>
                    <h3 class="feature-title">Barcode & QR Scanning</h3>
                    <p class="feature-text">
                        Accelerate receiving and picking with native handheld scanner and mobile camera support. Track batch numbers, serial IDs, and expiry dates effortlessly.
                    </p>
                </div>

                <!-- Feature 3 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-green">
                        <i class="fa-solid fa-cart-flatbed"></i>
                    </div>
                    <h3 class="feature-title">Automated Replenishment</h3>
                    <p class="feature-text">
                        Set dynamic reorder points with safety stock buffers. StockFlow automatically generates and routes purchase orders to your approved vendors.
                    </p>
                </div>

                <!-- Feature 4 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-orange">
                        <i class="fa-solid fa-chart-pie"></i>
                    </div>
                    <h3 class="feature-title">Predictive AI Analytics</h3>
                    <p class="feature-text">
                        Forecast seasonal demand patterns, calculate carrying costs, and identify dead stock before it eats into your company's operating margin.
                    </p>
                </div>

                <!-- Feature 5 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-purple">
                        <i class="fa-solid fa-arrows-split-up-and-left"></i>
                    </div>
                    <h3 class="feature-title">Omnichannel Integration</h3>
                    <p class="feature-text">
                        Connect with Shopify, Amazon, ERP systems, and EDI protocols in real time to prevent double-selling and guarantee synchronized channel listings.
                    </p>
                </div>

                <!-- Feature 6 -->
                <div class="feature-card">
                    <div class="feature-icon-box feature-icon-blue">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <h3 class="feature-title">Audit Trails & Roles</h3>
                    <p class="feature-text">
                        Maintain compliance with granular role-based permissions, end-to-end ledger logging, and single sign-on (SSO) for enterprise teams.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Workflow Section -->
    <section class="section" id="workflow" style="background: rgba(17, 24, 39, 0.4);">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">How It Works</span>
                <h2 class="section-title">Seamless 4-Stage Operational Flow</h2>
                <p class="section-description">
                    From receiving dock to customer doorstep, maintain total transparency and accountability at every checkpoint.
                </p>
            </div>

            <div class="workflow-steps">
                <div class="step-card">
                    <div class="step-number">01</div>
                    <h4 class="step-title">Inbound & Receiving</h4>
                    <p class="step-desc">Scan incoming shipments against purchase orders. Auto-verify quantities, inspect quality, and flag discrepancies instantly.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">02</div>
                    <h4 class="step-title">Smart Putaway & Bins</h4>
                    <p class="step-desc">StockFlow guides your warehouse staff to the optimal bin, rack, and zone based on velocity and physical dimensions.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">03</div>
                    <h4 class="step-title">Pick, Pack & Dispatch</h4>
                    <p class="step-desc">Wave and zone picking routes optimize walking time. Auto-print carrier shipping labels and packing slips with 1 click.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">04</div>
                    <h4 class="step-title">Live Audit & Insights</h4>
                    <p class="step-desc">Cycle count audits run seamlessly in the background without shutting down warehouse operations. Access executive reports 24/7.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Business Solutions Section -->
    <section class="section" id="solutions">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Tailored Solutions</span>
                <h2 class="section-title">Designed for Every Team in Your Enterprise</h2>
                <p class="section-description">
                    Empower warehouse teams, supply chain leaders, and finance executives with specialized tools suited to their daily workflow.
                </p>
            </div>

            <div class="solutions-grid">
                <!-- Solution 1: Warehouse Ops -->
                <div class="solution-card">
                    <div>
                        <div class="badge badge-primary" style="margin-bottom: 16px;">
                            <i class="fa-solid fa-dolly"></i> Warehouse & Logistics Managers
                        </div>
                        <h3 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 12px;">Eliminate manual bottlenecks & speed up dispatch</h3>
                        <p style="color: var(--text-muted); font-size: 0.95rem;">
                            Empower floor operators with lightning-fast scanning, digital pick lists, and automated pallet tracking that removes human error.
                        </p>
                        <ul class="solution-list">
                            <li><i class="fa-solid fa-check-circle"></i> Mobile-first barcode & QR scanning interface</li>
                            <li><i class="fa-solid fa-check-circle"></i> Wave, batch, and zone pick routing algorithms</li>
                            <li><i class="fa-solid fa-check-circle"></i> Instant carrier rate shopping & label generation</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="btn btn-secondary btn-sm" style="align-self: flex-start; margin-top: 20px;">Start Free Trial &rarr;</a>
                </div>

                <!-- Solution 2: Procurement & CFO -->
                <div class="solution-card">
                    <div>
                        <div class="badge badge-success" style="margin-bottom: 16px;">
                            <i class="fa-solid fa-coins"></i> Procurement & Finance Directors
                        </div>
                        <h3 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 12px;">Optimize working capital & prevent over-ordering</h3>
                        <p style="color: var(--text-muted); font-size: 0.95rem;">
                            Keep holding costs low while safeguarding against stockouts. Track landed costs, supplier performance, and gross margins accurately.
                        </p>
                        <ul class="solution-list">
                            <li><i class="fa-solid fa-check-circle"></i> Automated supplier PO creation and lead-time tracking</li>
                            <li><i class="fa-solid fa-check-circle"></i> Landed cost calculation including freight, tax & duties</li>
                            <li><i class="fa-solid fa-check-circle"></i> Direct sync with QuickBooks, NetSuite, and SAP ERP</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="btn btn-secondary btn-sm" style="align-self: flex-start; margin-top: 20px;">Start Free Trial &rarr;</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Pricing Section -->
    <section class="section" id="pricing" style="background: rgba(11, 15, 25, 0.6);">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Flexible Pricing</span>
                <h2 class="section-title">Transparent Plans Scaled to Your Business Size</h2>
                <p class="section-description">
                    No hidden setup fees. Upgrade, downgrade, or cancel anytime with our 30-day money-back guarantee.
                </p>
            </div>

            <!-- Billing Switch -->
            <div class="pricing-switch-container">
                <span style="font-weight: 600; font-size: 0.95rem;">Monthly Billing</span>
                <label class="pricing-switch">
                    <input type="checkbox" id="billingToggle" checked>
                    <span class="slider"></span>
                </label>
                <span style="font-weight: 600; font-size: 0.95rem;">Annual Billing <span class="badge badge-success" style="padding: 2px 8px; font-size: 0.75rem;">Save 20%</span></span>
            </div>

            <div class="pricing-grid">
                <!-- Starter Tier -->
                <div class="pricing-card">
                    <div>
                        <h3 class="plan-name">Starter</h3>
                        <p class="plan-desc">For growing retail and e-commerce companies looking to organize inventory.</p>
                        <div class="plan-price">
                            <span class="price-currency">$</span>
                            <span class="price-amount">39</span>
                            <span class="price-period">/month, billed annually</span>
                        </div>
                        <ul class="plan-features">
                            <li><i class="fa-solid fa-check"></i> Up to 5,000 active SKUs</li>
                            <li><i class="fa-solid fa-check"></i> 2 Warehouse / Store Locations</li>
                            <li><i class="fa-solid fa-check"></i> Barcode & QR Code Scanning</li>
                            <li><i class="fa-solid fa-check"></i> Automated Reorder Alerts</li>
                            <li><i class="fa-solid fa-check"></i> Email & Community Support</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp?plan=starter" class="btn btn-outline" style="width: 100%;">Start Free 14-Day Trial</a>
                </div>

                <!-- Professional Tier (Popular) -->
                <div class="pricing-card popular">
                    <div class="popular-badge">Most Popular</div>
                    <div>
                        <h3 class="plan-name">Professional</h3>
                        <p class="plan-desc">For high-volume distributors and multichannel businesses scaling fast.</p>
                        <div class="plan-price">
                            <span class="price-currency">$</span>
                            <span class="price-amount">99</span>
                            <span class="price-period">/month, billed annually</span>
                        </div>
                        <ul class="plan-features">
                            <li><i class="fa-solid fa-check"></i> Up to 50,000 active SKUs</li>
                            <li><i class="fa-solid fa-check"></i> Unlimited Warehouse Locations</li>
                            <li><i class="fa-solid fa-check"></i> AI Demand & Turnover Forecasting</li>
                            <li><i class="fa-solid fa-check"></i> Shopify, Amazon, & eBay Sync</li>
                            <li><i class="fa-solid fa-check"></i> Batch & Serial Expiration Tracking</li>
                            <li><i class="fa-solid fa-check"></i> Priority 24/7 Live Support</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp?plan=pro" class="btn btn-primary" style="width: 100%;">Start Free 14-Day Trial</a>
                </div>

                <!-- Enterprise Tier -->
                <div class="pricing-card">
                    <div>
                        <h3 class="plan-name">Enterprise</h3>
                        <p class="plan-desc">Custom infrastructure for 3PLs, large manufacturers, and enterprise fleets.</p>
                        <div class="plan-price">
                            <span class="price-currency">$</span>
                            <span class="price-amount">239</span>
                            <span class="price-period">/month, billed annually</span>
                        </div>
                        <ul class="plan-features">
                            <li><i class="fa-solid fa-check"></i> Unlimited SKUs & Transactions</li>
                            <li><i class="fa-solid fa-check"></i> Dedicated Account Manager & SLA</li>
                            <li><i class="fa-solid fa-check"></i> Custom ERP & SAP / Oracle Connectors</li>
                            <li><i class="fa-solid fa-check"></i> Role-Based SSO (SAML, Okta)</li>
                            <li><i class="fa-solid fa-check"></i> On-Premise / Private Cloud Option</li>
                        </ul>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp?plan=enterprise" class="btn btn-outline" style="width: 100%;">Contact Enterprise Sales</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="section" id="testimonials">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Client Reviews</span>
                <h2 class="section-title">Loved by 1,200+ Warehouse & Operations Teams</h2>
                <p class="section-description">
                    Discover how industry leaders transformed their inventory workflows with StockFlow.
                </p>
            </div>

            <div class="testimonials-grid">
                <!-- Testimonial 1 -->
                <div class="testimonial-card">
                    <div style="color: #f59e0b; margin-bottom: 16px;">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="testimonial-quote">
                        "StockFlow reduced our picking error rate by 92% in the first quarter alone. The barcode scanning interface is fast, intuitive, and works seamlessly with our existing handheld hardware."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar">MR</div>
                        <div class="author-info">
                            <h5>Marcus Rivera</h5>
                            <p>VP of Operations, Apex Retail</p>
                        </div>
                    </div>
                </div>

                <!-- Testimonial 2 -->
                <div class="testimonial-card">
                    <div style="color: #f59e0b; margin-bottom: 16px;">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="testimonial-quote">
                        "The automated purchase orders and demand forecasting saved us over $140,000 in dead stock and storage costs this year. It's the best software investment our company has made."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar" style="background: linear-gradient(135deg, #10b981, #06b6d4);">SJ</div>
                        <div class="author-info">
                            <h5>Sarah Jenkins</h5>
                            <p>Supply Chain Director, Nova Goods</p>
                        </div>
                    </div>
                </div>

                <!-- Testimonial 3 -->
                <div class="testimonial-card">
                    <div style="color: #f59e0b; margin-bottom: 16px;">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="testimonial-quote">
                        "Migrating from our legacy ERP was smooth and completely painless. Our 3 warehouse locations in Chicago, Dallas, and Seattle are finally on the exact same real-time page."
                    </p>
                    <div class="testimonial-author">
                        <div class="author-avatar" style="background: linear-gradient(135deg, #f59e0b, #ef4444);">DK</div>
                        <div class="author-info">
                            <h5>David Kim</h5>
                            <p>Chief Technology Officer, PrimeDistro</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="section" id="faq" style="background: rgba(17, 24, 39, 0.3);">
        <div class="container">
            <div class="section-header">
                <span class="section-tag">Frequently Asked Questions</span>
                <h2 class="section-title">Everything You Need to Know</h2>
                <p class="section-description">
                    Got questions? Here are quick answers to the most common questions about StockFlow.
                </p>
            </div>

            <div class="faq-container">
                <div class="faq-item active">
                    <button class="faq-question">
                        <span>How quickly can our company migrate existing inventory data?</span>
                        <i class="fa-solid fa-chevron-down faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        You can bulk import all existing SKUs, categories, suppliers, and current warehouse counts via our simple CSV/Excel import templates or via our REST API. Most companies complete their full migration and team onboarding within 2 to 4 hours.
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question">
                        <span>Does StockFlow work with our existing barcode hardware?</span>
                        <i class="fa-solid fa-chevron-down faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        Yes! StockFlow is compatible with all standard USB, Bluetooth, 2D/1D laser scanners (Zebra, Honeywell, Datalogic) as well as iOS and Android camera scanning via our progressive web application.
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question">
                        <span>Can we manage multiple independent warehouse locations?</span>
                        <i class="fa-solid fa-chevron-down faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        Absolutely. You can define unlimited physical warehouses, regional hubs, virtual transit locations, and retail outlets. Stock transfers between warehouses include in-transit tracking and verification workflows.
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question">
                        <span>Is there a contract or long-term commitment required?</span>
                        <i class="fa-solid fa-chevron-down faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        No. Our monthly plans are pay-as-you-go with zero lock-in contracts. If you choose our annual billing, you receive an instant 20% discount and a full 30-day money-back guarantee.
                    </div>
                </div>

                <div class="faq-item">
                    <button class="faq-question">
                        <span>How secure is our company's proprietary inventory and financial data?</span>
                        <i class="fa-solid fa-chevron-down faq-icon"></i>
                    </button>
                    <div class="faq-answer">
                        StockFlow employs end-to-end 256-bit AES encryption in transit and at rest, SOC2 Type II audited protocols, continuous automated backups, and granular role-based access control.
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action Banner -->
    <section class="cta-section" id="cta">
        <div class="container">
            <div class="cta-box">
                <h2 class="cta-title">Ready to Take Complete Control of Your Inventory?</h2>
                <p class="cta-desc">
                    Join thousands of growing companies using StockFlow to automate warehouse logistics, eliminate inventory discrepancies, and accelerate fulfillment.
                </p>

                <form class="cta-form" action="${pageContext.request.contextPath}/customer/signup/signup.jsp" method="GET">
                    <input type="email" name="email" class="cta-input" placeholder="Enter your business email..." required>
                    <button type="submit" class="btn btn-primary" style="white-space: nowrap;">
                        Get Started Free &rarr;
                    </button>
                </form>

                <div style="display: flex; justify-content: center; gap: 24px; margin-top: 24px; font-size: 0.85rem; color: var(--text-dim);">
                    <span><i class="fa-solid fa-shield-check" style="color: #10b981;"></i> 14-Day Free Trial</span>
                    <span><i class="fa-solid fa-credit-card" style="color: #10b981;"></i> No Credit Card Required</span>
                    <span><i class="fa-solid fa-bolt" style="color: #10b981;"></i> Instant Account Setup</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-brand">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                        <div class="logo-icon">
                            <i class="fa-solid fa-boxes-stacked"></i>
                        </div>
                        <span>Stock<span style="color: #38bdf8;">Flow</span></span>
                    </a>
                    <p>
                        The intelligent, high-speed inventory & warehouse management solution engineered for high-growth enterprises and distributors.
                    </p>
                    <div style="display: flex; gap: 16px; font-size: 1.2rem; color: var(--text-muted);">
                        <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                        <a href="#"><i class="fa-brands fa-linkedin"></i></a>
                        <a href="#"><i class="fa-brands fa-github"></i></a>
                        <a href="#"><i class="fa-brands fa-youtube"></i></a>
                    </div>
                </div>

                <div class="footer-col">
                    <h5>Platform</h5>
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp">Create Free Trial Account</a>
                        <a href="${pageContext.request.contextPath}/customer/login/login.jsp">Customer Portal Login</a>
                        <a href="#features">Multi-Warehouse</a>
                        <a href="#features">Barcode & Scanning</a>
                        <a href="#features">PO & Replenishment</a>
                        <a href="#features">Demand Forecasting</a>
                    </div>
                </div>

                <div class="footer-col">
                    <h5>Solutions</h5>
                    <div class="footer-links">
                        <a href="#solutions">Wholesale & B2B</a>
                        <a href="#solutions">eCommerce Brands</a>
                        <a href="#solutions">Manufacturing</a>
                        <a href="#solutions">3PL Providers</a>
                        <a href="#pricing">Enterprise Plans</a>
                    </div>
                </div>

                <div class="footer-col">
                    <h5>Company & Trust</h5>
                    <div class="footer-links">
                        <a href="#testimonials">Customer Stories</a>
                        <a href="#">Security & Compliance</a>
                        <a href="#">Privacy Policy</a>
                        <a href="#">Terms of Service</a>
                        <a href="#faq">Support Center</a>
                    </div>
                </div>
            </div>

            <div class="footer-bottom">
                <p>&copy; <%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %> StockFlow Systems Inc. All rights reserved.</p>
                <div style="display: flex; gap: 20px;">
                    <span>SOC2 Certified</span>
                    <span>&bull;</span>
                    <span>ISO 27001 Compliant</span>
                    <span>&bull;</span>
                    <span>GDPR Ready</span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Custom Scripts -->
    <script src="${pageContext.request.contextPath}/customer/js/main.js"></script>
</body>
</html>
