<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mon profil — GesEtu</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Fraunces:opsz,wght@9..144,700;9..144,900&display=swap" rel="stylesheet">
  <script>tailwind.config={theme:{extend:{fontFamily:{display:['"Fraunces"','serif'],body:['"Plus Jakarta Sans"','sans-serif']}}}}</script>
  <style>
    :root{--ease-spring:cubic-bezier(0.34,1.56,0.64,1);--ease-smooth:cubic-bezier(0.16,1,0.3,1);}
    html,body{font-family:'Plus Jakarta Sans',sans-serif;-webkit-font-smoothing:antialiased;}
    .font-display,h1,h2,h3{font-family:'Fraunces',serif;}
    @keyframes fadeUp{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}
    @keyframes scaleIn{from{opacity:0;transform:scale(0.84)}to{opacity:1;transform:scale(1)}}
    @keyframes shimmer{0%{background-position:-200% center}100%{background-position:200% center}}
    @keyframes gradShift{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}
    @keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}
    @keyframes countUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    .anim-fade-up{animation:fadeUp 0.5s var(--ease-smooth) both;}
    .anim-scale-in{animation:scaleIn 0.45s var(--ease-spring) both;}
    .d-0{animation-delay:0ms}.d-50{animation-delay:50ms}.d-100{animation-delay:100ms}
    .d-150{animation-delay:150ms}.d-200{animation-delay:200ms}.d-300{animation-delay:300ms}
    .shimmer-text{
      background:linear-gradient(90deg,hsl(var(--p)) 0%,hsl(var(--s)) 50%,hsl(var(--p)) 100%);
      background-size:200% auto;-webkit-background-clip:text;background-clip:text;
      -webkit-text-fill-color:transparent;animation:shimmer 3.5s linear infinite;
    }
    .avatar-grad{
      background:linear-gradient(135deg,hsl(var(--p)) 0%,hsl(var(--s)) 100%);
      background-size:200% 200%;animation:gradShift 8s ease infinite;
    }
    .input-wrap{transition:all 0.22s var(--ease-smooth);}
    .input-wrap:focus-within{transform:translateY(-2px);box-shadow:0 10px 28px -6px hsl(var(--p)/0.22);}
    .stat-item{animation:countUp 0.4s var(--ease-smooth) both;}
    .stat-item:nth-child(1){animation-delay:200ms}
    .stat-item:nth-child(2){animation-delay:300ms}
    .stat-item:nth-child(3){animation-delay:400ms}
    .btn:active{transform:scale(0.97)!important;}
    .btn-save{transition:all 0.3s var(--ease-smooth);}
    .btn-save:hover{transform:translateY(-2px);box-shadow:0 12px 32px -8px hsl(var(--p)/0.5);}
    ::-webkit-scrollbar{width:5px}::-webkit-scrollbar-thumb{background:hsl(var(--b3));border-radius:999px}
  </style>
