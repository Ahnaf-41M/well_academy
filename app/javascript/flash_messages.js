function fadeOutFlashMessages() {
    const notice = document.getElementById('flash-notice');
    const alert = document.getElementById('flash-alert');

    if (notice) {
        setTimeout(() => {
            notice.classList.remove('show');
            notice.classList.add('fade');
            setTimeout(() => notice.remove(), 300); 
        }, 1000); 
    }

    if (alert) {
        setTimeout(() => {
            alert.classList.remove('show');
            alert.classList.add('fade');
            setTimeout(() => alert.remove(), 300);
        }, 1000); 
    }
}
fadeOutFlashMessages();
