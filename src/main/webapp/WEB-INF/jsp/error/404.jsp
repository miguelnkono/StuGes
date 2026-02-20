<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
  <title>404 — GesEtu</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Fraunces:opsz,wght@9..144,900&display=swap" rel="stylesheet">
  <script>tailwind.config={theme:{extend:{fontFamily:{display:['"Fraunces"','serif']}}}}</script>
  <style>
    html,body{font-family:'Plus Jakarta Sans',sans-serif;-webkit-font-smoothing:antialiased;}
    :root{--ease-spring:cubic-bezier(0.34,1.56,0.64,1);--ease-smooth:cubic-bezier(0.16,1,0.3,1);}
    @keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}
    @keyframes float{0%,100%{transform:translateY(0) rotate(-2deg)}50%{transform:translateY(-18px) rotate(2deg)}}
    @keyframes gradShift{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}
    .anim-fade-up{animation:fadeUp 0.55s var(--ease-smooth) both;}
    .d-0{animation-delay:0ms}.d-100{animation-delay:100ms}.d-200{animation-delay:200ms}.d-300{animation-delay:300ms}
    .hero-num{
      font-family:'Fraunces',serif;
      font-size:clamp(7rem,20vw,14rem);font-weight:900;line-height:1;
      background:linear-gradient(135deg,hsl(var(--b3)) 0%,hsl(var(--b2)) 100%);
      -webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent;
      animation:float 6s ease-in-out infinite;user-select:none;
    }
    .btn-action{transition:all 0.25s var(--ease-smooth);}
    .btn-action:hover{transform:translateY(-2px);box-shadow:0 12px 32px -8px hsl(var(--p)/0.45);}
    ::-webkit-scrollbar{width:5px}::-webkit-scrollbar-thumb{background:hsl(var(--b3));border-radius:999px}
  </style>
</head>
<body class="bg-base-200 min-h-screen flex flex-col items-center justify-center p-6 text-center overflow-hidden">
  <script>const _t=localStorage.getItem('gesetu-theme');if(_t)document.documentElement.setAttribute('data-theme',_t);<\/script>

  <div class="hero-num anim-fade-up d-0">404</div>

  <div class="anim-fade-up d-100 space-y-3 max-w-sm -mt-4">
    <h1 class="font-display text-3xl font-black text-base-content leading-tight">Page introuvable</h1>
    <p class="text-base-content/45 text-sm leading-relaxed font-medium">
      La page que vous cherchez n'existe pas, a été déplacée ou est temporairement indisponible.
    </p>
  </div>

  <div class="flex flex-wrap gap-3 justify-center mt-8 anim-fade-up d-200">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="btn btn-primary rounded-2xl gap-2 font-bold normal-case px-6 btn-action shadow-lg shadow-primary/25">
      <i class="bi bi-grid-1x2"></i> Tableau de bord
    </a>
    <button onclick="history.back()"
            class="btn btn-ghost rounded-2xl gap-2 font-semibold normal-case px-6 border border-base-content/12 hover:border-base-content/25 transition-all duration-200">
      <i class="bi bi-arrow-left"></i> Retour
    </button>
  </div>

  <div class="fixed top-5 right-5">
    <label class="swap swap-rotate btn btn-ghost btn-sm btn-circle bg-base-100/80 backdrop-blur border border-base-200">
      <input type="checkbox" id="themeToggle"/>
      <i class="swap-off bi bi-sun-fill text-warning"></i>
      <i class="swap-on bi bi-moon-stars-fill text-info"></i>
    </label>
  </div>
  <script>
    (function(){const tog=document.getElementById('themeToggle'),s=localStorage.getItem('gesetu-theme')||'light';document.documentElement.setAttribute('data-theme',s);tog.checked=s==='dark';tog.addEventListener('change',function(){const th=this.checked?'dark':'light';document.documentElement.setAttribute('data-theme',th);localStorage.setItem('gesetu-theme',th);});})();
  </script>
</body>
</html>