</head>
<body class="bg-base-200 min-h-screen antialiased">
  <script>const _t=localStorage.getItem('gesetu-theme');if(_t)document.documentElement.setAttribute('data-theme',_t);</script>
  <%@ include file="fragments/navbar.jsp" %>

  <main class="max-w-2xl mx-auto py-10 px-4">
    <div class="text-sm breadcrumbs mb-6 text-base-content/40 anim-fade-up d-0">
      <ul>
        <li><a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary transition-colors">Tableau de bord</a></li>
        <li class="font-medium text-base-content/70">Mon profil</li>
      </ul>
    </div>

    <c:if test="${not empty sessionScope.flashMessage}">
      <div class="alert alert-success rounded-2xl mb-6 text-sm shadow-sm anim-scale-in">
        <i class="bi bi-check-circle-fill text-base"></i>
        <span>${sessionScope.flashMessage}</span>
        <button onclick="this.closest('.alert').remove()" class="btn btn-ghost btn-xs btn-circle ml-auto">x</button>
      </div>
      <c:remove var="flashMessage" scope="session"/>
    </c:if>

    <%-- Profile identity card --%>
    <div class="card bg-base-100 border border-base-200 shadow-lg rounded-3xl mb-5 overflow-hidden anim-fade-up d-50">
      <%-- Top gradient strip --%>
      <div class="h-1.5 w-full" style="background:linear-gradient(90deg,hsl(var(--p)),hsl(var(--s)),hsl(var(--a)));background-size:200%;animation:gradShift 5s ease infinite"></div>
      <div class="card-body p-7">
        <div class="flex items-center gap-5">
          <div class="avatar placeholder flex-shrink-0 anim-scale-in d-100">
            <div class="w-20 h-20 rounded-2xl avatar-grad text-primary-content text-2xl font-black shadow-xl">
              <span>${sessionScope.connectedUser.prenom.charAt(0)}${sessionScope.connectedUser.nom.charAt(0)}</span>
            </div>
          </div>
          <div class="flex-1 min-w-0 anim-fade-up d-150">
            <h2 class="font-display text-xl font-bold truncate">${sessionScope.connectedUser.fullName}</h2>
            <p class="text-base-content/45 text-sm flex items-center gap-1.5 mt-0.5">
              <i class="bi bi-envelope text-xs"></i>${sessionScope.connectedUser.email}
            </p>
            <div class="flex items-center gap-2 mt-3">
              <c:choose>
                <c:when test="${sessionScope.connectedUser.role == 'ADMIN'}">
                  <span class="badge badge-error gap-1 font-semibold"><i class="bi bi-shield-fill text-[10px]"></i>Administrateur</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-neutral gap-1 font-semibold"><i class="bi bi-person-fill text-[10px]"></i>Secrétaire</span>
                </c:otherwise>
              </c:choose>
              <span class="badge badge-success gap-1 font-semibold"><i class="bi bi-circle-fill text-[6px]"></i>Actif</span>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-3 gap-2 mt-6 pt-5 border-t border-base-200">
          <div class="stat-item text-center p-3 rounded-2xl bg-base-200/60 hover:bg-base-200 transition-all duration-200 cursor-default">
            <div class="font-display text-2xl font-black text-primary">${sessionScope.connectedUser.role == 'ADMIN' ? '∞' : '3'}</div>
            <div class="text-[11px] text-base-content/40 mt-0.5 font-medium uppercase tracking-wide">Permissions</div>
          </div>
          <div class="stat-item text-center p-3 rounded-2xl bg-base-200/60 hover:bg-base-200 transition-all duration-200 cursor-default">
            <div class="font-display text-2xl font-black text-secondary">2026</div>
            <div class="text-[11px] text-base-content/40 mt-0.5 font-medium uppercase tracking-wide">Depuis</div>
          </div>
          <div class="stat-item text-center p-3 rounded-2xl bg-base-200/60 hover:bg-base-200 transition-all duration-200 cursor-default">
            <div class="font-display text-2xl font-black text-success">✓</div>
            <div class="text-[11px] text-base-content/40 mt-0.5 font-medium uppercase tracking-wide">Vérifié</div>
          </div>
        </div>
      </div>
    </div>

    <%-- Password change card --%>
    <div class="card bg-base-100 border border-base-200 shadow-lg rounded-3xl anim-fade-up d-200">
      <div class="card-body p-7">
        <div class="flex items-center gap-3 mb-6">
          <div class="w-11 h-11 rounded-2xl bg-warning/10 flex items-center justify-center flex-shrink-0">
            <i class="bi bi-shield-lock text-xl text-warning"></i>
          </div>
          <div>
            <h3 class="font-display font-bold text-lg leading-tight">Changer le mot de passe</h3>
            <p class="text-base-content/40 text-xs mt-0.5">Min. 8 caractères · Majuscule · Chiffre · Symbole</p>
          </div>
        </div>

        <c:if test="${not empty error}">
          <div class="alert alert-error rounded-2xl mb-5 text-sm anim-scale-in">
            <i class="bi bi-exclamation-triangle-fill"></i><span>${error}</span>
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/profil" method="post" novalidate class="space-y-4">
          <div class="form-control">
            <label class="label pb-1"><span class="label-text font-semibold text-sm">Mot de passe actuel <span class="text-error">*</span></span></label>
            <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-warning hover:border-warning/40 transition-all duration-200">
              <i class="bi bi-lock text-base-content/35 text-sm"></i>
              <input type="password" id="currentPassword" name="currentPassword" placeholder="Votre mot de passe actuel" class="grow text-sm" required/>
              <button type="button" onclick="toggleField('currentPassword','eye0')" tabindex="-1"
                      class="text-base-content/30 hover:text-warning transition-all duration-200 hover:scale-110">
                <i class="bi bi-eye text-sm" id="eye0"></i>
              </button>
            </label>
          </div>
          <div class="divider text-xs text-base-content/25 font-medium tracking-wider uppercase">Nouveau mot de passe</div>
          <div class="form-control">
            <label class="label pb-1"><span class="label-text font-semibold text-sm">Nouveau mot de passe <span class="text-error">*</span></span></label>
            <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-primary hover:border-primary/40 transition-all duration-200">
              <i class="bi bi-lock-fill text-base-content/35 text-sm"></i>
              <input type="password" id="newPassword" name="newPassword" placeholder="Min. 8 caractères" class="grow text-sm" required minlength="8"/>
              <button type="button" onclick="toggleField('newPassword','eye1')" tabindex="-1"
                      class="text-base-content/30 hover:text-primary transition-all duration-200 hover:scale-110">
                <i class="bi bi-eye text-sm" id="eye1"></i>
              </button>
            </label>
            <div class="mt-2 space-y-1">
              <div class="w-full h-1.5 bg-base-300 rounded-full overflow-hidden">
                <div id="strengthBar" class="h-full w-0 rounded-full transition-all duration-500"></div>
              </div>
              <span id="strengthLabel" class="text-xs font-semibold opacity-0 transition-all duration-300"></span>
            </div>
          </div>
          <div class="form-control">
            <label class="label pb-1"><span class="label-text font-semibold text-sm">Confirmer <span class="text-error">*</span></span></label>
            <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-primary hover:border-primary/40 transition-all duration-200" id="confirmWrapper">
              <i class="bi bi-lock-fill text-base-content/35 text-sm"></i>
              <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Répétez le nouveau mot de passe" class="grow text-sm" required/>
              <button type="button" onclick="toggleField('confirmPassword','eye2')" tabindex="-1"
                      class="text-base-content/30 hover:text-primary transition-all duration-200 hover:scale-110">
                <i class="bi bi-eye text-sm" id="eye2"></i>
              </button>
            </label>
            <div id="matchHint" class="text-xs font-semibold mt-1.5 min-h-[1rem]"></div>
          </div>
          <div class="flex gap-3 pt-2">
            <button type="submit" class="btn btn-primary rounded-2xl font-bold gap-2 btn-save shadow-lg shadow-primary/25">
              <i class="bi bi-check-lg text-base"></i> Enregistrer
            </button>
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost rounded-2xl font-medium gap-2 border border-base-content/10 hover:border-base-content/20 transition-all duration-200">
              <i class="bi bi-arrow-left"></i> Retour
            </a>
          </div>
        </form>
      </div>
    </div>
  </main>

