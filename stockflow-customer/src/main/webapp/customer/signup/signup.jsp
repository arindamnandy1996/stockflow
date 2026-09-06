<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up &bull; StockFlow Inventory & Warehouse Platform</title>
    <meta name="description" content="Start your 14-day free trial of StockFlow. Real-time multi-warehouse inventory management, automated replenishment, and barcode tracking.">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <!-- Global and Signup Stylesheets -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/css/signup.css">
</head>
<body class="signup-page">

    <!-- Background Grid Texture -->
    <div class="signup-bg-grid"></div>

    <!-- Signup Top Header -->
    <header class="signup-header">
        <div class="signup-header-container">
            <a href="${pageContext.request.contextPath}/index.jsp" class="logo" title="Back to StockFlow Home">
                <div class="logo-icon">
                    <i class="fa-solid fa-boxes-stacked"></i>
                </div>
                <span>Stock<span style="color: #38bdf8;">Flow</span></span>
            </a>

            <div class="header-nav-links">
                <a href="${pageContext.request.contextPath}/index.jsp" class="back-home-link">
                    <i class="fa-solid fa-arrow-left"></i>
                    <span>Back to Homepage</span>
                </a>
                <a href="${pageContext.request.contextPath}/customer/login/login.jsp" class="header-login-btn">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    <span>Sign In</span>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Signup Section -->
    <main class="signup-main">
        <div class="signup-wrapper">
            
            <!-- Left Side: Interactive Registration Form -->
            <div class="signup-form-side">
                
                <div class="signup-title-group">
                    <div class="signup-badge">
                        <i class="fa-solid fa-bolt"></i>
                        <span>14-Day Free Trial &bull; No CC Required</span>
                    </div>
                    <h1 class="signup-heading">Start Your Free Trial</h1>
                    <p class="signup-subheading">Create your organization account and experience real-time inventory synchronization in minutes.</p>
                </div>

                <!-- Plan Selection Selector -->
                <div class="plan-selector-container">
                    <div class="plan-selector-label">
                        <span>Selected Plan Tier</span>
                        <span style="color: #38bdf8; text-transform: none; font-weight: 600;">Full Feature Sandbox Included</span>
                    </div>
                    <div class="plan-pills">
                        <button type="button" class="plan-pill-btn" data-plan="starter">
                            <span>Starter</span>
                            <span class="plan-price-tag">$39/mo</span>
                        </button>
                        <button type="button" class="plan-pill-btn active" data-plan="pro">
                            <span>Professional</span>
                            <span class="plan-price-tag">$99/mo (Popular)</span>
                        </button>
                        <button type="button" class="plan-pill-btn" data-plan="enterprise">
                            <span>Enterprise</span>
                            <span class="plan-price-tag">$239/mo</span>
                        </button>
                    </div>
                </div>

                <!-- Dynamic Alert Banner -->
                <div class="signup-alert" id="signupAlert" role="alert">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span id="alertMessage"></span>
                </div>

                <!-- Registration Form -->
                <form id="signupForm" 
                      class="signup-form" 
                      action="${pageContext.request.contextPath}/signup-auth" 
                      method="POST" 
                      data-context-path="${pageContext.request.contextPath}">
                    
                    <input type="hidden" id="selectedPlan" name="plan" value="pro">

                    <!-- Name & Company Row -->
                    <div class="form-row">
                        <!-- Full Name Field -->
                        <div class="form-group" id="fullNameGroup">
                            <label for="fullName" class="form-label">Full Name</label>
                            <div class="input-container">
                                <i class="fa-solid fa-user input-icon"></i>
                                <input type="text" 
                                       id="fullName" 
                                       name="fullName" 
                                       class="signup-input" 
                                       placeholder="e.g. Jordan Vance" 
                                       autocomplete="name" 
                                       required>
                            </div>
                            <div class="input-error-msg"></div>
                        </div>

                        <!-- Company Name Field -->
                        <div class="form-group" id="companyNameGroup">
                            <label for="companyName" class="form-label">Company Name</label>
                            <div class="input-container">
                                <i class="fa-solid fa-building input-icon"></i>
                                <input type="text" 
                                       id="companyName" 
                                       name="companyName" 
                                       class="signup-input" 
                                       placeholder="e.g. Apex Distro LLC" 
                                       autocomplete="organization" 
                                       required>
                            </div>
                            <div class="input-error-msg"></div>
                        </div>
                    </div>

                    <!-- Email & Company Size Row -->
                    <div class="form-row">
                        <!-- Business Email Field -->
                        <div class="form-group" id="emailGroup">
                            <label for="email" class="form-label">Business Work Email</label>
                            <div class="input-container">
                                <i class="fa-solid fa-envelope input-icon"></i>
                                <input type="email" 
                                       id="email" 
                                       name="email" 
                                       class="signup-input" 
                                       placeholder="jordan@company.com" 
                                       autocomplete="email" 
                                       required>
                            </div>
                            <div class="input-error-msg"></div>
                        </div>

                        <!-- Company Size / Operational Scale Field -->
                        <div class="form-group" id="companySizeGroup">
                            <label for="companySize" class="form-label">Warehouse Team Size</label>
                            <div class="input-container">
                                <i class="fa-solid fa-users-gear input-icon"></i>
                                <select id="companySize" name="companySize" class="signup-select" required>
                                    <option value="" disabled selected>Select team size...</option>
                                    <option value="1-5">1 - 5 Floor Operators</option>
                                    <option value="6-20">6 - 20 Warehouse Staff</option>
                                    <option value="21-100">21 - 100 Multi-Location Hubs</option>
                                    <option value="100+">100+ Enterprise Fleet</option>
                                </select>
                            </div>
                            <div class="input-error-msg"></div>
                        </div>
                    </div>

                    <!-- Password Field with Live Strength Feedback -->
                    <div class="form-group" id="passwordGroup">
                        <div class="form-label">
                            <label for="password">Security Password</label>
                            <span id="strengthLabel" style="font-size: 0.75rem; color: var(--text-dim);">Password strength</span>
                        </div>
                        <div class="input-container">
                            <i class="fa-solid fa-lock input-icon"></i>
                            <input type="password" 
                                   id="password" 
                                   name="password" 
                                   class="signup-input" 
                                   placeholder="Create a strong password (min 8 chars)" 
                                   autocomplete="new-password" 
                                   required>
                            <button type="button" class="password-toggle-btn" id="togglePassword" aria-label="Toggle password visibility">
                                <i class="fa-solid fa-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                        
                        <!-- Password Strength Progress Meter -->
                        <div class="password-strength-wrapper">
                            <div class="password-strength-bars">
                                <div class="strength-bar" id="strBar1"></div>
                                <div class="strength-bar" id="strBar2"></div>
                                <div class="strength-bar" id="strBar3"></div>
                            </div>
                            <div class="password-rules">
                                <div class="rule-item" id="ruleLength"><i class="fa-regular fa-circle"></i> 8+ characters</div>
                                <div class="rule-item" id="ruleUpper"><i class="fa-regular fa-circle"></i> Upper & lowercase</div>
                                <div class="rule-item" id="ruleNumber"><i class="fa-regular fa-circle"></i> At least 1 number</div>
                                <div class="rule-item" id="ruleSpecial"><i class="fa-regular fa-circle"></i> Special character</div>
                            </div>
                        </div>
                        <div class="input-error-msg"></div>
                    </div>

                    <!-- Confirm Password Field -->
                    <div class="form-group" id="confirmPasswordGroup">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="input-container">
                            <i class="fa-solid fa-shield-halved input-icon"></i>
                            <input type="password" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   class="signup-input" 
                                   placeholder="Re-enter password to confirm" 
                                   autocomplete="new-password" 
                                   required>
                            <button type="button" class="password-toggle-btn" id="toggleConfirmPassword" aria-label="Toggle confirm password visibility">
                                <i class="fa-solid fa-eye" id="toggleConfirmPasswordIcon"></i>
                            </button>
                        </div>
                        <div class="input-error-msg"></div>
                    </div>

                    <!-- Terms & Privacy Agreement Checkbox -->
                    <div class="form-group terms-row" id="termsGroup">
                        <label class="checkbox-label" for="termsCheckbox">
                            <input type="checkbox" id="termsCheckbox" name="terms" checked required>
                            <span>
                                I agree to the <a href="${pageContext.request.contextPath}/index.jsp#faq" class="terms-link" target="_blank">Terms of Service</a>, <a href="${pageContext.request.contextPath}/index.jsp#faq" class="terms-link" target="_blank">Privacy Policy</a> and receiving product updates.
                            </span>
                        </label>
                        <div class="input-error-msg"></div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="submitBtn" class="btn btn-primary btn-signup-submit">
                        <span class="btn-text">Create Free Enterprise Account</span>
                        <i class="fa-solid fa-arrow-right"></i>
                        <span class="spinner"></span>
                    </button>

                    <!-- Quick Demo Autofill Bar -->
                    <div class="demo-signup-row">
                        <div class="demo-signup-text">
                            <i class="fa-solid fa-wand-magic-sparkles" style="color: #818cf8;"></i>
                            <span>Quick testing in sandbox mode?</span>
                        </div>
                        <button type="button" id="demoSignupBtn" class="demo-autofill-btn">
                            <i class="fa-solid fa-bolt"></i>
                            <span>1-Click Demo Fill</span>
                        </button>
                    </div>

                    <!-- Back to Login Prompt -->
                    <div class="signup-login-prompt">
                        <span>Already registered with StockFlow?</span>
                        <a href="${pageContext.request.contextPath}/customer/login/login.jsp">Sign in here &rarr;</a>
                    </div>
                </form>
            </div>

            <!-- Right Side: Platform Showcase & Free Trial Guarantees -->
            <div class="signup-showcase-side">
                <div class="showcase-header">
                    <div class="badge badge-success" style="margin-bottom: 14px;">
                        <span class="pulse-dot"></span>
                        <span>14-Day Free Trial &bull; Instant Access</span>
                    </div>
                    <h2 class="showcase-title">Scale Your Warehouse With Total Precision</h2>
                    <p class="showcase-desc">Get uninterrupted access to all enterprise inventory capabilities during your 14-day trial period.</p>
                </div>

                <div class="trial-perks-box">
                    <div class="perk-item">
                        <div class="perk-icon feature-icon-purple">
                            <i class="fa-solid fa-warehouse"></i>
                        </div>
                        <div class="perk-text">
                            <h5>Unlimited SKUs & Locations</h5>
                            <p>Configure multiple fulfillment hubs, store bays, and inventory bins without arbitrary limits.</p>
                        </div>
                    </div>

                    <div class="perk-item">
                        <div class="perk-icon feature-icon-blue">
                            <i class="fa-solid fa-barcode"></i>
                        </div>
                        <div class="perk-text">
                            <h5>High-Velocity Barcode Engine</h5>
                            <p>Works out of the box with Zebra, Honeywell, and iOS/Android camera scanning.</p>
                        </div>
                    </div>

                    <div class="perk-item">
                        <div class="perk-icon feature-icon-green">
                            <i class="fa-solid fa-headset"></i>
                        </div>
                        <div class="perk-text">
                            <h5>Dedicated Onboarding Specialist</h5>
                            <p>Direct 1-on-1 assistance with CSV bulk catalog migration and team workflow setup.</p>
                        </div>
                    </div>
                </div>

                <!-- Testimonial Quote -->
                <div class="signup-testimonial">
                    <div class="testimonial-stars">
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                        <i class="fa-solid fa-star"></i>
                    </div>
                    <p class="signup-testimonial-quote">
                        "Setting up StockFlow took our 3 regional warehouses from messy spreadsheets to a synchronized automated engine in less than a single afternoon."
                    </p>
                    <div class="showcase-author">
                        <div class="author-mini-avatar">SJ</div>
                        <div class="showcase-author-info">
                            Sarah Jenkins
                            <span>Supply Chain Director &bull; Nova Goods</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- Bottom Security Footer -->
    <footer class="signup-footer">
        <div class="signup-footer-container">
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

    <!-- Signup Scripts -->
    <script src="${pageContext.request.contextPath}/customer/js/signup.js"></script>
</body>
</html>
