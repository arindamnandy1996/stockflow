/**
 * StockFlow Show Warehouses Script
 * Implements cascading filtering (Country -> State -> City), keyword search,
 * status & classification filtering, view toggling (table/grid),
 * view details modal with live telemetry, inline editing modal,
 * and decommissioning workflow with localStorage persistence.
 */

// Key for shared localStorage persistence across pages
const STORAGE_KEY = 'stockflow_warehouses';

// Initial Master Dataset across multiple countries, states, and cities
const DEFAULT_WAREHOUSES = [
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
        zone: 'Midwest Freight Hub • I-90 / I-294 Corridor',
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
        notes: 'Primary Midwest automated cross-dock hub and high-velocity parcel staging.',
        status: 'Active & Operational',
        temp: '20.4 °C',
        humidity: '42.8 %',
        occupancy: '74.2 %',
        zones: [
            { name: 'Zone A: High Velocity Pallets', type: 'Heavy Racking (Pallet-In Pallet-Out)', cap: 4500 },
            { name: 'Zone B: Case & Tote Pick Module', type: 'Mezzanine Shelving & Bins', cap: 2800 },
            { name: 'Zone C: Secure Vault / High-Value', type: 'Biometric Enclosed Caging', cap: 1200 }
        ]
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
        notes: 'High-velocity e-commerce direct dispatch center for Tri-State area.',
        status: 'Active & Operational',
        temp: '19.8 °C',
        humidity: '45.1 %',
        occupancy: '81.0 %',
        zones: [
            { name: 'Zone A: Rapid Ingest & Sort', type: 'Gravity Roller Converyors', cap: 3000 },
            { name: 'Zone B: High-Density Stacking', type: 'Narrow-Aisle VNA Racking', cap: 2400 }
        ]
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
        notes: 'Dedicated import deconsolidation facility and customs clearance point.',
        status: 'Active & Operational',
        temp: '22.1 °C',
        humidity: '39.4 %',
        occupancy: '68.5 %',
        zones: [
            { name: 'Zone A: Customs Bonded Staging', type: 'Secure Tariff Hold Bay', cap: 2200 },
            { name: 'Zone B: Micro-Pick Bins', type: 'Automated Carousel Systems', cap: 2000 }
        ]
    },
    {
        id: 'wh-4',
        name: 'Lone Star Super-Grid Center',
        code: 'WH-DFW-04',
        type: 'Distribution Center',
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
        notes: 'Automated conveyor sorting and AGV pallet shuttles integrated.',
        status: 'Active & Operational',
        temp: '21.5 °C',
        humidity: '44.0 %',
        occupancy: '89.3 %',
        zones: [
            { name: 'Zone A: Bulk Pallet High-Bay', type: '40ft Automated AS/RS Racking', cap: 7500 },
            { name: 'Zone B: Fast Pick Forward Area', type: 'Flow Racks', cap: 4000 }
        ]
    },
    {
        id: 'wh-5',
        name: 'Atlantic BioCold Storage Depot',
        code: 'WH-BOS-05',
        type: 'Cold Storage & Reefer',
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
        notes: 'Continuous dual-redundant temperature telemetry for FDA Title 21 compliance.',
        status: 'Active & Operational',
        temp: '4.2 °C',
        humidity: '85.0 %',
        occupancy: '62.4 %',
        zones: [
            { name: 'Zone A: Chilled Chamber (4°C)', type: 'Cold Insulated Racks', cap: 3200 },
            { name: 'Zone B: Deep Freeze (-20°C)', type: 'Cryo Lock Partitions', cap: 1600 }
        ]
    },
    {
        id: 'wh-6',
        name: 'Great Lakes Micro-Hub',
        code: 'WH-NAP-06',
        type: 'Micro-Fulfillment Center',
        address: '1850 Diehl Road',
        city: 'Naperville',
        state: 'IL',
        zip: '60563',
        country: 'United States',
        zone: 'I-88 Tech Corridor',
        area: 32000,
        pallets: 2100,
        docks: 6,
        clearHeight: 24,
        climate: 'Air-Conditioned Precision (18°C - 22°C)',
        manager: 'Elena Rostova',
        email: 'e.rostova@stockflow.io',
        phone: '+1 (630) 555-8812',
        shifts: '2 Shifts (16 Hours/Day)',
        bays: 2100,
        hazmat: false,
        rfid: true,
        customs: false,
        iot: true,
        notes: 'Suburban quick-dispatch depot servicing Chicago western suburbs.',
        status: 'Active & Operational',
        temp: '20.1 °C',
        humidity: '41.2 %',
        occupancy: '71.0 %',
        zones: [
            { name: 'Zone A: E-Commerce Pick Lines', type: 'Gravity Bins', cap: 1500 },
            { name: 'Zone B: Returns Staging', type: 'Reverse Logistics Bay', cap: 600 }
        ]
    },
    {
        id: 'wh-7',
        name: 'Silicon Valley Cross-Dock Terminal',
        code: 'WH-SFO-07',
        type: 'Cross-Dock Terminal',
        address: '890 Logistics Way',
        city: 'San Francisco',
        state: 'CA',
        zip: '94128',
        country: 'United States',
        zone: 'Bay Area Air-Freight Express Ring',
        area: 52000,
        pallets: 3600,
        docks: 18,
        clearHeight: 30,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Michael Chen',
        email: 'm.chen@stockflow.io',
        phone: '+1 (415) 555-7634',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 3600,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'High-speed parcel sorting connected directly to SFO freight gate.',
        status: 'Active & Operational',
        temp: '19.2 °C',
        humidity: '48.6 %',
        occupancy: '79.5 %',
        zones: [
            { name: 'Zone A: Inbound Cross-Dock Staging', type: 'Rapid Flow Conveyor', cap: 2400 },
            { name: 'Zone B: Express Air Freight Hold', type: 'Secure Cage', cap: 1200 }
        ]
    },
    {
        id: 'wh-8',
        name: 'Toronto Metro Distribution Center',
        code: 'WH-YYZ-01',
        type: 'Distribution Center',
        address: '5800 Airport Road',
        city: 'Mississauga',
        state: 'ON',
        zip: 'L4V 1E8',
        country: 'Canada',
        zone: 'Greater Toronto Area Freight Core • Hwy 401',
        area: 95000,
        pallets: 7200,
        docks: 16,
        clearHeight: 34,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Claire Beauchamp',
        email: 'c.beauchamp@stockflow.ca',
        phone: '+1 (905) 555-2311',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 7200,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Major Canadian central hub with direct customs bonded inspection bays.',
        status: 'Active & Operational',
        temp: '18.9 °C',
        humidity: '43.5 %',
        occupancy: '83.0 %',
        zones: [
            { name: 'Zone A: Standard Pallet Racks', type: 'High Bay 5-Tier', cap: 5000 },
            { name: 'Zone B: Canadian Bonded Section', type: 'CBSA Certified Enclosure', cap: 2200 }
        ]
    },
    {
        id: 'wh-9',
        name: 'Pacific Northwest Vancouver Hub',
        code: 'WH-YVR-02',
        type: 'Regional Fulfillment Center',
        address: '3400 Fraser Reach Court',
        city: 'Richmond',
        state: 'BC',
        zip: 'V6V 1J5',
        country: 'Canada',
        zone: 'Port of Vancouver Maritime Route',
        area: 58000,
        pallets: 4100,
        docks: 10,
        clearHeight: 30,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Liam Gallagher',
        email: 'l.gallagher@stockflow.ca',
        phone: '+1 (604) 555-9082',
        shifts: '2 Shifts (16 Hours/Day)',
        bays: 4100,
        hazmat: false,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Transpacific import hub for Western Canadian distribution.',
        status: 'In Setup / Pre-Launch',
        temp: '17.5 °C',
        humidity: '50.2 %',
        occupancy: '20.0 %',
        zones: [
            { name: 'Zone A: Container De-Stuffing', type: 'Floor Load Staging', cap: 2500 },
            { name: 'Zone B: Western Express Picks', type: 'Shelving', cap: 1600 }
        ]
    },
    {
        id: 'wh-10',
        name: 'London Thames Gateway Depot',
        code: 'WH-LON-01',
        type: 'Regional Fulfillment Center',
        address: '12 Dolphin Way, Purfleet',
        city: 'London',
        state: 'Greater London',
        zip: 'RM19 1NZ',
        country: 'United Kingdom',
        zone: 'M25 London Orbital Freight Ring',
        area: 82000,
        pallets: 6000,
        docks: 14,
        clearHeight: 32,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Oliver Wright',
        email: 'o.wright@stockflow.co.uk',
        phone: '+44 20 7946 0912',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 6000,
        hazmat: false,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Automated sortation serving Greater London and South East England.',
        status: 'Active & Operational',
        temp: '18.4 °C',
        humidity: '52.0 %',
        occupancy: '86.4 %',
        zones: [
            { name: 'Zone A: High Density Racks', type: 'VNA Racking', cap: 4200 },
            { name: 'Zone B: London Urban Dispatch', type: 'Fast Parcel Shuttles', cap: 1800 }
        ]
    },
    {
        id: 'wh-11',
        name: 'Bavaria Central Logistics Park',
        code: 'WH-MUC-01',
        type: 'Distribution Center',
        address: 'Industriestrasse 44',
        city: 'Munich',
        state: 'Bavaria',
        zip: '80331',
        country: 'Germany',
        zone: 'Autobahn A9 Southern Central Hub',
        area: 120000,
        pallets: 9800,
        docks: 20,
        clearHeight: 38,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Hans Gruber',
        email: 'h.gruber@stockflow.de',
        phone: '+49 89 2018 4401',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 9800,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Central European automated robotics fulfillment warehouse.',
        status: 'Active & Operational',
        temp: '19.0 °C',
        humidity: '41.0 %',
        occupancy: '76.8 %',
        zones: [
            { name: 'Zone A: Automated AS/RS', type: 'KUKA Robotics Shuttles', cap: 6500 },
            { name: 'Zone B: Heavy Cargo Bay', type: 'Reinforced Floor Stacking', cap: 3300 }
        ]
    },
    {
        id: 'wh-12',
        name: 'Jurong Gateway Bonded Complex',
        code: 'WH-SIN-01',
        type: 'Bonded Customs Warehouse',
        address: '25 Jurong Port Road',
        city: 'Singapore Port',
        state: 'Central Region',
        zip: '619098',
        country: 'Singapore',
        zone: 'Singapore Maritime Free Trade Zone',
        area: 88000,
        pallets: 6800,
        docks: 16,
        clearHeight: 35,
        climate: 'Air-Conditioned Precision (18°C - 22°C)',
        manager: 'Wei Ling Tan',
        email: 'wl.tan@stockflow.sg',
        phone: '+65 6789 0122',
        shifts: '24/7 Continuous (3 Shifts)',
        bays: 6800,
        hazmat: true,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'High-security customs bonded hub with biometric access control.',
        status: 'Active & Operational',
        temp: '20.0 °C',
        humidity: '55.0 %',
        occupancy: '91.2 %',
        zones: [
            { name: 'Zone A: Bonded Free Zone Bay', type: 'Customs Enclosure', cap: 4500 },
            { name: 'Zone B: Precision Climate Electronics', type: 'Anti-Static Cleanroom', cap: 2300 }
        ]
    },
    {
        id: 'wh-13',
        name: 'Sydney Port Botany Logistics',
        code: 'WH-SYD-01',
        type: 'Distribution Center',
        address: '45 Foreshore Road',
        city: 'Sydney',
        state: 'New South Wales',
        zip: '2019',
        country: 'Australia',
        zone: 'Port Botany Freight Rail Spur',
        area: 78000,
        pallets: 5900,
        docks: 12,
        clearHeight: 32,
        climate: 'Standard Ambient (15°C - 25°C)',
        manager: 'Jack Thompson',
        email: 'j.thompson@stockflow.com.au',
        phone: '+61 2 9123 4567',
        shifts: '2 Shifts (16 Hours/Day)',
        bays: 5900,
        hazmat: false,
        rfid: true,
        customs: true,
        iot: true,
        notes: 'Primary Oceania transshipment and order fulfillment terminal.',
        status: 'Active & Operational',
        temp: '21.0 °C',
        humidity: '49.0 %',
        occupancy: '75.4 %',
        zones: [
            { name: 'Zone A: Standard Pallet Racks', type: 'Selective Racking', cap: 4000 },
            { name: 'Zone B: E-Commerce Rapid Dispatch', type: 'Pick Modules', cap: 1900 }
        ]
    }
];

