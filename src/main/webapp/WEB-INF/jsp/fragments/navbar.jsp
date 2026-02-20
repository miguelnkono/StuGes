<%-- WEB-INF/jsp/fragments/navbar.jsp --%>
<div class="drawer">
  <input id="nav-drawer" type="checkbox" class="drawer-toggle"/>
  <div class="drawer-content flex flex-col">

    <nav class="navbar bg-base-100/75 backdrop-blur-xl border-b border-base-content/8 sticky top-0 z-50 px-4 lg:px-8 shadow-sm"
         style="transition:background 0.3s ease,box-shadow 0.3s ease">

      <div class="navbar-start gap-2">
        <label for="nav-drawer" class="btn btn-ghost btn-sm btn-circle drawer-button lg:hidden">
          <i class="bi bi-list text-xl"></i>
        </label>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="btn btn-ghost gap-2 text-lg font-black normal-case group"
           style="font-family:'Fraunces',serif">
          <div class="w-8 h-8 rounded-xl bg-primary flex items-center justify-center text-primary-content shadow-sm transition-all duration-300 group-hover:scale-110 group-hover:rotate-3">
            <i class="bi bi-mortarboard-fill text-xs"></i>
          </div>
          <span class="hidden sm:inline text-base-content">Ges<span class="text-primary">Etu</span></span>
        </a>
      </div>

      <div class="navbar-center hidden lg:flex">
        <ul class="menu menu-horizontal gap-1 px-1 text-sm">
          <li>
            <a href="${pageContext.request.contextPath}/dashboard"
               class="rounded-xl font-medium gap-2 hover:bg-primary/8 hover:text-primary transition-all duration-200">
              <i class="bi bi-grid-1x2"></i> Tableau de bord
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/etudiants?action=add"
               class="rounded-xl font-medium gap-2 hover:bg-primary/8 hover:text-primary transition-all duration-200">
              <i class="bi bi-person-plus"></i> Ajouter un étudiant
            </a>
          </li>
        </ul>
      </div>

      <div class="navbar-end gap-2">
        <label class="swap swap-rotate btn btn-ghost btn-sm btn-circle" title="Changer le thème">
          <input type="checkbox" id="themeToggle"/>
          <i class="swap-off bi bi-sun-fill text-warning"></i>
          <i class="swap-on bi bi-moon-stars-fill text-info"></i>
        </label>

        <div class="dropdown dropdown-end">
          <div tabindex="0" role="button"
               class="btn btn-ghost btn-sm gap-2 rounded-2xl pr-2 normal-case group transition-all duration-200 hover:bg-base-200">
            <div class="avatar placeholder">
              <div class="w-8 h-8 rounded-xl text-xs font-black shadow-sm transition-all duration-300 group-hover:scale-105"
                   style="background:linear-gradient(135deg,hsl(var(--p)),hsl(var(--s)));color:hsl(var(--pc))">
                <span>${sessionScope.connectedUser.prenom.charAt(0)}${sessionScope.connectedUser.nom.charAt(0)}</span>
              </div>
            </div>
            <span class="hidden md:inline text-sm font-semibold max-w-[120px] truncate">
              ${sessionScope.connectedUser.fullName}
            </span>
            <i class="bi bi-chevron-down text-xs opacity-40 transition-transform duration-200 group-focus:rotate-180"></i>
          </div>
          <ul tabindex="0"
              class="dropdown-content menu bg-base-100/90 backdrop-blur-xl rounded-2xl shadow-xl border border-base-content/8 w-60 mt-2 p-2 z-[100]"
              style="animation:scaleIn 0.2s var(--ease-spring) both">
            <li class="menu-title px-3 pt-2 pb-1">
              <div class="flex items-center gap-2">
                <c:choose>
                  <c:when test="${sessionScope.connectedUser.role == 'ADMIN'}">
                    <span class="badge badge-error badge-sm font-semibold">Admin</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-neutral badge-sm font-semibold">Secrétaire</span>
                  </c:otherwise>
                </c:choose>
                <span class="text-[11px] opacity-50 truncate">${sessionScope.connectedUser.email}</span>
              </div>
            </li>
            <div class="divider my-1 h-px"></div>
            <li>
              <a href="${pageContext.request.contextPath}/profil"
                 class="gap-3 rounded-xl text-sm font-medium hover:bg-primary/8 hover:text-primary transition-all duration-200">
                <i class="bi bi-person-gear text-base"></i> Mon profil
              </a>
            </li>
            <li>
              <a href="${pageContext.request.contextPath}/auth?action=logout"
                 class="gap-3 rounded-xl text-sm font-medium text-error hover:bg-error/8 transition-all duration-200">
                <i class="bi bi-box-arrow-right text-base"></i> Déconnexion
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </div>

  <div class="drawer-side z-[200]">
    <label for="nav-drawer" aria-label="close sidebar" class="drawer-overlay"></label>
    <aside class="bg-base-100 min-h-full w-64 p-4 flex flex-col gap-2 shadow-xl">
      <div class="flex items-center gap-2 px-2 py-3 mb-2" style="font-family:'Fraunces',serif">
        <div class="w-9 h-9 rounded-xl bg-primary flex items-center justify-center text-primary-content shadow-sm">
          <i class="bi bi-mortarboard-fill text-sm"></i>
        </div>
        <span class="font-black text-xl">Ges<span class="text-primary">Etu</span></span>
      </div>
      <ul class="menu menu-sm gap-1 w-full">
        <li><a href="${pageContext.request.contextPath}/dashboard" class="gap-3 rounded-xl font-medium"><i class="bi bi-grid-1x2"></i> Tableau de bord</a></li>
        <li><a href="${pageContext.request.contextPath}/etudiants?action=add" class="gap-3 rounded-xl font-medium"><i class="bi bi-person-plus"></i> Ajouter un étudiant</a></li>
        <li><a href="${pageContext.request.contextPath}/profil" class="gap-3 rounded-xl font-medium"><i class="bi bi-person-gear"></i> Mon profil</a></li>
        <div class="divider my-1"></div>
        <li><a href="${pageContext.request.contextPath}/auth?action=logout" class="gap-3 rounded-xl font-medium text-error"><i class="bi bi-box-arrow-right"></i> Déconnexion</a></li>
      </ul>
    </aside>
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
    // Navbar scroll shadow
    const nav=document.querySelector('nav');
    window.addEventListener('scroll',()=>{
      nav.style.boxShadow=window.scrollY>10?'0 4px 24px -4px rgba(0,0,0,0.12)':'none';
      nav.style.background=window.scrollY>10?'hsl(var(--b1)/0.95)':'hsl(var(--b1)/0.75)';
    });
  })();
</script>