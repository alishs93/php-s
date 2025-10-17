<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>بازی UNO</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700&display=swap');

    /* ----------------------- General & Layout Styles (Responsive) ----------------------- */
    body {
        font-family: 'Vazirmatn', sans-serif;
        background-color: #f0f2f5;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        min-height: 100vh;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        color: #333;
        overflow-x: hidden;
        overflow-y: hidden;
    }

    .game-container {
        background-color: #fff;
        border-radius: 0;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        padding: 10px;
        width: 100%;
        max-width: 1000px;
        display: flex;
        flex-direction: column;
        gap: 15px;
        min-height: 100vh;
    }

    h1 {
        display: none;
    }

    /* ----------------------- Card Base Styles (Standard Size) ----------------------- */
    .discard-pile .card, .draw-pile .card, .player-hand .card, .flying-card {
        width: 70px;
        height: 100px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        transition: transform 0.2s ease, box-shadow 0.2s ease, top 0.5s ease-in-out, left 0.5s ease-in-out, opacity 0.5s ease; /* Transitions for animation */
        user-select: none;
        position: relative; /* برای حرکت کارت‌ها نیاز به position داریم */
        background-size: cover;
        background-position: center;
        background-color: transparent;
        border: none;
        overflow: hidden;
        perspective: 1000px; /* برای انیمیشن 3D flip */
    }

    .card-image {
        width: 100%;
        height: 100%;
        object-fit: contain;
        border-radius: 8px;
        backface-visibility: hidden; /* جلوگیری از نمایش پشت تصویر در حین چرخش */
        transition: transform 0.5s ease; /* Transition برای flip */
    }

    /* AI Card Back */
    .ai-card-back {
        background-image: url('https://unocardinfo.victorhomedia.com/graphics/uno_card-back.png');
        background-size: cover;
        width: 60px;
        height: 90px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        position: relative; /* برای انیمیشن کشیدن کارت AI */
    }

    /* ----------------------- Flying Card Specific Styles ----------------------- */
    .flying-card {
        position: fixed; /* برای اینکه کارت روی همه چیز پرواز کند */
        z-index: 100;
        /* transition روی خود element تعریف شده */
    }

    /* Class for AI card flip */
    .flying-card.flipped .card-image {
        transform: rotateY(180deg);
    }

    /* ----------------------- AI Hand (Top Section) ----------------------- */
    .ai-area {
        display: flex;
        flex-direction: column;
        align-items: center;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }

    .ai-area h2 {
        font-size: 1em;
        margin-bottom: 5px;
    }

    .ai-hand {
        display: flex;
        justify-content: center;
        gap: 5px;
        min-height: 100px;
    }

    .ai-hand .card-count {
        padding: 6px 10px;
        font-size: 0.9em;
        margin-top: 5px;
    }

    /* ----------------------- Game Area (Center Section) ----------------------- */
    .game-area {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 20px;
        margin: 10px 0;
    }

    .card-pile p {
        font-weight: bold;
        color: #555;
        margin: 0 0 5px 0;
        font-size: 0.9em;
    }

    /* ----------------------- Status and Control ----------------------- */
    .game-status {
        margin: 10px 0;
        font-size: 1.2em;
        text-align: center;
    }

    .game-message {
        margin: 5px 0;
        font-size: 1em;
        min-height: 20px;
        text-align: center;
    }

    .action-buttons {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 10px;
    }

    .action-buttons button {
        padding: 10px 20px;
        font-size: 1em;
        font-weight: bold;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    #uno-button {
        background-color: #E74C3C;
        color: white;
        display: none;
    }

    #uno-button.active {
        display: block;
    }
    /* ----------------------- Player Hand (Bottom Section) ----------------------- */
    .player-hand-area {
        border-top: 1px solid #eee;
        padding-top: 10px;
    }

    .player-hand-area h2 {
        text-align: center;
        color: #4CAF50;
        margin-bottom: 5px;
        font-size: 1.2em;
    }

    .player-hand {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 8px;
        min-height: 110px;
    }

    .player-hand .card.unplayable {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }

    .player-hand .card:hover {
        transform: translateY(-8px) scale(1.05);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.25);
    }

    /* ----------------------- Modals (Color Picker, Game Over) ----------------------- */
    .modal {
        display: none;
        position: fixed;
        z-index: 100;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.6);
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background-color: #fefefe;
        margin: auto;
        padding: 30px;
        border-radius: 10px;
        width: 80%;
        max-width: 400px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        position: relative;
    }

    .color-options {
        display: flex;
        justify-content: space-around;
        gap: 10px;
        margin-top: 20px;
    }

    .color-option {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        cursor: pointer;
        border: 4px solid transparent;
        transition: border-color 0.2s ease, transform 0.2s ease;
    }

    .color-option.red { background-color: #E74C3C; }
    .color-option.blue { background-color: #3498DB; }
    .color-option.green { background-color: #2ECC71; }
    .color-option.yellow { background-color: #F1C40F; }

    .game-over-modal {
        display: none;
        position: fixed;
        z-index: 200;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0,0,0,0.7);
        justify-content: center;
        align-items: center;
    }

    .game-over-content {
        background-color: #fefefe;
        padding: 40px;
        border-radius: 15px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        width: 90%;
        max-width: 500px;
    }

    /* ----------------------- Responsive Adjustments (Mobile) ----------------------- */
    @media (max-width: 600px) {
        .game-container {
            padding: 5px;
            gap: 10px;
        }

        .discard-pile .card, .draw-pile .card, .player-hand .card, .flying-card {
            width: 55px;
            height: 80px;
            border-radius: 6px;
        }

        .ai-card-back {
            width: 50px;
            height: 75px;
        }

        .player-hand {
            gap: 5px;
        }

        .game-status {
            font-size: 1em;
        }

        .game-message {
            font-size: 0.9em;
        }

        .action-buttons button {
            padding: 8px 15px;
            font-size: 0.9em;
        }
    }
</style>
</head>
<body>
    <div class="game-container">
        <h1>بازی UNO</h1>

        <div class="ai-area">
            <h2 id="ai-hand-status">دست حریف (0 کارت)</h2>
            <div class="ai-hand" id="ai-hand">
                </div>
        </div>

        <div class="game-status" id="game-status">نوبت: شما</div>

        <div class="game-area">
            <div class="card-pile discard-pile">
                <p>کارت رو شده</p>
                <div id="discard-pile-card" class="card"></div>
            </div>
            <div class="card-pile draw-pile">
                <p>کارت کشیدن</p>
                <div id="draw-pile-card" class="card" onclick="drawCard()">
                    <img class="card-image" src="https://unocardinfo.victorhomedia.com/graphics/uno_card-back.png" alt="کارت کشیدن">
                </div>
            </div>
        </div>

        <div class="game-message" id="game-message"></div>
        
        <div class="action-buttons">
            <button id="uno-button" onclick="declareUno()">UNO!</button>
        </div>

        <div class="player-hand-area">
            <h2>دست شما</h2>
            <div class="player-hand" id="player-hand">
                </div>
        </div>
    </div>

    <div id="color-picker-modal" class="modal">
        <div class="modal-content">
            <h3>انتخاب رنگ جدید</h3>
            <div class="color-options">
                <div class="color-option red" onclick="chooseColor('red')"></div>
                <div class="color-option blue" onclick="chooseColor('blue')"></div>
                <div class="color-option green" onclick="chooseColor('green')"></div>
                <div class="color-option yellow" onclick="chooseColor('yellow')"></div>
            </div>
        </div>
    </div>

    <div id="game-over-modal" class="game-over-modal">
        <div class="game-over-content">
            <h2 id="game-over-title"></h2>
            <p id="game-over-message"></p>
            <button onclick="restartGame()">شروع مجدد</button>
        </div>
    </div>

<script>
    const COLORS = ['red', 'blue', 'green', 'yellow'];
    const VALUES = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'skip', 'reverse', 'draw2'];
    const WILD_CARDS = ['wild', 'wildDraw4'];

    let deck = [];
    let playerHand = [];
    let aiHand = [];
    let discardPile = [];
    let currentPlayer = 'player';
    let gameActive = true;
    let unoDeclared = false;
    let unoChallengeTimeout;
    let pendingWildCard = null;

    const IMAGE_BASE_URL = 'https://unocardinfo.victorhomedia.com/graphics/uno_card-';

    const playerHandDiv = document.getElementById('player-hand');
    const aiHandDiv = document.getElementById('ai-hand');
    const discardPileCardDiv = document.getElementById('discard-pile-card');
    const gameStatusDiv = document.getElementById('game-status');
    const gameMessageDiv = document.getElementById('game-message');
    const unoButton = document.getElementById('uno-button');
    const colorPickerModal = document.getElementById('color-picker-modal');
    const gameOverModal = document.getElementById('game-over-modal');
    const gameOverTitle = document.getElementById('game-over-title');
    const gameOverMessage = document.getElementById('game-over-message');
    const drawPileCardDiv = document.getElementById('draw-pile-card'); // اضافه شده برای Draw Pile

    // --- تابع جدید برای نمایش پیام و ذخیره در کنسول ---
    function displayGameMessage(message) {
        console.log("Game Message: " + message);
        gameMessageDiv.textContent = message;
    }

    // ----------------------- Card Rendering Logic -----------------------

    function getCardImageUrl(card) {
        if (card.value === 'wildDraw4') {
            return `${IMAGE_BASE_URL}wilddraw4.png`;
        }
        if (card.value === 'wild') {
            return `${IMAGE_BASE_URL}wildchange.png`;
        }
        
        let type = '';
        switch (card.value) {
            case 'skip': type = 'skip'; break;
            case 'reverse': type = 'reverse'; break;
            case 'draw2': type = 'draw2'; break; 
            default: type = card.value;
        }
        
        const color = card.chosenColor || card.color; 
        
        return `${IMAGE_BASE_URL}${color}${type}.png`;
    }

    function renderCard(card, isPlayerCard = true) {
        const cardDiv = document.createElement('div');
        // ID منحصر به فرد برای انیمیشن‌ها
        cardDiv.id = `card-${card.color}-${card.value}-${Date.now()}-${Math.random().toString(36).substring(7)}`; 
        cardDiv.className = `card`;
        cardDiv.dataset.color = card.color;
        cardDiv.dataset.value = card.value;

        const imageUrl = getCardImageUrl(card);
        
        const cardImage = document.createElement('img');
        cardImage.className = 'card-image';
        cardImage.src = imageUrl;
        cardImage.alt = getFarsiCardName(card);
        cardDiv.appendChild(cardImage);

        if (isPlayerCard) {
            cardDiv.onclick = () => playCard(cardDiv.dataset.color, cardDiv.dataset.value, cardDiv.id); // ارسال ID کارت
            if (!canPlay(card)) {
                cardDiv.classList.add('unplayable');
            }
        }
        return cardDiv;
    }

    function renderGame() {
        // Render discard pile
        const topCard = discardPile[discardPile.length - 1];
        discardPileCardDiv.innerHTML = '';
        const topCardImage = document.createElement('img');
        topCardImage.className = 'card-image';
        topCardImage.src = getCardImageUrl(topCard); 
        topCardImage.alt = getFarsiCardName(topCard);
        discardPileCardDiv.appendChild(topCardImage);

        // Render player's hand
        playerHandDiv.innerHTML = '';
        playerHand.forEach(card => playerHandDiv.appendChild(renderCard(card)));

        // Render AI's hand (just card backs)
        aiHandDiv.innerHTML = '';
        aiHand.forEach(() => {
            const aiCardBack = document.createElement('div');
            aiCardBack.className = 'ai-card-back';
            aiHandDiv.appendChild(aiCardBack);
        });
        
        const aiCount = document.createElement('div');
        aiCount.className = 'card-count';
        aiCount.textContent = `${aiHand.length} کارت`;
        aiHandDiv.appendChild(aiCount);

        document.getElementById('ai-hand-status').textContent = `دست حریف (${aiHand.length} کارت)`;

        if (playerHand.length === 2 && currentPlayer === 'player') {
            unoButton.classList.add('active');
        } else {
            unoButton.classList.remove('active');
        }
    }
    
    // ----------------------- Core Game Logic -----------------------
    function createDeck() {
        let newDeck = [];
        COLORS.forEach(color => {
            newDeck.push({ color, value: '0' });
            for (let i = 1; i <= 9; i++) {
                newDeck.push({ color, value: String(i) });
                newDeck.push({ color, value: String(i) });
            }
            VALUES.slice(10).forEach(value => {
                newDeck.push({ color, value });
                newDeck.push({ color, value });
            });
        });
        for (let i = 0; i < 4; i++) {
            newDeck.push({ color: 'wild', value: 'wild' });
            newDeck.push({ color: 'wild', value: 'wildDraw4' });
        }
        return newDeck;
    }

    function shuffleDeck(deckToShuffle) {
        for (let i = deckToShuffle.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [deckToShuffle[i], deckToShuffle[j]] = [deckToShuffle[j], deckToShuffle[i]];
        }
        return deckToShuffle;
    }

    function dealCards() {
        playerHand = [];
        aiHand = [];
        for (let i = 0; i < 7; i++) {
            playerHand.push(deck.pop());
            aiHand.push(deck.pop());
        }
    }

    function drawCardFromDeck() {
        if (deck.length === 0) {
            if (discardPile.length <= 1) {
                displayGameMessage('کارت‌های کافی برای ادامه بازی نیست! بازی تمام شد.');
                endGame('draw');
                return null;
            }
            const currentTopCard = discardPile.shift();
            deck = shuffleDeck(discardPile);
            discardPile = [currentTopCard];
            displayGameMessage('دسته کارت کشیدن دوباره پر شد!');
        }
        return deck.pop();
    }

    function initializeGame() {
        deck = createDeck();
        shuffleDeck(deck);
        dealCards();
        discardPile = [];
        gameActive = true;
        unoDeclared = false;
        clearTimeout(unoChallengeTimeout);
        pendingWildCard = null;
        currentPlayer = 'player';

        let firstCard = drawCardFromDeck();
        while (firstCard.color === 'wild') {
            deck.unshift(firstCard);
            shuffleDeck(deck);
            firstCard = drawCardFromDeck();
        }
        discardPile.push(firstCard);

        renderGame();
        updateGameStatus();
        displayGameMessage('بازی شروع شد!');
    }

    function updateGameStatus() {
        gameStatusDiv.textContent = currentPlayer === 'player' ? 'نوبت: شما' : 'نوبت: حریف';
    }

    function canPlay(card) {
        const topCard = discardPile[discardPile.length - 1];
        if (card.color === 'wild') return true;

        const effectiveColor = topCard.chosenColor || topCard.color;

        if (card.color === effectiveColor || card.value === topCard.value) return true;

        return false;
    }

    function applyCardEffect(card, player) {
        const opponentHand = player === 'player' ? aiHand : playerHand;
        const otherPlayer = player === 'player' ? 'ai' : 'player';

        switch (card.value) {
            case 'skip':
            case 'reverse':
                displayGameMessage(` نوبت ${otherPlayer === 'player' ? 'شما' : 'حریف'} رد شد!`);
                return false; 
            case 'draw2':
                displayGameMessage(` ${otherPlayer === 'player' ? 'شما' : 'حریف'} 2 کارت می‌کشد.`);
                opponentHand.push(drawCardFromDeck(), drawCardFromDeck());
                switchTurn(); 
                return false;
            case 'wildDraw4':
                displayGameMessage(` ${otherPlayer === 'player' ? 'شما' : 'حریف'} 4 کارت می‌کشد.`);
                opponentHand.push(drawCardFromDeck(), drawCardFromDeck(), drawCardFromDeck(), drawCardFromDeck());
                switchTurn(); 
                return false;
        }
        
        return true;
    }

    // --- تابع اصلاح شده playCard برای انیمیشن پرواز ---
    async function playCard(color, value, cardId) {
        if (!gameActive || currentPlayer !== 'player' || pendingWildCard) {
            displayGameMessage('هنوز نوبت شما نیست یا باید رنگ انتخاب کنید.');
            return;
        }

        const cardIndex = playerHand.findIndex(c => c.color === color && c.value === value);
        if (cardIndex === -1) { return; }

        const card = playerHand[cardIndex];
        if (!canPlay(card)) {
            displayGameMessage('شما نمی‌توانید این کارت را بازی کنید! باید با رنگ یا شماره کارت قبلی یکی باشد.');
            return;
        }

        // --- شروع انیمیشن ---
        const flyingCard = document.getElementById(cardId);
        if (!flyingCard) {
            console.error("Flying card not found:", cardId);
            return;
        }
        
        const discardPileRect = discardPileCardDiv.getBoundingClientRect();
        const startRect = flyingCard.getBoundingClientRect();

        // Clone the card for animation
        const animatedCard = flyingCard.cloneNode(true);
        animatedCard.classList.add('flying-card');
        animatedCard.style.left = `${startRect.left}px`;
        animatedCard.style.top = `${startRect.top}px`;
        animatedCard.style.width = `${startRect.width}px`;
        animatedCard.style.height = `${startRect.height}px`;
        animatedCard.style.position = 'fixed';
        document.body.appendChild(animatedCard);

        // Hide original card immediately
        flyingCard.style.opacity = '0';
        flyingCard.style.pointerEvents = 'none';

        // Animate to discard pile
        requestAnimationFrame(() => {
            animatedCard.style.left = `${discardPileRect.left}px`;
            animatedCard.style.top = `${discardPileRect.top}px`;
            animatedCard.style.transform = `scale(1.1) rotate(0deg)`; // کمی بزرگتر و بدون چرخش
            animatedCard.style.opacity = '1';
        });

        // Wait for animation to finish
        await new Promise(resolve => setTimeout(resolve, 500)); // مدت زمان انیمیشن در CSS

        playerHand.splice(cardIndex, 1);
        delete card.chosenColor; 
        discardPile.push(card);
        displayGameMessage(`شما ${getFarsiCardName(card)} را بازی کردید.`);
        clearTimeout(unoChallengeTimeout);

        document.body.removeChild(animatedCard); // حذف کارت متحرک
        renderGame(); // رندر مجدد دست بازیکن و کارت Discard Pile

        if (playerHand.length === 1 && !unoDeclared) {
            startUnoChallenge('player');
        } else if (playerHand.length !== 1) {
            unoDeclared = false;
        }

        if (playerHand.length === 0) {
            endGame('player');
            return;
        }

        if (card.color === 'wild') {
            pendingWildCard = card;
            showColorPickerModal();
        } else {
            const shouldSwitch = applyCardEffect(card, 'player');
            if (shouldSwitch) {
                switchTurn();
            } else {
                renderGame(); 
                gameStatusDiv.textContent = 'نوبت: شما (مجدد)';
            }
        }
    }

    // --- تابع اصلاح شده drawCard برای انیمیشن ---
    async function drawCard() {
        if (!gameActive || currentPlayer !== 'player' || pendingWildCard) {
            displayGameMessage('هنوز نوبت شما نیست!');
            return;
        }

        const drawnCardData = drawCardFromDeck();
        if (!drawnCardData) return; // اگر کارتی برای کشیدن نیست

        // --- شروع انیمیشن کشیدن کارت ---
        const drawPileRect = drawPileCardDiv.getBoundingClientRect();
        const playerHandRect = playerHandDiv.getBoundingClientRect();

        // ایجاد یک کارت "پرنده" برای انیمیشن
        const animatedCard = document.createElement('div');
        animatedCard.className = `card flying-card`;
        animatedCard.style.left = `${drawPileRect.left}px`;
        animatedCard.style.top = `${drawPileRect.top}px`;
        animatedCard.style.width = `${drawPileRect.width}px`;
        animatedCard.style.height = `${drawPileRect.height}px`;
        animatedCard.style.opacity = '1';

        const cardImage = document.createElement('img');
        cardImage.className = 'card-image';
        cardImage.src = 'https://unocardinfo.victorhomedia.com/graphics/uno_card-back.png'; // کارت پشت
        animatedCard.appendChild(cardImage);
        document.body.appendChild(animatedCard);

        // انیمیشن پرواز
        requestAnimationFrame(() => {
            // مقصد نهایی کارت را به مرکز دست بازیکن یا جایی نزدیک آن تنظیم می‌کنیم.
            const targetLeft = playerHandRect.left + playerHandRect.width / 2 - animatedCard.offsetWidth / 2;
            const targetTop = playerHandRect.bottom - animatedCard.offsetHeight / 2;

            animatedCard.style.left = `${targetLeft}px`;
            animatedCard.style.top = `${targetTop}px`;
            animatedCard.style.transform = `scale(0.8) rotate(360deg)`; // کمی کوچکتر با چرخش
            animatedCard.style.opacity = '1';
        });

        await new Promise(resolve => setTimeout(resolve, 500)); // صبر برای اتمام انیمیشن

        document.body.removeChild(animatedCard); // حذف کارت متحرک
        
        playerHand.push(drawnCardData);
        displayGameMessage(`شما یک کارت کشیدید. (${getFarsiCardName(drawnCardData)})`);
        
        if (canPlay(drawnCardData)) {
            gameMessageDiv.textContent += ' می‌توانید آن را بازی کنید.';
        } else {
            switchTurn();
        }
        renderGame();
    }

    function switchTurn() {
        clearTimeout(unoChallengeTimeout);
        unoDeclared = false;
        if (!gameActive) return;

        currentPlayer = (currentPlayer === 'player') ? 'ai' : 'player';
        updateGameStatus();
        if (currentPlayer === 'ai') {
            displayGameMessage('نوبت حریف است...');
            setTimeout(aiTurn, 1500); // افزایش زمان برای انیمیشن AI
        } else {
            displayGameMessage('نوبت شماست.');
            renderGame();
        }
    }

    function chooseColor(chosenColor) {
        colorPickerModal.style.display = 'none';
        if (pendingWildCard) {
            pendingWildCard.chosenColor = chosenColor; 
            discardPile[discardPile.length - 1].chosenColor = chosenColor; 
            renderGame(); 

            displayGameMessage(` رنگ به ${getFarsiColorName(chosenColor)} تغییر کرد.`); // استفاده از displayGameMessage
            // این خط را از gameMessageDiv.textContent += حذف کنید تا پیام دوبار تکرار نشود.

            const shouldSwitch = applyCardEffect(pendingWildCard, 'player');
            pendingWildCard = null;

            if (playerHand.length === 0) {
                endGame('player');
            } else if (shouldSwitch) {
                switchTurn();
            } else {
                renderGame(); 
                gameStatusDiv.textContent = 'نوبت: شما (مجدد)';
            }
        }
    }
    
    function showColorPickerModal() {
        colorPickerModal.style.display = 'flex';
    }

    // --- تابع اصلاح شده aiTurn برای انیمیشن و Flip کارت ---
    async function aiTurn() {
        if (!gameActive) return;

        const topCard = discardPile[discardPile.length - 1];
        let playableCards = aiHand.filter(card => canPlay(card));
        let cardToPlay = null;

        // ... (منطق انتخاب کارت AI - بدون تغییر عمده) ...
        if (aiHand.length === 2) {
            const winningCards = playableCards.filter(card => !['draw2', 'wildDraw4'].includes(card.value));
            if (winningCards.length > 0) cardToPlay = winningCards[0];
        } else if (aiHand.length === 1 && playableCards.length > 0) {
            cardToPlay = playableCards[0];
        }

        if (!cardToPlay && playerHand.length === 1 && !unoDeclared) {
             const blockingCards = playableCards.filter(card =>
                ['draw2', 'wildDraw4', 'skip', 'reverse'].includes(card.value)
            );
            if (blockingCards.length > 0) cardToPlay = blockingCards[0];
        }

        if (!cardToPlay) {
            const actionCards = playableCards.filter(card =>
                ['skip', 'reverse', 'draw2'].includes(card.value) && card.color !== 'wild'
            );
            if (actionCards.length > 0) cardToPlay = actionCards[0];
        }

        if (!cardToPlay && playerHand.length <= 3) {
             const wildDraw4 = playableCards.find(card => card.value === 'wildDraw4');
             if (wildDraw4) cardToPlay = wildDraw4;
        }

        if (!cardToPlay) {
            const regularCards = playableCards.filter(card => !WILD_CARDS.includes(card.value));
            if (regularCards.length > 0) cardToPlay = regularCards[0];
        }

        if (!cardToPlay && playableCards.length > 0) {
            const wildCard = playableCards.find(card => card.value === 'wild');
            if (wildCard) cardToPlay = wildCard;
        }

        // --- AI Action ---
        if (cardToPlay) {
            const cardIndex = aiHand.findIndex(c => c === cardToPlay);
            aiHand.splice(cardIndex, 1); // کارت از دست AI حذف می‌شود

            // --- شروع انیمیشن کارت AI ---
            const aiCardBacks = aiHandDiv.querySelectorAll('.ai-card-back');
            const flyingCardElement = aiCardBacks[cardIndex]; // فرض می‌کنیم کارت حذف شده، آخرین کارت در دست AI باشد یا هر کارت دیگری
            
            if (!flyingCardElement) {
                console.error("AI flying card element not found.");
                renderGame(); // fallback to render
                return;
            }

            const discardPileRect = discardPileCardDiv.getBoundingClientRect();
            const startRect = flyingCardElement.getBoundingClientRect();

            const animatedCard = document.createElement('div');
            animatedCard.className = `card flying-card`;
            animatedCard.style.left = `${startRect.left}px`;
            animatedCard.style.top = `${startRect.top}px`;
            animatedCard.style.width = `${startRect.width}px`;
            animatedCard.style.height = `${startRect.height}px`;
            animatedCard.style.opacity = '1';
            animatedCard.style.position = 'fixed'; // برای حرکت روی صفحه

            const cardImage = document.createElement('img');
            cardImage.className = 'card-image';
            cardImage.src = getCardImageUrl(cardToPlay); // تصویر روی کارت
            animatedCard.appendChild(cardImage);
            document.body.appendChild(animatedCard);

            // انیمیشن چرخاندن کارت (flip)
            animatedCard.classList.add('flipped');

            // انیمیشن پرواز
            requestAnimationFrame(() => {
                animatedCard.style.left = `${discardPileRect.left}px`;
                animatedCard.style.top = `${discardPileRect.top}px`;
                animatedCard.style.transform = `scale(1.1) rotateY(180deg) rotate(0deg)`; // چرخش کامل و کمی بزرگتر
                animatedCard.style.opacity = '1';
            });

            await new Promise(resolve => setTimeout(resolve, 1000)); // صبر برای انیمیشن

            document.body.removeChild(animatedCard); // حذف کارت متحرک
            delete cardToPlay.chosenColor;
            discardPile.push(cardToPlay);
            displayGameMessage(`حریف ${getFarsiCardName(cardToPlay)} را بازی کرد.`);
            renderGame(); // رندر مجدد دست AI و کارت Discard Pile

            if (aiHand.length === 1) {
                unoDeclared = true;
                displayGameMessage('حریف UNO گفت!');
            } else if (aiHand.length !== 1) {
                unoDeclared = false;
            }

            if (aiHand.length === 0) {
                endGame('ai');
                return;
            }

            if (cardToPlay.color === 'wild') {
                const chosenColor = aiChooseColor();
                cardToPlay.chosenColor = chosenColor;
                discardPile[discardPile.length - 1].chosenColor = chosenColor; 
                displayGameMessage(` رنگ به ${getFarsiColorName(chosenColor)} تغییر کرد.`);
                
                await new Promise(resolve => setTimeout(resolve, 500)); // کمی مکث
                const shouldSwitch = applyCardEffect(cardToPlay, 'ai');
                if (shouldSwitch) {
                    switchTurn();
                } else {
                    setTimeout(aiTurn, 1000); 
                    gameStatusDiv.textContent = 'نوبت: حریف (مجدد)';
                }
            } else {
                await new Promise(resolve => setTimeout(resolve, 500)); // کمی مکث
                const shouldSwitch = applyCardEffect(cardToPlay, 'ai');
                if (shouldSwitch) {
                    switchTurn();
                } else {
                    setTimeout(aiTurn, 1000);
                    gameStatusDiv.textContent = 'نوبت: حریف (مجدد)';
                }
            }
        } else {
            // AI must draw
            // --- انیمیشن کشیدن کارت AI ---
            const drawPileRect = drawPileCardDiv.getBoundingClientRect();
            const aiHandRect = aiHandDiv.getBoundingClientRect();

            const animatedCard = document.createElement('div');
            animatedCard.className = `card flying-card`;
            animatedCard.style.left = `${drawPileRect.left}px`;
            animatedCard.style.top = `${drawPileRect.top}px`;
            animatedCard.style.width = `${drawPileRect.width}px`;
            animatedCard.style.height = `${drawPileRect.height}px`;
            animatedCard.style.opacity = '1';

            const cardImage = document.createElement('img');
            cardImage.className = 'card-image';
            cardImage.src = 'https://unocardinfo.victorhomedia.com/graphics/uno_card-back.png'; // کارت پشت
            animatedCard.appendChild(cardImage);
            document.body.appendChild(animatedCard);

            requestAnimationFrame(() => {
                const targetLeft = aiHandRect.left + aiHandRect.width / 2 - animatedCard.offsetWidth / 2;
                const targetTop = aiHandRect.top + aiHandRect.height / 2 - animatedCard.offsetHeight / 2;

                animatedCard.style.left = `${targetLeft}px`;
                animatedCard.style.top = `${targetTop}px`;
                animatedCard.style.transform = `scale(0.8) rotate(-360deg)`; // با چرخش برعکس
                animatedCard.style.opacity = '1';
            });

            await new Promise(resolve => setTimeout(resolve, 500)); // صبر برای اتمام انیمیشن

            document.body.removeChild(animatedCard); // حذف کارت متحرک
            
            const drawn = drawCardFromDeck();
            if (drawn) {
                aiHand.push(drawn);
                displayGameMessage(`حریف کارت کشید. (${getFarsiCardName(drawn)})`);
                if (canPlay(drawn)) {
                    gameMessageDiv.textContent += ' حریف کارت کشیده شده را بازی کرد.';
                    const playedDrawnCard = aiHand.pop();
                    delete playedDrawnCard.chosenColor;
                    discardPile.push(playedDrawnCard);

                     if (aiHand.length === 1) {
                        unoDeclared = true;
                        displayGameMessage('حریف UNO گفت!');
                    } else if (aiHand.length !== 1) {
                        unoDeclared = false;
                    }
                    
                    if (playedDrawnCard.color === 'wild') {
                        const chosenColor = aiChooseColor();
                        playedDrawnCard.chosenColor = chosenColor;
                        discardPile[discardPile.length - 1].chosenColor = chosenColor;
                        displayGameMessage(` رنگ به ${getFarsiColorName(chosenColor)} تغییر کرد.`);
                    }
                    
                    if (aiHand.length === 0) {
                        endGame('ai');
                        return;
                    }

                    await new Promise(resolve => setTimeout(resolve, 500)); // مکث برای خوانایی
                    const shouldSwitch = applyCardEffect(playedDrawnCard, 'ai');
                    if (shouldSwitch) {
                        switchTurn();
                    } else {
                        setTimeout(aiTurn, 1000);
                        gameStatusDiv.textContent = 'نوبت: حریف (مجدد)';
                    }

                } else {
                    await new Promise(resolve => setTimeout(resolve, 500)); // مکث برای خوانایی
                    switchTurn();
                }
            } else {
                switchTurn();
            }
            renderGame(); // رندر بعد از اتمام همه چیز
        }
    }
    
    function aiChooseColor() {
        const colorsInHand = aiHand.reduce((acc, card) => {
            if (COLORS.includes(card.color)) {
                acc[card.color] = (acc[card.color] || 0) + 1;
            }
            return acc;
        }, {});
        let bestColor = COLORS[0];
        let maxCount = -1;
        for (const color of COLORS) {
            const count = colorsInHand[color] || 0;
            if (count > maxCount) {
                maxCount = count;
                bestColor = color;
            }
        }
        return bestColor;
    }

    function declareUno() {
        if (playerHand.length === 1 && currentPlayer === 'player') {
            unoDeclared = true;
            displayGameMessage('شما UNO گفتید!');
            clearTimeout(unoChallengeTimeout);
            unoButton.classList.remove('active');
        } else {
            displayGameMessage('شما نمی‌توانید UNO بگویید مگر اینکه یک کارت داشته باشید!');
        }
    }

    function startUnoChallenge(player) {
        if (player === 'player') {
            unoChallengeTimeout = setTimeout(() => {
                if (!unoDeclared && playerHand.length === 1) {
                    displayGameMessage('حریف شما را در UNO نگفتن گرفت! 2 کارت جریمه می‌کشید.');
                    playerHand.push(drawCardFromDeck(), drawCardFromDeck());
                    renderGame();
                }
                unoDeclared = false;
            }, 3000);
        }
    }


    function endGame(winner) {
        gameActive = false;
        clearTimeout(unoChallengeTimeout);
        if (winner === 'player') {
            gameOverTitle.textContent = 'تبریک! شما برنده شدید! 🏆';
            gameOverMessage.textContent = 'شما تمام کارت‌های خود را با موفقیت بازی کردید.';
        } else if (winner === 'ai') {
            gameOverTitle.textContent = 'شما باختید! 😔';
            gameOverMessage.textContent = 'حریف تمام کارت‌های خود را زودتر بازی کرد.';
        } else {
            gameOverTitle.textContent = 'بازی به پایان رسید!';
            gameOverMessage.textContent = 'به دلیل اتمام کارت‌ها بازی متوقف شد.';
        }
        gameOverModal.style.display = 'flex';
    }

    function restartGame() {
        gameOverModal.style.display = 'none';
        initializeGame();
    }

    function getFarsiCardName(card) {
        const colorName = getFarsiColorName(card.color);
        let valueName;
        switch (card.value) {
            case '0': case '1': case '2': case '3': case '4':
            case '5': case '6': case '7': case '8': case '9':
                valueName = card.value;
                break;
            case 'skip': valueName = 'رد کردن نوبت (🚫)'; break;
            case 'reverse': valueName = 'تغییر جهت (🔄)'; break;
            case 'draw2': valueName = 'کشیدن 2 کارت (+2)'; break;
            case 'wild': valueName = 'کارت وحشی'; break;
            case 'wildDraw4': valueName = 'کارت وحشی کشیدن 4 (+4)'; break;
            default: valueName = card.value;
        }
        if (card.color === 'wild') {
            return valueName;
        }
        return `${valueName} ${colorName}`;
    }

    function getFarsiColorName(color) {
        switch (color) {
            case 'red': return 'قرمز';
            case 'blue': return 'آبی';
            case 'green': return 'سبز';
            case 'yellow': return 'زرد';
            case 'wild': return 'وحشی';
            default: return color;
        }
    }

    initializeGame();

    // ----------------------- MutationObserver for Game Messages -----------------------
    if (gameMessageDiv) {
        const config = { childList: true, subtree: true, characterData: true };
        const callback = function(mutationsList, observer) {
            for(const mutation of mutationsList) {
                const message = gameMessageDiv.textContent.trim();
                if (message && message !== lastLoggedMessage) {
                    console.log("Game Message (Observer): " + message);
                    lastLoggedMessage = message;
                }
            }
        };

        const observer = new MutationObserver(callback);
        observer.observe(gameMessageDiv, config);
        let lastLoggedMessage = "";
        
        console.log("Game message logging setup complete.");
    }
    // ----------------------------------------------------------------------------------
</script>
</body>
</html>