// Active State
let warehouses = [];
let currentViewMode = 'table'; // 'table' or 'grid'
let activeSortField = 'name';
let activeSortAsc = true;
let selectedWhForAction = null;

/**
 * Load Warehouses from localStorage or initialize with Master Dataset
 */
function loadWarehouses() {
    try {
        const stored = localStorage.getItem(STORAGE_KEY);
        if (stored) {
            warehouses = JSON.parse(stored);
        } else {
            warehouses = JSON.parse(JSON.stringify(DEFAULT_WAREHOUSES));
            saveWarehousesToStorage();
        }
    } catch (e) {
        console.error('Failed to parse warehouses from storage:', e);
        warehouses = JSON.parse(JSON.stringify(DEFAULT_WAREHOUSES));
    }
}

/**
 * Persist current warehouses to localStorage
 */
function saveWarehousesToStorage() {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(warehouses));
    } catch (e) {
        console.error('Failed to save warehouses to storage:', e);
    }
}

/**
 * Initialize Cascading Filter Dropdowns: Country -> State -> City
 */
function initCascadingFilters() {
    const countrySelect = document.getElementById('filterCountry');
    if (!countrySelect) return;

    // Get unique sorted list of countries
    const countries = [...new Set(warehouses.map(w => w.country).filter(Boolean))].sort();

    // Preserve selection if possible
    const currentCountry = countrySelect.value || 'all';
    countrySelect.innerHTML = '<option value="all">All Countries (Global Fleet)</option>';
    countries.forEach(c => {
        const opt = document.createElement('option');
        opt.value = c;
        opt.textContent = c;
        countrySelect.appendChild(opt);
    });

    if (countries.includes(currentCountry)) {
        countrySelect.value = currentCountry;
    } else {
        countrySelect.value = 'all';
    }

    // Trigger state cascade based on current country
    updateStateFilterOptions();
}

