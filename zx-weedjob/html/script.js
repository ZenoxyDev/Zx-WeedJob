window.addEventListener('message', function(event) {
    if (event.data.action === 'startProgressBar') {
        startProgressBar(event.data.duration);
    } else if (event.data.action === 'cancelProgressBar') {
        cancelProgressBar();
    }
});

function startProgressBar(duration) {
    const progressBar = document.getElementById('progress-bar');
    const progressContainer = document.getElementById('progress-container');
    const progressText = document.getElementById('progress-text');

    progressText.innerText = 'İşlem Devam Ediyor..';
    progressContainer.style.display = 'block';
    progressBar.style.width = '0';

    setTimeout(() => {
        progressBar.style.width = '100%';
    }, 100);

    setTimeout(() => {
        progressBar.style.width = '0';
        progressContainer.style.display = 'none';
    }, duration);
}

function cancelProgressBar() {
    const progressBar = document.getElementById('progress-bar');
    const progressContainer = document.getElementById('progress-container');
    const progressText = document.getElementById('progress-text');

    progressText.innerText = 'İptal Edildi';
    progressBar.style.width = '0';
    setTimeout(() => {
        progressContainer.style.display = 'none';
    }, 2000);
}
