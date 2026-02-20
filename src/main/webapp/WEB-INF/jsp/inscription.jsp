<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Inscription — GesEtu</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Fraunces:opsz,wght@9..144,700;9..144,900&display=swap" rel="stylesheet">
  <script>tailwind.config={theme:{extend:{fontFamily:{display:['"Fraunces"','serif'],body:['"Plus Jakarta Sans"','sans-serif']}}}}</script>
  <style>
    :root{--ease-spring:cubic-bezier(0.34,1.56,0.64,1);--ease-smooth:cubic-bezier(0.16,1,0.3,1);}
    html,body{font-family:'Plus Jakarta Sans',sans-serif;-webkit-font-smoothing:antialiased;}
    .font-display,h1,h2{font-family:'Fraunces',serif;}
    .mesh-bg{
      background-color:hsl(var(--b1));
      background-image:
        radial-gradient(ellipse at 10% 50%,hsl(var(--su)/0.16) 0,transparent 55%),
        radial-gradient(ellipse at 90% 20%,hsl(var(--p)/0.12) 0,transparent 50%),
        radial-gradient(ellipse at 50% 95%,hsl(var(--s)/0.10) 0,transparent 45%);
    }
    .glass{
      background:hsl(var(--b1)/0.84);
      backdrop-filter:blur(26px) saturate(180%);
      -webkit-backdrop-filter:blur(26px) saturate(180%);
      border:1px solid hsl(var(--b3)/0.5);
    }
    .orb{position:fixed;border-radius:50%;filter:blur(70px);pointer-events:none;z-index:0;}
    .orb-a{width:350px;height:350px;background:hsl(var(--su)/0.12);top:-100px;left:-80px;animation:orb1 16s ease-in-out infinite;}
    .orb-b{width:280px;height:280px;background:hsl(var(--p)/0.10);bottom:-60px;right:-60px;animation:orb2 20s ease-in-out infinite;}
    @keyframes orb1{0%,100%{transform:translate(0,0)}50%{transform:translate(35px,-25px)}}
    @keyframes orb2{0%,100%{transform:translate(0,0)}50%{transform:translate(-30px,20px)}}
    @keyframes fadeUp{from{opacity:0;transform:translateY(28px)}to{opacity:1;transform:translateY(0)}}
    @keyframes scaleIn{from{opacity:0;transform:scale(0.84)}to{opacity:1;transform:scale(1)}}
    @keyframes shimmer{0%{background-position:-200% center}100%{background-position:200% center}}
    @keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-7px)}}
    .anim-fade-up{animation:fadeUp 0.55s var(--ease-smooth) both;}
    .anim-scale-in{animation:scaleIn 0.45s var(--ease-spring) both;}
    .d-0{animation-delay:0ms}.d-50{animation-delay:50ms}.d-100{animation-delay:100ms}
    .d-150{animation-delay:150ms}.d-200{animation-delay:200ms}.d-250{animation-delay:250ms}
    .d-300{animation-delay:300ms}.d-400{animation-delay:400ms}
    .shimmer-text{
      background:linear-gradient(90deg,hsl(var(--su)) 0%,hsl(var(--p)/0.9) 50%,hsl(var(--su)) 100%);
      background-size:200% auto;-webkit-background-clip:text;background-clip:text;
      -webkit-text-fill-color:transparent;animation:shimmer 3.5s linear infinite;
    }
    .input-wrap{transition:all 0.25s var(--ease-smooth);}
    .input-wrap:focus-within{transform:translateY(-2px);box-shadow:0 10px 28px -6px hsl(var(--su)/0.25);}
    .btn:active{transform:scale(0.97)!important;}
    .btn-glow:hover{transform:translateY(-2px);box-shadow:0 14px 36px -8px hsl(var(--su)/0.55);}
    ::-webkit-scrollbar{width:5px}::-webkit-scrollbar-thumb{background:hsl(var(--b3));border-radius:999px}
  </style>