/**
 * Handle Country Selection Change
 */
function handleCountryChange() {
    updateStateFilterOptions();
    applyFilters();
}

/**
 * Update State dropdown options based on selected Country
 */
function updateStateFilterOptions() {
    const countrySelect = document.getElementById('filterCountry');
    const stateSelect = document.getElementById('filterState');
    const citySelect = document.getElementById('filterCity');
    if (!stateSelect || !citySelect) return;

    const selectedCountry = countrySelect ? countrySelect.value : 'all';

    // Filter warehouses by country first
    let relevantWarehouses = warehouses;
    if (selectedCountry !== 'all') {
        relevantWarehouses = warehouses.filter(w => w.country === selectedCountry);
    }

    const states = [...new Set(relevantWarehouses.map(w => w.state).filter(Boolean))].sort();

    stateSelect.innerHTML = '<option value="all">All States / Provinces</option>';
    states.forEach(s => {
        const opt = document.createElement('option');
        opt.value = s;
        opt.textContent = s;
        stateSelect.appendChild(opt);
    });

    stateSelect.value = 'all';

    // Now update city options based on country + state
    updateCityFilterOptions();
}

/**
 * Handle State Selection Change
 */
function handleStateChange() {
    updateCityFilterOptions();
    applyFilters();
}

/**
 * Update City dropdown options based on selected Country & State
 */
function updateCityFilterOptions() {
    const countrySelect = document.getElementById('filterCountry');
    const stateSelect = document.getElementById('filterState');
    const citySelect = document.getElementById('filterCity');
    if (!citySelect) return;

    const selectedCountry = countrySelect ? countrySelect.value : 'all';
    const selectedState = stateSelect ? stateSelect.value : 'all';

    let relevantWarehouses = warehouses;
    if (selectedCountry !== 'all') {
        relevantWarehouses = relevantWarehouses.filter(w => w.country === selectedCountry);
    }
    if (selectedState !== 'all') {
        relevantWarehouses = relevantWarehouses.filter(w => w.state === selectedState);
    }

    const cities = [...new Set(relevantWarehouses.map(w => w.city).filter(Boolean))].sort();

    citySelect.innerHTML = '<option value="all">All Cities</option>';
    cities.forEach(c => {
        const opt = document.createElement('option');
        opt.value = c;
        opt.textContent = c;
        citySelect.appendChild(opt);
    });

    citySelect.value = 'all';
}

/**
 * Handle City Selection Change
 */
function handleCityChange() {
    applyFilters();
}

/**
 * Filter Warehouses based on Country -> State -> City, Keyword, Status, and Type
 */
