/**
 * StockFlow Customer Portal - Login Interactive JavaScript
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. DOM Elements
    const loginForm = document.getElementById('loginForm');
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const rememberMeCheckbox = document.getElementById('rememberMe');
    const togglePasswordBtn = document.getElementById('togglePassword');
    const togglePasswordIcon = document.getElementById('togglePasswordIcon');
    const submitBtn = document.getElementById('submitBtn');
    const loginAlert = document.getElementById('loginAlert');
    const alertMessage = document.getElementById('alertMessage');
    const tabBtns = document.querySelectorAll('.login-tab-btn');
    const roleInput = document.getElementById('userRole');
    const userLabel = document.getElementById('userLabel');
    const forgotPasswordLink = document.getElementById('forgotPasswordLink');

    // Demo Autofill Buttons
    const demoCustomerBtn = document.getElementById('demoCustomerBtn');
    const demoAdminBtn = document.getElementById('demoAdminBtn');

    // 2. Check URL Query Parameters for notifications (e.g. ?error=1, ?loggedOut=1)
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('error')) {
        const errorType = urlParams.get('error');
        if (errorType === 'invalid' || errorType === '1') {
            showAlert('Invalid email or password. Please verify your credentials and try again.', 'danger');
        } else if (errorType === 'session_expired') {
            showAlert('Your session has expired. Please sign in again.', 'info');
        } else if (errorType === 'access_denied') {
            showAlert('Access denied. Please log in with appropriate privileges.', 'danger');
        } else {
            showAlert('Authentication failed. Please check your credentials.', 'danger');
        }
    } else if (urlParams.has('msg') || urlParams.has('status')) {
        const msg = urlParams.get('msg') || urlParams.get('status');
        if (msg === 'logged_out' || msg === 'logout') {
            showAlert('You have been successfully signed out of StockFlow.', 'success');
        } else if (msg === 'registered') {
            showAlert('Account created successfully! Please sign in with your credentials.', 'success');
        } else if (msg === 'password_reset') {
            showAlert('Password reset link has been processed. Please sign in.', 'info');
        }
    }

    // 3. Tab Switching (Customer Portal vs Warehouse Staff)
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const role = btn.getAttribute('data-role');
            if (roleInput) {
                roleInput.value = role;
            }

            if (role === 'staff') {
                userLabel.textContent = 'Staff ID or Corporate Email';
                usernameInput.placeholder = 'e.g. staff.sarah@stockflow.internal';
                usernameInput.setAttribute('type', 'text');
            } else {
                userLabel.textContent = 'Business Email or Customer ID';
                usernameInput.placeholder = 'name@company.com';
                usernameInput.setAttribute('type', 'email');
            }

            clearErrors();
        });
    });

    // 4. Toggle Password Visibility
    if (togglePasswordBtn && passwordInput && togglePasswordIcon) {
        togglePasswordBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const isPassword = passwordInput.getAttribute('type') === 'password';
            passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
            togglePasswordIcon.classList.toggle('fa-eye', !isPassword);
            togglePasswordIcon.classList.toggle('fa-eye-slash', isPassword);
        });
    }

    // 5. Quick Demo Account Autofill
    if (demoCustomerBtn) {
        demoCustomerBtn.addEventListener('click', () => {
            // Select customer tab
            const customerTab = document.querySelector('.login-tab-btn[data-role="customer"]');
            if (customerTab) customerTab.click();

            usernameInput.value = 'alex.morgan@acmelogistics.com';
            passwordInput.value = 'StockFlow2026!';
            clearErrors();
            highlightFields();
            showAlert('Demo Customer credentials loaded. Click "Sign In" to proceed.', 'info');
        });
    }

    if (demoAdminBtn) {
        demoAdminBtn.addEventListener('click', () => {
            // Select staff tab
            const staffTab = document.querySelector('.login-tab-btn[data-role="staff"]');
            if (staffTab) staffTab.click();

            usernameInput.value = 'admin@stockflow.internal';
            passwordInput.value = 'AdminPass2026!';
            clearErrors();
            highlightFields();
            showAlert('Demo Staff / Admin credentials loaded. Click "Sign In" to proceed.', 'info');
        });
    }

    function highlightFields() {
        [usernameInput, passwordInput].forEach(input => {
            input.style.transition = 'all 0.3s ease';
            input.style.borderColor = '#818cf8';
            input.style.boxShadow = '0 0 12px rgba(129, 140, 248, 0.4)';
            setTimeout(() => {
                input.style.borderColor = '';
                input.style.boxShadow = '';
            }, 1200);
        });
    }

    // 6. Forgot Password Modal / Prompt Handler
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', (e) => {
            e.preventDefault();
            const emailVal = usernameInput.value.trim();
            if (emailVal && emailVal.includes('@')) {
                showAlert(`Password reset link sent to ${emailVal}. Please check your inbox.`, 'success');
            } else {
                const promptEmail = prompt('Please enter your registered email address to receive password reset instructions:', emailVal);
                if (promptEmail && promptEmail.trim().length > 3) {
                    showAlert(`Password reset instructions have been dispatched to ${promptEmail.trim()}.`, 'success');
                }
            }
        });
    }

    // 7. SSO Buttons Handling
    const ssoBtns = document.querySelectorAll('.sso-btn');
    ssoBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const provider = btn.textContent.trim();
            showAlert(`Connecting to ${provider} Enterprise Identity Provider...`, 'info');
            btn.style.opacity = '0.7';
            setTimeout(() => {
                btn.style.opacity = '1';
                showAlert(`Single Sign-On (${provider}) authentication initiated.`, 'success');
            }, 1500);
        });
    });

    // 8. Form Validation & Submission
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            let isValid = true;
            clearErrors();

            const username = usernameInput.value.trim();
            const password = passwordInput.value.trim();
            const currentRole = roleInput ? roleInput.value : 'customer';

            // Validate Username / Email
            if (!username) {
                showFieldError('usernameGroup', 'Please enter your email or identifier.');
                isValid = false;
            } else if (currentRole === 'customer' && !isValidEmail(username)) {
                showFieldError('usernameGroup', 'Please enter a valid email address.');
                isValid = false;
            }

            // Validate Password
            if (!password) {
                showFieldError('passwordGroup', 'Please enter your password.');
                isValid = false;
            } else if (password.length < 6) {
                showFieldError('passwordGroup', 'Password must contain at least 6 characters.');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                shakeElement(loginForm);
                return;
            }

            // If form has no backend servlet configured and is static, provide smooth feedback or let form post to servlet
            if (loginForm.getAttribute('action') && loginForm.getAttribute('action') !== '#' && !loginForm.getAttribute('action').startsWith('javascript')) {
                // Submit button loading state
                if (submitBtn) {
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                }
                // Allow standard form submission to continue to Servlet/JSP
                return true;
            } else {
                e.preventDefault();
                if (submitBtn) {
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                }

                // Simulate successful authentication in client demo
                setTimeout(() => {
                    showAlert(`Welcome back, ${username}! Redirecting to Dashboard...`, 'success');
                    setTimeout(() => {
                        window.location.href = `../dashboard.jsp`;
                    }, 1200);
                }, 1000);
            }
        });
    }

    // Helper: Email format validator
    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    // Helper: Show field level error
    function showFieldError(groupId, message) {
        const group = document.getElementById(groupId);
        if (group) {
            group.classList.add('has-error');
            const errorMsgEl = group.querySelector('.input-error-msg');
            if (errorMsgEl) {
                errorMsgEl.innerHTML = `<i class="fa-solid fa-circle-exclamation"></i> ${message}`;
            }
        }
    }

    // Helper: Clear errors
    function clearErrors() {
        document.querySelectorAll('.form-group').forEach(group => {
            group.classList.remove('has-error');
        });
    }

    // Helper: Show Alert banner
    function showAlert(msg, type = 'danger') {
        if (!loginAlert || !alertMessage) return;

        loginAlert.className = `login-alert login-alert-${type} show`;
        const icon = loginAlert.querySelector('i');
        if (icon) {
            if (type === 'danger') icon.className = 'fa-solid fa-triangle-exclamation';
            else if (type === 'success') icon.className = 'fa-solid fa-circle-check';
            else icon.className = 'fa-solid fa-circle-info';
        }
        alertMessage.textContent = msg;
    }

    // Helper: Shake animation for errors
    function shakeElement(el) {
        el.style.animation = 'none';
        el.offsetHeight; /* trigger reflow */
        el.style.animation = 'shake 0.4s cubic-bezier(.36,.07,.19,.97) both';
    }

    // Input listeners to clear error on typing
    [usernameInput, passwordInput].forEach(input => {
        if (input) {
            input.addEventListener('input', () => {
                const group = input.closest('.form-group');
                if (group) group.classList.remove('has-error');
            });
        }
    });
});

// CSS shake keyframe dynamically injected
const styleSheet = document.createElement('style');
styleSheet.innerHTML = `
@keyframes shake {
  10%, 90% { transform: translate3d(-1px, 0, 0); }
  20%, 80% { transform: translate3d(2px, 0, 0); }
  30%, 50%, 70% { transform: translate3d(-4px, 0, 0); }
  40%, 60% { transform: translate3d(4px, 0, 0); }
}
`;
document.head.appendChild(styleSheet);
