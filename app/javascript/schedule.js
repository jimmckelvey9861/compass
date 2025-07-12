// Add drop deduplication and debug tracking
let lastDropId = null;
let dropCounter = {
  total: 0,
  deduped: 0
};

console.log('[DND DEBUG] schedule.js loaded');
// Schedule management functionality
import interact from 'interactjs';

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

function initJobPaletteDraggable() {
  const jobItems = document.querySelectorAll('.job-item[data-draggable="job-palette"]');
  console.log('[DND DEBUG] Found job items:', jobItems.length, jobItems);
  
  if (jobItems.length === 0) {
    console.log('[DND DEBUG] No job items found - exiting');
    return;
  }
  
  jobItems.forEach(item => {
    console.log('[DND DEBUG] job-item attributes:', {
      id: item.getAttribute('data-job-id'),
      draggable: item.getAttribute('data-draggable'),
      name: item.getAttribute('data-job-name')
    });
    
    item.addEventListener('click', function() {
      console.log('[DND DEBUG] Job item clicked:', this.dataset.jobName);
    });
  });
  
  console.log('[DND DEBUG] About to initialize interact.js draggable...');
  const dragResult = interact('.job-item[data-draggable="job-palette"]').draggable({
    inertia: false,
    autoScroll: true,
    ignoreFrom: 'a, button, .clickable', // Ignore drag on interactive elements
    listeners: {
      start(event) {
        console.log('[DND DEBUG] *** DRAG START ***', event.target.dataset.jobName);
        event.preventDefault(); // Prevent default browser behavior
        event.target.setAttribute('aria-grabbed', 'true');
        event.target.classList.add('dragging');
      },
      move(event) {
        console.log('[DND DEBUG] Drag move', event.target.dataset.jobName);
        event.preventDefault(); // Prevent default browser behavior
        
        // Update element position
        const target = event.target;
        const x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        const y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        
        target.style.transform = `translate(${x}px, ${y}px)`;
        target.setAttribute('data-x', x);
        target.setAttribute('data-y', y);
      },
      end(event) {
        console.log('[DND DEBUG] *** DRAG END ***', event.target.dataset.jobName);
        event.preventDefault(); // Prevent default browser behavior
        event.target.setAttribute('aria-grabbed', 'false');
        event.target.classList.remove('dragging');
        
        // Reset position
        event.target.style.transform = '';
        event.target.removeAttribute('data-x');
        event.target.removeAttribute('data-y');
      }
    }
  });
  console.log('[DND DEBUG] Interact.js draggable result:', dragResult);
  console.log('[DND DEBUG] Interact.js version:', interact.version);
}

function initDropZones() {
  const dropZones = document.querySelectorAll('.time-slot-drop-zone[data-droppable="schedule-slot"]');
  console.log('[DND DEBUG] Found drop zones:', dropZones.length);
  
  if (dropZones.length === 0) {
    console.log('[DND DEBUG] No drop zones found - exiting');
    return;
  }

  // Clear any existing dropzones before initializing
  interact('.time-slot-drop-zone[data-droppable="schedule-slot"]').unset();

  interact('.time-slot-drop-zone[data-droppable="schedule-slot"]')
    .dropzone({
      accept: '.job-item[data-draggable="job-palette"]',
      overlap: 0.25,
      
      ondropactivate: function(event) {
        console.log('[DND DEBUG] Dropzone activated', {
          target: event.target.dataset.date + ' ' + event.target.dataset.slotStart
        });
        event.target.classList.add('drop-active');
      },
      
      ondragenter: function(event) {
        const relatedTarget = event.relatedTarget;
        const target = event.target;
        
        // Remove highlight from all other dropzones
        document.querySelectorAll('.dropzone-highlight').forEach(zone => {
          if (zone !== target) {
            zone.classList.remove('dropzone-highlight');
          }
        });
        
        console.log('[DND DEBUG] Dropzone ondragenter', {
          job: relatedTarget.dataset.jobName,
          date: target.dataset.date,
          time: target.dataset.slotStart
        });
        
        target.classList.add('dropzone-highlight');
        relatedTarget.classList.add('can-drop');
      },
      
      ondragleave: function(event) {
        const relatedTarget = event.relatedTarget;
        const target = event.target;
        
        console.log('[DND DEBUG] Dropzone ondragleave', {
          job: relatedTarget.dataset.jobName,
          date: target.dataset.date,
          time: target.dataset.slotStart
        });
        
        target.classList.remove('dropzone-highlight');
        relatedTarget.classList.remove('can-drop');
      },
      
      ondrop: function(event) {
        const relatedTarget = event.relatedTarget;
        const target = event.target;
        
        dropCounter.total++;
        
        // Generate a unique drop ID from the job and target data
        const dropId = `${relatedTarget.dataset.jobId}-${target.dataset.date}-${target.dataset.slotStart}`;
        
        console.log('[DND DEBUG] Dropzone ondrop', {
          dropId,
          job: relatedTarget.dataset.jobName,
          date: target.dataset.date,
          time: target.dataset.slotStart,
          dropCount: dropCounter
        });
        
        // Deduplicate drops
        if (dropId === lastDropId) {
          dropCounter.deduped++;
          console.log('[DND DEBUG] Duplicate drop detected and prevented', { dropId, dropCount: dropCounter });
          return;
        }
        
        lastDropId = dropId;
        
        const jobId = relatedTarget.dataset.jobId;
        const slotDate = target.dataset.date;
        const slotStart = target.dataset.slotStart;
        
        target.classList.remove('drop-active', 'dropzone-highlight');
        relatedTarget.classList.remove('can-drop');
        
        if (jobId && slotDate && slotStart) {
          createShift(jobId, slotDate, slotStart);
        } else {
          console.error('[DND DEBUG] Missing required data for shift creation', {
            jobId,
            slotDate,
            slotStart
          });
        }
      },
      
      ondropdeactivate: function(event) {
        console.log('[DND DEBUG] Dropzone deactivated', {
          target: event.target.dataset.date + ' ' + event.target.dataset.slotStart
        });
        event.target.classList.remove('drop-active', 'dropzone-highlight');
      }
    });
}

async function createShift(jobId, date, startTime) {
  console.log('[DND DEBUG] Creating shift:', { jobId, date, startTime });
  
  try {
    const response = await fetch('/managers/shifts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        shift: {
          job_id: jobId,
          start_date: date,
          start_time: startTime
        }
      })
    });
    
    if (response.ok) {
      console.log('[DND DEBUG] Shift created successfully');
      // Simple page reload for now - we can make this more sophisticated later
      window.location.reload();
    } else {
      console.error('[DND DEBUG] Failed to create shift:', response.status);
    }
  } catch (error) {
    console.error('[DND DEBUG] Error creating shift:', error);
  }
}

// Clean up event listener initialization
let initialized = false;

function initAll() {
  if (initialized) {
    console.log('[DND DEBUG] Already initialized, skipping');
    return;
  }
  
  console.log('[DND DEBUG] Initializing all drag and drop functionality');
  initJobPaletteDraggable();
  initDropZones();
  initSchedule();
  
  initialized = true;
}

// Remove multiple event listeners, just use turbo:load
document.removeEventListener('turbo:load', initAll);
document.removeEventListener('DOMContentLoaded', initAll);
document.removeEventListener('turbo:render', initAll);

document.addEventListener('turbo:load', () => {
  console.log('[DND DEBUG] turbo:load triggered, resetting initialization state');
  initialized = false;
  initAll();
});

// Initial load only if needed
if (document.readyState !== 'loading' && !initialized) {
  console.log('[DND DEBUG] Document already loaded, initializing once');
  initAll();
}
