<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${empty etudiant ? 'Ajouter' : 'Modifier'} un étudiant — GesEtu</title>
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
    @keyframes spin-slow{to{transform:rotate(360deg)}}
    .anim-fade-up{animation:fadeUp 0.5s var(--ease-smooth) both;}
    .anim-scale-in{animation:scaleIn 0.4s var(--ease-spring) both;}
    .d-0{animation-delay:0ms}.d-50{animation-delay:50ms}.d-100{animation-delay:100ms}
    .d-150{animation-delay:150ms}.d-200{animation-delay:200ms}.d-250{animation-delay:250ms}
    .shimmer-text{
      background:linear-gradient(90deg,hsl(var(--p)) 0%,hsl(var(--s)) 50%,hsl(var(--p)) 100%);
      background-size:200% auto;-webkit-background-clip:text;background-clip:text;
      -webkit-text-fill-color:transparent;animation:shimmer 3.5s linear infinite;
    }
    .input-wrap{transition:all 0.22s var(--ease-smooth);}
    .input-wrap:focus-within{transform:translateY(-1px);box-shadow:0 8px 24px -6px hsl(var(--p)/0.2);}
    .form-field{
      transition:all 0.22s var(--ease-smooth);
    }
    .form-field:focus-within .field-label{color:hsl(var(--p));transform:scale(0.97);}
    .btn:active{transform:scale(0.97)!important;}
    .btn-submit{transition:all 0.3s var(--ease-smooth);}
    .btn-submit:hover{transform:translateY(-2px);box-shadow:0 12px 32px -8px hsl(var(--p)/0.5);}
    ::-webkit-scrollbar{width:5px}::-webkit-scrollbar-thumb{background:hsl(var(--b3));border-radius:999px}
  </style>
