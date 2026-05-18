function goToDashboard(role) {
  localStorage.setItem("role", role);
  window.location.href = "dashboard.html";
}

document.addEventListener("DOMContentLoaded", function () {
  const role = localStorage.getItem("role");
  const roleText = document.getElementById("roleText");

  if (roleText && role) {
    roleText.innerText = "Current role: " + role;
  }

  const createPolicyLink = document.querySelector(
    'a[href="createPolicy.html"]',
  );
  const submitClaimLink = document.querySelector('a[href="submitClaim.html"]');
  const verifyClaimLink = document.querySelector('a[href="verifyClaim.html"]');

  if (role === "company") {
    submitClaimLink.style.display = "none";
  }

  if (role === "customer") {
    createPolicyLink.style.display = "none";
    verifyClaimLink.style.display = "none";
  }

  if (role === "verifier") {
    createPolicyLink.style.display = "none";
    submitClaimLink.style.display = "none";
  }
});
