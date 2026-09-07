/**
 * StockFlow Warehouse Management & Setup Script
 * Handles real-time telemetry calculations, presets, dynamic zone configuration,
 * interactive table searching/filtering, IoT modal telemetry, edit mode, decommission workflow,
 * and dropdown sidebar actions.
 */

// Preset Data Store
const PRESETS = {
    'mega-dc': {
        name: 'Dallas Super-Grid Logistics Center',
        code: 'WH-DFW-01',
        type: 'Distribution Center',
        status: 'Active & Operational',
        address: '10400 Trade Corridor Expressway',
        city: 'Dallas',
        state: 'TX',
        zip: '75261',
        country: 'United States',
        zone: 'Southwest Hub • I-35 / I-20 Freight Corridor',
        area: 140000,
        pallets: 11500,
        docks: 24,
        clearHeight: 40,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Sarah Jenkins',
        email: 's.jenkins@stockflow.io',
        phone: '+1 (214) 555-8941',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 11500,
        hazmat: true,
        rfid: true,
        customs: false,
        iot: true,
        notes: 'Automated conveyor sorting and AGV pallet shuttles integrated.'
    },
    'cold-pharma': {
        name: 'Atlantic BioCold Storage Center',
        code: 'WH-BOS-09',
        type: 'Cold Storage & Reefer',
        status: 'Active & Operational',
        address: '220 Seaport Marine Parkway',
        city: 'Boston',
        state: 'MA',
        zip: '02210',
        country: 'United States',
        zone: 'Northeast Bio Corridor • Port of Boston',
        area: 65000,
        pallets: 4800,
        docks: 10,
        clearHeight: 32,
        climate: 'Chilled Refrigeration (2°C - 8°C)',
        manager: 'Dr. Evelyn Vance',
        email: 'e.vance@stockflow.io',
        phone: '+1 (617) 555-0322',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 4800,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Continuous dual-redundant temperature telemetry for FDA Title 21 compliance.'
    },
    'micro-urban': {
        name: 'Manhattan Instant Micro-Hub',
        code: 'WH-NYC-07',
        type: 'Micro-Fulfillment Center',
        status: 'Active & Operational',
        address: '530 West 28th Street',
        city: 'New York',
        state: 'NY',
        zip: '10001',
        country: 'United States',
        zone: 'Tri-State Metro High-Velocity Route',
        area: 28000,
        pallets: 1800,
        docks: 4,
        clearHeight: 24,
        climate: 'Air-Conditioned Precision (18°C - 22°C)',
        manager: 'Liam O\'Connor',
        email: 'l.oconnor@stockflow.io',
        phone: '+1 (212) 555-9011',
        shifts: '2 Shifts (16 Hours/Day)',
        bays: 1800,
        hazmat: false,
        rfid: true,
        customs: false,
        iot: true,
        notes: 'Dedicated 30-minute hyper-local delivery staging bays.'
    },
    'bonded-port': {
        name: 'Long Beach Gateway Bonded Wharf',
        code: 'WH-LGB-02',
        type: 'Bonded Customs Warehouse',
        status: 'In Setup / Pre-Launch',
        address: '1150 Pier F Avenue',
        city: 'Long Beach',
        state: 'CA',
        zip: '90802',
        country: 'United States',
        zone: 'Pacific Rim Maritime Gateway',
        area: 95000,
        pallets: 7200,
        docks: 18,
        clearHeight: 36,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'David Kim',
        email: 'd.kim@stockflow.io',
        phone: '+1 (562) 555-7733',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 7200,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Direct container rail spur access and bonded customs quarantine enclosure.'
    }
};