function getFilteredWarehouses() {
    const selectedCountry = document.getElementById('filterCountry')?.value || 'all';
    const selectedState = document.getElementById('filterState')?.value || 'all';
    const selectedCity = document.getElementById('filterCity')?.value || 'all';
    const selectedType = document.getElementById('filterType')?.value || 'all';
    const selectedStatus = document.getElementById('filterStatus')?.value || 'all';
    const keyword = (document.getElementById('filterKeyword')?.value || '').toLowerCase().trim();

    return warehouses.filter(wh => {
        // Country filter
        if (selectedCountry !== 'all' && wh.country !== selectedCountry) {
            return false;
        }

        // State filter
        if (selectedState !== 'all' && wh.state !== selectedState) {
            return false;
        }

        // City filter
        if (selectedCity !== 'all' && wh.city !== selectedCity) {
            return false;
        }

        // Classification Type filter
        if (selectedType !== 'all' && wh.type !== selectedType) {
            return false;
        }

        // Status filter
        if (selectedStatus !== 'all') {
            if (selectedStatus === 'Operational' && !(wh.status.includes('Active') || wh.status.includes('Operational'))) {
                return false;
            }
            if (selectedStatus === 'Setup' && !(wh.status.includes('Setup') || wh.status.includes('Pre-Launch'))) {
                return false;
            }
            if (selectedStatus === 'Maintenance' && !wh.status.includes('Maintenance')) {
                return false;
            }
            if (selectedStatus === 'Decommissioned' && !wh.status.includes('Decommissioned')) {
                return false;
            }
        }

        // Keyword search (name, code, manager, city, state, country, address, zone)
        if (keyword) {
            const searchable = [
                wh.name,
                wh.code,
                wh.type,
                wh.city,
                wh.state,
                wh.country,
                wh.address,
                wh.zone,
                wh.manager,
                wh.notes
            ].join(' ').toLowerCase();

            if (!searchable.includes(keyword)) {
                return false;
            }
        }

        return true;
    });
}

/**
 * Apply Filters and Re-render Views + KPI summaries + Active Chips
 */
function applyFilters() {
    const filtered = getFilteredWarehouses();

    // Sort filtered results
    filtered.sort((a, b) => {
        let valA = a[activeSortField];
        let valB = b[activeSortField];

        if (typeof valA === 'string') {
            valA = valA.toLowerCase();
            valB = (valB || '').toLowerCase();
        }

        if (valA < valB) return activeSortAsc ? -1 : 1;
        if (valA > valB) return activeSortAsc ? 1 : -1;
        return 0;
    });

    renderTableView(filtered);
    renderGridView(filtered);
    updateFilterChips();
    updateResultsMeta(filtered.length);
    updateTopKPIs();
}

/**
 * Render Table View
 */
function renderTableView(list) {
    const tbody = document.getElementById('warehousesTableBody');
    const emptyBox = document.getElementById('emptyResultsBox');
    const tableContainer = document.getElementById('tableWrapper');
    if (!tbody) return;

    tbody.innerHTML = '';

    if (list.length === 0) {
        if (emptyBox) emptyBox.style.display = 'block';
        if (tableContainer) tableContainer.style.display = 'none';
        return;
    }

    if (emptyBox) emptyBox.style.display = 'none';
    if (tableContainer) tableContainer.style.display = 'block';

    list.forEach(wh => {
        const tr = document.createElement('tr');
        const isDecom = wh.status.includes('Decommissioned');
        const isOp = wh.status.includes('Active') || wh.status.includes('Operational');
        const isSetup = wh.status.includes('Setup') || wh.status.includes('Pre-Launch');

        let statusBadgeClass = 'badge-primary';
        let statusText = wh.status;
        if (isOp) {
            statusBadgeClass = 'badge-success';
            statusText = '<span class="pulse-dot"></span> Operational';
        } else if (isSetup) {
            statusBadgeClass = 'badge-warning';
            statusText = 'In Setup';
        } else if (isDecom) {
            statusBadgeClass = 'badge-warning';
            statusText = 'Decommissioned';
        }

        // Icon based on type
        let iconClass = 'fa-warehouse';
        let avatarClass = '';
        if (wh.type.includes('Cold')) {
            iconClass = 'fa-snowflake';
            avatarClass = 'cold';
        } else if (wh.type.includes('Bonded')) {
            iconClass = 'fa-ship';
            avatarClass = 'bonded';
        } else if (wh.type.includes('Micro')) {
            iconClass = 'fa-city';
            avatarClass = 'micro';
        } else if (wh.type.includes('Cross-Dock')) {
            iconClass = 'fa-truck-fast';
        }

        tr.innerHTML = `
            <td>
                <div class="wh-title-cell">
                    <div class="wh-icon-avatar ${avatarClass}">
                        <i class="fa-solid ${iconClass}"></i>
                    </div>
                    <div class="wh-name-wrap">
                        <h4>${escapeHtml(wh.name)}</h4>
                        <div class="wh-sub-meta">
                            <code>${escapeHtml(wh.code)}</code>
                            <span>•</span>
                            <span>${escapeHtml(wh.type)}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div class="location-cell">
                    <div class="location-primary">
                        <i class="fa-solid fa-location-dot" style="color: #38bdf8; font-size: 0.8rem;"></i>
                        ${escapeHtml(wh.city)}, ${escapeHtml(wh.state)}
                    </div>
                    <div class="location-secondary">
                        ${escapeHtml(wh.country)} • ${escapeHtml(wh.zip || '')}
                    </div>
                </div>
            </td>
            <td>
                <div class="capacity-cell">
                    <div class="capacity-val">${(wh.area || 0).toLocaleString()} sq ft</div>
                    <div class="capacity-sub">${(wh.pallets || 0).toLocaleString()} Pallets • ${wh.docks || 0} Docks</div>
                </div>
            </td>
            <td>
                <div style="font-size: 0.85rem; font-weight: 600; color: #f8fafc;">${escapeHtml(wh.manager || 'Unassigned')}</div>
                <div style="font-size: 0.75rem; color: var(--text-dim);">${escapeHtml(wh.shifts || 'Standard')}</div>
            </td>
            <td>
                <span class="badge ${statusBadgeClass}" style="padding: 3px 10px; font-size: 0.75rem;">
                    ${statusText}
                </span>
            </td>
            <td style="text-align: right;">
                <div class="action-buttons-group">
                    <button type="button" class="action-btn action-btn-view" onclick="openDetailsModal('${wh.id}')" title="View Detailed Specifications & IoT Sensors">
                        <i class="fa-solid fa-eye"></i> View Details
                    </button>
                    <button type="button" class="action-btn action-btn-edit" onclick="openEditModal('${wh.id}')" title="Edit Warehouse Parameters">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                    </button>
                    <button type="button" class="action-btn action-btn-decom" onclick="openDecommissionModal('${wh.id}')" title="${isDecom ? 'Reactivate Facility' : 'Decommission Hub'}">
                        <i class="fa-solid ${isDecom ? 'fa-rotate-left' : 'fa-trash-can'}"></i> ${isDecom ? 'Restore' : 'Decommission'}
                    </button>
                </div>
            </td>
        `;

        tbody.appendChild(tr);
    });
}

