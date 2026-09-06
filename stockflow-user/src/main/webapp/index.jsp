<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.Year" %>
<%
    String currentYear = String.valueOf(Year.now().getValue());
    String appName = "StockFlow";
    String appTagline = "Smart Inventory & Seamless Ordering Portal";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="StockFlow User Portal - Real-time stock visibility, fast fulfillment, and streamlined ordering for end users and businesses.">
    <title><%= appName %> - <%= appTagline %></title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- ==================== HEADER / NAVBAR ==================== -->
    <header class="header">
        <div class="container navbar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo" aria-label="StockFlow Home">
                <div class="brand-icon">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>
                <div class="brand-text">Stock<span>Flow</span></div>
            </a>

            <!-- Desktop Navigation -->
            <ul class="nav-menu" id="nav-menu">
                <li><a href="#features" class="nav-link">Features</a></li>
                <li><a href="#catalog" class="nav-link">Product Catalog</a></li>
                <li><a href="#how-it-works" class="nav-link">How It Works</a></li>
                <li><a href="#tracking" class="nav-link">Track Order</a></li>
                <li><a href="#faq" class="nav-link">FAQ</a></li>

                <!-- Mobile Drawer Auth Actions -->
                <li class="mobile-auth-divider"></li>
                <li class="mobile-auth-actions">
                    <button type="button" class="btn btn-outline btn-sm trigger-login-modal">
                        <i class="fa-solid fa-arrow-right-to-bracket"></i> Log In
                    </button>
                    <button type="button" class="btn btn-primary btn-sm trigger-signup-modal">
                        <i class="fa-solid fa-user-plus"></i> Sign Up Free
                    </button>
                </li>
            </ul>

            <!-- Header Actions (Login, Sign Up, Quick Actions) -->
            <div class="nav-actions">
                <button type="button" class="btn-nav-login trigger-login-modal">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Log In
                </button>
                <button type="button" class="btn btn-primary btn-sm trigger-signup-modal">
                    <i class="fa-solid fa-user-plus"></i> Sign Up
                </button>
            </div>

            <!-- Mobile Hamburger Toggle -->
            <button class="hamburger" id="hamburger-toggle" aria-label="Toggle navigation menu">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </header>

    <main>
        <!-- ==================== HERO SECTION ==================== -->
        <section class="hero">
            <div class="container hero-grid">
                <div class="hero-content">
                    <div class="hero-badge">
                        <span class="badge-pulse"></span>
                        <span>Live Stock & Instant Order Processing</span>
                    </div>
                    <h1 class="hero-title">
                        Order & Track Inventory <span class="gradient-text">With Zero Friction</span>
                    </h1>
                    <p class="hero-description">
                        Access real-time stock levels across regional distribution hubs, place quick bulk or single orders, and receive automated milestone delivery alerts.
                    </p>
                    <div class="hero-cta">
                        <button type="button" class="btn btn-primary btn-lg trigger-signup-modal">
                            <i class="fa-solid fa-bolt"></i> Get Started Free
                        </button>
                        <a href="#catalog" class="btn btn-secondary btn-lg">
                            <i class="fa-solid fa-boxes-stacked"></i> Browse Catalog
                        </a>
                    </div>
                    <div class="hero-stats">
                        <div class="stat-item">
                            <h4>99.8%</h4>
                            <p>Fulfillment Accuracy</p>
                        </div>
                        <div class="stat-item">
                            <h4>&lt; 24h</h4>
                            <p>Average Dispatch</p>
                        </div>
                        <div class="stat-item">
                            <h4>50k+</h4>
                            <p>SKUs Available</p>
                        </div>
                    </div>
                </div>

                <!-- Hero Graphic / Interactive Dashboard Card Preview -->
                <div class="hero-card-wrapper">
                    <div class="floating-badge floating-badge-1">
                        <div class="floating-icon green">
                            <i class="fa-solid fa-check"></i>
                        </div>
                        <div>
                            <div class="floating-text-title">Order #8924 Dispatched</div>
                            <div class="floating-text-desc">Estimated Delivery: Today, 3:00 PM</div>
                        </div>
                    </div>

                    <div class="hero-main-card">
                        <div class="card-top-bar">
                            <span class="card-title"><i class="fa-solid fa-chart-pie"></i> Live Hub Inventory</span>
                            <span class="live-indicator"><span class="dot"></span> Synced</span>
                        </div>
                        <div class="stock-preview-list">
                            <div class="stock-item">
                                <div class="stock-info">
                                    <div class="item-icon"><i class="fa-solid fa-laptop"></i></div>
                                    <div>
                                        <div class="item-name">Pro Workstation M3</div>
                                        <div class="item-category">SKU: HW-8830 &bull; Electronics</div>
                                    </div>
                                </div>
                                <span class="stock-status-pill status-in-stock">142 In Stock</span>
                            </div>

                            <div class="stock-item">
                                <div class="stock-info">
                                    <div class="item-icon"><i class="fa-solid fa-keyboard"></i></div>
                                    <div>
                                        <div class="item-name">Wireless Mechanical Hub</div>
                                        <div class="item-category">SKU: HW-1204 &bull; Accessories</div>
                                    </div>
                                </div>
                                <span class="stock-status-pill status-in-stock">89 In Stock</span>
                            </div>

                            <div class="stock-item">
                                <div class="stock-info">
                                    <div class="item-icon"><i class="fa-solid fa-headphones"></i></div>
                                    <div>
                                        <div class="item-name">Noise Canceling Headset</div>
                                        <div class="item-category">SKU: AUD-9920 &bull; Audio</div>
                                    </div>
                                </div>
                                <span class="stock-status-pill status-low-stock">4 Left (Reordering)</span>
                            </div>
                        </div>
                    </div>

                    <div class="floating-badge floating-badge-2">
                        <div class="floating-icon blue">
                            <i class="fa-solid fa-rotate"></i>
                        </div>
                        <div>
                            <div class="floating-text-title">Instant Restock Notification</div>
                            <div class="floating-text-desc">Warehouse Central &bull; Just now</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== QUICK SEARCH & FILTER BAR ==================== -->
        <section class="quick-search-section">
            <div class="container">
                <div class="search-box-card">
                    <div class="search-field">
                        <label for="product-search-input">Search Product or SKU</label>
                        <input type="text" id="product-search-input" placeholder="e.g. Ergonomic Chair, HW-8830...">
                    </div>
                    <div class="search-field">
                        <label for="category-filter-select">Category</label>
                        <select id="category-filter-select">
                            <option value="all">All Categories</option>
                            <option value="electronics">Electronics</option>
                            <option value="furniture">Furniture & Office</option>
                            <option value="accessories">Peripherals & Accessories</option>
                        </select>
                    </div>
                    <div class="search-field">
                        <label for="stock-status-select">Availability</label>
                        <select id="stock-status-select">
                            <option value="all">Any Status</option>
                            <option value="in-stock">In Stock Only</option>
                            <option value="fast-shipping">Fast Shipping</option>
                        </select>
                    </div>
                    <div class="search-field" style="justify-content: flex-end;">
                        <button type="button" id="search-action-btn" class="btn btn-primary" style="height: 42px;">
                            <i class="fa-solid fa-search"></i> Search Stock
                        </button>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== KEY FEATURES / BENEFITS ==================== -->
        <section class="features-section" id="features">
            <div class="container">
                <div class="section-header">
                    <span class="section-tag">Why StockFlow</span>
                    <h2 class="section-title">Engineered For High-Speed Order Fulfillment</h2>
                    <p class="section-subtitle">
                        Empowering end users and organizations with direct, real-time access to accurate inventory quantities and live shipment visibility.
                    </p>
                </div>

                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-arrows-rotate"></i>
                        </div>
                        <h3 class="feature-title">Real-Time Inventory Sync</h3>
                        <p class="feature-desc">
                            Live inventory counts refreshed across regional depots. Never place an order for out-of-stock items again.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-truck-ramp-box"></i>
                        </div>
                        <h3 class="feature-title">Same-Day Dispatch</h3>
                        <p class="feature-desc">
                            Automated warehouse routing assigns your order to the nearest fulfillment hub for instant packing and courier dispatch.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-satellite-dish"></i>
                        </div>
                        <h3 class="feature-title">Live Milestone Tracking</h3>
                        <p class="feature-desc">
                            Track every step from warehouse picking and quality check to in-transit transit checkpoints and final delivery.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </div>
                        <h3 class="feature-title">Instant Invoicing & Receipts</h3>
                        <p class="feature-desc">
                            Generate and download compliant VAT/GST tax invoices, POs, and digital delivery proofs with a single click.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <h3 class="feature-title">Verified Quality Assurance</h3>
                        <p class="feature-desc">
                            Every item is barcode-scanned and inspected before departure to guarantee zero damaged or mismatched deliveries.
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon-wrapper">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <h3 class="feature-title">24/7 Dedicated Support</h3>
                        <p class="feature-desc">
                            Direct assistance from our fulfillment and logistics agents ready to resolve modifications or tracking queries.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== PRODUCT CATALOG SECTION ==================== -->
        <section class="catalog-section" id="catalog">
            <div class="container">
                <div class="section-header">
                    <span class="section-tag">Current Inventory</span>
                    <h2 class="section-title">Popular Items Ready for Fast Dispatch</h2>
                    <p class="section-subtitle">
                        Select from high-demand products stocked and ready for immediate order fulfillment.
                    </p>
                </div>

                <div class="catalog-tabs">
                    <button class="tab-btn active" data-category="all">All Products</button>
                    <button class="tab-btn" data-category="electronics">Electronics</button>
                    <button class="tab-btn" data-category="furniture">Office & Ergonomics</button>
                    <button class="tab-btn" data-category="accessories">Accessories</button>
                </div>

                <div class="product-grid" id="product-grid-container">
                    <!-- Product 1 -->
                    <article class="product-card" data-category="electronics" data-stock="in-stock">
                        <div class="product-image-container">
                            <i class="fa-solid fa-laptop" style="color: #4f46e5;"></i>
                            <span class="product-badge stock-tag-high">In Stock (142)</span>
                        </div>
                        <div class="product-content">
                            <div class="product-meta">
                                <span>Electronics &bull; Hub North</span>
                                <span><i class="fa-solid fa-star" style="color: #f59e0b;"></i> 4.9</span>
                            </div>
                            <h4 class="product-name">Pro Workstation Ultra M3</h4>
                            <p class="product-sku">SKU: HW-8830</p>
                            <div class="product-footer">
                                <div class="product-price">$1,299.00 <span>/ unit</span></div>
                                <button class="btn btn-primary btn-sm btn-order-action" data-product-name="Pro Workstation Ultra M3">
                                    <i class="fa-solid fa-plus"></i> Order
                                </button>
                            </div>
                        </div>
                    </article>

                    <!-- Product 2 -->
                    <article class="product-card" data-category="furniture" data-stock="in-stock">
                        <div class="product-image-container">
                            <i class="fa-solid fa-chair" style="color: #0ea5e9;"></i>
                            <span class="product-badge stock-tag-high">In Stock (78)</span>
                        </div>
                        <div class="product-content">
                            <div class="product-meta">
                                <span>Furniture &bull; Hub Central</span>
                                <span><i class="fa-solid fa-star" style="color: #f59e0b;"></i> 4.8</span>
                            </div>
                            <h4 class="product-name">Ergonomic Mesh Executive Chair</h4>
                            <p class="product-sku">SKU: FN-4012</p>
                            <div class="product-footer">
                                <div class="product-price">$349.50 <span>/ unit</span></div>
                                <button class="btn btn-primary btn-sm btn-order-action" data-product-name="Ergonomic Mesh Executive Chair">
                                    <i class="fa-solid fa-plus"></i> Order
                                </button>
                            </div>
                        </div>
                    </article>

                    <!-- Product 3 -->
                    <article class="product-card" data-category="accessories" data-stock="fast-shipping">
                        <div class="product-image-container">
                            <i class="fa-solid fa-keyboard" style="color: #10b981;"></i>
                            <span class="product-badge stock-tag-new">Fast Shipping</span>
                        </div>
                        <div class="product-content">
                            <div class="product-meta">
                                <span>Accessories &bull; Hub West</span>
                                <span><i class="fa-solid fa-star" style="color: #f59e0b;"></i> 4.9</span>
                            </div>
                            <h4 class="product-name">Mechanical Bluetooth Keyboard</h4>
                            <p class="product-sku">SKU: HW-1204</p>
                            <div class="product-footer">
                                <div class="product-price">$89.00 <span>/ unit</span></div>
                                <button class="btn btn-primary btn-sm btn-order-action" data-product-name="Mechanical Bluetooth Keyboard">
                                    <i class="fa-solid fa-plus"></i> Order
                                </button>
                            </div>
                        </div>
                    </article>

                    <!-- Product 4 -->
                    <article class="product-card" data-category="electronics" data-stock="in-stock">
                        <div class="product-image-container">
                            <i class="fa-solid fa-desktop" style="color: #8b5cf6;"></i>
                            <span class="product-badge stock-tag-high">In Stock (95)</span>
                        </div>
                        <div class="product-content">
                            <div class="product-meta">
                                <span>Electronics &bull; Hub Central</span>
                                <span><i class="fa-solid fa-star" style="color: #f59e0b;"></i> 4.7</span>
                            </div>
                            <h4 class="product-name">4K Ultra-Wide Curved Monitor</h4>
                            <p class="product-sku">SKU: DP-6610</p>
                            <div class="product-footer">
                                <div class="product-price">$520.00 <span>/ unit</span></div>
                                <button class="btn btn-primary btn-sm btn-order-action" data-product-name="4K Ultra-Wide Curved Monitor">
                                    <i class="fa-solid fa-plus"></i> Order
                                </button>
                            </div>
                        </div>
                    </article>
                </div>
            </div>
        </section>

        <!-- ==================== HOW IT WORKS ==================== -->
        <section class="how-it-works-section" id="how-it-works">
            <div class="container">
                <div class="section-header">
                    <span class="section-tag">Seamless Process</span>
                    <h2 class="section-title">How Ordering Works with StockFlow</h2>
                    <p class="section-subtitle">
                        From live stock reservation to doorstep arrival in three simple, transparent steps.
                    </p>
                </div>

                <div class="steps-grid">
                    <div class="step-card">
                        <div class="step-number">1</div>
                        <h3 class="step-title">Select & Reserve Stock</h3>
                        <p class="step-desc">
                            Browse real-time verified quantities in your nearest warehouse and lock in your order with instant reservation.
                        </p>
                    </div>

                    <div class="step-card">
                        <div class="step-number">2</div>
                        <h3 class="step-title">Automated Dispatch</h3>
                        <p class="step-desc">
                            Our automated fulfillment center scans, packs, and dispatches your order with express courier routing.
                        </p>
                    </div>

                    <div class="step-card">
                        <div class="step-number">3</div>
                        <h3 class="step-title">Track & Receive</h3>
                        <p class="step-desc">
                            Follow live tracking milestones and receive SMS/Email delivery updates with digital proof of delivery.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== ORDER TRACKING SIMULATOR ==================== -->
        <section class="container" id="tracking">
            <div class="tracking-banner">
                <div class="container tracking-inner">
                    <div class="tracking-left">
                        <h2>Live Order Tracking</h2>
                        <p>Enter your Order Reference ID or Waybill number to see current progress and dispatch telemetry.</p>
                        <div class="tracking-form-group">
                            <input type="text" id="track-order-input" placeholder="e.g. ORD-8924" value="ORD-8924">
                            <button type="button" id="btn-track-order" class="btn btn-accent">Track</button>
                        </div>
                    </div>

                    <div class="tracking-visual">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <strong id="track-order-id-display">ORD-8924</strong>
                                <div style="font-size: 0.8rem; color: #94a3b8;">Carrier: Express Logistics &bull; Dispatched Today</div>
                            </div>
                            <span class="stock-status-pill status-in-stock" id="track-status-badge">In Transit</span>
                        </div>

                        <div class="tracking-progress-steps">
                            <div class="track-step done">
                                <div class="track-step-dot"><i class="fa-solid fa-check"></i></div>
                                <span class="track-step-label">Order Placed</span>
                            </div>
                            <div class="track-step done">
                                <div class="track-step-dot"><i class="fa-solid fa-box"></i></div>
                                <span class="track-step-label">Packed</span>
                            </div>
                            <div class="track-step active">
                                <div class="track-step-dot"><i class="fa-solid fa-truck"></i></div>
                                <span class="track-step-label">In Transit</span>
                            </div>
                            <div class="track-step">
                                <div class="track-step-dot"><i class="fa-solid fa-house"></i></div>
                                <span class="track-step-label">Delivered</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== TESTIMONIALS ==================== -->
        <section class="testimonials-section">
            <div class="container">
                <div class="section-header">
                    <span class="section-tag">Client Feedback</span>
                    <h2 class="section-title">Trusted by Thousands of End Users</h2>
                    <p class="section-subtitle">See what our clients and procurement managers say about ordering with StockFlow.</p>
                </div>

                <div class="testimonial-grid">
                    <div class="testimonial-card">
                        <div class="rating-stars">
                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        </div>
                        <p class="testimonial-text">
                            "StockFlow transformed how we source equipment for our remote engineering team. Real-time availability saved us dozens of hours of back-and-forth emails."
                        </p>
                        <div class="user-profile">
                            <div class="avatar">SC</div>
                            <div class="user-info">
                                <h5>Sarah Jenkins</h5>
                                <p>Operations Lead, TechCorp</p>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="rating-stars">
                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i>
                        </div>
                        <p class="testimonial-text">
                            "The live tracking and same-day dispatch are unmatched. Every order arrived exactly when scheduled with detailed invoice records."
                        </p>
                        <div class="user-profile">
                            <div class="avatar">MR</div>
                            <div class="user-info">
                                <h5>Marcus Rivera</h5>
                                <p>Procurement Director, Apex Logistics</p>
                            </div>
                        </div>
                    </div>

                    <div class="testimonial-card">
                        <div class="rating-stars">
                            <i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star-half-stroke"></i>
                        </div>
                        <p class="testimonial-text">
                            "The cleanest inventory interface we've ever used. Simple search, instant order placement, and seamless customer support."
                        </p>
                        <div class="user-profile">
                            <div class="avatar">EL</div>
                            <div class="user-info">
                                <h5>Elena Lin</h5>
                                <p>Facility Manager, Horizon Studio</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== FAQ SECTION ==================== -->
        <section class="faq-section" id="faq">
            <div class="container">
                <div class="section-header">
                    <span class="section-tag">Help & Answers</span>
                    <h2 class="section-title">Frequently Asked Questions</h2>
                    <p class="section-subtitle">Everything you need to know about placing and tracking orders on StockFlow.</p>
                </div>

                <div class="faq-container">
                    <div class="faq-item active">
                        <button class="faq-question">
                            <span>How accurate is the live stock availability?</span>
                            <span class="faq-icon">+</span>
                        </button>
                        <div class="faq-answer">
                            Our inventory system syncs in real-time with warehouse barcode scanners. When you place an item in your order, the quantity is automatically reserved for you.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            <span>How quickly will my order be dispatched?</span>
                            <span class="faq-icon">+</span>
                        </button>
                        <div class="faq-answer">
                            Orders confirmed before 2:00 PM local time are dispatched the same business day from our closest distribution center.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            <span>Can I place bulk or commercial orders?</span>
                            <span class="faq-icon">+</span>
                        </button>
                        <div class="faq-answer">
                            Yes! Our platform supports both single unit orders and bulk pallet shipments with automatic volume tier pricing.
                        </div>
                    </div>

                    <div class="faq-item">
                        <button class="faq-question">
                            <span>How do I track an existing order?</span>
                            <span class="faq-icon">+</span>
                        </button>
                        <div class="faq-answer">
                            Simply enter your Order ID into the live tracking section above or click the tracking link provided in your order confirmation email.
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ==================== CALL TO ACTION ==================== -->
        <section class="container">
            <div class="cta-banner">
                <div class="cta-content">
                    <h2 class="cta-title">Ready to Experience Hassle-Free Ordering?</h2>
                    <p class="cta-desc">Join thousands of businesses and individual users managing their supply orders with StockFlow.</p>
                    <div class="cta-buttons">
                        <button type="button" class="btn btn-secondary btn-lg trigger-signup-modal">
                            <i class="fa-solid fa-user-plus"></i> Create Free Account
                        </button>
                        <button type="button" class="btn btn-accent btn-lg trigger-login-modal">
                            <i class="fa-solid fa-arrow-right-to-bracket"></i> Customer Sign In
                        </button>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- ==================== AUTH MODAL (LOGIN & SIGN UP) ==================== -->
    <div class="modal-overlay" id="auth-modal" aria-hidden="true" role="dialog">
        <div class="modal-container">
            <button class="modal-close-btn" id="modal-close-btn" aria-label="Close modal">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <div class="auth-tabs">
                <button type="button" class="auth-tab-btn active" data-tab="login">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Log In
                </button>
                <button type="button" class="auth-tab-btn" data-tab="signup">
                    <i class="fa-solid fa-user-plus"></i> Sign Up
                </button>
            </div>

            <div class="auth-body">
                <!-- Login Panel -->
                <div class="auth-form-panel active" id="auth-login-panel">
                    <div class="form-header">
                        <h3>Welcome Back</h3>
                        <p>Sign in to manage orders, tracks, and saved items</p>
                    </div>

                    <form id="login-form">
                        <div class="form-group">
                            <label for="login-email">Email or Username</label>
                            <div class="input-with-icon">
                                <i class="fa-solid fa-envelope"></i>
                                <input type="text" id="login-email" placeholder="name@company.com" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="login-password">Password</label>
                            <div class="input-with-icon">
                                <i class="fa-solid fa-lock"></i>
                                <input type="password" id="login-password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <div class="form-row-between">
                            <label class="checkbox-label">
                                <input type="checkbox" id="remember-me" checked> Remember me
                            </label>
                            <a href="#" class="form-link">Forgot password?</a>
                        </div>

                        <button type="submit" class="btn btn-primary auth-submit-btn">
                            Sign In to Portal
                        </button>

                        <div class="auth-social-divider">
                            <span>or continue with</span>
                        </div>

                        <button type="button" class="btn-social">
                            <i class="fa-brands fa-google" style="color: #ea4335;"></i> Sign In with Google
                        </button>

                        <div style="text-align: center; margin-top: 1.25rem; font-size: 0.85rem; color: var(--text-muted);">
                            Don't have an account? <a href="#" class="form-link switch-auth-tab" data-target-tab="signup">Create one free</a>
                        </div>
                    </form>
                </div>

                <!-- Signup Panel -->
                <div class="auth-form-panel" id="auth-signup-panel">
                    <div class="form-header">
                        <h3>Create Your Account</h3>
                        <p>Get instant access to real-time stock and expedited fulfillment</p>
                    </div>

                    <form id="signup-form">
                        <div class="form-group">
                            <label for="signup-name">Full Name or Company</label>
                            <div class="input-with-icon">
                                <i class="fa-solid fa-user"></i>
                                <input type="text" id="signup-name" placeholder="Alex Morgan / Acme Corp" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="signup-email">Work Email</label>
                            <div class="input-with-icon">
                                <i class="fa-solid fa-envelope"></i>
                                <input type="email" id="signup-email" placeholder="alex@company.com" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="signup-password">Create Password</label>
                            <div class="input-with-icon">
                                <i class="fa-solid fa-lock"></i>
                                <input type="password" id="signup-password" placeholder="At least 8 characters" minlength="8" required>
                            </div>
                        </div>

                        <div class="form-row-between">
                            <label class="checkbox-label" style="font-size: 0.8rem;">
                                <input type="checkbox" id="terms-agree" required>
                                <span>I agree to the <a href="#" class="form-link">Terms</a> and <a href="#" class="form-link">Privacy Policy</a></span>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary auth-submit-btn">
                            Create Account
                        </button>

                        <div style="text-align: center; margin-top: 1.25rem; font-size: 0.85rem; color: var(--text-muted);">
                            Already have an account? <a href="#" class="form-link switch-auth-tab" data-target-tab="login">Sign in</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== FOOTER ==================== -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-brand">
                    <div class="brand-logo" style="color: white;">
                        <div class="brand-icon"><i class="fa-solid fa-boxes-stacked"></i></div>
                        <div>Stock<span>Flow</span></div>
                    </div>
                    <p>Next-generation inventory management, real-time stock allocation, and intelligent order fulfillment for modern enterprises.</p>
                </div>

                <div>
                    <h4 class="footer-heading">Platform</h4>
                    <ul class="footer-links">
                        <li><a href="#catalog">Product Catalog</a></li>
                        <li><a href="#features">Inventory Features</a></li>
                        <li><a href="#tracking">Live Tracking</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="footer-heading">Account & Portal</h4>
                    <ul class="footer-links">
                        <li><a href="#" class="trigger-login-modal">Customer Sign In</a></li>
                        <li><a href="#" class="trigger-signup-modal">Create Free Account</a></li>
                        <li><a href="#tracking">Order Tracking</a></li>
                        <li><a href="#">Enterprise SSO</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="footer-heading">Hubs & Legal</h4>
                    <ul class="footer-links">
                        <li><a href="#faq">Help Center & FAQ</a></li>
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Shipping Policy</a></li>
                    </ul>
                </div>

                <div class="footer-newsletter">
                    <h4 class="footer-heading">Stay Updated</h4>
                    <p>Subscribe for inventory restock alerts and platform updates.</p>
                    <form id="newsletter-form" class="newsletter-form">
                        <input type="email" class="newsletter-input" placeholder="Enter your email..." required>
                        <button type="submit" class="btn btn-primary btn-sm">Join</button>
                    </form>
                </div>
            </div>

            <div class="footer-bottom">
                <div>
                    &copy; <%= currentYear %> <%= appName %> Inc. All rights reserved.
                </div>
                <div class="footer-bottom-links">
                    <a href="#">Security</a>
                    <a href="#">API Documentation</a>
                    <a href="#">Status</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Interactive JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
