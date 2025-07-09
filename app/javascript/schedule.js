// Schedule management functionality
function updateShiftBars() {
  const shiftBars = document.querySelectorAll('.bar-container');
  
  shiftBars.forEach(container => {
    const nameContainer = container.querySelector('.name-container');
    const nameText = container.querySelector('.name-text');
    const maxConcurrent = parseInt(container.dataset.maxConcurrent) || 1;
    const position = parseInt(container.dataset.position) || 0;
    const isDayView = container.dataset.dayView === 'true';
    
    const columnWidth = container.parentElement.offsetWidth;
    const rightPadding = columnWidth * 0.05;
    const maxBarWidth = (columnWidth - rightPadding - (maxConcurrent * 1)) / maxConcurrent;
    const barWidth = Math.max(2, maxBarWidth);
    
    container.style.width = barWidth + 'px';
    container.style.left = (position * (barWidth + 1)) + 'px';
    
    if (barWidth >= 12) {
      nameContainer.style.opacity = '1';
      const textScale = isDayView ? 
        Math.min(1.5, barWidth / 40) :
        Math.min(1.2, barWidth / 30);
      nameText.style.fontSize = (textScale * (isDayView ? 1.25 : 1.125)) + 'rem';
      
      nameText.style.transform = container.offsetHeight > barWidth ? 'rotate(-90deg)' : 'none';
    } else {
      nameContainer.style.opacity = '0';
    }
  });
}

function updateScheduleHeight() {
  const scheduleEl = document.getElementById('scheduleGrid');
  const containerEl = document.getElementById('scheduleContainer');
  const headerEl = document.getElementById('scheduleHeader');
  
  if (!scheduleEl || !containerEl || !headerEl) return;

  const topMargin = 24;
  const bottomMargin = 32;
  const headerHeight = headerEl.offsetHeight;
  const availableHeight = window.innerHeight - headerHeight - topMargin - bottomMargin;
  
  const hoursSpan = parseFloat(scheduleEl.dataset.hoursSpan) || 10;
  const minHourHeight = parseInt(scheduleEl.dataset.minHourHeight) || 20;
  
  const hourHeight = Math.max(minHourHeight, Math.floor(availableHeight / hoursSpan));
  document.documentElement.style.setProperty('--hour-height', `${hourHeight}px`);
  
  const totalHeight = hourHeight * hoursSpan;
  scheduleEl.style.height = `${totalHeight}px`;
  containerEl.classList.toggle('overflow-auto', totalHeight > availableHeight);

  updateShiftBars();
}

function initSchedule() {
  updateScheduleHeight();
  window.addEventListener('resize', () => {
    requestAnimationFrame(updateScheduleHeight);
  });
}

document.addEventListener('turbo:load', initSchedule);
document.addEventListener('turbo:render', initSchedule);