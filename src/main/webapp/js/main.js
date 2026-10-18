/**
 * Digital Library and Recommendation System
 * Client-side Interactivity and Validation Utilities
 */

document.addEventListener('DOMContentLoaded', function () {
  // 1. User Badge Dropdown Toggle
  const userTrigger = document.querySelector('.user-badge-trigger');
  const dropdownPanel = document.querySelector('.dropdown-panel');

  if (userTrigger && dropdownPanel) {
    userTrigger.addEventListener('click', function (e) {
      e.stopPropagation();
      dropdownPanel.classList.toggle('show');
    });

    document.addEventListener('click', function (e) {
      if (!dropdownPanel.contains(e.target) && !userTrigger.contains(e.target)) {
        dropdownPanel.classList.remove('show');
      }
    });
  }

  // 2. Mobile Navigation Menu Toggle
  const mobileBtn = document.querySelector('.mobile-menu-btn');
  const navLinks = document.querySelector('.nav-links');

  if (mobileBtn && navLinks) {
    mobileBtn.addEventListener('click', function () {
      navLinks.classList.toggle('mobile-open');
    });
  }

  // 3. Auto-dismiss alerts after 5 seconds
  const alerts = document.querySelectorAll('.alert');
  alerts.forEach(function (alert) {
    setTimeout(function () {
      alert.style.transition = 'opacity 0.5s ease';
      alert.style.opacity = '0';
      setTimeout(function () {
        if (alert.parentNode) {
          alert.parentNode.removeChild(alert);
        }
      }, 500);
    }, 5000);
  });

  // 4. Auto-submit catalog filters on select change
  const autoFilterSelects = document.querySelectorAll('.catalog-filter-form select');
  autoFilterSelects.forEach(function (select) {
    select.addEventListener('change', function () {
      const form = select.closest('form');
      if (form) {
        form.submit();
      }
    });
  });

  // 5. Password Confirmation Validation on Registration
  const registerForm = document.querySelector('form.register-form');
  if (registerForm) {
    registerForm.addEventListener('submit', function (e) {
      const pwd = document.getElementById('password');
      const confirmPwd = document.getElementById('confirmPassword');
      if (pwd && confirmPwd && pwd.value !== confirmPwd.value) {
        e.preventDefault();
        alert('Passwords do not match. Please re-enter.');
        confirmPwd.focus();
      }
    });
  }

  // 6. Generic Modal Handlers
  window.openModal = function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.style.display = 'flex';
    }
  };

  window.closeModal = function (modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.style.display = 'none';
    }
  };

  // Close modals when clicking backdrop
  window.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-backdrop')) {
      e.target.style.display = 'none';
    }
  });
});
