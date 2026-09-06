document.addEventListener('DOMContentLoaded', () => {
    // 1. Navbar Scroll Effect
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 20) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 2. Mobile Menu Toggle
    const mobileToggle = document.getElementById('mobileToggle');
    const mobileNav = document.getElementById('mobileNav');
    if (mobileToggle && mobileNav) {
        mobileToggle.addEventListener('click', () => {
            mobileNav.classList.toggle('active');
            const icon = mobileToggle.querySelector('i');
            if (icon) {
                icon.classList.toggle('fa-bars');
                icon.classList.toggle('fa-xmark');
            }
        });
        
        // Close menu on link click
        mobileNav.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                mobileNav.classList.remove('active');
            });
        });
    }

    // 3. Pricing Toggle (Monthly vs Annual)
    const billingToggle = document.getElementById('billingToggle');
    const priceAmounts = document.querySelectorAll('.price-amount');
    const pricePeriods = document.querySelectorAll('.price-period');

    const pricingData = {
        monthly: [49, 129, 299],
        annual: [39, 99, 239]
    };

    if (billingToggle) {
        billingToggle.addEventListener('change', () => {
            const isAnnual = billingToggle.checked;
            priceAmounts.forEach((el, index) => {
                const targetPrice = isAnnual ? pricingData.annual[index] : pricingData.monthly[index];
                if (targetPrice !== undefined) {
                    el.textContent = targetPrice;
                }
            });
            pricePeriods.forEach(el => {
                el.textContent = isAnnual ? '/month, billed annually' : '/month';
            });
        });
    }

    // 4. FAQ Accordion
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        const questionBtn = item.querySelector('.faq-question');
        questionBtn.addEventListener('click', () => {
            const isActive = item.classList.contains('active');
            faqItems.forEach(otherItem => otherItem.classList.remove('active'));
            if (!isActive) {
                item.classList.add('active');
            }
        });
    });

    // 5. Simulated Live Activity Toasts
    const simulatedActivities = [
        { icon: 'fa-boxes-stacked', text: 'Auto-reorder PO #4892 triggered for Warehouse Central' },
        { icon: 'fa-barcode', text: '1,420 items scanned & verified at Bay 4' },
        { icon: 'fa-truck-fast', text: 'Dispatched 52 Amazon & Shopify orders seamlessly' },
        { icon: 'fa-chart-line', text: 'Inventory accuracy reached 99.94% today' }
    ];

    let toastIndex = 0;
    const showToast = () => {
        const container = document.querySelector('.toast-container');
        if (!container) return;

        const current = simulatedActivities[toastIndex];
        toastIndex = (toastIndex + 1) % simulatedActivities.length;

        const toast = document.createElement('div');
        toast.className = 'toast';
        toast.innerHTML = `<i class="fa-solid ${current.icon}" style="color: #38bdf8;"></i><span>${current.text}</span>`;
        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(10px)';
            toast.style.transition = 'all 0.4s ease';
            setTimeout(() => toast.remove(), 400);
        }, 4500);
    };

    // Trigger toast periodically
    setTimeout(showToast, 3000);
    setInterval(showToast, 8000);

    // 6. Smooth anchor scroll offset handling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                e.preventDefault();
                const offset = 80;
                const bodyRect = document.body.getBoundingClientRect().top;
                const elementRect = targetElement.getBoundingClientRect().top;
                const elementPosition = elementRect - bodyRect;
                const offsetPosition = elementPosition - offset;

                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
});