/**
 * Render Grid / Card View
 */
function renderGridView(list) {
    const grid = document.getElementById('warehousesCardsGrid');
    if (!grid) return;

    grid.innerHTML = '';

    if (list.length === 0) return;

    list.forEach(wh => {
        const card = document.createElement('div');
        const isDecom = wh.status.includes('Decommissioned');
        const isOp = wh.status.includes('Active') || wh.status.includes('Operational');
        const isSetup = wh.status.includes('Setup') || wh.status.includes('Pre-Launch');

        card.className = 'wh-hub-card' + (isDecom ? ' decommissioned' : '');

        let statusBadge = '<span class="badge badge-success"><span class="pulse-dot"></span> Operational</span>';
        if (isSetup) statusBadge = '<span class="badge badge-warning">In Setup</span>';
        if (isDecom) statusBadge = '<span class="badge badge-warning" style="color: #ef4444; border-color: rgba(239,68,68,0.3);">Decommissioned</span>';

        let iconClass = 'fa-warehouse';
        if (wh.type.includes('Cold')) iconClass = 'fa-snowflake';
        else if (wh.type.includes('Bonded')) iconClass = 'fa-ship';
        else if (wh.type.includes('Micro')) iconClass = 'fa-city';
        else if (wh.type.includes('Cross-Dock')) iconClass = 'fa-truck-fast';

        card.innerHTML = `
            <div>
                <div class="card-top-bar">
                    <div>
                        <div class="card-wh-title">${escapeHtml(wh.name)}</div>
                        <span class="card-wh-code">${escapeHtml(wh.code)}</span>
                    </div>
                    ${statusBadge}
                </div>

                <div class="card-geo-tag">
                    <i class="fa-solid fa-map-location-dot"></i>
                    <span><strong>${escapeHtml(wh.city)}, ${escapeHtml(wh.state)}</strong> (${escapeHtml(wh.country)})</span>
                </div>

                <div class="card-metrics-grid">
                    <div class="card-metric-item">
                        <span class="card-metric-label">Floor Area</span>
                        <span class="card-metric-val">${(wh.area || 0).toLocaleString()} <span style="font-size: 0.75rem; color: var(--text-dim);">sq ft</span></span>
                    </div>
                    <div class="card-metric-item">
                        <span class="card-metric-label">Pallets</span>
                        <span class="card-metric-val">${(wh.pallets || 0).toLocaleString()}</span>
                    </div>
                    <div class="card-metric-item">
                        <span class="card-metric-label">Dock Doors</span>
                        <span class="card-metric-val">${wh.docks || 0}</span>
                    </div>
                </div>

                <div class="card-feature-pills">
                    <span class="feature-pill ${wh.hazmat ? 'active' : ''}">
                        <i class="fa-solid fa-biohazard"></i> Hazmat
                    </span>
                    <span class="feature-pill ${wh.rfid ? 'active' : ''}">
                        <i class="fa-solid fa-tower-broadcast"></i> RFID
                    </span>
                    <span class="feature-pill ${wh.customs ? 'active' : ''}">
                        <i class="fa-solid fa-passport"></i> Customs
                    </span>
                    <span class="feature-pill ${wh.iot ? 'active' : ''}">
                        <i class="fa-solid fa-satellite-dish"></i> IoT Smart
                    </span>
                </div>
            </div>

            <div class="card-actions-footer">
                <button type="button" class="action-btn action-btn-view" onclick="openDetailsModal('${wh.id}')">
                    <i class="fa-solid fa-eye"></i> Details
                </button>
                <button type="button" class="action-btn action-btn-edit" onclick="openEditModal('${wh.id}')">
                    <i class="fa-solid fa-pen-to-square"></i> Edit
                </button>
                <button type="button" class="action-btn action-btn-decom" onclick="openDecommissionModal('${wh.id}')">
                    <i class="fa-solid ${isDecom ? 'fa-rotate-left' : 'fa-trash-can'}"></i> ${isDecom ? 'Restore' : 'Decom'}
                </button>
            </div>
        `;

        grid.appendChild(card);
    });
}

/**
 * Toggle View Mode: Table or Grid
 */
