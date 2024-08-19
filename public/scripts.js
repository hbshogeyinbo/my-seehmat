document.addEventListener('DOMContentLoaded', function() {
    const menuItems = document.querySelectorAll('.menu div');

    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            // Remove active class from all items
            menuItems.forEach(i => i.classList.remove('active'));

            // Add active class to clicked item
            item.classList.add('active');

            const sectionId = item.getAttribute('data-scroll');
            const section = document.getElementById(sectionId);

            if (section) {
                section.scrollIntoView({ behavior: 'smooth' });
            }
        });
    });
});
