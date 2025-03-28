$(document).ready(function() {
    const circle = document.querySelector('.progress-ring__circle');
    const text = document.querySelector('.progress-text');
    const fishContainer = document.querySelector('.fish-container');
    const radius = circle.r.baseVal.value;
    const circumference = radius * 2 * Math.PI;
    
    circle.style.strokeDasharray = `${circumference} ${circumference}`;
    circle.style.strokeDashoffset = circumference;
    
    let progress = 0;
    let progressInterval;
    let fishingState = 'waiting'; // waiting, ready, caught
    
    function setProgress(percent) {
        const offset = circumference - (percent / 100 * circumference);
        circle.style.strokeDashoffset = offset;
        text.textContent = `${Math.round(percent)}%`;
    }
    
    function showFish() {
        fishContainer.classList.add('show');
        document.querySelector('.fishing-progress').classList.add('catch-ready');
        fishingState = 'ready';
    }
    
    function hideFish() {
        fishContainer.classList.remove('show');
        document.querySelector('.fishing-progress').classList.remove('catch-ready');
        fishingState = 'waiting';
    }
    
    window.addEventListener('message', function(event) {
        if (event.data.type === "ui") {
            if (event.data.status) {
                $('#container').fadeIn();
                progress = 0;
                setProgress(0);
                fishingState = 'waiting';
                hideFish();
                
                // Her 50ms'de bir progress'i artır
                progressInterval = setInterval(() => {
                    progress += 0.5;
                    setProgress(progress);
                    
                    if (progress >= 100) {
                        clearInterval(progressInterval);
                        hideFish();
                        $.post('https://qb-fishing/minigameCompleted', JSON.stringify({
                            success: false
                        }));
                    }
                }, 50);
            } else {
                $('#container').fadeOut();
                if (progressInterval) {
                    clearInterval(progressInterval);
                }
                hideFish();
            }
        } else if (event.data.type === "showFish") {
            if (event.data.status) {
                showFish();
            } else {
                hideFish();
            }
        }
    });
    
    // Tuş kontrolleri
    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // ESC
            $.post('https://qb-fishing/exit', JSON.stringify({}));
        } else if (e.keyCode === 69) { // E tuşu
            if (fishingState === 'ready') {
                clearInterval(progressInterval);
                fishingState = 'caught';
                // Yakalama animasyonu
                fishContainer.style.animation = 'none';
                void fishContainer.offsetWidth;
                fishContainer.style.animation = 'readyToCatch 0.5s ease-in-out';
                
                setTimeout(() => {
                    $.post('https://qb-fishing/minigameCompleted', JSON.stringify({
                        success: true
                    }));
                }, 500);
            } else if (fishingState === 'waiting') {
                // Erken basarsa ceza
                clearInterval(progressInterval);
                $.post('https://qb-fishing/minigameCompleted', JSON.stringify({
                    success: false
                }));
            }
        }
    });
}); 