function setViewMode(mode) {
    currentViewMode = mode;
    const tableWrap = document.getElementById('tableWrapper');
    const gridWrap = document.getElementById('gridWrapper');
    const btnTable = document.getElementById('viewModeTable');
    const btnGrid = document.getElementById('viewModeGrid');

    if (mode === 'table') {
        if (tableWrap) tableWrap.style.display = 'block';
        if (gridWrap) gridWrap.style.display = 'none';
        if (btnTable) btnTable.classList.add('active');
        if (btnGrid) btnGrid.classList.remove('active');
    } else {
        if (tableWrap) tableWrap.style.display = 'none';
        if (gridWrap) gridWrap.style.display = 'block';
        if (btnTable) btnTable.classList.remove('active');
        if (btnGrid) btnGrid.classList.add('active');
    }
}

/**
 * Update Active Filter Chips
 */
function updateFilterChips() {
    const container = document.getElementById('activeFilterChips');
    if (!container) return;

    container.innerHTML = '';

    const country = document.getElementById('filterCountry')?.value;
    const state = document.getElementById('filterState')?.value;
    const city = document.getElementById('filterCity')?.value;
    const type = document.getElementById('filterType')?.value;
    const status = document.getElementById('filterStatus')?.value;
    const keyword = document.getElementById('filterKeyword')?.value.trim();

    const chips = [];

    if (country && country !== 'all') {
        chips.push({ label: `Country: ${country}`, resetFn: () => { document.getElementById('filterCountry').value = 'all'; handleCountryChange(); } });
    }
    if (state && state !== 'all') {
        chips.push({ label: `State: ${state}`, resetFn: () => { document.getElementById('filterState').value = 'all'; handleStateChange(); } });
    }
    if (city && city !== 'all') {
        chips.push({ label: `City: ${city}`, resetFn: () => { document.getElementById('filterCity').value = 'all'; handleCityChange(); } });
    }
    if (type && type !== 'all') {
        chips.push({ label: `Type: ${type}`, resetFn: () => { document.getElementById('filterType').value = 'all'; applyFilters(); } });
    }
    if (status && status !== 'all') {
        chips.push({ label: `Status: ${status}`, resetFn: () => { document.getElementById('filterStatus').value = 'all'; applyFilters(); } });
    }
    if (keyword) {
        chips.push({ label: `Search: "${keyword}"`, resetFn: () => { document.getElementById('filterKeyword').value = ''; applyFilters(); } });
    }

    chips.forEach(chip => {
        const span = document.createElement('span');
        span.className = 'filter-chip';
        span.innerHTML = `
            <span>${escapeHtml(chip.label)}</span>
            <i class="fa-solid fa-xmark chip-remove" title="Remove filter"></i>
        `;
        span.querySelector('.chip-remove').addEventListener('click', chip.resetFn);
        container.appendChild(span);
    });
}

/**
 * Update Results Meta Count
 */
function updateResultsMeta(count) {
    const countElem = document.getElementById('filteredCount');
    const totalElem = document.getElementById('totalCountBadge');
    if (countElem) countElem.textContent = count;
    if (totalElem) totalElem.textContent = warehouses.length;
}

/**
 * Update Top KPI Stat Strip
 */
function updateTopKPIs() {
    const totalCount = warehouses.length;
    const operationalCount = warehouses.filter(w => w.status.includes('Active') || w.status.includes('Operational')).length;
    const totalArea = warehouses.reduce((sum, w) => sum + (w.area || 0), 0);
    const totalPallets = warehouses.reduce((sum, w) => sum + (w.pallets || 0), 0);

    const kpiCount = document.getElementById('kpiTotalHubs');
    const kpiOperational = document.getElementById('kpiOperationalHubs');
    const kpiArea = document.getElementById('kpiTotalArea');
    const kpiPallets = document.getElementById('kpiTotalPallets');

    if (kpiCount) kpiCount.textContent = totalCount + ' Hubs';
    if (kpiOperational) kpiOperational.textContent = operationalCount + ' Active';
    if (kpiArea) kpiArea.textContent = (totalArea).toLocaleString() + ' sq ft';
    if (kpiPallets) kpiPallets.textContent = (totalPallets).toLocaleString();
}

/**
 * Reset All Cascading & Secondary Filters
 */
function resetAllFilters() {
    const country = document.getElementById('filterCountry');
    const state = document.getElementById('filterState');
    const city = document.getElementById('filterCity');
    const type = document.getElementById('filterType');
    const status = document.getElementById('filterStatus');
    const keyword = document.getElementById('filterKeyword');

    if (country) country.value = 'all';
    updateStateFilterOptions();
    if (type) type.value = 'all';
    if (status) status.value = 'all';
    if (keyword) keyword.value = '';

    applyFilters();
    showToast('Filters have been reset.', 'info');
}

/**
 * Sort Table by Column
 */
function sortTableBy(field) {
    if (activeSortField === field) {
        activeSortAsc = !activeSortAsc;
    } else {
        activeSortField = field;
        activeSortAsc = true;
    }

    // Update icons
    document.querySelectorAll('.sortable').forEach(th => {
        const icon = th.querySelector('.sort-icon');
        if (icon) {
            icon.className = 'fa-solid fa-sort sort-icon';
        }
    });

    const activeTh = document.getElementById(`th-${field}`);
    if (activeTh) {
        const icon = activeTh.querySelector('.sort-icon');
        if (icon) {
            icon.className = `fa-solid ${activeSortAsc ? 'fa-sort-up' : 'fa-sort-down'} sort-icon`;
            icon.style.color = '#818cf8';
        }
    }

    applyFilters();
}

/* ==========================================================================
   MODAL DIALOGS: VIEW DETAILS, EDIT WAREHOUSE, DECOMMISSION
   ========================================================================== */

/**
 * Open View Details Modal
 */
