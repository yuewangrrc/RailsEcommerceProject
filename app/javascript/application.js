// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Ensure Bootstrap dropdowns work with Turbo
document.addEventListener("turbo:load", function() {
  // Re-initialize Bootstrap dropdowns after Turbo navigation
  if (typeof bootstrap !== 'undefined') {
    const dropdowns = document.querySelectorAll('.dropdown-toggle');
    dropdowns.forEach(function(dropdown) {
      new bootstrap.Dropdown(dropdown);
    });
  }
});

// Fallback: Re-initialize on DOM content loaded
document.addEventListener("DOMContentLoaded", function() {
  if (typeof bootstrap !== 'undefined') {
    const dropdowns = document.querySelectorAll('.dropdown-toggle');
    dropdowns.forEach(function(dropdown) {
      new bootstrap.Dropdown(dropdown);
    });
  }
});
