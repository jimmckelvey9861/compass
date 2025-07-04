// Initialize the job filter functionality
document.addEventListener('DOMContentLoaded', function() {
  console.log('Job filter: DOMContentLoaded event fired');
  initJobFilter();
});

document.addEventListener('turbo:load', function() {
  console.log('Job filter: turbo:load event fired');
  initJobFilter();
});

document.addEventListener('turbo:render', function() {
  console.log('Job filter: turbo:render event fired');
  initJobFilter();
});

// Main initialization function
function initJobFilter() {
  console.log('Job filter: Initializing job filter');
  
  // Get required DOM elements
  const filterButton = document.getElementById('job-filter-button');
  const filterDropdown = document.getElementById('job-filter-dropdown');
  const allCheckbox = document.getElementById('job-filter-all');
  const jobItems = document.querySelectorAll('.job-filter-item');
  
  // Log element existence for debugging
  console.log('Job filter elements found:', {
    button: filterButton ? 'found' : 'missing',
    dropdown: filterDropdown ? 'found' : 'missing',
    allCheckbox: allCheckbox ? 'found' : 'missing',
    jobItems: jobItems.length
  });
  
  // Exit if required elements are missing
  if (!filterButton || !filterDropdown) {
    console.warn('Job filter: Required elements not found');
    return;
  }
  
  // Remove any existing event listeners (to avoid duplicates)
  filterButton.replaceWith(filterButton.cloneNode(true));
  // Get the fresh button reference after replacing
  const newFilterButton = document.getElementById('job-filter-button');
  
  // Toggle dropdown visibility on button click
  newFilterButton.addEventListener('click', function(event) {
    event.preventDefault();
    event.stopPropagation();
    
    // Toggle the hidden class
    const isHidden = filterDropdown.classList.contains('hidden');
    console.log('Job filter: Button clicked, dropdown was', isHidden ? 'hidden' : 'visible');
    
    // Toggle the dropdown
    if (isHidden) {
      filterDropdown.classList.remove('hidden');
      console.log('Job filter: Dropdown shown');
    } else {
      filterDropdown.classList.add('hidden');
      console.log('Job filter: Dropdown hidden');
    }
  });
  
  // Close dropdown when clicking outside
  document.addEventListener('click', function(event) {
    if (!newFilterButton.contains(event.target) && !filterDropdown.contains(event.target)) {
      if (!filterDropdown.classList.contains('hidden')) {
        console.log('Job filter: Outside click detected, closing dropdown');
        filterDropdown.classList.add('hidden');
      }
    }
  });
  
  // Handle "All" checkbox
  if (allCheckbox) {
    allCheckbox.addEventListener('change', function() {
      const isChecked = this.checked;
      console.log('Job filter: All checkbox changed to', isChecked ? 'checked' : 'unchecked');
      
      // Update all individual checkboxes
      jobItems.forEach(item => {
        const checkbox = item.querySelector('input[type="checkbox"]');
        if (checkbox) checkbox.checked = isChecked;
      });
      
      updateFilterState();
    });
  }
  
  // Handle individual job checkboxes
  jobItems.forEach(item => {
    const checkbox = item.querySelector('input[type="checkbox"]');
    if (checkbox) {
      checkbox.addEventListener('change', function(event) {
        // Get count of checked items before processing this change
        const checkedCount = getCheckedCount();
        console.log('Job filter: Job checkbox changed, currently', checkedCount, 'selected');
        
        // Prevent unchecking the last checkbox
        if (!this.checked && checkedCount <= 1) {
          console.log('Job filter: Prevented unchecking last item');
          event.preventDefault();
          this.checked = true;
          return;
        }
        
        updateFilterState();
      });
    }
  });
  
  // Helper function to count checked items
  function getCheckedCount() {
    let count = 0;
    jobItems.forEach(item => {
      const checkbox = item.querySelector('input[type="checkbox"]');
      if (checkbox && checkbox.checked) {
        count++;
      }
    });
    return count;
  }
  
  // Update filter based on checkbox states
  function updateFilterState() {
    const selectedJobIds = [];
    const totalJobs = jobItems.length;
    let selectedCount = 0;
    
    // Get selected job IDs
    jobItems.forEach(item => {
      const checkbox = item.querySelector('input[type="checkbox"]');
      const jobId = item.dataset.jobId;
      
      if (checkbox && checkbox.checked) {
        selectedJobIds.push(jobId);
        selectedCount++;
      }
    });
    
    console.log('Job filter: Selected', selectedCount, 'of', totalJobs, 'jobs');
    
    // Ensure at least one job is selected
    if (selectedCount === 0 && jobItems.length > 0) {
      // Force select the first job
      const firstItem = jobItems[0];
      const firstCheckbox = firstItem.querySelector('input[type="checkbox"]');
      if (firstCheckbox) {
        console.log('Job filter: Auto-selecting first job');
        firstCheckbox.checked = true;
        selectedJobIds.push(firstItem.dataset.jobId);
        selectedCount = 1;
      }
    }
    
    // Update button text
    if (selectedCount === totalJobs) {
      newFilterButton.textContent = 'Jobs: All';
    } else {
      newFilterButton.textContent = 'Jobs: Select';
    }
    
    // Update "All" checkbox state
    if (allCheckbox) {
      allCheckbox.checked = selectedCount === totalJobs;
    }
    
    // Apply filtering
    filterShifts(selectedJobIds);
  }
  
  // Filter shifts based on selected job IDs
  function filterShifts(selectedJobIds) {
    console.log('Job filter: Filtering shifts for job IDs:', selectedJobIds);
    const shiftBars = document.querySelectorAll('.bar-container');
    let visibleCount = 0;
    
    shiftBars.forEach(bar => {
      const jobId = bar.dataset.jobId;
      
      if (selectedJobIds.includes(jobId)) {
        bar.style.display = '';
        visibleCount++;
      } else {
        bar.style.display = 'none';
      }
    });
    
    console.log('Job filter: Showing', visibleCount, 'of', shiftBars.length, 'shifts');
    
    // Update layout
    updateScheduleLayout();
  }
  
  // Update schedule layout after filtering
  function updateScheduleLayout() {
    const scheduleEl = document.getElementById('scheduleGrid');
    const containerEl = document.getElementById('scheduleContainer');
    const headerEl = document.getElementById('scheduleHeader');
    
    if (!scheduleEl || !containerEl || !headerEl) {
      console.warn('Job filter: Schedule elements not found');
      return;
    }

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
  
  // Update shift bars after layout change
  function updateShiftBars() {
    const shiftBars = document.querySelectorAll('.bar-container');
    
    shiftBars.forEach(container => {
      // Skip hidden bars
      if (container.style.display === 'none') return;
      
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
  
  // Initialize on load
  setTimeout(() => {
    console.log('Job filter: Running initial state update');
    updateFilterState();
  }, 100);
  
  console.log('Job filter: Initialization complete');
}