// Connected Facilities Initial Data Store
let warehouses = [
    {
        id: 'wh-1',
        name: 'Central Logistics Hub',
        code: 'WH-CHI-01',
        type: 'Distribution Center',
        address: '7420 North Port Boulevard',
        city: 'Chicago',
        state: 'IL',
        zip: '60666',
        country: 'United States',
        zone: 'Midwest Freight Hub • I-90',
        area: 110000,
        pallets: 8500,
        docks: 16,
        clearHeight: 36,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Marcus Rivera',
        email: 'm.rivera@stockflow.io',
        phone: '+1 (312) 555-0199',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 8500,
        hazmat: true,
        rfid: true,
        customs: false,
        iot: true,
        notes: 'Primary Midwest automated cross-dock hub.',
        status: 'Active & Operational',
        temp: '20.4 °C',
        humidity: '42.8 %',
        occupancy: '74.2 %'
    },
    {
        id: 'wh-2',
        name: 'East Coast Logistics Center',
        code: 'WH-NJ-02',
        type: 'Regional Fulfillment Center',
        address: '150 Industrial Parkway',
        city: 'Newark',
        state: 'NJ',
        zip: '07114',
        country: 'United States',
        zone: 'I-95 Northeast Freight Corridor',
        area: 75000,
        pallets: 5400,
        docks: 12,
        clearHeight: 32,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Sarah Jenkins',
        email: 's.jenkins@stockflow.io',
        phone: '+1 (201) 555-3344',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 5400,
        hazmat: true,
        rfid: true,
        customs: false,
        iot: true,
        notes: 'High-velocity e-commerce direct dispatch center.',
        status: 'Active & Operational',
        temp: '19.8 °C',
        humidity: '45.1 %',
        occupancy: '81.0 %'
    },
    {
        id: 'wh-3',
        name: 'West Coast Gateway Hub',
        code: 'WH-LAX-03',
        type: 'Micro-Fulfillment Center',
        address: '420 Pacific Ocean Way',
        city: 'Long Beach',
        state: 'CA',
        zip: '90802',
        country: 'United States',
        zone: 'Southern California Port Gateway',
        area: 60000,
        pallets: 4200,
        docks: 8,
        clearHeight: 28,
        climate: 'Air-Conditioned Precision (18°C - 22°C)',
        manager: 'David Kim',
        email: 'd.kim@stockflow.io',
        phone: '+1 (562) 555-9011',
        shifts: '2 Shifts (16 Hours/Day)',
        bays: 4200,
        hazmat: false,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Dedicated import deconsolidation facility.',
        status: 'Active & Operational',
        temp: '22.1 °C',
        humidity: '39.4 %',
        occupancy: '68.5 %'
    }
];

let currentFilter = 'all';
let activeModalWh = null;
let editingWarehouseId = null;

// Toggle Sidebar Dropdown
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

