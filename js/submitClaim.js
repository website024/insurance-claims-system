function submitClaimDemo() {
  const claims = JSON.parse(localStorage.getItem("claims")) || [];

  const claim = {
    claimId: claims.length,
    policyId: document.getElementById("policyId").value,
    amount: document.getElementById("claimAmount").value,
    reason: document.getElementById("claimReason").value,
    evidenceHash: document.getElementById("evidenceHash").value,
    status: "Pending",
    txHash: "0xCLAIM" + Date.now(),
  };

  claims.push(claim);
  localStorage.setItem("claims", JSON.stringify(claims));

  document.getElementById("claimMessage").innerText =
    "Claim submitted successfully! TX Hash: " + claim.txHash;
}
