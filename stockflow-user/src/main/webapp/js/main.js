/**
 * StockFlow User Landing Page JavaScript
 * Handles interactivity, search filtering, accordions, auth modal, and tracking simulator.
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Mobile Menu Toggle
    const hamburger = document.getElementById('hamburger-toggle');
    const navMenu = document.getElementById('nav-menu');

    if (hamburger && navMenu) {
        hamburger.addEventListener('click', () => {
            navMenu.classList.toggle('open');
            hamburger.setAttribute('aria-expanded', navMenu.classList.contains('open'));
        });
    }

    // 2. Auth Modal (Login / Sign Up) Triggers & Logic
    const authModal = document.getElementById('auth-modal');
    const modalCloseBtn = document.getElementById('modal-close-btn');
    const authTabBtns = document.querySelectorAll('.auth-tab-btn');
    const authFormPanels = document.querySelectorAll('.auth-form-panel');
    const openLoginBtns = document.querySelectorAll('.trigger-login-modal');
    const openSignupBtns = document.querySelectorAll('.trigger-signup-modal');
    const switchTabLinks = document.querySelectorAll('.switch-auth-tab');

    function openModal(initialTab = 'login') {
        if (!authModal) return;
        authModal.classList.add('open');
        document.body.style.overflow = 'hidden';
        switchTab(initialTab);
    }

    function closeModal() {
        if (!authModal) return;
        authModal.classList.remove('open');
        document.body.style.overflow = '';
    }

    function switchTab(tabName) {
        authTabBtns.forEach(btn => {
            if (btn.getAttribute('data-tab') === tabName) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        authFormPanels.forEach(panel => {
            if (panel.id === `auth-${tabName}-panel`) {
                panel.classList.add('active');
            } else {
                panel.classList.remove('active');
            }
        });
    }

    openLoginBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            if (navMenu && navMenu.classList.contains('open')) {
                navMenu.classList.remove('open');
            }
            openModal('login');
        });
    });

    openSignupBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            if (navMenu && navMenu.classList.contains('open')) {
                navMenu.classList.remove('open');
            }
            openModal('signup');
        });
    });

    authTabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const target = btn.getAttribute('data-tab');
            switchTab(target);
        });
    });

    switchTabLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = link.getAttribute('data-target-tab');
            switchTab(target);
        });
    });

    if (modalCloseBtn) {
        modalCloseBtn.addEventListener('click', closeModal);
    }

    if (authModal) {
        authModal.addEventListener('click', (e) => {
            if (e.target === authModal) {
                closeModal();
            }
        });
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && authModal && authModal.classList.contains('open')) {
            closeModal();
        }
    });

    // Handle Form Submissions (Login / Sign Up)
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = document.getElementById('login-email').value;
            showToast(`Welcome back! Logged in as ${email}`, 'success');
            closeModal();
        });
    }

    const signupForm = document.getElementById('signup-form');
    if (signupForm) {
        signupForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const name = document.getElementById('signup-name').value;
            showToast(`Account successfully created for ${name}! Welcome to StockFlow.`, 'success');
            closeModal();
        });
    }

    // 3. Product Catalog Category Tabs Filter
    const tabBtns = document.querySelectorAll('.tab-btn');
    const productCards = document.querySelectorAll('.product-card');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            const selectedCategory = btn.getAttribute('data-category');

            productCards.forEach(card => {
                const cardCategory = card.getAttribute('data-category');
                if (selectedCategory === 'all' || cardCategory === selectedCategory) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    // 4. Quick Search Filter
    const searchInput = document.getElementById('product-search-input');
    const categorySelect = document.getElementById('category-filter-select');
    const stockStatusSelect = document.getElementById('stock-status-select');
    const searchBtn = document.getElementById('search-action-btn');

    function filterProducts() {
        const query = (searchInput ? searchInput.value : '').toLowerCase().trim();
        const selectedCat = categorySelect ? categorySelect.value : 'all';
        const selectedStock = stockStatusSelect ? stockStatusSelect.value : 'all';

        productCards.forEach(card => {
            const title = card.querySelector('.product-name').textContent.toLowerCase();
            const sku = card.querySelector('.product-sku').textContent.toLowerCase();
            const category = card.getAttribute('data-category');
            const stock = card.getAttribute('data-stock');

            const matchesQuery = query === '' || title.includes(query) || sku.includes(query);
            const matchesCat = selectedCat === 'all' || category === selectedCat;
            const matchesStock = selectedStock === 'all' || stock === selectedStock;

            if (matchesQuery && matchesCat && matchesStock) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });

        // Scroll to catalog section if user performed an explicit search
        const catalogSection = document.getElementById('catalog');
        if (catalogSection) {
            catalogSection.scrollIntoView({ behavior: 'smooth' });
        }
    }

    if (searchBtn) {
        searchBtn.addEventListener('click', filterProducts);
    }
    if (searchInput) {
        searchInput.addEventListener('keyup', (e) => {
            if (e.key === 'Enter') filterProducts();
        });
    }

    // 5. FAQ Accordion
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        const questionBtn = item.querySelector('.faq-question');
        questionBtn.addEventListener('click', () => {
            const isOpen = item.classList.contains('active');
            faqItems.forEach(i => i.classList.remove('active'));
            if (!isOpen) {
                item.classList.add('active');
            }
        });
    });

    // 6. Order Tracking Simulator
    const trackOrderBtn = document.getElementById('btn-track-order');
    const trackOrderInput = document.getElementById('track-order-input');
    const trackOrderIdDisplay = document.getElementById('track-order-id-display');
    const trackStatusBadge = document.getElementById('track-status-badge');

    if (trackOrderBtn && trackOrderInput) {
        trackOrderBtn.addEventListener('click', () => {
            const orderId = trackOrderInput.value.trim();
            if (!orderId) {
                showToast('Please enter a valid Order ID (e.g., ORD-8924)', 'warning');
                return;
            }

            if (trackOrderIdDisplay) {
                trackOrderIdDisplay.textContent = orderId.toUpperCase();
            }
            if (trackStatusBadge) {
                trackStatusBadge.textContent = 'In Transit - Out for Delivery';
            }

            // Update steps visual
            const steps = document.querySelectorAll('.track-step');
            if (steps.length >= 4) {
                steps[0].className = 'track-step done';
                steps[1].className = 'track-step done';
                steps[2].className = 'track-step active';
                steps[3].className = 'track-step';
            }

            showToast('Tracking details updated for ' + orderId.toUpperCase(), 'success');
        });
    }

    // 7. Newsletter Subscription Simulator
    const newsletterForm = document.getElementById('newsletter-form');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const email = newsletterForm.querySelector('input[type="email"]').value;
            if (email) {
                showToast('Thank you for subscribing! Updates will be sent to ' + email, 'success');
                newsletterForm.reset();
            }
        });
    }

    // 8. Add to Cart / Order Simulation
    const orderButtons = document.querySelectorAll('.btn-order-action');
    orderButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const productName = btn.getAttribute('data-product-name') || 'Item';
            showToast(`"${productName}" added to order draft!`, 'success');
        });
    });
});

// Toast notification helper
function showToast(message, type = 'success') {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `<span>${type === 'success' ? '✓' : 'ℹ'}</span> <span>${message}</span>`;

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(10px)';
        setTimeout(() => toast.remove(), 300);
    }, 3500);
}