// Handle Dropdown Navigation Action
function handleNavAction(action, e) {
    if (e) e.preventDefault();

    // Mark active in dropdown
    document.querySelectorAll('.dash-dropdown-item').forEach(el => el.classList.remove('active'));
    const clickedItem = document.getElementById('navAction-' + action);
    if (clickedItem) clickedItem.classList.add('active');

    switch (action) {
        case 'create':
            cancelEditWarehouse(false);
            resetWarehouseForm();
            if (e) {
                const formCard = document.querySelector('.wh-card');
                if (formCard) {
                    formCard.scrollIntoView({ behavior: 'smooth' });
                    document.getElementById('whName')?.focus();
                }
            }
            showToast('Ready to provision a new warehouse facility.', 'info');
            break;

        case 'show':
            const tableSec = document.getElementById('existingWarehousesSection');
            if (tableSec) {
                tableSec.scrollIntoView({ behavior: 'smooth' });
                const searchInput = document.getElementById('tableSearchInput');
                if (searchInput) searchInput.focus();
                showToast('Showing connected warehouse hubs (' + warehouses.length + ').', 'info');
            } else {
                showToast('Connected warehouse hubs (' + warehouses.length + ' active) will be displayed on the dedicated fleet analytics page.', 'info');
            }
            break;

        case 'update':
            // Open update mode for the first warehouse or open selector
            if (warehouses.length > 0) {
                startEditWarehouse(warehouses[0].id);
            } else {
                showToast('No warehouses available to update. Create one first.', 'warning');
            }
            break;

        case 'decommission':
            openDecommissionModal();
            break;
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

// Toast Notifications
function showToast(message, type = 'success') {
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

// Apply Preset Template
function applyPreset(key) {
    const data = PRESETS[key];
    if (!data) return;

    document.getElementById('whName').value = data.name;
    document.getElementById('whCode').value = data.code;
    document.getElementById('whType').value = data.type;
    document.getElementById('whStatus').value = data.status;
    document.getElementById('whAddress').value = data.address;
    document.getElementById('whCity').value = data.city;
    document.getElementById('whState').value = data.state;
    document.getElementById('whZip').value = data.zip;
    document.getElementById('whCountry').value = data.country;
    document.getElementById('whZone').value = data.zone;
    document.getElementById('whArea').value = data.area;
    document.getElementById('whPallets').value = data.pallets;
    document.getElementById('whDocks').value = data.docks;
    document.getElementById('whClearHeight').value = data.clearHeight;
    document.getElementById('whClimate').value = data.climate;
    document.getElementById('whManager').value = data.manager;
    document.getElementById('whEmail').value = data.email;
    document.getElementById('whPhone').value = data.phone;
    document.getElementById('whShifts').value = data.shifts;
    document.getElementById('whBays').value = data.bays;
    document.getElementById('whNotes').value = data.notes;

    document.getElementById('checkHazmat').checked = data.hazmat;
    toggleCardStyle('toggleHazmat', document.getElementById('checkHazmat'));

    document.getElementById('checkRFID').checked = data.rfid;
    toggleCardStyle('toggleRFID', document.getElementById('checkRFID'));

    document.getElementById('checkCustoms').checked = data.customs;
    toggleCardStyle('toggleCustoms', document.getElementById('checkCustoms'));

    document.getElementById('checkIoT').checked = data.iot;
    toggleCardStyle('toggleIoT', document.getElementById('checkIoT'));

    updatePreview();
    showToast('Applied preset configuration: ' + data.name, 'info');
}

// Toggle Card Checked Visual Style
function toggleCardStyle(cardId, checkbox) {
    const card = document.getElementById(cardId);
    if (!card) return;
    if (checkbox.checked) {
        card.classList.add('active');
    } else {
        card.classList.remove('active');
    }
}

// Zone List Management
function addCustomZone() {
    const container = document.getElementById('zoneListContainer');
    if (!container) return;

    const count = container.children.length + 1;
    const letter = String.fromCharCode(64 + count);
    const div = document.createElement('div');
    div.className = 'zone-item';
    div.innerHTML = `
        <input type="text" class="form-input zone-name-input" value="Zone ${letter}: Specialized Section" placeholder="Zone Name">
        <input type="text" class="form-input zone-type-input" value="Standard High-Bay Racking" placeholder="Zone Type">
        <input type="number" class="form-input zone-cap-input" value="1500" placeholder="Pallet Cap" oninput="updatePreview()">
        <button type="button" class="btn-zone-del" onclick="removeZone(this)" title="Delete Zone"><i class="fa-solid fa-xmark"></i></button>
    `;
    container.appendChild(div);
    updatePreview();
}

function removeZone(btn) {
    const container = document.getElementById('zoneListContainer');
    if (container.children.length <= 1) {
        showToast('Facility must have at least one active storage partition.', 'warning');
        return;
    }
    btn.parentElement.remove();
    updatePreview();
}

// Real-time Preview Synchronization & Calculations
function updatePreview() {
    const name = document.getElementById('whName')?.value || 'New Logistics Facility';
    const code = document.getElementById('whCode')?.value || 'WH-NODE-XX';
    const type = document.getElementById('whType')?.value || 'Regional Fulfillment Center';
    const city = document.getElementById('whCity')?.value || 'Location Pending';
    const state = document.getElementById('whState')?.value || '';
    const country = document.getElementById('whCountry')?.value || 'United States';
    const area = parseFloat(document.getElementById('whArea')?.value) || 0;
    const pallets = parseFloat(document.getElementById('whPallets')?.value) || 0;
    const docks = parseFloat(document.getElementById('whDocks')?.value) || 0;
    const height = parseFloat(document.getElementById('whClearHeight')?.value) || 30;
    const manager = document.getElementById('whManager')?.value || 'Pending Assignment';
    const climate = document.getElementById('whClimate')?.value || 'Standard Ambient (15°C - 25°C)';
    const zone = document.getElementById('whZone')?.value || 'Regional Gateway Corridor';
    const status = document.getElementById('whStatus')?.value || 'Active & Operational';

    // Update Text Elements
    if (document.getElementById('prevName')) document.getElementById('prevName').textContent = name;
    if (document.getElementById('prevCode')) document.getElementById('prevCode').textContent = code;
    if (document.getElementById('prevType')) document.getElementById('prevType').textContent = type;
    if (document.getElementById('prevLocation')) {
        document.getElementById('prevLocation').textContent = city + (state ? ', ' + state : '') + ' (' + (country === 'United States' ? 'USA' : country) + ')';
    }
    if (document.getElementById('prevArea')) document.getElementById('prevArea').textContent = area.toLocaleString() + ' sq ft';
    if (document.getElementById('prevPallets')) document.getElementById('prevPallets').textContent = pallets.toLocaleString() + ' Pallets';
    if (document.getElementById('prevDocks')) document.getElementById('prevDocks').textContent = docks + ' Docks';
    if (document.getElementById('prevManager')) document.getElementById('prevManager').textContent = manager;
    if (document.getElementById('prevClimate')) document.getElementById('prevClimate').textContent = climate;
    if (document.getElementById('prevCorridor')) document.getElementById('prevCorridor').textContent = zone;

    // Status Badge
    const prevStatus = document.getElementById('prevStatus');
    if (prevStatus) {
        prevStatus.textContent = status;
        if (status.includes('Active')) {
            prevStatus.className = 'badge badge-success';
        } else if (status.includes('Setup') || status.includes('Pre-Launch')) {
            prevStatus.className = 'badge badge-warning';
        } else {
            prevStatus.className = 'badge badge-primary';
        }
    }

    // Mathematical Telemetry Calculations
    // 1. Cubic Volume (Area * Clear Height)
    const cubicVolume = (area * height) / 1000000;
    const cubicElem = document.getElementById('calcCubicVol');
    if (cubicElem) {
        cubicElem.textContent = cubicVolume > 0 ? (cubicVolume.toFixed(2) + 'M ft³') : '--';
    }

    // 2. Pallet Density per 1,000 sq ft
    const density = area > 0 ? ((pallets / area) * 1000).toFixed(1) : 0;
    const densityElem = document.getElementById('calcDensity');
    if (densityElem) {
        densityElem.textContent = density > 0 ? (density + ' / kft²') : '--';
    }

    // 3. Peak Dock Throughput (Docks * 24 pallets/hour avg)
    const throughput = docks * 24;
    const tpElem = document.getElementById('calcThroughput');
    if (tpElem) {
        tpElem.textContent = throughput > 0 ? (throughput + ' Plts/hr') : '--';
    }

    // 4. Zone Count
    const zoneCount = document.getElementById('zoneListContainer')?.children.length || 0;
    const zoneElem = document.getElementById('calcZoneCount');
    if (zoneElem) {
        zoneElem.textContent = zoneCount + (zoneCount === 1 ? ' Zone' : ' Zones');
    }
}

// Reset Warehouse Form
function resetWarehouseForm() {
    document.getElementById('newWarehouseForm')?.reset();
    editingWarehouseId = null;

    const banner = document.getElementById('editModeBanner');
    if (banner) banner.classList.remove('active');

    const submitBtn = document.getElementById('submitWarehouseBtn');
    if (submitBtn) {
        submitBtn.innerHTML = '<i class="fa-solid fa-plus-circle"></i> Commission Facility';
    }

    updatePreview();
}

// Start Edit Warehouse
function startEditWarehouse(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;

    editingWarehouseId = id;

    document.getElementById('whName').value = wh.name;
    document.getElementById('whCode').value = wh.code;
    document.getElementById('whType').value = wh.type;
    document.getElementById('whStatus').value = wh.status;
    document.getElementById('whAddress').value = wh.address;
    document.getElementById('whCity').value = wh.city;
    document.getElementById('whState').value = wh.state;
    document.getElementById('whZip').value = wh.zip;
    document.getElementById('whCountry').value = wh.country;
    document.getElementById('whZone').value = wh.zone;
    document.getElementById('whArea').value = wh.area;
    document.getElementById('whPallets').value = wh.pallets;
    document.getElementById('whDocks').value = wh.docks;
    document.getElementById('whClearHeight').value = wh.clearHeight;
    document.getElementById('whClimate').value = wh.climate;
    document.getElementById('whManager').value = wh.manager;
    document.getElementById('whEmail').value = wh.email;
    document.getElementById('whPhone').value = wh.phone;
    document.getElementById('whShifts').value = wh.shifts;
    document.getElementById('whBays').value = wh.bays;
    document.getElementById('whNotes').value = wh.notes || '';

    document.getElementById('checkHazmat').checked = !!wh.hazmat;
    toggleCardStyle('toggleHazmat', document.getElementById('checkHazmat'));

    document.getElementById('checkRFID').checked = !!wh.rfid;
    toggleCardStyle('toggleRFID', document.getElementById('checkRFID'));

    document.getElementById('checkCustoms').checked = !!wh.customs;
    toggleCardStyle('toggleCustoms', document.getElementById('checkCustoms'));

    document.getElementById('checkIoT').checked = !!wh.iot;
    toggleCardStyle('toggleIoT', document.getElementById('checkIoT'));

    // Update banner
    const banner = document.getElementById('editModeBanner');
    if (banner) {
        banner.classList.add('active');
        document.getElementById('editingWarehouseName').textContent = wh.name;
        document.getElementById('editingWarehouseCode').textContent = wh.code;
    }

    const submitBtn = document.getElementById('submitWarehouseBtn');
    if (submitBtn) {
        submitBtn.innerHTML = '<i class="fa-solid fa-pen-to-square"></i> Save Facility Updates';
    }

    updatePreview();

    const formCard = document.querySelector('.wh-card');
    if (formCard) formCard.scrollIntoView({ behavior: 'smooth' });

    showToast('Editing configuration for ' + wh.name, 'info');
}

function cancelEditWarehouse(notify = true) {
    resetWarehouseForm();
    if (notify) showToast('Cleared facility configuration form.', 'info');
}

function saveAsDraft() {
    showToast('Facility configuration draft saved locally.', 'success');
}

// Form Submit Handler
function handleWarehouseSubmit(e) {
    e.preventDefault();

    const name = document.getElementById('whName').value.trim();
    const code = document.getElementById('whCode').value.trim();
    const type = document.getElementById('whType').value;
    const status = document.getElementById('whStatus').value;
    const address = document.getElementById('whAddress').value.trim();
    const city = document.getElementById('whCity').value.trim();
    const state = document.getElementById('whState').value.trim();
    const zip = document.getElementById('whZip').value.trim();
    const country = document.getElementById('whCountry').value;
    const zone = document.getElementById('whZone').value.trim();
    const area = parseFloat(document.getElementById('whArea').value) || 0;
    const pallets = parseFloat(document.getElementById('whPallets').value) || 0;
    const docks = parseFloat(document.getElementById('whDocks').value) || 0;
    const clearHeight = parseFloat(document.getElementById('whClearHeight').value) || 30;
    const climate = document.getElementById('whClimate').value;
    const manager = document.getElementById('whManager').value.trim();
    const email = document.getElementById('whEmail').value.trim();
    const phone = document.getElementById('whPhone').value.trim();
    const shifts = document.getElementById('whShifts').value;
    const bays = parseFloat(document.getElementById('whBays').value) || pallets;
    const hazmat = document.getElementById('checkHazmat').checked;
    const rfid = document.getElementById('checkRFID').checked;
    const customs = document.getElementById('checkCustoms').checked;
    const iot = document.getElementById('checkIoT').checked;
    const notes = document.getElementById('whNotes').value.trim();

    if (editingWarehouseId) {
        // Update existing
        const idx = warehouses.findIndex(w => w.id === editingWarehouseId);
        if (idx !== -1) {
            warehouses[idx] = {
                ...warehouses[idx],
                name,
                code,
                type,
                status,
                address,
                city,
                state,
                zip,
                country,
                zone,
                area,
                pallets,
                docks,
                clearHeight,
                climate,
                manager,
                email,
                phone,
                shifts,
                bays,
                hazmat,
                rfid,
                customs,
                iot,
                notes
            };
        }
        showToast('Facility "' + name + '" successfully updated!', 'success');
        resetWarehouseForm();
    } else {
        // Create new
        const newWh = {
            id: 'wh-' + Date.now(),
            name,
            code,
            type,
            status,
            address,
            city,
            state,
            zip,
            country,
            zone,
            area,
            pallets,
            docks,
            clearHeight,
            climate,
            manager,
            email,
            phone,
            shifts,
            bays,
            hazmat,
            rfid,
            customs,
            iot,
            notes,
            temp: '21.0 °C',
            humidity: '41.5 %',
            occupancy: '100.0 % Avail'
        };

        warehouses.unshift(newWh);
        showToast('Warehouse "' + name + '" successfully registered & synced!', 'success');
        resetWarehouseForm();
    }

    renderWarehousesTable();
    updateTopStats();
    updatePreview();

    const existingSec = document.getElementById('existingWarehousesSection');
    if (existingSec) {
        existingSec.scrollIntoView({ behavior: 'smooth' });
    }
}

// Render Warehouses Table
function renderWarehousesTable() {
    const tbody = document.getElementById('warehousesTableBody');
    if (!tbody) return;
    tbody.innerHTML = '';

    const searchTerm = (document.getElementById('tableSearchInput')?.value || '').toLowerCase().trim();

    const filtered = warehouses.filter(wh => {
        const matchesSearch = wh.name.toLowerCase().includes(searchTerm) ||
                              wh.code.toLowerCase().includes(searchTerm) ||
                              wh.city.toLowerCase().includes(searchTerm) ||
                              wh.type.toLowerCase().includes(searchTerm);

        if (!matchesSearch) return false;

        if (currentFilter === 'operational') {
            return wh.status.includes('Active') || wh.status.includes('Operational');
        } else if (currentFilter === 'pre-launch') {
            return wh.status.includes('Setup') || wh.status.includes('Pre-Launch') || wh.status.includes('Maintenance');
        }
        return true;
    });

    filtered.forEach(wh => {
        const tr = document.createElement('tr');
        const isOp = wh.status.includes('Active') || wh.status.includes('Operational');
        const statusBadge = isOp ? '<span class="badge badge-success" style="padding: 2px 8px; font-size: 0.72rem;">Operational</span>'
                                 : '<span class="badge badge-warning" style="padding: 2px 8px; font-size: 0.72rem;">Pre-Launch</span>';

        tr.innerHTML = `
            <td>
                <div style="font-weight: 700; color: #f8fafc;">${wh.name}</div>
                <div style="font-size: 0.75rem; color: var(--text-dim);"><code style="font-family: 'JetBrains Mono', monospace;">${wh.code}</code></div>
            </td>
            <td>${wh.type}</td>
            <td>${wh.city}, ${wh.state} (${wh.country === 'United States' ? 'USA' : wh.country})</td>
            <td style="font-weight: 600;">${wh.area.toLocaleString()} sq ft</td>
            <td style="font-weight: 600; color: #f8fafc;">${wh.pallets.toLocaleString()} Pallets</td>
            <td>${wh.manager}</td>
            <td>${statusBadge}</td>
            <td style="text-align: right;">
                <div style="display: inline-flex; gap: 6px;">
                    <button type="button" class="btn btn-outline btn-sm" style="padding: 4px 8px; font-size: 0.75rem; color: #818cf8; border-color: rgba(129, 140, 248, 0.3);" onclick="startEditWarehouse('${wh.id}')" title="Update facility">
                        <i class="fa-solid fa-pen-to-square"></i>
                    </button>
                    <button type="button" class="btn btn-outline btn-sm" style="padding: 4px 10px; font-size: 0.75rem;" onclick="openTelemetryModal('${wh.id}')">
                        <i class="fa-solid fa-satellite-dish" style="color: #38bdf8;"></i> Telemetry
                    </button>
                    <button type="button" class="btn btn-outline btn-sm" style="padding: 4px 8px; font-size: 0.75rem; color: #ef4444; border-color: rgba(239, 68, 68, 0.2);" onclick="deleteWarehouse('${wh.id}')" title="Decommission">
                        <i class="fa-solid fa-trash-can"></i>
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(tr);
    });

    const countElem = document.getElementById('tableCount');
    if (countElem) countElem.textContent = warehouses.length;
    const navElem = document.getElementById('navWhCount');
    if (navElem) navElem.textContent = warehouses.length;
}

function filterWarehouseTable() {
    renderWarehousesTable();
}

function setTableFilter(filter, btn) {
    currentFilter = filter;
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    renderWarehousesTable();
}

function updateTopStats() {
    const totalCountElem = document.getElementById('statTotalCount');
    if (totalCountElem) totalCountElem.textContent = warehouses.length + ' Hubs';
    
    let totalArea = warehouses.reduce((sum, w) => sum + w.area, 0);
    let totalPallets = warehouses.reduce((sum, w) => sum + w.pallets, 0);
    
    const areaElem = document.getElementById('statTotalArea');
    if (areaElem) areaElem.textContent = totalArea.toLocaleString() + ' sq ft';
    
    const palletElem = document.getElementById('statTotalPallets');
    if (palletElem) palletElem.textContent = totalPallets.toLocaleString();
}

function deleteWarehouse(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;
    if (confirm('Are you sure you want to decommission facility: ' + wh.name + ' (' + wh.code + ')?')) {
        warehouses = warehouses.filter(w => w.id !== id);
        if (editingWarehouseId === id) cancelEditWarehouse(false);
        renderWarehousesTable();
        updateTopStats();
        showToast('Decommissioned facility ' + wh.name, 'info');
    }
}

// Decommission Modal & Workflow
function openDecommissionModal() {
    const list = document.getElementById('decommissionList');
    if (list) {
        list.innerHTML = '';
        if (warehouses.length === 0) {
            list.innerHTML = '<p style="font-size: 0.85rem; color: var(--text-dim); text-align: center; padding: 20px;">No connected facilities available to decommission.</p>';
        } else {
            warehouses.forEach(wh => {
                const item = document.createElement('div');
                item.className = 'decom-item';
                item.innerHTML = `
                    <div>
                        <div style="font-weight: 700; color: #f8fafc; font-size: 0.9rem;">${wh.name}</div>
                        <div style="font-size: 0.75rem; color: var(--text-dim);"><code>${wh.code}</code> &bull; ${wh.city}, ${wh.state} &bull; ${wh.area.toLocaleString()} sq ft</div>
                    </div>
                    <button type="button" class="btn btn-outline btn-sm" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.4); font-size: 0.78rem;" onclick="confirmDecommission('${wh.id}')">
                        <i class="fa-solid fa-trash-can"></i> Decommission
                    </button>
                `;
                list.appendChild(item);
            });
        }
    }
    const modal = document.getElementById('decommissionModal');
    if (modal) modal.classList.add('active');
}

function closeDecommissionModal() {
    const modal = document.getElementById('decommissionModal');
    if (modal) modal.classList.remove('active');
}

function confirmDecommission(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;
    if (confirm('Permanently decommission facility: ' + wh.name + ' (' + wh.code + ')? All live inventory routing through this location will be suspended.')) {
        warehouses = warehouses.filter(w => w.id !== id);
        if (editingWarehouseId === id) cancelEditWarehouse(false);
        renderWarehousesTable();
        updateTopStats();
        openDecommissionModal(); // Refresh modal list
        showToast('Decommissioned facility ' + wh.name, 'info');
    }
}

// Live Telemetry Modal
function openTelemetryModal(id) {
    const wh = warehouses.find(w => w.id === id) || warehouses[0];
    activeModalWh = wh;
    document.getElementById('modalFacilityTitle').textContent = wh.name;
    document.getElementById('sensorTemp').textContent = wh.temp || '20.4 °C';
    document.getElementById('sensorHumidity').textContent = wh.humidity || '42.8 %';
    document.getElementById('sensorOccupancy').textContent = wh.occupancy || '74.2 %';
    document.getElementById('sensorDocks').textContent = (wh.docks ? Math.floor(wh.docks * 0.4) : '6') + ' / ' + (wh.docks || 14) + ' In Use';

    const modal = document.getElementById('telemetryModal');
    if (modal) modal.classList.add('active');
}

function closeTelemetryModal() {
    const modal = document.getElementById('telemetryModal');
    if (modal) modal.classList.remove('active');
}

function refreshSensorData() {
    if (!activeModalWh) return;
    const newTemp = (19.5 + Math.random() * 3).toFixed(1) + ' °C';
    const newHum = (40 + Math.random() * 8).toFixed(1) + ' %';
    document.getElementById('sensorTemp').textContent = newTemp;
    document.getElementById('sensorHumidity').textContent = newHum;

    const timeStr = new Date().toTimeString().split(' ')[0];
    const logStream = document.getElementById('sensorLogStream');
    if (logStream) {
        logStream.innerHTML = `[${timeStr}] Active Edge Sensor Refresh • Temp: ${newTemp}, Humidity: ${newHum}<br>` + logStream.innerHTML;
    }

    showToast('Sensors refreshed for ' + activeModalWh.name, 'info');
}

// Export Functionality (JSON & CSV)
function exportWarehouseData(format) {
    let content = '';
    let mimeType = '';
    let filename = 'stockflow-warehouses-' + Date.now();

    if (format === 'json') {
        content = JSON.stringify(warehouses, null, 2);
        mimeType = 'application/json';
        filename += '.json';
    } else {
        const headers = ['ID', 'Name', 'Code', 'Classification', 'City', 'State', 'Country', 'Area_SqFt', 'Pallet_Positions', 'Loading_Docks', 'Manager', 'Status'];
        const rows = warehouses.map(w => [
            w.id, `"${w.name}"`, w.code, `"${w.type}"`, `"${w.city}"`, w.state, `"${w.country}"`, w.area, w.pallets, w.docks, `"${w.manager}"`, `"${w.status}"`
        ]);
        content = headers.join(',') + '\n' + rows.map(r => r.join(',')).join('\n');
        mimeType = 'text/csv';
        filename += '.csv';
    }

    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    showToast('Exported connected facilities as ' + format.toUpperCase(), 'success');
}

// Check URL Params for Action Routing
function handleUrlParams() {
    const params = new URLSearchParams(window.location.search);
    const action = params.get('action');
    if (action) {
        // Expand dropdown
        const dropdown = document.getElementById('warehouseNavDropdown');
        if (dropdown) {
            dropdown.classList.add('open');
            const menu = dropdown.querySelector('.dash-dropdown-menu');
            if (menu) menu.classList.add('show');
            const btn = dropdown.querySelector('.dash-dropdown-toggle');
            if (btn) btn.setAttribute('aria-expanded', 'true');
        }
        setTimeout(() => {
            handleNavAction(action);
        }, 150);
    }
}

// Initialize on DOM Ready
document.addEventListener('DOMContentLoaded', () => {
    renderWarehousesTable();
    updateTopStats();
    updatePreview();
    handleUrlParams();
});
