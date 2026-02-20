<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Connexion — GesEtu</title>
  <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
  <script>
    tailwind.config = { theme: { extend: { fontFamily: { display: ['Syne', 'sans-serif'], body: ['DM Sans', 'sans-serif'] } } } }
  </script>
  <style>
    html, body { font-family: 'DM Sans', sans-serif; }
    h1,h2,h3,.font-display { font-family: 'Syne', sans-serif; }
    .mesh-bg {
      background-color: hsl(var(--b1));
      background-image:
        radial-gradient(at 20% 30%, hsl(var(--p) / 0.15) 0px, transparent 55%),
        radial-gradient(at 80% 10%, hsl(var(--s) / 0.12) 0px, transparent 50%),
        radial-gradient(at 60% 80%, hsl(var(--a) / 0.10) 0px, transparent 45%);
    }
    .glass-card {
      background: hsl(var(--b1) / 0.85);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid hsl(var(--b3) / 0.6);
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .slide-up { animation: slideUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
    .slide-up-delay { animation: slideUp 0.5s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both; }
  </style>
</head>
<body class="mesh-bg min-h-screen flex items-center justify-center p-4">

  <%-- Theme persists from localStorage --%>
  <script>
    const t = localStorage.getItem('gesetu-theme');
    if (t) document.documentElement.setAttribute('data-theme', t);
  </script>

  <%-- Theme toggle floating --%>
  <div class="fixed top-4 right-4 z-50">
    <label class="swap swap-rotate btn btn-ghost btn-sm btn-circle bg-base-100/80 backdrop-blur shadow-sm border border-base-200">
      <input type="checkbox" id="themeToggle" />
      <i class="swap-off bi bi-sun-fill text-warning"></i>
      <i class="swap-on bi bi-moon-stars-fill text-info"></i>
    </label>
  </div>

  <div class="w-full max-w-md slide-up">

    <%-- Logo header --%>
    <div class="text-center mb-8 slide-up">
      <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-primary shadow-lg shadow-primary/30 mb-4">
        <i class="bi bi-mortarboard-fill text-2xl text-primary-content"></i>
      </div>
      <h1 class="font-display text-3xl font-black text-base-content tracking-tight">
        Ges<span class="text-primary">Etu</span>
      </h1>
      <p class="text-base-content/50 text-sm mt-1 font-light">Système de gestion des étudiants</p>
    </div>

    <%-- Card --%>
    <div class="glass-card rounded-3xl shadow-2xl p-8 slide-up-delay">

      <%-- Flash message --%>
      <c:if test="${not empty sessionScope.flashMessage}">
        <div class="alert alert-success mb-6 rounded-2xl text-sm">
          <i class="bi bi-check-circle-fill"></i>
          <span>${sessionScope.flashMessage}</span>
          <button onclick="this.closest('.alert').remove()" class="btn btn-ghost btn-xs btn-circle ml-auto">
            <i class="bi bi-x"></i>
          </button>
        </div>
        <c:remove var="flashMessage" scope="session"/>
      </c:if>

      <c:if test="${not empty error}">
        <div class="alert alert-error mb-6 rounded-2xl text-sm">
          <i class="bi bi-exclamation-triangle-fill"></i>
          <span>${error}</span>
        </div>
      </c:if>

      <h2 class="font-display text-xl font-bold text-base-content mb-6">Connexion</h2>

      <form action="${pageContext.request.contextPath}/auth" method="post" class="space-y-4" novalidate>

        <%-- Email --%>
        <div class="form-control">
          <label class="label pb-1">
            <span class="label-text font-medium text-sm">Adresse email</span>
          </label>
          <label class="input input-bordered flex items-center gap-3 rounded-xl focus-within:input-primary transition-all">
            <i class="bi bi-envelope text-base-content/40 text-sm"></i>
            <input type="email" name="email" value="${email}" placeholder="vous@example.com"
                   class="grow text-sm" required autofocus />
          </label>
        </div>

        <%-- Password --%>
        <div class="form-control">
          <label class="label pb-1">
            <span class="label-text font-medium text-sm">Mot de passe</span>
          </label>
          <label class="input input-bordered flex items-center gap-3 rounded-xl focus-within:input-primary transition-all">
            <i class="bi bi-lock text-base-content/40 text-sm"></i>
            <input type="password" id="motDePasse" name="motDePasse" placeholder="••••••••"
                   class="grow text-sm" required />
            <button type="button" id="togglePwd" tabindex="-1"
                    class="text-base-content/30 hover:text-primary transition-colors">
              <i class="bi bi-eye text-sm" id="eyeIcon"></i>
            </button>
          </label>
        </div>

        <button type="submit"
                class="btn btn-primary w-full rounded-xl font-semibold mt-2 shadow-lg shadow-primary/20 hover:shadow-primary/40 transition-all">
          <i class="bi bi-box-arrow-in-right"></i>
          Se connecter
        </button>
      </form>

      <div class="divider text-xs text-base-content/30 my-6">Pas encore de compte ?</div>

      <a href="${pageContext.request.contextPath}/inscription"
         class="btn btn-outline btn-block rounded-xl font-medium text-sm normal-case">
        <i class="bi bi-person-plus"></i>
        Créer un compte
      </a>
    </div>

    <p class="text-center text-xs text-base-content/30 mt-6">
      GesEtu © 2026 — Tous droits réservés
    </p>
  </div>

<script>
  // Theme toggle
  (function() {
    const toggle = document.getElementById('themeToggle');
    const saved  = localStorage.getItem('gesetu-theme') || 'light';
    document.documentElement.setAttribute('data-theme', saved);
    toggle.checked = saved === 'dark';
    toggle.addEventListener('change', function() {
      const theme = this.checked ? 'dark' : 'light';
      document.documentElement.setAttribute('data-theme', theme);
      localStorage.setItem('gesetu-theme', theme);
    });
  })();

  // Password toggle
  document.getElementById('togglePwd').addEventListener('click', function() {
    const pwd  = document.getElementById('motDePasse');
    const icon = document.getElementById('eyeIcon');
    pwd.type   = pwd.type === 'password' ? 'text' : 'password';
    icon.className = pwd.type === 'password' ? 'bi bi-eye text-sm' : 'bi bi-eye-slash text-sm';
  });
</script>
</body>
</html>
