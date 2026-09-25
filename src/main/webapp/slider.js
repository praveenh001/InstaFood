/* =========================================================================
   one8-style Horizontal Slider Initializer for Instafoods
   ========================================================================= */

// Dynamically inject slider styles to guarantee rendering and bypass browser cache
(function injectSliderStyles() {
  if (document.getElementById('injected-slider-styles')) return;
  const style = document.createElement('style');
  style.id = 'injected-slider-styles';
  style.textContent = `
    .slider-initialized {
      display: flex !important;
      flex-wrap: nowrap !important;
      overflow-x: auto !important;
      scroll-behavior: smooth !important;
      -webkit-overflow-scrolling: touch !important;
      scrollbar-width: none !important;
      gap: 30px !important;
      width: 100% !important;
    }
    .slider-initialized::-webkit-scrollbar {
      display: none !important;
    }
    .slider-initialized .restaurant-card,
    .slider-initialized .feat-card {
      flex-shrink: 0 !important;
      width: 340px !important;
    }
    .slider-initialized .food-card {
      flex-shrink: 0 !important;
      width: 290px !important;
    }
    .slider-controls-container {
      margin-top: 32px;
      margin-bottom: 40px !important;
      padding: 0 20px;
      width: 100%;
      box-sizing: border-box;
    }
    .slider-controls-row {
      display: flex;
      align-items: center;
      gap: 20px;
      width: 100%;
    }
    .slider-pagination {
      font-family: var(--font-heading), sans-serif;
      font-weight: 800;
      font-size: 0.85rem;
      color: var(--text-muted);
      letter-spacing: 0.5px;
      white-space: nowrap;
    }
    .slider-navigation-btns {
      display: flex;
      gap: 8px;
      white-space: nowrap;
    }
    .slider-nav-btn {
      background: transparent;
      border: 1px solid var(--border);
      color: var(--text-muted);
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;
      font-size: 0.75rem;
    }
    .slider-nav-btn:hover {
      border-color: var(--primary);
      color: var(--primary);
    }
    .slider-track-wrapper {
      flex-grow: 1;
      height: 30px;
      display: flex;
      align-items: center;
      position: relative;
      cursor: pointer;
    }
    .slider-track {
      width: 100%;
      height: 2px;
      background: rgba(255, 255, 255, 0.12);
      position: relative;
    }
    .slider-progress-line {
      position: absolute;
      left: 0;
      top: 0;
      height: 100%;
      width: 0%;
      background: #000000;
      transition: background-color 0.25s ease;
    }
    .slider-track-wrapper.active .slider-progress-line {
      background: #22c55e;
      box-shadow: 0 0 8px rgba(34, 197, 94, 0.8);
    }
    .slider-thumb {
      position: absolute;
      top: 50%;
      left: 0%;
      transform: translate(-50%, -50%);
      width: 38px;
      height: 28px;
      cursor: grab;
      z-index: 10;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #000000;
      transition: color 0.25s ease;
      filter: drop-shadow(0 0 2px rgba(255, 255, 255, 0.5));
    }
    .slider-thumb:active {
      cursor: grabbing;
    }
    .slider-thumb.active {
      color: #22c55e;
      filter: drop-shadow(0 0 6px rgba(34, 197, 94, 0.8));
    }
    .slider-symbol-svg {
      width: 100%;
      height: 100%;
      pointer-events: none;
    }
  `;
  document.head.appendChild(style);
})();

