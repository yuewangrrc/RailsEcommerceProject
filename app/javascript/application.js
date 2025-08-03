// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Simple and reliable dropdown handling
document.addEventListener('click', function(e) {
  // Handle dropdown toggle clicks
  if (e.target.matches('.dropdown-toggle') || e.target.closest('.dropdown-toggle')) {
    e.preventDefault();
    e.stopPropagation();
    
    const toggle = e.target.matches('.dropdown-toggle') ? e.target : e.target.closest('.dropdown-toggle');
    const dropdown = toggle.closest('.dropdown');
    const menu = dropdown.querySelector('.dropdown-menu');
    
    // Close all other open dropdowns
    document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
      if (otherMenu !== menu) {
        otherMenu.style.display = 'none';
        const otherToggle = otherMenu.previousElementSibling;
        if (otherToggle) otherToggle.setAttribute('aria-expanded', 'false');
      }
    });
    
    // Toggle current dropdown
    if (menu.style.display === 'block') {
      menu.style.display = 'none';
      toggle.setAttribute('aria-expanded', 'false');
    } else {
      menu.style.display = 'block';
      toggle.setAttribute('aria-expanded', 'true');
    }
  }
  // Close all dropdowns when clicking outside
  else if (!e.target.closest('.dropdown')) {
    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
      menu.style.display = 'none';
      const toggle = menu.previousElementSibling;
      if (toggle) toggle.setAttribute('aria-expanded', 'false');
    });
  }
});