</head>
<body class="bg-base-200 min-h-screen text-base-content antialiased">
  <script>const _t=localStorage.getItem('gesetu-theme');if(_t)document.documentElement.setAttribute('data-theme',_t);</script>
  <%@ include file="fragments/navbar.jsp" %>

  <main class="max-w-3xl mx-auto py-10 px-4">
    <div class="text-sm breadcrumbs mb-6 text-base-content/40 anim-fade-up d-0">
      <ul>
        <li><a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary transition-colors">Tableau de bord</a></li>
        <li class="text-base-content/70 font-medium">${empty etudiant ? 'Ajouter un étudiant' : 'Modifier l\'étudiant'}</li>
      </ul>
    </div>

    <div class="card bg-base-100 shadow-xl border border-base-200 rounded-3xl anim-fade-up d-50">
      <div class="card-body p-8 md:p-10">
        <div class="flex items-center gap-5 mb-8">
          <c:choose>
            <c:when test="${empty etudiant}">
              <div class="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center flex-shrink-0 anim-scale-in d-100" style="animation:scaleIn 0.4s 100ms var(--ease-spring) both">
                <i class="bi bi-person-plus-fill text-2xl text-primary"></i>
              </div>
            </c:when>
            <c:otherwise>
              <div class="w-16 h-16 rounded-2xl bg-warning/10 flex items-center justify-center flex-shrink-0 anim-scale-in d-100">
                <i class="bi bi-pencil-square text-2xl text-warning"></i>
              </div>
            </c:otherwise>
          </c:choose>
          <div class="anim-fade-up d-100">
            <h2 class="font-display text-2xl font-bold leading-tight">
              ${empty etudiant ? 'Ajouter un étudiant' : 'Modifier l\'étudiant'}
            </h2>
            <p class="text-base-content/40 text-sm mt-1">
              Les champs <span class="text-error font-semibold">*</span> sont obligatoires
            </p>
          </div>
        </div>

        <c:if test="${not empty error}">
          <div class="alert alert-error rounded-2xl mb-6 text-sm anim-scale-in">
            <i class="bi bi-exclamation-triangle-fill"></i><span>${error}</span>
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/etudiants" method="post" novalidate>
          <input type="hidden" name="action" value="${empty etudiant ? 'add' : 'edit'}"/>
          <input type="hidden" name="id" value="${etudiant.id}"/>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
            <div class="form-control form-field anim-fade-up d-150">
              <label class="label pb-1"><span class="label-text font-semibold text-sm field-label transition-all duration-200">Prénom <span class="text-error">*</span></span></label>
              <input type="text" name="prenom" value="${not empty prenom ? prenom : etudiant.prenom}" placeholder="Jean" required
                     class="input input-bordered input-wrap rounded-2xl text-sm focus:input-primary hover:border-primary/40 transition-all duration-200"/>
            </div>
            <div class="form-control form-field anim-fade-up d-150">
              <label class="label pb-1"><span class="label-text font-semibold text-sm field-label transition-all duration-200">Nom <span class="text-error">*</span></span></label>
              <input type="text" name="nom" value="${not empty nom ? nom : etudiant.nom}" placeholder="Dupont" required
                     class="input input-bordered input-wrap rounded-2xl text-sm focus:input-primary hover:border-primary/40 transition-all duration-200"/>
            </div>
            <div class="form-control form-field anim-fade-up d-200">
              <label class="label pb-1"><span class="label-text font-semibold text-sm field-label transition-all duration-200">Matricule <span class="text-error">*</span></span></label>
              <input type="text" name="matricule" value="${not empty matricule ? matricule : etudiant.matricule}" placeholder="STU-001" required
                     ${not empty etudiant ? 'readonly' : ''}
                     class="input input-bordered rounded-2xl text-sm transition-all duration-200 ${not empty etudiant ? 'opacity-55 cursor-not-allowed bg-base-200' : 'input-wrap focus:input-primary hover:border-primary/40'}"/>
              <c:if test="${not empty etudiant}">
                <label class="label pt-1"><span class="label-text-alt text-base-content/35 text-xs flex items-center gap-1"><i class="bi bi-info-circle"></i>Le matricule ne peut pas être modifié</span></label>
              </c:if>
            </div>
            <div class="form-control anim-fade-up d-200">
              <label class="label pb-1"><span class="label-text font-semibold text-sm">Email</span></label>
              <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-primary hover:border-primary/40 transition-all duration-200">
                <i class="bi bi-envelope text-base-content/35 text-sm"></i>
                <input type="email" name="email" value="${not empty email ? email : etudiant.email}" placeholder="jean@etu.cm" class="grow text-sm"/>
              </label>
            </div>
            <div class="form-control anim-fade-up d-250">
              <label class="label pb-1"><span class="label-text font-semibold text-sm">Filière</span></label>
              <label class="input input-bordered input-wrap flex items-center gap-3 rounded-2xl focus-within:input-primary hover:border-primary/40 transition-all duration-200">
                <i class="bi bi-building text-base-content/35 text-sm"></i>
                <input type="text" name="filiere" value="${not empty filiere ? filiere : etudiant.filiere}" placeholder="Informatique" class="grow text-sm"/>
              </label>
            </div>
            <div class="form-control anim-fade-up d-250">
              <label class="label pb-1"><span class="label-text font-semibold text-sm">Niveau</span></label>
              <select name="niveau" class="select select-bordered rounded-2xl text-sm focus:select-primary hover:border-primary/40 transition-all duration-200 input-wrap">
                <option value="">— Choisir —</option>
                <c:forEach var="n" items="${['L1','L2','L3','M1','M2','D1','D2','D3']}">
                  <option value="${n}" ${(not empty niveau ? niveau : etudiant.niveau) == n ? 'selected' : ''}>${n}</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-control md:col-span-2 md:w-1/2 anim-fade-up d-250">
              <label class="label pb-1"><span class="label-text font-semibold text-sm">Date de naissance</span></label>
              <input type="date" name="dateNaissance" value="${not empty dateNaissance ? dateNaissance : etudiant.dateNaissance}"
                     class="input input-bordered input-wrap rounded-2xl text-sm focus:input-primary hover:border-primary/40 transition-all duration-200"/>
            </div>
          </div>

          <div class="flex flex-col sm:flex-row gap-3 mt-8 pt-6 border-t border-base-200 anim-fade-up d-250">
            <button type="submit" class="btn btn-primary rounded-2xl font-bold gap-2 btn-submit shadow-lg shadow-primary/25">
              <i class="bi bi-check-lg text-base"></i>
              ${empty etudiant ? 'Enregistrer l\'étudiant' : 'Mettre à jour'}
            </button>
            <a href="${pageContext.request.contextPath}/dashboard"
               class="btn btn-ghost rounded-2xl font-medium gap-2 border border-base-content/10 hover:border-base-content/20 transition-all duration-200">
              <i class="bi bi-x-lg"></i> Annuler
            </a>
          </div>
        </form>
      </div>
    </div>
  </main>
</body>
</html>