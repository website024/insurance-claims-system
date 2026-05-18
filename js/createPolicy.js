function createPolicyDemo() {
  const policies = JSON.parse(localStorage.getItem("policies")) || [];

  const policy = {
    policyId: policies.length,

    customer: document.getElementById("customerAddress").value,

    policyType: document.getElementById("policyType").value,

    claimLimit: document.getElementById("claimLimit").value,

    durationDays: document.getElementById("durationDays").value,

    conditionText: document.getElementById("conditionText").value,

    status: "Active",

    txHash: "0xPOLICY" + Date.now(),
  };

  policies.push(policy);

  localStorage.setItem("policies", JSON.stringify(policies));

  document.getElementById("policyMessage").innerText =
    "Policy created successfully! TX Hash: " + policy.txHash;

  console.log(policies);
}