<script>
  function toggleField(fid,iid){
    const f=document.getElementById(fid),i=document.getElementById(iid);
    f.type=f.type==='password'?'text':'password';
    i.className=f.type==='password'?'bi bi-eye text-sm':'bi bi-eye-slash text-sm';
  }
  const sc=['bg-error','bg-warning','bg-info','bg-success'];
  const sl=['Très faible','Faible','Moyen','Fort'];
  const sw=['w-1/4','w-2/4','w-3/4','w-full'];
  const st=['text-error','text-warning','text-info','text-success'];
  document.getElementById('newPassword').addEventListener('input',function(){
    const v=this.value;let s=0;
    if(v.length>=8)s++;if(/[A-Z]/.test(v))s++;if(/[0-9]/.test(v))s++;if(/[^A-Za-z0-9]/.test(v))s++;
    const bar=document.getElementById('strengthBar'),lbl=document.getElementById('strengthLabel');
    if(s>0){bar.className='h-full rounded-full transition-all duration-500 '+sc[s-1]+' '+sw[s-1];lbl.textContent=sl[s-1];lbl.className='text-xs font-semibold opacity-100 transition-all duration-300 '+st[s-1];}
    else{bar.className='h-full w-0 rounded-full transition-all duration-500';lbl.className='text-xs font-semibold opacity-0';}
    checkMatch();
  });
  document.getElementById('confirmPassword').addEventListener('input',checkMatch);
  function checkMatch(){
    const np=document.getElementById('newPassword').value,cp=document.getElementById('confirmPassword').value;
    const hint=document.getElementById('matchHint'),wrap=document.getElementById('confirmWrapper');
    if(!cp){hint.textContent='';return;}
    if(np===cp){hint.innerHTML='<span class="text-success flex items-center gap-1"><i class="bi bi-check-circle-fill"></i>Les mots de passe correspondent</span>';wrap.classList.add('input-success');wrap.classList.remove('input-error');}
    else{hint.innerHTML='<span class="text-error flex items-center gap-1"><i class="bi bi-x-circle-fill"></i>Les mots de passe ne correspondent pas</span>';wrap.classList.add('input-error');wrap.classList.remove('input-success');}
  }
<\/script>
</body>
</html>