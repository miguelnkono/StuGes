<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Tableau de bord — GesEtu</title>
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
    @keyframes rowIn{from{opacity:0;transform:translateX(-12px)}to{opacity:1;transform:translateX(0)}}
    @keyframes shimmer{0%{background-position:-200% center}100%{background-position:200% center}}
    @keyframes gradShift{0%,100%{background-position:0% 50%}50%{background-position:100% 50%}}
    @keyframes countUp{from{opacity:0;transform:translateY(12px) scale(0.9)}to{opacity:1;transform:translateY(0) scale(1)}}
    @keyframes toastIn{from{opacity:0;transform:translateX(32px)}to{opacity:1;transform:translateX(0)}}
    @keyframes popIn{0%{transform:scale(0);opacity:0}70%{transform:scale(1.12)}100%{transform:scale(1);opacity:1}}

    .anim-fade-up{animation:fadeUp 0.5s var(--ease-smooth) both;}
    .anim-scale-in{animation:scaleIn 0.45s var(--ease-spring) both;}
    .anim-count{animation:countUp 0.5s var(--ease-spring) both;}
    .anim-toast{animation:toastIn 0.4s var(--ease-spring) both;}
    .d-0{animation-delay:0ms}.d-50{animation-delay:50ms}.d-100{animation-delay:100ms}
    .d-150{animation-delay:150ms}.d-200{animation-delay:200ms}.d-250{animation-delay:250ms}
    .d-300{animation-delay:300ms}.d-400{animation-delay:400ms}

    /* Table row stagger */
    .table tbody tr{animation:rowIn 0.35s var(--ease-smooth) both;}
    .table tbody tr:nth-child(1){animation-delay:50ms}.table tbody tr:nth-child(2){animation-delay:90ms}
    .table tbody tr:nth-child(3){animation-delay:130ms}.table tbody tr:nth-child(4){animation-delay:170ms}
    .table tbody tr:nth-child(5){animation-delay:210ms}.table tbody tr:nth-child(n+6){animation-delay:250ms}

    .shimmer-text{
      background:linear-gradient(90deg,hsl(var(--p)) 0%,hsl(var(--s)) 50%,hsl(var(--p)) 100%);
      background-size:200% auto;-webkit-background-clip:text;background-clip:text;
      -webkit-text-fill-color:transparent;animation:shimmer 3.5s linear infinite;
    }
    /* Stat cards */
    .stat-blue{
      background:linear-gradient(135deg,hsl(var(--p)) 0%,hsl(221,83%,38%) 100%);
      background-size:200% 200%;animation:gradShift 6s ease infinite;
      color:hsl(var(--pc));position:relative;overflow:hidden;
    }
    .stat-green{
      background:linear-gradient(135deg,hsl(var(--su)) 0%,hsl(158,72%,26%) 100%);
      background-size:200% 200%;animation:gradShift 7s 1s ease infinite;
      color:hsl(var(--suc));position:relative;overflow:hidden;
    }
    .stat-blue::before,.stat-green::before{
      content:'';position:absolute;top:-40%;right:-12%;width:160px;height:160px;border-radius:50%;
      background:rgba(255,255,255,0.09);pointer-events:none;
    }
    .stat-blue::after,.stat-green::after{
      content:'';position:absolute;bottom:-50%;left:-8%;width:120px;height:120px;border-radius:50%;
      background:rgba(255,255,255,0.05);pointer-events:none;
    }

    /* Search bar input hover/focus */
    .search-input-wrap{transition:all 0.22s var(--ease-smooth);}
    .search-input-wrap:focus-within{transform:translateY(-1px);box-shadow:0 6px 20px -4px hsl(var(--p)/0.18);}

    /* Action button hover */
    .action-btn{transition:all 0.18s var(--ease-smooth);}
    .action-btn:hover{transform:scale(1.12);}
    .btn:active{transform:scale(0.96)!important;}

    /* Card hover */
    .card-hover{transition:box-shadow 0.25s var(--ease-smooth),transform 0.25s var(--ease-smooth);}
    .card-hover:hover{box-shadow:0 16px 48px -12px hsl(var(--p)/0.15);transform:translateY(-2px);}

    /* Inactive row */
    .row-inactive{opacity:0.5;}

    ::-webkit-scrollbar{width:5px;height:5px}
    ::-webkit-scrollbar-thumb{background:hsl(var(--b3));border-radius:999px}
    ::-webkit-scrollbar-thumb:hover{background:hsl(var(--p)/0.45)}
  </style>
