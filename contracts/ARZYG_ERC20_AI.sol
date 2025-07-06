// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/functions/FunctionsClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/// @title ARZY-G Token with AI-Verified Usefulness via Chainlink Functions (Web4 Standard)
/// @author Arzykul Muratov
contract ARZYG_ERC20_AI is ERC20, AccessControl, FunctionsClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    bytes32 public constant RESERVE_ROLE = keccak256("RESERVE_ROLE");
    address public reserve;

    bytes32 public donID;

    struct ProofRequest {
        address to;
        uint256 amount;
        string proof;
    }

    mapping(bytes32 => ProofRequest) public pendingRequests;

    event MintRequested(bytes32 indexed requestId, address indexed to, uint256 amount, string proof);
    event AIMinted(address indexed to, uint256 amount, string proof);
    event ProofRejected(bytes32 indexed requestId, string reason);
    event ReserveChanged(address indexed oldReserve, address indexed newReserve);

    constructor(
        uint256 initialSupply,
        address _reserve,
        address router,
        bytes32 _donID
    )
        ERC20("ARZY-G", "ARZYG")
        FunctionsClient(router)
        ConfirmedOwner(msg.sender)
    {
        require(_reserve != address(0), "Invalid reserve");

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(RESERVE_ROLE, _reserve);

        reserve = _reserve;
        donID = _donID;

        _mint(_reserve, initialSupply);
    }

    modifier onlyReserve() {
        require(hasRole(RESERVE_ROLE, msg.sender), "Not reserve");
        _;
    }

    function changeReserve(address newReserve) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newReserve != address(0), "Invalid reserve");

        address old = reserve;
        reserve = newReserve;

        _revokeRole(RESERVE_ROLE, old);
        _grantRole(RESERVE_ROLE, newReserve);

        emit ReserveChanged(old, newReserve);
    }

    /// @notice Called by backend/server via Chainlink Functions
    function requestAIMint(
        string calldata sourceCode,
        string calldata proof,
        address to,
        uint256 amount,
        bytes calldata secrets
    ) external onlyOwner returns (bytes32 requestId) {
        require(to != address(0), "Invalid to");
        require(amount > 0, "Zero amount");
        require(bytes(proof).length > 5, "Short proof");

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(sourceCode);
        req.addArgs([proof]);
        if (secrets.length > 0) {
            req.secretsLocation = FunctionsRequest.Location.DONHosted;
            req.encryptedSecretsReference = secrets;
        }

        requestId = _sendRequest(req.encodeCBOR(), SubscriptionManager.getCurrentSubscription(), 250_000, donID);

        pendingRequests[requestId] = ProofRequest(to, amount, proof);
        emit MintRequested(requestId, to, amount, proof);
    }

    /// @notice Called by Chainlink node after AI verified usefulness
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        ProofRequest memory req = pendingRequests[requestId];
        delete pendingRequests[requestId];

        if (bytes(err).length > 0) {
            emit ProofRejected(requestId, string(err));
            return;
        }

        uint256 result = abi.decode(response, (uint256));
        if (result == 1) {
            _mint(req.to, req.amount);
            emit AIMinted(req.to, req.amount, req.proof);
        } else {
            emit ProofRejected(requestId, "Rejected by AI");
        }
    }
}
