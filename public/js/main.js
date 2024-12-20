// Ensure the DOM is fully loaded before running scripts
document.addEventListener('DOMContentLoaded', function () {
  // Hamburger Menu Toggle
  const hamburger = document.querySelector('.hamburger');
  const sidebar = document.querySelector('.sidebar');

  if (hamburger && sidebar) {
    hamburger.addEventListener('click', function () {
      sidebar.classList.toggle('hidden');
    });
  }

  // GSAP Animation for Hero Arrow
  gsap.fromTo(
    ".hero-arrow",
    { opacity: 0, y: -10 }, // Starting state
    { opacity: 1, y: 0, repeat: -1, yoyo: true, duration: 1 } // Repeating bounce animation
  );

  // GSAP Animation for "Hire Me" Button
  const hireMeButton = document.querySelector('.btn-hire-me');

  if (hireMeButton) {
    // Mouse enter animation
    hireMeButton.addEventListener('mouseenter', () => {
      gsap.to(hireMeButton, {
        backgroundColor: "#B8A58E", // Change background to beige
        color: "#fff",             // Change text color to white
        scale: 1.1,                // Slightly enlarge button
        duration: 0.3,             // Duration of animation
        ease: "power2.inOut"       // Smooth easing
      });
    });

    // Mouse leave animation
    hireMeButton.addEventListener('mouseleave', () => {
      gsap.to(hireMeButton, {
        backgroundColor: "transparent", // Reset background to transparent
        color: "#00bcd4",               // Reset text color to original
        scale: 1,                       // Reset button size
        duration: 0.3,                  // Duration of animation
        ease: "power2.inOut"            // Smooth easing
      });
    });
  }

  // Color Mode Toggle
  const toggleButton = document.querySelector('.color-mode-toggle');
  if (toggleButton) {
    toggleButton.addEventListener('click', () => {
      document.body.classList.toggle('colorscheme-light');
      document.body.classList.toggle('colorscheme-dark');
    });
  }
});