</head>
<body class="bg-base-200 min-h-screen text-base-content antialiased">
  <script>const _t=localStorage.getItem('gesetu-theme');if(_t)document.documentElement.setAttribute('data-theme',_t);</script>
  <%@ include file="fragments/navbar.jsp" %>

  <%-- Toast notifications --%>
  <c:if test="${not empty flash}">
    <div class="toast toast-top toast-end z-[999] pt-4" id="flashToast">
      <div class="alert alert-success shadow-xl rounded-2xl text-sm gap-3 anim-toast">
        <i class="bi bi-check-circle-fill text-base flex-shrink-0"></i>
        <span class="font-medium">${flash}</span>
        <button onclick="document.getElementById('flashToast').remove()" class="btn btn-ghost btn-xs btn-circle ml-1">x</button>
      </div>
    </div>
    <script>setTimeout(()=>{const e=document.getElementById('flashToast');if(e){e.style.transition='opacity 0.4s ease';e.style.opacity='0';setTimeout(()=>e.remove(),400);}},5000);</script>
  </c:if>
  <c:if test="${not empty flashError}">
    <div class="toast toast-top toast-end z-[999] pt-4" id="errorToast">
      <div class="alert alert-error shadow-xl rounded-2xl text-sm gap-3 anim-toast">
        <i class="bi bi-exclamation-triangle-fill text-base flex-shrink-0"></i>
        <span class="font-medium">${flashError}</span>
        <button onclick="document.getElementById('errorToast').remove()" class="btn btn-ghost btn-xs btn-circle ml-1">x</button>
      </div>
    </div>
    <script>setTimeout(()=>{const e=document.getElementById('errorToast');if(e){e.style.transition='opacity 0.4s ease';e.style.opacity='0';setTimeout(()=>e.remove(),400);}},6000);</script>
  </c:if>
  <c:if test="${not empty dbError}">
    <div class="alert alert-warning rounded-2xl mx-4 mt-4 text-sm shadow-sm anim-scale-in">
      <i class="bi bi-database-exclamation"></i><span>${dbError}</span>
    </div>
  </c:if>

  <main class="max-w-[1400px] mx-auto px-4 lg:px-8 py-8">

    <%-- Page header --%>
    <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 mb-8 anim-fade-up d-0">
      <div>
        <p class="text-base-content/35 text-xs font-semibold uppercase tracking-widest mb-1">Vue d'ensemble</p>
        <h1 class="font-display text-3xl md:text-4xl font-black tracking-tight leading-none">
          Tableau de <span class="shimmer-text">bord</span>
        </h1>
        <p class="text-base-content/45 text-sm mt-2 font-medium">
          Bonjour, <span class="text-base-content/80 font-semibold">${sessionScope.connectedUser.prenom}</span> 👋 — ${sessionScope.connectedUser.role == 'ADMIN' ? 'Vous avez accès complet.' : 'Mode secrétaire actif.'}
        </p>
      </div>
      <a href="${pageContext.request.contextPath}/etudiants?action=add"
         class="btn btn-primary rounded-2xl gap-2 shadow-lg shadow-primary/25 self-start sm:self-auto font-semibold transition-all duration-300 hover:translate-y-[-2px] hover:shadow-primary/45 anim-fade-up d-100">
        <i class="bi bi-person-plus-fill text-base"></i> Ajouter un étudiant
      </a>
    </div>

    <%-- Secrétaire banner --%>
    <c:if test="${sessionScope.connectedUser.role == 'SECRETAIRE'}">
      <div class="flex items-start gap-3 bg-warning/8 border border-warning/25 rounded-2xl p-4 mb-6 text-sm anim-fade-up d-100">
        <i class="bi bi-info-circle-fill text-warning text-base flex-shrink-0 mt-0.5"></i>
        <span class="text-base-content/70 font-medium">Mode <strong class="text-base-content">Secrétaire</strong> — consultation, ajout et modification uniquement. La suppression et gestion des comptes sont réservées aux administrateurs.</span>
      </div>
    </c:if>

    <%-- KPI cards --%>
    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mb-8">
      <div class="stat-green rounded-3xl p-6 shadow-lg anim-fade-up d-50">
        <div class="flex items-start justify-between relative z-10">
          <div>
            <div class="text-[2.8rem] font-black leading-none font-display anim-count d-100">${etudiants.size()}</div>
            <div class="text-sm font-semibold opacity-80 mt-1.5 flex items-center gap-1.5">
              Étudiants
              <c:if test="${isFiltered}"><span class="badge badge-sm bg-white/20 border-0 text-inherit text-xs">filtré</span></c:if>
            </div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-white/15 flex items-center justify-center">
            <i class="bi bi-mortarboard-fill text-xl"></i>
          </div>
        </div>
      </div>

      <div class="stat-blue rounded-3xl p-6 shadow-lg anim-fade-up d-100">
        <div class="flex items-start justify-between relative z-10">
          <div>
            <div class="text-[2.8rem] font-black leading-none font-display anim-count d-150">${utilisateurs.size()}</div>
            <div class="text-sm font-semibold opacity-80 mt-1.5">Utilisateurs</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-white/15 flex items-center justify-center">
            <i class="bi bi-people-fill text-xl"></i>
          </div>
        </div>
      </div>

      <div class="card bg-base-100 border border-base-200 rounded-3xl p-6 shadow-sm anim-fade-up d-150 card-hover">
        <div class="flex items-start justify-between">
          <div>
            <div class="text-[2.8rem] font-black leading-none font-display text-accent anim-count d-200">${filieres.size()}</div>
            <div class="text-sm font-semibold text-base-content/50 mt-1.5">Filières</div>
          </div>
          <div class="w-12 h-12 rounded-2xl bg-accent/10 flex items-center justify-center">
            <i class="bi bi-building text-xl text-accent"></i>
          </div>
        </div>
      </div>

      <div class="card bg-base-100 border border-base-200 rounded-3xl p-6 shadow-sm anim-fade-up d-200 card-hover">
        <div class="flex items-center gap-3">
          <div class="avatar placeholder flex-shrink-0">
            <div class="w-14 h-14 rounded-2xl text-sm font-black shadow-md"
                 style="background:linear-gradient(135deg,hsl(var(--p)),hsl(var(--s)));color:hsl(var(--pc))">
              <span>${sessionScope.connectedUser.prenom.charAt(0)}${sessionScope.connectedUser.nom.charAt(0)}</span>
            </div>
          </div>
          <div class="min-w-0 flex-1">
            <div class="font-bold text-sm truncate">${sessionScope.connectedUser.fullName}</div>
            <div class="text-base-content/35 text-xs truncate mt-0.5">${sessionScope.connectedUser.email}</div>
            <div class="mt-2">
              <c:choose>
                <c:when test="${sessionScope.connectedUser.role == 'ADMIN'}">
                  <span class="badge badge-error badge-sm font-semibold">Admin</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-neutral badge-sm font-semibold">Secrétaire</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </div>

    <%-- ════════════ STUDENTS TABLE ════════════ --%>
    <div class="card bg-base-100 border border-base-200 shadow-sm rounded-3xl mb-5 anim-fade-up d-200 card-hover">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 px-6 pt-6 pb-4 border-b border-base-200">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-2xl bg-success/10 flex items-center justify-center">
            <i class="bi bi-mortarboard text-success text-lg"></i>
          </div>
          <div>
            <h2 class="font-display font-bold text-lg leading-tight">Liste des étudiants</h2>
            <p class="text-base-content/35 text-xs mt-0.5">${etudiants.size()} résultat(s)<c:if test="${isFiltered}"> — filtré</c:if></p>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/etudiants?action=add"
           class="btn btn-success btn-sm rounded-xl gap-2 normal-case font-semibold shadow-sm transition-all duration-200 hover:shadow-success/35 hover:translate-y-[-1px]">
          <i class="bi bi-plus-lg"></i> Ajouter
        </a>
      </div>

      <%-- Search bar --%>
      <div class="px-6 py-4 border-b border-base-200 bg-base-200/40">
        <form action="${pageContext.request.contextPath}/dashboard" method="get" id="searchForm"
              class="flex flex-col sm:flex-row gap-3 items-end">
          <div class="flex-1 min-w-0">
            <label class="label pb-1 pt-0">
              <span class="label-text text-[11px] font-bold text-base-content/40 uppercase tracking-widest">
                <i class="bi bi-search me-1"></i>Nom / Matricule
              </span>
            </label>
            <label class="input input-sm input-bordered search-input-wrap flex items-center gap-2 rounded-xl bg-base-100 focus-within:input-primary">
              <i class="bi bi-search text-base-content/30 text-xs"></i>
              <input type="text" name="nom" value="${filterNom}" placeholder="Rechercher..." class="grow text-sm" id="searchInput"/>
            </label>
          </div>
          <div class="sm:w-44">
            <label class="label pb-1 pt-0"><span class="label-text text-[11px] font-bold text-base-content/40 uppercase tracking-widest">Filière</span></label>
            <select name="filiere" id="filiereSelect"
                    class="select select-sm select-bordered rounded-xl bg-base-100 focus:select-primary w-full text-sm transition-all duration-200">
              <option value="">Toutes</option>
              <c:forEach var="f" items="${filieres}">
                <option value="${f}" ${filterFiliere == f ? 'selected' : ''}>${f}</option>
              </c:forEach>
            </select>
          </div>
          <div class="sm:w-32">
            <label class="label pb-1 pt-0"><span class="label-text text-[11px] font-bold text-base-content/40 uppercase tracking-widest">Niveau</span></label>
            <select name="niveau" id="niveauSelect"
                    class="select select-sm select-bordered rounded-xl bg-base-100 focus:select-primary w-full text-sm transition-all duration-200">
              <option value="">Tous</option>
              <c:forEach var="n" items="${niveaux}">
                <option value="${n}" ${filterNiveau == n ? 'selected' : ''}>${n}</option>
              </c:forEach>
            </select>
          </div>
          <div class="flex gap-2 flex-shrink-0">
            <button type="submit" class="btn btn-primary btn-sm rounded-xl gap-1.5 normal-case font-semibold transition-all duration-200 hover:translate-y-[-1px]">
              <i class="bi bi-funnel"></i> Filtrer
            </button>
            <c:if test="${isFiltered}">
              <a href="${pageContext.request.contextPath}/dashboard"
                 class="btn btn-ghost btn-sm rounded-xl gap-1.5 normal-case border border-base-content/10 hover:border-base-content/25 transition-all duration-200">
                <i class="bi bi-x-lg"></i> Reset
              </a>
            </c:if>
          </div>
        </form>
        <c:if test="${isFiltered}">
          <div class="flex flex-wrap gap-2 items-center mt-3">
            <span class="text-[11px] text-base-content/35 font-semibold uppercase tracking-widest">Actifs :</span>
            <c:if test="${not empty filterNom}">
              <span class="badge badge-primary badge-sm gap-1 font-semibold"><i class="bi bi-search text-[10px]"></i>${filterNom}</span>
            </c:if>
            <c:if test="${not empty filterFiliere}">
              <span class="badge badge-success badge-sm gap-1 font-semibold"><i class="bi bi-building text-[10px]"></i>${filterFiliere}</span>
            </c:if>
            <c:if test="${not empty filterNiveau}">
              <span class="badge badge-info badge-sm gap-1 font-semibold"><i class="bi bi-layers text-[10px]"></i>${filterNiveau}</span>
            </c:if>
          </div>
        </c:if>
      </div>

      <div class="overflow-x-auto">
        <table class="table table-sm table-zebra">
          <thead>
            <tr class="text-[11px] font-bold text-base-content/35 uppercase tracking-widest border-b border-base-200">
              <th class="w-10">#</th><th>Matricule</th><th>Nom complet</th>
              <th class="hidden md:table-cell">Email</th>
              <th class="hidden lg:table-cell">Filière</th>
              <th>Niveau</th>
              <th class="hidden xl:table-cell">Date naiss.</th>
              <th class="text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty etudiants}">
                <tr><td colspan="8" class="text-center py-16">
                  <div class="flex flex-col items-center gap-3 text-base-content/25">
                    <c:choose>
                      <c:when test="${isFiltered}">
                        <i class="bi bi-search text-5xl anim-scale-in"></i>
                        <div class="anim-fade-up d-50"><p class="font-display font-bold text-base">Aucun résultat</p><p class="text-sm mt-0.5">Aucun étudiant ne correspond à votre recherche.</p></div>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-ghost btn-sm rounded-xl gap-2 normal-case border border-base-content/10 mt-2 anim-fade-up d-100"><i class="bi bi-x"></i>Effacer les filtres</a>
                      </c:when>
                      <c:otherwise>
                        <i class="bi bi-inbox text-5xl anim-scale-in"></i>
                        <div class="anim-fade-up d-50"><p class="font-display font-bold text-base">Aucun étudiant</p><p class="text-sm mt-0.5">Commencez par en ajouter un.</p></div>
                        <a href="${pageContext.request.contextPath}/etudiants?action=add" class="btn btn-success btn-sm rounded-xl gap-2 normal-case mt-2 anim-fade-up d-100"><i class="bi bi-plus-lg"></i>Ajouter</a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="e" items="${etudiants}" varStatus="st">
                  <tr class="hover cursor-default">
                    <td class="text-base-content/25 text-xs font-mono">${st.index + 1}</td>
                    <td><span class="badge badge-ghost badge-sm font-mono text-xs tracking-wide">${e.matricule}</span></td>
                    <td>
                      <div class="flex items-center gap-3">
                        <div class="avatar placeholder hidden sm:flex">
                          <div class="w-8 h-8 rounded-xl bg-base-300 text-base-content/60 text-xs font-bold transition-all duration-200">
                            <span>${e.prenom.charAt(0)}${e.nom.charAt(0)}</span>
                          </div>
                        </div>
                        <span class="font-semibold text-sm">${e.fullName}</span>
                      </div>
                    </td>
                    <td class="hidden md:table-cell">
                      <c:if test="${not empty e.email}">
                        <a href="mailto:${e.email}" class="link link-hover text-sm text-base-content/50 hover:text-primary transition-colors duration-200">${e.email}</a>
                      </c:if>
                    </td>
                    <td class="hidden lg:table-cell text-sm text-base-content/60 font-medium">${e.filiere}</td>
                    <td>
                      <c:if test="${not empty e.niveau}">
                        <span class="badge badge-info badge-outline badge-sm font-semibold">${e.niveau}</span>
                      </c:if>
                    </td>
                    <td class="hidden xl:table-cell text-sm text-base-content/40">${e.dateNaissance}</td>
                    <td>
                      <div class="flex items-center justify-center gap-0.5">
                        <a href="${pageContext.request.contextPath}/etudiants?action=edit&id=${e.id}"
                           class="btn btn-ghost btn-xs rounded-lg text-primary hover:bg-primary/10 action-btn" title="Modifier">
                          <i class="bi bi-pencil"></i>
                        </a>
                        <c:choose>
                          <c:when test="${sessionScope.connectedUser.role == 'ADMIN'}">
                            <button class="btn btn-ghost btn-xs rounded-lg text-error hover:bg-error/10 action-btn"
                                    title="Supprimer"
                                    onclick="confirmDelete('${pageContext.request.contextPath}/etudiants?action=delete&id=${e.id}','${e.fullName}')">
                              <i class="bi bi-trash"></i>
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button class="btn btn-ghost btn-xs rounded-lg opacity-15 cursor-not-allowed" disabled title="Réservé aux administrateurs">
                              <i class="bi bi-trash"></i>
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <%-- ════════════ USERS TABLE ════════════ --%>
    <div class="card bg-base-100 border border-base-200 shadow-sm rounded-3xl anim-fade-up d-300 card-hover">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 px-6 pt-6 pb-4 border-b border-base-200">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-2xl bg-primary/10 flex items-center justify-center">
            <i class="bi bi-people text-primary text-lg"></i>
          </div>
          <div>
            <h2 class="font-display font-bold text-lg leading-tight">Utilisateurs</h2>
            <p class="text-base-content/35 text-xs mt-0.5">${utilisateurs.size()} compte(s) enregistré(s)</p>
          </div>
        </div>
        <c:if test="${sessionScope.connectedUser.role != 'ADMIN'}">
          <span class="badge badge-neutral gap-1.5 font-semibold"><i class="bi bi-lock text-xs"></i>Lecture seule</span>
        </c:if>
      </div>

      <div class="overflow-x-auto">
        <table class="table table-sm table-zebra">
          <thead>
            <tr class="text-[11px] font-bold text-base-content/35 uppercase tracking-widest border-b border-base-200">
              <th class="w-10">#</th><th>Utilisateur</th>
              <th class="hidden sm:table-cell">Email</th>
              <th>Rôle</th><th>Statut</th>
              <th class="hidden lg:table-cell">Créé le</th>
              <c:if test="${sessionScope.connectedUser.role == 'ADMIN'}">
                <th class="text-center">Actions</th>
              </c:if>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty utilisateurs}">
                <tr><td colspan="7" class="text-center py-10 text-base-content/25">
                  <i class="bi bi-people text-4xl block mb-2"></i><span class="font-medium">Aucun utilisateur.</span>
                </td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="u" items="${utilisateurs}" varStatus="st">
                  <tr class="hover ${not u.actif ? 'row-inactive' : ''}">
                    <td class="text-base-content/25 text-xs font-mono">${st.index + 1}</td>
                    <td>
                      <div class="flex items-center gap-3">
                        <div class="avatar placeholder">
                          <div class="w-8 h-8 rounded-xl text-xs font-bold transition-all duration-200
                            ${u.role == 'ADMIN' ? 'bg-error/12 text-error' : 'bg-base-300 text-base-content/60'}">
                            <span>${u.prenom.charAt(0)}${u.nom.charAt(0)}</span>
                          </div>
                        </div>
                        <span class="font-semibold text-sm">${u.fullName}</span>
                        <c:if test="${u.id == sessionScope.connectedUser.id}">
                          <span class="badge badge-ghost badge-xs font-semibold">vous</span>
                        </c:if>
                      </div>
                    </td>
                    <td class="hidden sm:table-cell text-sm text-base-content/50">${u.email}</td>
                    <td>
                      <c:choose>
                        <c:when test="${u.role == 'ADMIN'}">
                          <span class="badge badge-error badge-sm gap-1 font-semibold"><i class="bi bi-shield-fill text-[10px]"></i>Admin</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-neutral badge-sm font-semibold">Secrétaire</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${u.actif}">
                          <span class="badge badge-success badge-sm gap-1 font-semibold"><span class="w-1.5 h-1.5 rounded-full bg-current inline-block"></span>Actif</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge badge-warning badge-sm font-semibold">Inactif</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="hidden lg:table-cell text-xs text-base-content/35 font-medium">${u.createdAt}</td>
                    <c:if test="${sessionScope.connectedUser.role == 'ADMIN'}">
                      <td>
                        <div class="flex items-center justify-center gap-0.5">
                          <c:choose>
                            <c:when test="${u.id == sessionScope.connectedUser.id}">
                              <span class="text-xs text-base-content/20 italic px-3">—</span>
                            </c:when>
                            <c:otherwise>
                              <a href="${pageContext.request.contextPath}/utilisateurs?action=toggle&id=${u.id}"
                                 class="btn btn-ghost btn-xs rounded-lg action-btn ${u.actif ? 'text-warning hover:bg-warning/10' : 'text-success hover:bg-success/10'}"
                                 title="${u.actif ? 'Désactiver' : 'Activer'}"
                                 onclick="return confirm('${u.actif ? 'Désactiver' : 'Activer'} le compte de ${u.fullName} ?')">
                                <i class="bi bi-${u.actif ? 'pause-circle' : 'play-circle'}"></i>
                              </a>
                              <button class="btn btn-ghost btn-xs rounded-lg text-error hover:bg-error/10 action-btn"
                                      title="Supprimer"
                                      onclick="confirmDeleteUser('${pageContext.request.contextPath}/utilisateurs?action=delete&id=${u.id}','${u.fullName}')">
                                <i class="bi bi-trash"></i>
                              </button>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <%-- Delete student modal --%>
  <dialog id="deleteModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box rounded-3xl">
      <div class="flex items-center gap-4 mb-4">
        <div class="w-12 h-12 rounded-2xl bg-error/10 flex items-center justify-center flex-shrink-0">
          <i class="bi bi-trash text-error text-xl"></i>
        </div>
        <div>
          <h3 class="font-display font-bold text-lg">Supprimer l'étudiant</h3>
          <p class="text-base-content/40 text-sm">Cette action est irréversible.</p>
        </div>
      </div>
      <p class="text-sm text-base-content/60 mb-6">Êtes-vous sûr de vouloir supprimer <strong id="deleteStudentName" class="text-base-content"></strong> ?</p>
      <div class="modal-action gap-3">
        <form method="dialog"><button class="btn btn-ghost rounded-2xl normal-case font-semibold">Annuler</button></form>
        <a id="deleteConfirmBtn" href="#" class="btn btn-error rounded-2xl normal-case font-bold gap-2">
          <i class="bi bi-trash"></i> Supprimer définitivement
        </a>
      </div>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
  </dialog>

  <%-- Delete user modal --%>
  <dialog id="deleteUserModal" class="modal modal-bottom sm:modal-middle">
    <div class="modal-box rounded-3xl">
      <div class="flex items-center gap-4 mb-4">
        <div class="w-12 h-12 rounded-2xl bg-error/10 flex items-center justify-center flex-shrink-0">
          <i class="bi bi-person-x text-error text-xl"></i>
        </div>
        <div>
          <h3 class="font-display font-bold text-lg">Supprimer l'utilisateur</h3>
          <p class="text-base-content/40 text-sm">Cette action est irréversible.</p>
        </div>
      </div>
      <p class="text-sm text-base-content/60 mb-6">Êtes-vous sûr de vouloir supprimer le compte de <strong id="deleteUserName" class="text-base-content"></strong> ?</p>
      <div class="modal-action gap-3">
        <form method="dialog"><button class="btn btn-ghost rounded-2xl normal-case font-semibold">Annuler</button></form>
        <a id="deleteUserConfirmBtn" href="#" class="btn btn-error rounded-2xl normal-case font-bold gap-2">
          <i class="bi bi-person-x"></i> Supprimer le compte
        </a>
      </div>
    </div>
    <form method="dialog" class="modal-backdrop"><button>close</button></form>
  </dialog>

<script>
  document.getElementById('filiereSelect').addEventListener('change',()=>document.getElementById('searchForm').submit());
  document.getElementById('niveauSelect').addEventListener('change', ()=>document.getElementById('searchForm').submit());
  function confirmDelete(url,name){document.getElementById('deleteStudentName').textContent=name;document.getElementById('deleteConfirmBtn').href=url;document.getElementById('deleteModal').showModal();}
  function confirmDeleteUser(url,name){document.getElementById('deleteUserName').textContent=name;document.getElementById('deleteUserConfirmBtn').href=url;document.getElementById('deleteUserModal').showModal();}
<\/script>
</body>
</html>