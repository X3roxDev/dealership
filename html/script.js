let vehicles = [];
let selectedVehicle = null;
let selectedColor = 0;
let currency = "$";
let isModalOpen = false;
let categoryLabels = {};
let purchasePending = false;
const resourceName = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'dealership';

window.addEventListener('message', function(event) {
    if (event.data.action === 'open') {
        vehicles = event.data.vehicles;
        currency = event.data.currency;
        categoryLabels = event.data.categoryLabels || {};

        if (event.data.shopTitle) {
            $('.brand-text h1')
                .empty()
                .append($('<span>').text('X3roxDev'))
                .append($('<strong>').text(event.data.shopTitle));
        }
        $('.brand-text p').text(event.data.shopSubtitle || '');

        if (event.data.locales) {
            updateLocales(event.data.locales);
        }

        $('#app').show();
        loadCategories();
        filterVehicles('all', '');
    } else if (event.data.action === 'close') {
        $('#app').hide();
        $('#modal').hide();
        isModalOpen = false;
    }
});

$(document).on('keydown', function(e) {
    if (e.key === "Escape") {
        if ($('#modal').is(':visible')) {
            $('#modal').fadeOut();
            $('#payment-menu').removeClass('is-open');
            isModalOpen = false;
        } else {
            closeShop();
        }
    }
});

$('#close-btn').click(function() {
    closeShop();
});

$('#sidebar-close-btn').click(function() {
    closeShop();
});

$('.close-modal').click(function() {
    $('#modal').hide();
    $('#payment-menu').removeClass('is-open');
    isModalOpen = false;
});

function closeShop() {
    $('#app').hide();
    $('#modal').hide();
    $('#payment-menu').removeClass('is-open');
    isModalOpen = false;
    purchasePending = false;
    $.post(`https://${resourceName}/close`, JSON.stringify({}));
}

function loadCategories() {
    const categories = ['all'];
    vehicles.forEach(veh => {
        if (!categories.includes(veh.category)) {
            categories.push(veh.category);
        }
    });

    const container = $('#category-filters');
    container.empty();
    
    categories.forEach(cat => {
        const active = cat === 'all' ? 'active' : '';
        const label = cat === 'all'
            ? (categoryLabels.all || 'All Vehicles')
            : (categoryLabels[cat] || cat.charAt(0).toUpperCase() + cat.slice(1));
        container.append(`<button class="filter-btn ${active}" data-filter="${cat}">${label}</button>`);
    });
}

function loadVehicles(list) {
    const container = $('#vehicle-grid');
    container.empty();
    $('#vehicle-count').text(list.length.toLocaleString());

    list.forEach(veh => {
        let imgPath;
        if (veh.image && veh.image.length > 0) {
            imgPath = `img/${veh.image}`;
        } else {
            const fileModel = (veh.model || '').toString().toLowerCase();
            imgPath = `img/${fileModel}.png`;
        }
        
        const price = Number(veh.price) || 0;
        const categoryLabel = veh.categoryLabel || categoryLabels[veh.category] || veh.category;
        const html = `
            <div class="vehicle-card" data-model="${veh.model}">
                <div class="card-img">
                    <img src="${imgPath}" onerror="this.onerror=null;this.src='img/default_vehicle.svg';">
                    <span class="card-class">${categoryLabel}</span>
                </div>
                <div class="card-info">
                    <div class="card-brand">${veh.brand}</div>
                    <div class="card-name">${veh.label}</div>
                    <div class="card-price">${currency}${price.toLocaleString()}</div>
                </div>
            </div>
        `;
        container.append(html);
    });

}

// Filter Click
$(document).on('click', '.filter-btn', function() {
    $('.filter-btn').removeClass('active');
    $(this).addClass('active');
    
    const filter = $(this).data('filter');
    const search = $('#search').val().toLowerCase();
    
    filterVehicles(filter, search);
});

// Search Input
$('#search').on('input', function() {
    const filter = $('.filter-btn.active').data('filter');
    const search = $(this).val().toLowerCase();
    
    filterVehicles(filter, search);
});

// Sort Change
$('#sort-select').change(function() {
    const filter = $('.filter-btn.active').data('filter');
    const search = $('#search').val().toLowerCase();
    
    filterVehicles(filter, search);
});

