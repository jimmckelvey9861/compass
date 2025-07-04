// Schedule management functionality

// Update the size and text rotation of shift bars
function updateShiftBars() {
  const shiftBars = document.querySelectorAll('.bar-container');
  
  shiftBars.forEach(container => {
    const nameContainer = container.querySelector('.name-container');
    const nameText = container.querySelector('.name-text');
    const maxConcurrent = parseInt(container.dataset.maxConcurrent);
    const position = parseInt(container.dataset.position);
    const isDayView = container.dataset.dayView === 'true';
    
    const columnWidth = container.parentElement.offsetWidth;
    const rightPadding = columnWidth * 0.05; // 5% of column width for right padding
    const maxBarWidth = (columnWidth - rightPadding - (maxConcurrent * 1)) / maxConcurrent;
    const barWidth = Math.max(2, maxBarWidth);
    
    // Position and size the bar with 1px spacing
    container.style.width = barWidth + 'px';
    container.style.left = (position * (barWidth + 1)) + 'px';
    
    // Handle text visibility and rotation
    if (barWidth >= 12) {
      nameContainer.style.opacity = '1';
      // Scale text larger in day view
      const textScale = isDayView ? 
        Math.min(1.5, barWidth / 40) : // Day view: larger text
        Math.min(1.2, barWidth / 30);  // Week view: normal text
      nameText.style.fontSize = (textScale * (isDayView ? 1.25 : 1.125)) + 'rem';
      
      // Rotate text if bar is taller than it is wide
      if (container.offsetHeight > barWidth) {
        nameText.style.transform = 'rotate(-90deg)';
      } else {
        nameText.style.transform = 'none';
      }
    } else {
      nameContainer.style.opacity = '0';
    }
  });
}

// Update schedule grid height to fit viewport
function updateScheduleHeight() {
  const scheduleEl = document.getElementById('scheduleGrid');
  const containerEl = document.getElementById('scheduleContainer');
  if (!scheduleEl || !containerEl) return;

  // Get available height (viewport height minus header and padding)
  const headerHeight = 64; // Height of the header section
  const bottomPadding = 32; // Padding at the bottom
  const availableHeight = window.innerHeight - headerHeight - bottomPadding;
  
  // Get hours span from the element's data attribute
  const hoursSpan = parseFloat(scheduleEl.dataset.hoursSpan);
  const minHourHeight = parseInt(scheduleEl.dataset.minHourHeight);
  
  // Calculate hour height based on available space
  const hourHeight = Math.max(minHourHeight, Math.floor(availableHeight / hoursSpan));
  
  // Set CSS custom property for hour height
  document.documentElement.style.setProperty('--hour-height', `${hourHeight}px`);
  
  // Set grid height
  const totalHeight = hourHeight * hoursSpan;
  scheduleEl.style.height = `${totalHeight}px`;
  
  // Add/remove scroll class based on height
  if (totalHeight > availableHeight) {
    containerEl.classList.add('overflow-auto');
  } else {
    containerEl.classList.remove('overflow-auto');
  }

  // Update shift bars after height is set
  updateShiftBars();
}

// Initialize schedule
function initSchedule() {
  // Update layout on load and resize
  updateScheduleHeight();
  window.addEventListener('resize', () => {
    requestAnimationFrame(updateScheduleHeight);
  });
}

// Export functions
export { initSchedule, updateScheduleHeight, updateShiftBars };