function openDetailsModal(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;
    selectedWhForAction = wh;

    document.getElementById('detailsWhName').textContent = wh.name;
    document.getElementById('detailsWhCode').textContent = wh.code;
    document.getElementById('detailsWhType').textContent = wh.type;
    document.getElementById('detailsWhStatus').textContent = wh.status;
    
    // Address & Geo
    document.getElementById('detailsWhAddress').textContent = wh.address;
    document.getElementById('detailsWhLocation').textContent = `${wh.city}, ${wh.state} ${wh.zip || ''} (${wh.country})`;
    document.getElementById('detailsWhCorridor').textContent = wh.zone || 'Regional Logistics Node';

    // Specs
    document.getElementById('detailsWhArea').textContent = (wh.area || 0).toLocaleString() + ' sq ft';
    document.getElementById('detailsWhPallets').textContent = (wh.pallets || 0).toLocaleString() + ' Pallet Positions';
    document.getElementById('detailsWhDocks').textContent = (wh.docks || 0) + ' Loading Dock Doors';
    document.getElementById('detailsWhHeight').textContent = (wh.clearHeight || 30) + ' ft Clear Height';
    document.getElementById('detailsWhClimate').textContent = wh.climate || 'Standard Ambient';

    // Management
    document.getElementById('detailsWhManager').textContent = wh.manager || 'Unassigned';
    document.getElementById('detailsWhEmail').textContent = wh.email || 'dispatch@stockflow.io';
    document.getElementById('detailsWhPhone').textContent = wh.phone || '+1 (800) 555-FLOW';
    document.getElementById('detailsWhShifts').textContent = wh.shifts || '24/7 Operations';
    document.getElementById('detailsWhNotes').textContent = wh.notes || 'No special operational notes registered.';

    // Telemetry Sensor readings
    document.getElementById('detailsSensorTemp').textContent = wh.temp || '20.5 °C';
    document.getElementById('detailsSensorHumidity').textContent = wh.humidity || '44.0 %';
    document.getElementById('detailsSensorOccupancy').textContent = wh.occupancy || '75.0 %';
    document.getElementById('detailsSensorDocks').textContent = (wh.docks ? Math.floor(wh.docks * 0.4) : '6') + ' / ' + (wh.docks || 14) + ' In Use';

    // Storage Zones breakdown
    const zonesTbody = document.getElementById('detailsZonesTbody');
    if (zonesTbody) {
        zonesTbody.innerHTML = '';
        const zones = wh.zones || [
            { name: 'Zone A: Standard Pallet Racks', type: 'Selective Heavy Racking', cap: Math.floor((wh.pallets || 5000) * 0.7) },
            { name: 'Zone B: Rapid Pick Module', type: 'Flow Racks & Bins', cap: Math.ceil((wh.pallets || 5000) * 0.3) }
        ];

        zones.forEach(z => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td style="font-weight: 700; color: #f8fafc;">${escapeHtml(z.name)}</td>
                <td style="color: var(--text-muted);">${escapeHtml(z.type)}</td>
                <td style="font-weight: 700; color: #38bdf8; font-family: 'JetBrains Mono', monospace; text-align: right;">${(z.cap || 0).toLocaleString()} Pallets</td>
            `;
            zonesTbody.appendChild(tr);
        });
    }

    // Modal Open
    const modal = document.getElementById('viewDetailsModal');
    if (modal) modal.classList.add('active');
}

function closeDetailsModal() {
    const modal = document.getElementById('viewDetailsModal');
    if (modal) modal.classList.remove('active');
}

/**
 * Open Edit Warehouse Modal
 */
function openEditModal(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;
    selectedWhForAction = wh;

    document.getElementById('editWhId').value = wh.id;
    document.getElementById('editWhName').value = wh.name;
    document.getElementById('editWhCode').value = wh.code;
    document.getElementById('editWhType').value = wh.type;
    document.getElementById('editWhStatus').value = wh.status;
    document.getElementById('editWhCountry').value = wh.country;
    document.getElementById('editWhState').value = wh.state;
    document.getElementById('editWhCity').value = wh.city;
    document.getElementById('editWhAddress').value = wh.address;
    document.getElementById('editWhZip').value = wh.zip || '';
    document.getElementById('editWhZone').value = wh.zone || '';
    document.getElementById('editWhArea').value = wh.area;
    document.getElementById('editWhPallets').value = wh.pallets;
    document.getElementById('editWhDocks').value = wh.docks;
    document.getElementById('editWhClearHeight').value = wh.clearHeight || 30;
    document.getElementById('editWhClimate').value = wh.climate;
    document.getElementById('editWhManager').value = wh.manager;
    document.getElementById('editWhEmail').value = wh.email;
    document.getElementById('editWhPhone').value = wh.phone;
    document.getElementById('editWhShifts').value = wh.shifts;
    document.getElementById('editWhNotes').value = wh.notes || '';

    // Features
    document.getElementById('editCheckHazmat').checked = !!wh.hazmat;
    document.getElementById('editCheckRFID').checked = !!wh.rfid;
    document.getElementById('editCheckCustoms').checked = !!wh.customs;
    document.getElementById('editCheckIoT').checked = !!wh.iot;

    const modal = document.getElementById('editWarehouseModal');
    if (modal) modal.classList.add('active');
}

function closeEditModal() {
    const modal = document.getElementById('editWarehouseModal');
    if (modal) modal.classList.remove('active');
}

/**
 * Handle Edit Warehouse Form Submission
 */
function handleEditWarehouseSubmit(e) {
    e.preventDefault();
    const id = document.getElementById('editWhId').value;
    const idx = warehouses.findIndex(w => w.id === id);
    if (idx === -1) return;

    warehouses[idx] = {
        ...warehouses[idx],
        name: document.getElementById('editWhName').value.trim(),
        code: document.getElementById('editWhCode').value.trim(),
        type: document.getElementById('editWhType').value,
        status: document.getElementById('editWhStatus').value,
        country: document.getElementById('editWhCountry').value,
        state: document.getElementById('editWhState').value.trim(),
        city: document.getElementById('editWhCity').value.trim(),
        address: document.getElementById('editWhAddress').value.trim(),
        zip: document.getElementById('editWhZip').value.trim(),
        zone: document.getElementById('editWhZone').value.trim(),
        area: parseFloat(document.getElementById('editWhArea').value) || 0,
        pallets: parseFloat(document.getElementById('editWhPallets').value) || 0,
        docks: parseFloat(document.getElementById('editWhDocks').value) || 0,
        clearHeight: parseFloat(document.getElementById('editWhClearHeight').value) || 30,
        climate: document.getElementById('editWhClimate').value,
        manager: document.getElementById('editWhManager').value.trim(),
        email: document.getElementById('editWhEmail').value.trim(),
        phone: document.getElementById('editWhPhone').value.trim(),
        shifts: document.getElementById('editWhShifts').value,
        notes: document.getElementById('editWhNotes').value.trim(),
        hazmat: document.getElementById('editCheckHazmat').checked,
        rfid: document.getElementById('editCheckRFID').checked,
        customs: document.getElementById('editCheckCustoms').checked,
        iot: document.getElementById('editCheckIoT').checked
    };

    saveWarehousesToStorage();
    initCascadingFilters();
    applyFilters();
    closeEditModal();
    showToast(`Warehouse "${warehouses[idx].name}" successfully updated!`, 'success');
}

/**
 * Open Decommission Modal
 */
function openDecommissionModal(id) {
    const wh = warehouses.find(w => w.id === id);
    if (!wh) return;
    selectedWhForAction = wh;

    const isDecom = wh.status.includes('Decommissioned');

    document.getElementById('decomWhName').textContent = wh.name;
    document.getElementById('decomWhCode').textContent = wh.code;
    document.getElementById('decomWhLocation').textContent = `${wh.city}, ${wh.state} (${wh.country})`;

    const actionTitle = document.getElementById('decomModalTitle');
    const actionBtn = document.getElementById('decomConfirmBtn');
    const warningText = document.getElementById('decomWarningText');

    if (isDecom) {
        if (actionTitle) actionTitle.innerHTML = '<i class="fa-solid fa-rotate-left" style="color: #10b981;"></i> Reactivate Warehouse Hub';
        if (actionBtn) {
            actionBtn.className = 'btn btn-primary btn-sm';
            actionBtn.innerHTML = '<i class="fa-solid fa-rotate-left"></i> Confirm Reactivation';
        }
        if (warningText) warningText.textContent = 'This facility is currently decommissioned. Reactivating will restore active inventory routing and automated order dispatch through this node.';
    } else {
        if (actionTitle) actionTitle.innerHTML = '<i class="fa-solid fa-triangle-exclamation" style="color: #ef4444;"></i> Decommission Warehouse Hub';
        if (actionBtn) {
            actionBtn.className = 'btn btn-outline btn-sm';
            actionBtn.style.color = '#ef4444';
            actionBtn.style.borderColor = 'rgba(239, 68, 68, 0.4)';
            actionBtn.innerHTML = '<i class="fa-solid fa-trash-can"></i> Confirm Decommission';
        }
        if (warningText) warningText.textContent = 'Decommissioning will suspend all automated replenishment, picking routes, and edge IoT telemetry for this node in your active logistics network.';
    }

    const modal = document.getElementById('decommissionConfirmModal');
    if (modal) modal.classList.add('active');
}

function closeDecomConfirmModal() {
    const modal = document.getElementById('decommissionConfirmModal');
    if (modal) modal.classList.remove('active');
}

function executeDecommission() {
    if (!selectedWhForAction) return;
    const wh = selectedWhForAction;
    const isDecom = wh.status.includes('Decommissioned');

    if (isDecom) {
        wh.status = 'Active & Operational';
        showToast(`Reactivated facility "${wh.name}". Live routing restored.`, 'success');
    } else {
        wh.status = 'Decommissioned / Inactive';
        showToast(`Decommissioned facility "${wh.name}". Logistics routing suspended.`, 'info');
    }

    saveWarehousesToStorage();
    closeDecomConfirmModal();
    applyFilters();
}

/**
 * Export Warehouse List as CSV or JSON
 */
function exportWarehouseFleet(format) {
    const list = getFilteredWarehouses();
    let content = '';
    let mimeType = '';
    let filename = 'stockflow-warehouses-' + Date.now();

    if (format === 'json') {
        content = JSON.stringify(list, null, 2);
        mimeType = 'application/json';
        filename += '.json';
    } else {
        const headers = ['Facility_Name', 'Code', 'Classification', 'Country', 'State', 'City', 'Address', 'ZIP', 'Area_SqFt', 'Pallet_Positions', 'Dock_Doors', 'Clear_Height_Ft', 'Climate', 'Manager', 'Status'];
        const rows = list.map(w => [
            `"${w.name}"`, w.code, `"${w.type}"`, `"${w.country}"`, `"${w.state}"`, `"${w.city}"`, `"${w.address}"`, `"${w.zip || ''}"`, w.area, w.pallets, w.docks, w.clearHeight, `"${w.climate}"`, `"${w.manager}"`, `"${w.status}"`
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

    showToast(`Exported ${list.length} warehouse(s) as ${format.toUpperCase()}.`, 'success');
}

/**
 * Helper to escape HTML strings
 */
function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

/**
 * Toast Notification System
 */
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

/**
 * Toggle Sidebar Nav Dropdown
 */
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

/**
 * Handle Employee Management Submenu Actions
 */
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

// Initialize on DOM Ready
document.addEventListener('DOMContentLoaded', () => {
    loadWarehouses();
    initCascadingFilters();
    applyFilters();
});