function initCardSliders() {
  const grids = document.querySelectorAll('.restaurant-grid, .menu-grid');
  
  grids.forEach((grid) => {
    // Avoid double initialization
    if (grid.classList.contains('slider-initialized')) return;
    
    // Check if there are cards
    const cards = grid.querySelectorAll('.restaurant-card, .food-card, .feat-card');
    if (cards.length === 0) return;
    
    // 1. Mark grid as slider-initialized
    grid.classList.add('slider-initialized');
    
    // 2. Create slider controls wrapper
    const controls = document.createElement('div');
    controls.className = 'slider-controls-container';
    
    controls.innerHTML = `
      <div class="slider-controls-row">
        <div class="slider-pagination"><span class="current-slide">1</span>/<span>${cards.length}</span></div>
        <div class="slider-navigation-btns">
          <button class="slider-nav-btn prev-btn" aria-label="Previous"><i class="fa-solid fa-chevron-left"></i></button>
          <button class="slider-nav-btn next-btn" aria-label="Next"><i class="fa-solid fa-chevron-right"></i></button>
        </div>
        <div class="slider-track-wrapper">
          <div class="slider-track">
            <div class="slider-progress-line"></div>
            <div class="slider-thumb">
              <!-- Custom '7' logo SVG with white outline for visibility on dark backgrounds -->
              <svg viewBox="0 0 100 80" class="slider-symbol-svg" width="38" height="28" style="width: 38px; height: 28px; display: block;" xmlns="http://www.w3.org/2000/svg">
                <path d="M 0 40 L 40 40" stroke="#ffffff" stroke-width="16" stroke-linecap="square" />
                <path d="M 55 40 L 100 40" stroke="#ffffff" stroke-width="16" stroke-linecap="square" />
                <path d="M 40 30 H 60 L 42 55" fill="none" stroke="#ffffff" stroke-width="18" stroke-linejoin="miter" stroke-linecap="square" />
                
                <path class="symbol-line-left" d="M 0 40 L 40 40" stroke="currentColor" stroke-width="8" stroke-linecap="square" />
                <path class="symbol-line-right" d="M 55 40 L 100 40" stroke="currentColor" stroke-width="8" stroke-linecap="square" />
                <path class="symbol-7" d="M 40 30 H 60 L 42 55" fill="none" stroke="currentColor" stroke-width="10" stroke-linejoin="miter" stroke-linecap="square" />
              </svg>
            </div>
          </div>
        </div>
      </div>
    `;
    
    // Insert controls directly after the grid
    grid.parentNode.insertBefore(controls, grid.nextSibling);
    
    // Select elements inside controls
    const currentSpan = controls.querySelector('.current-slide');
    const prevBtn = controls.querySelector('.prev-btn');
    const nextBtn = controls.querySelector('.next-btn');
    const trackWrapper = controls.querySelector('.slider-track-wrapper');
    const track = controls.querySelector('.slider-track');
    const progressLine = controls.querySelector('.slider-progress-line');
    const thumb = controls.querySelector('.slider-thumb');
    
    let isDragging = false;
    let startX = 0;
    let startLeft = 0;
    let activeTimeout = null;
    
    // Update color states to green when active/scrolling/dragging
    function setScrollActive() {
      trackWrapper.classList.add('active');
      thumb.classList.add('active');
      
      if (activeTimeout) clearTimeout(activeTimeout);
      
      activeTimeout = setTimeout(() => {
        if (!isDragging) {
          trackWrapper.classList.remove('active');
          thumb.classList.remove('active');
        }
      }, 150); // reverts to black when scroll stops
    }
    
    // Sync thumb position & page indicators to scroll state
    function updateThumbFromScroll() {
      const visibleCards = Array.from(cards).filter(c => c.style.display !== 'none');
      const totalSlides = visibleCards.length;
      
      // Update total slides label
      controls.querySelector('.slider-pagination').querySelector('span:last-child').textContent = totalSlides;
      
      const maxScroll = grid.scrollWidth - grid.clientWidth;
      if (maxScroll <= 0) {
        progressLine.style.width = '100%';
        thumb.style.left = '0px';
        currentSpan.textContent = totalSlides > 0 ? 1 : 0;
        return;
      }
      
      const scrollPercent = grid.scrollLeft / maxScroll;
      
      // Update pagination index (1-based)
      const firstCard = visibleCards[0] || cards[0];
      const cardWidth = firstCard.clientWidth + 30; // card + layout gap
      const currentIdx = Math.min(totalSlides, Math.max(1, Math.round(grid.scrollLeft / cardWidth) + 1));
      currentSpan.textContent = currentIdx;
      
      // Update progress line length
      progressLine.style.width = (scrollPercent * 100) + '%';
      
      // Position thumb
      const maxThumbMove = track.clientWidth;
      const thumbLeft = scrollPercent * maxThumbMove;
      thumb.style.left = thumbLeft + 'px';
    }
    
    // Scroll event on grid container
    grid.addEventListener('scroll', () => {
      updateThumbFromScroll();
      setScrollActive();
    });
    
    // Re-trigger layout updates on custom events or window changes
    grid.addEventListener('update-slider', updateThumbFromScroll);
    
    // Initial sync
    setTimeout(updateThumbFromScroll, 100);
    window.addEventListener('resize', updateThumbFromScroll);
    
    // Prev / Next navigation button clicks
    prevBtn.addEventListener('click', () => {
      const visibleCards = Array.from(cards).filter(c => c.style.display !== 'none');
      const firstCard = visibleCards[0] || cards[0];
      const cardWidth = firstCard.clientWidth + 30;
      grid.scrollLeft -= cardWidth;
    });
    
    nextBtn.addEventListener('click', () => {
      const visibleCards = Array.from(cards).filter(c => c.style.display !== 'none');
      const firstCard = visibleCards[0] || cards[0];
      const cardWidth = firstCard.clientWidth + 30;
      grid.scrollLeft += cardWidth;
    });
    
    // Drag/Slide logic for thumb
    function onDragStart(e) {
      isDragging = true;
      trackWrapper.classList.add('active');
      thumb.classList.add('active');
      
      startX = e.type === 'touchstart' ? e.touches[0].clientX : e.clientX;
      startLeft = parseFloat(thumb.style.left) || 0;
      
      document.addEventListener(e.type === 'touchstart' ? 'touchmove' : 'mousemove', onDragMove);
      document.addEventListener(e.type === 'touchstart' ? 'touchend' : 'mouseup', onDragEnd);
      e.preventDefault();
    }
    
    function onDragMove(e) {
      if (!isDragging) return;
      
      const clientX = e.type === 'touchmove' ? e.touches[0].clientX : e.clientX;
      const deltaX = clientX - startX;
      
      const maxThumbMove = track.clientWidth;
      const newLeft = Math.min(maxThumbMove, Math.max(0, startLeft + deltaX));
      
      thumb.style.left = newLeft + 'px';
      
      const percent = maxThumbMove > 0 ? (newLeft / maxThumbMove) : 0;
      progressLine.style.width = (percent * 100) + '%';
      
      // Scroll grid container dynamically
      const maxScroll = grid.scrollWidth - grid.clientWidth;
      grid.scrollLeft = percent * maxScroll;
    }
    
    function onDragEnd(e) {
      isDragging = false;
      trackWrapper.classList.remove('active');
      thumb.classList.remove('active');
      
      document.removeEventListener(e.type === 'touchend' ? 'touchmove' : 'mousemove', onDragMove);
      document.removeEventListener(e.type === 'touchend' ? 'touchend' : 'mouseup', onDragEnd);
    }
    
    thumb.addEventListener('mousedown', onDragStart);
    thumb.addEventListener('touchstart', onDragStart);
    
    // Clicking track jumps scroll position
    trackWrapper.addEventListener('click', (e) => {
      if (e.target === thumb) return;
      const rect = track.getBoundingClientRect();
      const clickX = e.clientX - rect.left;
      const percent = Math.min(1, Math.max(0, clickX / rect.width));
      
      const maxScroll = grid.scrollWidth - grid.clientWidth;
      grid.scrollTo({
        left: percent * maxScroll,
        behavior: 'smooth'
      });
    });
  });
}

// Automatically trigger initialization when DOM is loaded
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initCardSliders);
} else {
  initCardSliders();
}
