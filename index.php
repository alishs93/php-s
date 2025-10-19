<?php
// زمان سرور
date_default_timezone_set("Asia/Tehran");
$time = date("H:i:s");
?>
<!DOCTYPE html>
<html lang="fa">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>🌐 سایت علی‌سینا</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Vazirmatn', sans-serif;
      background: linear-gradient(135deg, #00b4db, #0083b0);
      color: white;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
      animation: gradientMove 8s infinite alternate;
    }

    @keyframes gradientMove {
      0% { background: linear-gradient(135deg, #00b4db, #0083b0); }
      100% { background: linear-gradient(135deg, #0083b0, #00b4db); }
    }

    h1 {
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
    }

    h2 {
      font-size: 1.3rem;
      opacity: 0.9;
    }

    .time {
      margin-top: 30px;
      padding: 10px 20px;
      background: rgba(255,255,255,0.1);
      border-radius: 15px;
      font-size: 1.1rem;
      backdrop-filter: blur(5px);
    }

    footer {
      position: absolute;
      bottom: 15px;
      font-size: 0.9rem;
      opacity: 0.7;
    }
  </style>
</head>
<body>
  <h1>👋 خوش اومدی به سایت علی‌سینا</h1>
  <h2>این صفحه با ❤️ و PHP ساخته شده!</h2>
  <div class="time">⏰ ساعت سرور: <?php echo $time; ?></div>
  <footer>Powered by PHP on Render.com</footer>
</body>
</html>
