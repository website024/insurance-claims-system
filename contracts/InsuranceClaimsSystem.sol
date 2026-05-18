// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsuranceClaimsSystem {
    address public insuranceCompany;

    constructor() payable {
        insuranceCompany = msg.sender;
    }

    enum PolicyStatus {
        Active,
        Expired
    }

    enum ClaimStatus {
        Pending,
        Processing,
        NeedMoreEvidence,
        Approved,
        Rejected,
        Paid
    }

    struct Policy {
        uint256 policyId;
        address customer;
        string policyType;
        uint256 claimLimit;
        uint256 expiryDate;
        string conditionText;
        PolicyStatus status;
    }

    struct Claim {
        uint256 claimId;
        uint256 policyId;
        address customer;
        string evidenceHash;
        uint256 amount;
        ClaimStatus status;
    }

    uint256 public nextPolicyId;
    uint256 public nextClaimId;

    mapping(uint256 => Policy) public policies;
    mapping(uint256 => Claim) public claims;

    event PolicyCreated(uint256 policyId, address customer);
    event ClaimSubmitted(uint256 claimId, uint256 policyId, address customer);
    event ClaimStatusUpdated(uint256 claimId, ClaimStatus status);
    event ClaimPaid(uint256 claimId, address customer, uint256 amount);

    modifier onlyCompany() {
        require(msg.sender == insuranceCompany, "Only insurance company");
        _;
    }

    function createPolicy(
        address _customer,
        string memory _policyType,
        uint256 _claimLimit,
        uint256 _durationInDays,
        string memory _conditionText
    ) public onlyCompany {
        uint256 expiryDate = block.timestamp + (_durationInDays * 1 days);

        policies[nextPolicyId] = Policy(
            nextPolicyId,
            _customer,
            _policyType,
            _claimLimit,
            expiryDate,
            _conditionText,
            PolicyStatus.Active
        );

        emit PolicyCreated(nextPolicyId, _customer);
        nextPolicyId++;
    }

    function submitClaim(
        uint256 _policyId,
        string memory _evidenceHash,
        uint256 _amount
    ) public {
        Policy memory policy = policies[_policyId];

        require(policy.customer == msg.sender, "Only policy owner");
        require(policy.status == PolicyStatus.Active, "Policy is not active");
        require(block.timestamp <= policy.expiryDate, "Policy expired");
        require(_amount <= policy.claimLimit, "Amount exceeds claim limit");

        claims[nextClaimId] = Claim(
            nextClaimId,
            _policyId,
            msg.sender,
            _evidenceHash,
            _amount,
            ClaimStatus.Pending
        );

        emit ClaimSubmitted(nextClaimId, _policyId, msg.sender);
        nextClaimId++;
    }

    function updateClaimStatus(
        uint256 _claimId,
        ClaimStatus _status
    ) public onlyCompany {
        require(
            claims[_claimId].status != ClaimStatus.Paid,
            "Paid claim cannot be updated"
        );

        claims[_claimId].status = _status;
        emit ClaimStatusUpdated(_claimId, _status);
    }

    function payClaim(uint256 _claimId) public onlyCompany {
        Claim storage claim = claims[_claimId];

        require(claim.status == ClaimStatus.Approved, "Claim is not approved");
        require(address(this).balance >= claim.amount, "Not enough contract balance");

        payable(claim.customer).transfer(claim.amount);
        claim.status = ClaimStatus.Paid;

        emit ClaimPaid(_claimId, claim.customer, claim.amount);
    }

    receive() external payable {}
}