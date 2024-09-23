// Visitor counter code
document.addEventListener('DOMContentLoaded', async function() {
    // URL of the API Gateway (use the correct URL for your API)
    const apiUrl = 'https://dtchx90qob.execute-api.eu-west-1.amazonaws.com/dev';

    // Function to send a POST request to the API Gateway
    async function incrementVisitorCount() {
        try {
            const response = await fetch(apiUrl, {
                method: 'POST',  // HTTP method
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.ok) {
                const data = await response.json();
                console.log('Visitor Count Incremented:', data);  // Log success
            } else {
                console.error('Error:', response.statusText);  // Handle errors
            }
        } catch (error) {
            console.error('Error:', error);  // Handle network errors
        }
    }

    // Call incrementVisitorCount when the page loads
    incrementVisitorCount();

    // Menu functionality code
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
