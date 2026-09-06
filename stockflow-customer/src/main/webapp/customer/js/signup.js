/**
 * StockFlow Customer Portal - Signup Interactive JavaScript
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. DOM Elements
    const signupForm = document.getElementById('signupForm');
    const fullNameInput = document.getElementById('fullName');
    const companyNameInput = document.getElementById('companyName');
    const emailInput = document.getElementById('email');
    const companySizeSelect = document.getElementById('companySize');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const termsCheckbox = document.getElementById('termsCheckbox');
    const selectedPlanInput = document.getElementById('selectedPlan');
    const submitBtn = document.getElementById('submitBtn');
    const signupAlert = document.getElementById('signupAlert');
    const alertMessage = document.getElementById('alertMessage');
    const planPillBtns = document.querySelectorAll('.plan-pill-btn');
    const demoSignupBtn = document.getElementById('demoSignupBtn');

    // Password Toggles
    const togglePasswordBtn = document.getElementById('togglePassword');
    const togglePasswordIcon = document.getElementById('togglePasswordIcon');
    const toggleConfirmPasswordBtn = document.getElementById('toggleConfirmPassword');
    const toggleConfirmPasswordIcon = document.getElementById('toggleConfirmPasswordIcon');

    // Password Strength Elements
    const bar1 = document.getElementById('strBar1');
    const bar2 = document.getElementById('strBar2');
    const bar3 = document.getElementById('strBar3');
    const strengthLabel = document.getElementById('strengthLabel');
    const ruleLength = document.getElementById('ruleLength');
    const ruleUpper = document.getElementById('ruleUpper');
    const ruleNumber = document.getElementById('ruleNumber');
    const ruleSpecial = document.getElementById('ruleSpecial');

    // 2. Check URL Query Parameters (e.g. ?plan=pro, ?email=..., ?error=...)
    const urlParams = new URLSearchParams(window.location.search);
    
    // Auto-select Plan if present in URL
    if (urlParams.has('plan')) {
        const planParam = urlParams.get('plan').toLowerCase();
        setActivePlan(planParam);
    }

    // Auto-fill email if passed from Landing Page CTA form
    if (urlParams.has('email')) {
        const emailParam = urlParams.get('email');
        if (emailInput && emailParam) {
            emailInput.value = emailParam;
        }
    }

    // Handle incoming URL error messages
    if (urlParams.has('error')) {
        const err = urlParams.get('error');
        if (err === 'exists') {
            showAlert('An account with this email address already exists. Please sign in or use another email.', 'danger');
        } else if (err === 'terms') {
            showAlert('You must accept the Terms of Service to register your account.', 'danger');
        } else if (err === 'password_mismatch') {
            showAlert('Passwords do not match. Please verify and try again.', 'danger');
        } else if (err === 'db_error') {
            showAlert('Could not connect to MongoDB database. Please ensure MongoDB service is active.', 'danger');
        } else {
            showAlert('Registration failed. Please check all fields and submit again.', 'danger');
        }
    }

    // 3. Plan Switcher Handling
    planPillBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const plan = btn.getAttribute('data-plan');
            setActivePlan(plan);
        });
    });

    function setActivePlan(planName) {
        let found = false;
        planPillBtns.forEach(b => {
            if (b.getAttribute('data-plan') === planName) {
                b.classList.add('active');
                found = true;
            } else {
                b.classList.remove('active');
            }
        });
        if (found && selectedPlanInput) {
            selectedPlanInput.value = planName;
        }
    }

    // 4. Password Visibility Toggles
    if (togglePasswordBtn && passwordInput && togglePasswordIcon) {
        togglePasswordBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const isPassword = passwordInput.getAttribute('type') === 'password';
            passwordInput.setAttribute('type', isPassword ? 'text' : 'password');
            togglePasswordIcon.classList.toggle('fa-eye', !isPassword);
            togglePasswordIcon.classList.toggle('fa-eye-slash', isPassword);
        });
    }

    if (toggleConfirmPasswordBtn && confirmPasswordInput && toggleConfirmPasswordIcon) {
        toggleConfirmPasswordBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const isPassword = confirmPasswordInput.getAttribute('type') === 'password';
            confirmPasswordInput.setAttribute('type', isPassword ? 'text' : 'password');
            toggleConfirmPasswordIcon.classList.toggle('fa-eye', !isPassword);
            toggleConfirmPasswordIcon.classList.toggle('fa-eye-slash', isPassword);
        });
    }

    // 5. Password Strength Meter & Real-time Rule Check
    if (passwordInput) {
        passwordInput.addEventListener('input', () => {
            checkPasswordStrength(passwordInput.value);
            if (confirmPasswordInput && confirmPasswordInput.value) {
                checkPasswordMatch();
            }
        });
    }

    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', () => {
            checkPasswordMatch();
        });
    }

    function checkPasswordStrength(pass) {
        const hasLength = pass.length >= 8;
        const hasUpper = /[A-Z]/.test(pass) && /[a-z]/.test(pass);
        const hasNumber = /[0-9]/.test(pass);
        const hasSpecial = /[^A-Za-z0-9]/.test(pass);

        updateRuleState(ruleLength, hasLength);
        updateRuleState(ruleUpper, hasUpper);
        updateRuleState(ruleNumber, hasNumber);
        updateRuleState(ruleSpecial, hasSpecial);

        let score = 0;
        if (hasLength) score++;
        if (hasUpper) score++;
        if (hasNumber) score++;
        if (hasSpecial) score++;

        // Reset bars
        [bar1, bar2, bar3].forEach(b => {
            if (b) {
                b.className = 'strength-bar';
            }
        });

        if (!pass) {
            if (strengthLabel) strengthLabel.textContent = 'Password strength';
            return;
        }

        if (score <= 1) {
            if (bar1) bar1.classList.add('weak');
            if (strengthLabel) {
                strengthLabel.textContent = 'Weak';
                strengthLabel.style.color = '#ef4444';
            }
        } else if (score >= 2 && score < 4) {
            if (bar1) bar1.classList.add('medium');
            if (bar2) bar2.classList.add('medium');
            if (strengthLabel) {
                strengthLabel.textContent = 'Good';
                strengthLabel.style.color = '#f59e0b';
            }
        } else if (score >= 4) {
            if (bar1) bar1.classList.add('strong');
            if (bar2) bar2.classList.add('strong');
            if (bar3) bar3.classList.add('strong');
            if (strengthLabel) {
                strengthLabel.textContent = 'Strong';
                strengthLabel.style.color = '#10b981';
            }
        }
    }

    function updateRuleState(el, isValid) {
        if (!el) return;
        if (isValid) {
            el.classList.add('valid');
            const icon = el.querySelector('i');
            if (icon) icon.className = 'fa-solid fa-check';
        } else {
            el.classList.remove('valid');
            const icon = el.querySelector('i');
            if (icon) icon.className = 'fa-regular fa-circle';
        }
    }

    function checkPasswordMatch() {
        if (!confirmPasswordInput || !passwordInput) return;
        const pass = passwordInput.value;
        const confirmPass = confirmPasswordInput.value;
        const group = document.getElementById('confirmPasswordGroup');

        if (confirmPass && pass !== confirmPass) {
            showFieldError('confirmPasswordGroup', 'Passwords do not match');
        } else if (group) {
            group.classList.remove('has-error');
        }
    }

    // 6. 1-Click Demo Fill
    if (demoSignupBtn) {
        demoSignupBtn.addEventListener('click', () => {
            if (fullNameInput) fullNameInput.value = 'Jordan Vance';
            if (companyNameInput) companyNameInput.value = 'Apex Distro & Logistics LLC';
            if (emailInput) emailInput.value = 'jordan.vance@apexdistro.com';
            if (companySizeSelect) companySizeSelect.value = '21-100';
            if (passwordInput) {
                passwordInput.value = 'StockFlow#2026';
                checkPasswordStrength('StockFlow#2026');
            }
            if (confirmPasswordInput) confirmPasswordInput.value = 'StockFlow#2026';
            if (termsCheckbox) termsCheckbox.checked = true;

            setActivePlan('pro');
            clearErrors();
            highlightAllFields();
            showAlert('Demo enterprise account profile loaded. Click "Create Free Enterprise Account" to register!', 'info');
        });
    }

    function highlightAllFields() {
        const inputs = [fullNameInput, companyNameInput, emailInput, companySizeSelect, passwordInput, confirmPasswordInput];
        inputs.forEach(input => {
            if (input) {
                input.style.transition = 'all 0.3s ease';
                input.style.borderColor = '#818cf8';
                input.style.boxShadow = '0 0 10px rgba(129, 140, 248, 0.35)';
                setTimeout(() => {
                    input.style.borderColor = '';
                    input.style.boxShadow = '';
                }, 1200);
            }
        });
    }

    // 7. Form Validation & Submission
    if (signupForm) {
        signupForm.addEventListener('submit', (e) => {
            let isValid = true;
            clearErrors();

            const fullName = fullNameInput ? fullNameInput.value.trim() : '';
            const companyName = companyNameInput ? companyNameInput.value.trim() : '';
            const email = emailInput ? emailInput.value.trim() : '';
            const companySize = companySizeSelect ? companySizeSelect.value : '';
            const password = passwordInput ? passwordInput.value : '';
            const confirmPassword = confirmPasswordInput ? confirmPasswordInput.value : '';
            const termsChecked = termsCheckbox ? termsCheckbox.checked : false;

            // Full Name
            if (!fullName || fullName.length < 2) {
                showFieldError('fullNameGroup', 'Please enter your full name (at least 2 characters).');
                isValid = false;
            }

            // Company Name
            if (!companyName || companyName.length < 2) {
                showFieldError('companyNameGroup', 'Please enter your company or organization name.');
                isValid = false;
            }

            // Business Email
            if (!email) {
                showFieldError('emailGroup', 'Please provide your business email address.');
                isValid = false;
            } else if (!isValidEmail(email)) {
                showFieldError('emailGroup', 'Please enter a valid business email address.');
                isValid = false;
            }

            // Company Size
            if (!companySize) {
                showFieldError('companySizeGroup', 'Please select your estimated warehouse / company size.');
                isValid = false;
            }

            // Password
            if (!password) {
                showFieldError('passwordGroup', 'Please create a security password.');
                isValid = false;
            } else if (password.length < 8) {
                showFieldError('passwordGroup', 'Password must contain at least 8 characters.');
                isValid = false;
            }

            // Confirm Password
            if (!confirmPassword) {
                showFieldError('confirmPasswordGroup', 'Please re-type your password to confirm.');
                isValid = false;
            } else if (password !== confirmPassword) {
                showFieldError('confirmPasswordGroup', 'Passwords do not match.');
                isValid = false;
            }

            // Terms Agreement
            if (!termsChecked) {
                showAlert('You must agree to the Terms of Service & Privacy Policy to continue.', 'danger');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                shakeElement(signupForm);
                return;
            }

            // If form posts to servlet
            if (signupForm.getAttribute('action') && signupForm.getAttribute('action') !== '#' && !signupForm.getAttribute('action').startsWith('javascript')) {
                if (submitBtn) {
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                }
                return true;
            } else {
                e.preventDefault();
                if (submitBtn) {
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                }

                setTimeout(() => {
                    showAlert(`Account for ${fullName} (${companyName}) created successfully! Initializing workspace...`, 'success');
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

    // Helper: Show field error
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

    // Helper: Clear field errors
    function clearErrors() {
        document.querySelectorAll('.form-group').forEach(group => {
            group.classList.remove('has-error');
        });
    }

    // Helper: Show alert banner
    function showAlert(msg, type = 'danger') {
        if (!signupAlert || !alertMessage) return;

        signupAlert.className = `signup-alert signup-alert-${type} show`;
        const icon = signupAlert.querySelector('i');
        if (icon) {
            if (type === 'danger') icon.className = 'fa-solid fa-triangle-exclamation';
            else if (type === 'success') icon.className = 'fa-solid fa-circle-check';
            else icon.className = 'fa-solid fa-circle-info';
        }
        alertMessage.textContent = msg;
    }

    // Helper: Shake animation
    function shakeElement(el) {
        el.style.animation = 'none';
        el.offsetHeight;
        el.style.animation = 'shake 0.4s cubic-bezier(.36,.07,.19,.97) both';
    }

    // Clear error on user typing in inputs
    const allInputs = [fullNameInput, companyNameInput, emailInput, companySizeSelect, passwordInput, confirmPasswordInput];
    allInputs.forEach(input => {
        if (input) {
            input.addEventListener('input', () => {
                const group = input.closest('.form-group');
                if (group) group.classList.remove('has-error');
            });
        }
    });
});
