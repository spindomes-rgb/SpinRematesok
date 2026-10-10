document.addEventListener('DOMContentLoaded', () => {
    const grid = document.getElementById('product-grid');
    const tabBtns = document.querySelectorAll('.tab-btn');

    function renderProducts(category = 'all') {
        grid.innerHTML = '';

        const filteredItems = category === 'all'
            ? ITEMS
            : ITEMS.filter(item => item.category === category);

        filteredItems.forEach(item => {
            // Logic to handle either salePrice or discount
            let finalPrice = 0;
            let displayDiscount = 0;

            if (item.salePrice !== undefined) {
                finalPrice = item.salePrice;
                displayDiscount = Math.round((1 - (item.salePrice / item.originalPrice)) * 100);
            } else if (item.discount !== undefined) {
                finalPrice = Math.round(item.originalPrice * (1 - item.discount));
                displayDiscount = Math.round(item.discount * 100);
            }

            const card = document.createElement('div');
            card.className = `card ${item.sold ? 'sold' : ''}`;

            const displayName = item.name.charAt(0).toUpperCase() + item.name.slice(1);
            const waMessage = encodeURIComponent(`Hola, me interesa el artículo en remate: ${displayName} (${item.id}). ¿Sigue disponible?`);
            const waLink = `https://wa.me/${CONFIG.whatsappNumber}?text=${waMessage}`;

            const sizeText = (item.width === '???' || item.height === '???')
                ? 'Medida a consultar'
                : (item.width === item.height ? `Alto ${item.height}` : `${item.width} x ${item.height}`);
            card.innerHTML = `
                ${item.sold ? '<div class="sold-overlay">VENDIDO</div>' : ''}
                <div class="image-container">
                    ${displayDiscount > 0 && !item.sold ? `<div class="offer-badge">-${displayDiscount}%</div>` : ''}
                    <img src="${item.image}" alt="${displayName}" loading="lazy">
                </div>
                <div class="card-body">
                    <h3 class="product-title">${displayName}</h3>
                    <div class="product-info">
                        <div class="info-item"><i class="fas fa-expand-arrows-alt"></i> ${sizeText}</div>
                        <div class="info-item"><i class="fas fa-info-circle"></i> ${item.description}</div>
                    </div>
                    <div class="price-container">
                        <span class="original-price">${CONFIG.currency}${item.originalPrice.toLocaleString('es-CL')}</span>
                        <span class="sale-price">${CONFIG.currency}${finalPrice.toLocaleString('es-CL')}</span>
                    </div>
                    ${item.sold ?
                    '<button class="whatsapp-btn" disabled>Agotado</button>' :
                    `<a href="${waLink}" target="_blank" class="whatsapp-btn">
                            <i class="fab fa-whatsapp"></i> Comprar ahora
                        </a>`
                }
                </div>
            `;
            grid.appendChild(card);
        });
    }

    // Tab filtering
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderProducts(btn.dataset.category);
        });
    });

    // Initial render
    renderProducts();
});