function filterVehicles(category, search) {
    const currentCategory = category;
    const term = search.toLowerCase();
    const sortType = $('#sort-select').val();
    const selectedLabel = currentCategory === 'all'
        ? 'All'
        : (categoryLabels[currentCategory] || currentCategory.charAt(0).toUpperCase() + currentCategory.slice(1));

    $('#selected-class').text(selectedLabel);

    // 1. Filter
    let filtered = vehicles.filter(veh => {
        const matchesCategory = currentCategory === 'all' || veh.category === currentCategory;
        const label = (veh.label || '').toLowerCase();
        const brand = (veh.brand || '').toLowerCase();
        const modelStr = (veh.model || '').toLowerCase();
        const matchesSearch =
            term.length === 0 ||
            label.includes(term) ||
            brand.includes(term) ||
            modelStr.includes(term);
        return matchesCategory && matchesSearch;
    });

    // 2. Sort
    filtered.sort((a, b) => {
        if (sortType === 'lowest_price') {
            return (Number(a.price) || 0) - (Number(b.price) || 0);
        } else if (sortType === 'highest_price') {
            return (Number(b.price) || 0) - (Number(a.price) || 0);
        } else if (sortType === 'name_az') {
            return (a.label || '').localeCompare(b.label || '');
        } else if (sortType === 'name_za') {
            return (b.label || '').localeCompare(a.label || '');
        }
        return 0;
    });

    // 3. Render
    loadVehicles(filtered);
}

// Open Modal
$(document).on('click', '.vehicle-card', function(e) {
    e.preventDefault();
    e.stopPropagation();
    const model = $(this).data('model');
    selectedVehicle = vehicles.find(v => v.model === model);
    
    if (selectedVehicle) {
        $('#modal-title').text(selectedVehicle.label);
        $('#modal-brand').text(selectedVehicle.brand);
        $('#modal-class').text(selectedVehicle.categoryLabel || categoryLabels[selectedVehicle.category] || selectedVehicle.category);
        $('#modal-price').text((Number(selectedVehicle.price) || 0).toLocaleString());
        const imgFile = selectedVehicle.image && selectedVehicle.image.length > 0 ? selectedVehicle.image : `${(selectedVehicle.model || '').toString().toLowerCase()}.png`;
        const imgPath = `img/${imgFile}`;
        const placeholder = 'img/default_vehicle.svg';
        const $img = $('#modal-img');
        $img.off('error');
        $img.on('error', function() {
            $(this).off('error').attr('src', placeholder);
        });
        $img.attr('src', imgPath);
        
        // Reset color
        $('.color-option').removeClass('selected');
        $('.color-option[data-color="0"]').addClass('selected');
        selectedColor = 0;
        $('#payment-menu').removeClass('is-open');
        purchasePending = false;
        isModalOpen = true;
        $('#modal').css('display', 'flex').show();
    }
});

// Color Selection
$('.color-option').click(function() {
    $('.color-option').removeClass('selected');
    $(this).addClass('selected');
    selectedColor = $(this).data('color');
});

// Buy Button
$('#buy-btn').click(function() {
    if (!selectedVehicle) return;
    $('#payment-menu').addClass('is-open');
});

$(document).on('click', '.payment-option', function() {
    if (!selectedVehicle || purchasePending) return;

    const paymentMethod = $(this).data('payment') || 'cash';
    purchasePending = true;

    $.post(`https://${resourceName}/buy`, JSON.stringify({
        model: selectedVehicle.model,
        price: selectedVehicle.price,
        color: selectedColor,
        paymentMethod: paymentMethod
    }), function(response) {
        if (response.success) {
            $('#modal').hide();
            $('#payment-menu').removeClass('is-open');
            closeShop();
        }
        purchasePending = false;
    });
});

function updateLocales(locales) {
    if (locales.ui_categories) $('.nav-section h3').text(locales.ui_categories);
    if (locales.ui_all_vehicles) $('.filter-btn[data-filter="all"]').text(locales.ui_all_vehicles);
    if (locales.ui_search_placeholder) $('#search').attr('placeholder', locales.ui_search_placeholder);
    if (locales.ui_select_color) $('.customization h3').text(locales.ui_select_color);
    if (locales.ui_test_drive) $('#test-drive-btn').html(`<i class="fas fa-gauge-high"></i> ${locales.ui_test_drive}`);
    if (locales.ui_buy) $('#buy-btn').html(`<i class="fas fa-check"></i> ${locales.ui_buy}`);
}

// Test Drive Button
$('#test-drive-btn').click(function() {
    if (!selectedVehicle) return;
    
    $.post(`https://${resourceName}/testDrive`, JSON.stringify({
        model: selectedVehicle.model
    }), function(response) {
        if (response.success) {
            $('#modal').hide();
            closeShop();
        }
    });
});
