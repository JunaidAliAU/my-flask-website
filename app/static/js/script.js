document.addEventListener('DOMContentLoaded', function() {
    // Set initial active section
    showSection('home');
    
    // Update status
    updateStatus();
});

function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Show selected section
    document.getElementById(sectionId).classList.add('active');
    
    // Update active nav link
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${sectionId}`) {
            link.classList.add('active');
        }
    });
}

async function fetchData() {
    try {
        const response = await fetch('/api/hello');
        const data = await response.json();
        
        const apiResponse = document.getElementById('api-response');
        apiResponse.innerHTML = `
            <h3>API Response:</h3>
            <p><strong>Message:</strong> ${data.message}</p>
            <p><strong>Status:</strong> ${response.status}</p>
            <p><strong>Timestamp:</strong> ${new Date().toLocaleString()}</p>
        `;
        apiResponse.classList.add('show');
    } catch (error) {
        const apiResponse = document.getElementById('api-response');
        apiResponse.innerHTML = `
            <h3>Error:</h3>
            <p>${error.message}</p>
        `;
        apiResponse.classList.add('show');
    }
}

function updateStatus() {
    // Simulate status check
    setInterval(() => {
        fetch('/api/hello')
            .then(response => {
                const statusElement = document.querySelector('.status-online');
                if (response.ok) {
                    statusElement.textContent = 'Online';
                    statusElement.style.color = '#4CAF50';
                } else {
                    statusElement.textContent = 'Offline';
                    statusElement.style.color = '#f44336';
                }
            })
            .catch(() => {
                const statusElement = document.querySelector('.status-online');
                statusElement.textContent = 'Offline';
                statusElement.style.color = '#f44336';
            });
    }, 30000); // Check every 30 seconds
}