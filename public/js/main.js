document.addEventListener('DOMContentLoaded', function () {
    const hamburger = document.querySelector('.hamburger');
    const sidebar = document.querySelector('.sidebar');
  
    hamburger.addEventListener('click', function () {
      sidebar.classList.toggle('hidden');
      
    });
  });
  