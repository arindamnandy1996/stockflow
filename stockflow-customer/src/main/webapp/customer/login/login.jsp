<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In &bull; StockFlow Customer & Operations Portal</title>
    <meta name="description" content="Secure customer and warehouse operator portal login for StockFlow Inventory Management System.">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Global and Login Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/login.css">
</head>
<body class="login-page">

    <!-- Background Grid Texture -->
    <div class="login-bg-grid"></div>

    <!-- Login Top Header -->
    <header class="login-header">
        <div class="login-header-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo" title="Back to StockFlow Home">
                <div class="logo-icon">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>
                <span>Stock<span style="color: #38bdf8;">Flow</span></span>
            </a>

            <div style="display: flex; align-items: center; gap: 12px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="back-home-link">
                    <i class="fa-solid fa-arrow-left"></i>
                    <span>Back to Homepage</span>
                </a>
                <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp" class="back-home-link" style="color: #38bdf8; border-color: rgba(56, 189, 248, 0.3);">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Sign Up Free</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Login Section -->
    <main class="login-main">
        <div class="login-wrapper">
            
            <!-- Left Side: Interactive Login Form -->
            <div class="login-form-side">
                
                <div class="login-title-group">
                    <div class="login-badge">
                        <i class="fa-solid fa-shield-halved"></i>
                        <span>Secure Access Gateway</span>
                    </div>
                    <h1 class="login-heading">Welcome Back</h1>
                    <p class="login-subheading">Access real-time inventory telemetry, order flows, and replenishment dashboards.</p>
                </div>

                <!-- Role Selector Tabs -->
                <div class="login-tabs">
                    <button type="button" class="login-tab-btn active" data-role="customer">
                        <i class="fa-solid fa-building-user"></i>
                        <span>Customer Portal</span>
                    </button>
                    <button type="button" class="login-tab-btn" data-role="staff">
                        <i class="fa-solid fa-warehouse"></i>
                        <span>Warehouse Staff</span>
                    </button>
                </div>

                <!-- Dynamic Alert Banner -->
                <div class="login-alert" id="loginAlert" role="alert">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span id="alertMessage"></span>
                </div>

                <!-- Login Form -->
                <form id="loginForm" 
                      class="login-form" 
                      action="${pageContext.request.contextPath}/login-auth" 
                      method="POST" 
                      data-context-path="${pageContext.request.contextPath}">
                    
                    <input type="hidden" id="userRole" name="role" value="customer">

                    <!-- Email / Identifier Field -->
                    <div class="form-group" id="usernameGroup">
                        <label for="username" class="form-label" id="userLabel">Business Email or Customer ID</label>
                        <div class="input-container">
                            <i class="fa-solid fa-envelope input-icon"></i>
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   class="login-input" 
                                   placeholder="name@company.com" 
                                   autocomplete="username" 
                                   required>
                        </div>
                        <div class="input-error-msg"></div>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group" id="passwordGroup">
                        <div class="form-label">
                            <label for="password">Password</label>
                            <a href="#" id="forgotPasswordLink" class="forgot-link">Forgot Password?</a>
                        </div>
                        <div class="input-container">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" 
                                   id="password" 
                                   name="password" 
                                   class="login-input" 
                                   placeholder="Enter your security password" 
                                   autocomplete="current-password" 
                                   required>
                            <button type="button" class="password-toggle-btn" id="togglePassword" aria-label="Toggle password visibility">
                                <i class="fa-solid fa-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                        <div class="input-error-msg"></div>
                    </div>

                    <!-- Options Row -->
                    <div class="form-options">
                        <label class="checkbox-label" for="rememberMe">
                            <input type="checkbox" id="rememberMe" name="rememberMe" checked>
                            <span>Remember this device (30 days)</span>
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn" class="btn btn-primary btn-login-submit">
                        <span class="btn-text">Sign In to StockFlow</span>
                        <i class="fa-solid fa-arrow-right"></i>
                        <span class="spinner"></span>
                    </button>

                    <!-- Quick Demo Credentials Fill -->
                    <div class="demo-accounts">
                        <div class="demo-title">
                            <span><i class="fa-solid fa-wand-magic-sparkles"></i> 1-Click Demo Logins</span>
                            <span style="font-size: 0.7rem; color: #818cf8;">Sandbox Ready</span>
                        </div>
                        <div class="demo-buttons-row">
                            <button type="button" id="demoCustomerBtn" class="demo-btn">
                                <i class="fa-solid fa-user-check" style="color: #38bdf8;"></i>
                                <span>Demo Customer</span>
                            </button>
                            <button type="button" id="demoAdminBtn" class="demo-btn">
                                <i class="fa-solid fa-user-shield" style="color: #34d399;"></i>
                                <span>Demo Admin</span>
                            </button>
                        </div>
                    </div>

                    <!-- Social / SSO Divider -->
                    <div class="login-divider">
                        <span>or continue with SSO</span>
                    </div>

                    <!-- Single Sign-On Enterprise Options -->
                    <div class="sso-buttons">
                        <button type="button" class="sso-btn">
                            <i class="fa-brands fa-google" style="color: #ea4335;"></i>
                            <span>Google SSO</span>
                        </button>
                        <button type="button" class="sso-btn">
                            <i class="fa-brands fa-microsoft" style="color: #00a4ef;"></i>
                            <span>Microsoft 365</span>
                        </button>
                    </div>

                    <!-- Signup Link -->
                    <div class="login-signup-prompt">
                        <span>Don't have an enterprise account?</span>
                        <a href="${pageContext.request.contextPath}/customer/signup/signup.jsp">Start 14-Day Free Trial &rarr;</a>
                    </div>
                </form>
            </div>

            <!-- Right Side: Platform Showcase & Live Insights -->
            <div class="login-showcase-side">
                <div class="showcase-header">
                    <div class="badge badge-primary" style="margin-bottom: 14px;">
                        <span class="pulse-dot"></span>
                        <span>Enterprise Cloud v3.2</span>
                    </div>
                    <h2 class="showcase-title">Zero Stockouts. 100% Visibility.</h2>
                    <p class="showcase-desc">Unified multi-warehouse management platform built for modern supply chains and rapid order fulfillment.</p>
                </div>

                <div class="showcase-features">
                    <div class="showcase-feature-item">
                        <div class="showcase-icon-box feature-icon-purple">
                            <i class="fa-solid fa-barcode"></i>
                        </div>
                        <div class="showcase-feat-text">
                            <h5>High-Velocity Barcode Picking</h5>
                            <p>Sub-second camera and handheld 2D/1D scanner response.</p>
                        </div>
                    </div>

                    <div class="showcase-feature-item">
                        <div class="showcase-icon-box feature-icon-blue">
                            <i class="fa-solid fa-arrows-rotate"></i>
                        </div>
                        <div class="showcase-feat-text">
                            <h5>Instant Multi-Warehouse Sync</h5>
                            <p>Real-time bin, bay, and transit telemetry across all hubs.</p>
                        </div>
                    </div>

                    <div class="showcase-feature-item">
                        <div class="showcase-icon-box feature-icon-green">
                            <i class="fa-solid fa-brain"></i>
                        </div>
                        <div class="showcase-feat-text">
                            <h5>Predictive AI Reordering</h5>
                            <p>Autonomous PO routing based on seasonal velocity trends.</p>
                        </div>
                    </div>
                </div>

                <!-- Testimonial Quote -->
                <div class="showcase-testimonial">
                    <div class="testimonial-stars">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="showcase-quote">
                        "StockFlow streamlined our B2B distribution operations across 3 states with unmatched accuracy."
                    </p>
                    <div class="showcase-author">
                        <div class="author-mini-avatar">MR</div>
                        <div class="showcase-author-info">
                            Marcus Rivera
                            <span>VP of Logistics &bull; Apex Retail</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- Bottom Security Footer -->
    <footer class="login-footer">
        <div class="login-footer-container">
            <div>
                &copy; <%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %> StockFlow Systems Inc. All rights reserved.
            </div>
            <div class="security-badges">
                <div class="sec-badge">
                    <i class="fa-solid fa-lock"></i>
                    <span>256-Bit SSL Encrypted</span>
                </div>
                <div class="sec-badge">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>SOC2 Type II Certified</span>
                </div>
                <div class="sec-badge">
                    <i class="fa-solid fa-server"></i>
                    <span>99.99% Cloud Uptime</span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Login Scripts -->
    <script src="${pageContext.request.contextPath}/customer/js/login.js"></script>
</body>
</html>