</head>
<body class="mesh-bg min-h-screen flex items-center justify-center py-10 px-4 overflow-hidden">
  <script>const _t=localStorage.getItem('gesetu-theme');if(_t)document.documentElement.setAttribute('data-theme',_t);</script>
  <div class="orb orb-a"></div>
  <div class="orb orb-b"></div>

  <div class="fixed top-5 right-5 z-50">
    <label class="swap swap-rotate btn btn-ghost btn-sm btn-circle glass shadow-sm">
      <input type="checkbox" id="themeToggle"/>
      <i class="swap-off bi bi-sun-fill text-warning"></i>
      <i class="swap-on bi bi-moon-stars-fill text-info"></i>
    </label>
  </div>

  <div class="w-full max-w-lg relative z-10">
    <div class="text-center mb-7 anim-fade-up d-0">
      <a href="${pageContext.request.contextPath}/auth"
         class="inline-flex items-center gap-1.5 text-base-content/40 hover:text-primary text-xs font-medium mb-5 transition-all duration-200 hover:gap-2.5">
        <i class="bi bi-arrow-left"></i> Retour à la connexion
      </a>
      <div class="relative inline-block">
        <div class="w-18 h-18 rounded-3xl bg-success flex items-center justify-center shadow-2xl shadow-success/40 mx-auto anim-scale-in d-50" style="width:72px;height:72px">
          <i class="bi bi-person-plus-fill text-3xl text-success-content"></i>
        </div>
        <span class="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-primary border-[3px] border-base-100" style="animation:float 4s ease-in-out infinite"></span>
      </div>
      <h1 class="font-display text-[2.4rem] font-black tracking-tight mt-4 leading-none">
        Créer un <span class="shimmer-text">compte</span>
      </h1>
      <p class="text-base-content/40 text-[0.78rem] mt-2 font-medium tracking-widest uppercase">Rejoignez GesEtu dès maintenant</p>
    </div>

    <div class="glass rounded-3xl shadow-2xl p-8 anim-fade-up d-100">
      <c:if test="${not empty error}">
        <div class="alert alert-error mb-6 rounded-2xl text-sm anim-scale-in">
          <i class="bi bi-exclamation-triangle-fill"></i><span>${error}</span>
        </div>
      </c:if>
      <form action="${pageContext.request.contextPath}/inscription" method="post" novalidate class="space-y-4">
        <div class="grid grid-cols-2 gap-3 anim-fade-up d-150">
          <div class="form-control">
            <label class="label pb-1"><span class="label-text font-semibold text-sm">Prénom <span class="text-error">*</span></span></label>
            <input type="text" name="prenom" value="${prenom}" placeholder="Jean" required
                   class="input input-bordered rounded-2xl text-sm focus:input-success transition-all duration-200 hover:border-success/50"/>
          </div>
          <div class="form-control">
            <label class="label pb-1"><span class="label-text font-semibold text-sm">Nom <span class="text-error">*</span></span></label>
            <input type="text" name="nom" value="${nom}" placeholder="Dupont" required
                   class="input input-bordered rounded-2xl text-sm focus:input-success transition-all duration-200 hover:border-success/50"/>
          </div>
        </div>
        <div class="form-control anim-fade-up d-200">
          <label class="label pb-1"><span class="label-text font-semibold text-sm">Email <span class="text-error">*</span></span></label>
          <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-success">
            <i class="bi bi-envelope text-base-content/35 text-sm"></i>
            <input type="email" name="email" value="${email}" placeholder="vous@example.com" class="grow text-sm" required/>
          </label>
        </div>
        <div class="form-control anim-fade-up d-200">
          <label class="label pb-1"><span class="label-text font-semibold text-sm">Rôle</span></label>
          <select name="role" class="select select-bordered rounded-2xl text-sm focus:select-success transition-all duration-200">
            <option value="SECRETAIRE" ${role == 'SECRETAIRE' || empty role ? 'selected' : ''}>Secrétaire</option>
            <option value="ADMIN" ${role == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
          </select>
        </div>
        <div class="form-control anim-fade-up d-250">
          <label class="label pb-1"><span class="label-text font-semibold text-sm">Mot de passe <span class="text-error">*</span></span></label>
          <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-success">
            <i class="bi bi-lock text-base-content/35 text-sm"></i>
            <input type="password" id="motDePasse" name="motDePasse" placeholder="Min. 8 caractères" class="grow text-sm" required minlength="8"/>
            <button type="button" id="togglePwd" tabindex="-1" class="text-base-content/30 hover:text-success transition-all duration-200 hover:scale-110">
              <i class="bi bi-eye text-sm" id="eyeIcon"></i>
            </button>
          </label>
          <div class="mt-2 space-y-1">
            <div class="w-full h-1.5 bg-base-300 rounded-full overflow-hidden">
              <div id="strengthBar" class="h-full w-0 rounded-full transition-all duration-500"></div>
            </div>
            <span id="strengthLabel" class="text-xs font-semibold opacity-0 transition-all duration-300"></span>
          </div>
        </div>
        <div class="form-control anim-fade-up d-300">
          <label class="label pb-1"><span class="label-text font-semibold text-sm">Confirmer <span class="text-error">*</span></span></label>
          <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-success" id="confirmWrapper">
            <i class="bi bi-lock-fill text-base-content/35 text-sm"></i>
            <input type="password" id="confirmerMdp" name="confirmerMotDePasse" placeholder="Répétez le mot de passe" class="grow text-sm" required/>
          </label>
          <div id="matchHint" class="text-xs font-semibold mt-1.5 min-h-[1rem] transition-all duration-200"></div>
        </div>
        <div class="pt-2 anim-fade-up d-400">
          <button type="submit" class="btn btn-success w-full rounded-2xl font-bold tracking-wide btn-glow shadow-lg shadow-success/30 gap-2 transition-all duration-300">
            <i class="bi bi-check-circle text-base"></i> Créer le compte
          </button>
        </div>
      </form>
    </div>
  </div>

<script>
  (function(){
    const tog=document.getElementById('themeToggle');
    const saved=localStorage.getItem('gesetu-theme')||'light';
    document.documentElement.setAttribute('data-theme',saved);
    tog.checked=saved==='dark';
    tog.addEventListener('change',function(){
      const th=this.checked?'dark':'light';
      document.documentElement.setAttribute('data-theme',th);
      localStorage.setItem('gesetu-theme',th);
    });
  })();
  document.getElementById('togglePwd').addEventListener('click',function(){
    const pwd=document.getElementById('motDePasse'),icon=document.getElementById('eyeIcon');
    pwd.type=pwd.type==='password'?'text':'password';
    icon.className=pwd.type==='password'?'bi bi-eye text-sm':'bi bi-eye-slash text-sm';
  });
  const sc=['bg-error','bg-warning','bg-info','bg-success'];
  const sl=['Très faible','Faible','Moyen','Fort'];
  const sw=['w-1/4','w-2/4','w-3/4','w-full'];
  const st=['text-error','text-warning','text-info','text-success'];
  document.getElementById('motDePasse').addEventListener('input',function(){
    const v=this.value;let s=0;
    if(v.length>=8)s++;if(/[A-Z]/.test(v))s++;if(/[0-9]/.test(v))s++;if(/[^A-Za-z0-9]/.test(v))s++;
    const bar=document.getElementById('strengthBar'),lbl=document.getElementById('strengthLabel');
    if(s>0){bar.className='h-full rounded-full transition-all duration-500 '+sc[s-1]+' '+sw[s-1];lbl.textContent=sl[s-1];lbl.className='text-xs font-semibold opacity-100 transition-all duration-300 '+st[s-1];}
    else{bar.className='h-full w-0 rounded-full transition-all duration-500';lbl.className='text-xs font-semibold opacity-0 transition-all duration-300';}
    checkMatch();
  });
  document.getElementById('confirmerMdp').addEventListener('input',checkMatch);
  function checkMatch(){
    const pw=document.getElementById('motDePasse').value,cp=document.getElementById('confirmerMdp').value;
    const hint=document.getElementById('matchHint'),wrap=document.getElementById('confirmWrapper');
    if(!cp){hint.textContent='';wrap.classList.remove('input-success','input-error');return;}
    if(pw===cp){hint.innerHTML='<span class="text-success flex items-center gap-1"><i class="bi bi-check-circle-fill"></i>Les mots de passe correspondent</span>';wrap.classList.add('input-success');wrap.classList.remove('input-error');}
    else{hint.innerHTML='<span class="text-error flex items-center gap-1"><i class="bi bi-x-circle-fill"></i>Les mots de passe ne correspondent pas</span>';wrap.classList.add('input-error');wrap.classList.remove('input-success');}
  }
</script>
</body>
</html>