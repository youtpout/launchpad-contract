//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

// Exemple contract don't use it in prod, need to implement buyer part
contract Launchpad is AccessControlEnumerable {
    error notOwner();
    error cantCancelFinished();
    error tokenNotApproved(uint256);
    error tokenIncorrectAmount(uint256);
    error notLaunched();
    error tooSoon();

    enum PresaleStatus {
        Creation,
        Cancelled,
        Launched,
        Finished,
        NotFilled
    }

    struct Presale {
        uint256 id;
        address tokenAddress;
        uint256 tokenAmount;
        uint256 tokenByBNB;
        address owner;
        uint256 amountMin;
        uint256 amountMax;
        uint256 startDate;
        uint256 endDate;
        uint256 softCap;
        uint256 hardCap;
        uint256 actualCap;
        PresaleStatus status;
    }

    Presale[] public presales;

    event PresaleCreated(address owner, address token, uint256 presaleId);
    event PresaleCanceled(uint256 presaleId);
    event PresaleLaunched(uint256 presaleId);
    event PresaleFinished(uint256 presaleId, bool filled);

    mapping(address => uint256[]) public userPresales;
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MODERATOR_ROLE, _msgSender());
    }

    function createPresale(
        IERC20 token,
        uint256 tokenAmount,
        uint256 tokenByBNB,
        uint256 amountMin,
        uint256 amountMax,
        uint256 softCap,
        uint256 hardCap
    ) public {
        uint256 allowance = token.allowance(msg.sender, address(this));
        if (allowance < tokenAmount) {
            revert tokenNotApproved(allowance);
        }
        token.transfer(address(this), tokenAmount);
        uint256 balance = token.balanceOf(address(this));
        if (balance < tokenAmount) {
            revert tokenIncorrectAmount(balance);
        }
        Presale memory newPresale;
        newPresale.id = presales.length;
        newPresale.tokenAddress = address(token);
        newPresale.tokenAmount = tokenAmount;
        newPresale.tokenByBNB = tokenByBNB;
        newPresale.amountMin = amountMin;
        newPresale.amountMax = amountMax;
        newPresale.softCap = softCap;
        newPresale.hardCap = hardCap;
        newPresale.owner = msg.sender;
        newPresale.status = PresaleStatus.Creation;

        presales.push(newPresale);
        userPresales[msg.sender].push(newPresale.id);

        emit PresaleCreated(msg.sender, address(token), newPresale.id);
    }

    function launch(uint256 id, uint256 endDate) public {
        if (presales[id].owner != msg.sender) {
            revert notOwner();
        }
        presales[id].startDate = block.timestamp;
        presales[id].endDate = endDate;
        presales[id].status = PresaleStatus.Launched;
        emit PresaleLaunched(id);
    }

    function canceled(uint256 id) public {
        if (presales[id].owner != msg.sender) {
            revert notOwner();
        }
        if (presales[id].status == PresaleStatus.Finished) {
            revert cantCancelFinished();
        }
        presales[id].status = PresaleStatus.Cancelled;
        emit PresaleCanceled(id);
    }

    function moderatorCancel(uint256 id) public onlyRole(MODERATOR_ROLE) {
        if (presales[id].status == PresaleStatus.Finished) {
            revert cantCancelFinished();
        }
        presales[id].status = PresaleStatus.Cancelled;
        emit PresaleCanceled(id);
    }

    function finished(uint256 id) public onlyRole(MODERATOR_ROLE) {
        if (presales[id].status != PresaleStatus.Launched) {
            revert notLaunched();
        }
        if (presales[id].endDate < block.timestamp) {
            revert tooSoon();
        }
        if (presales[id].actualCap < presales[id].softCap) {
            presales[id].status = PresaleStatus.NotFilled;
            emit PresaleFinished(id, false);
        } else {
            presales[id].status = PresaleStatus.Finished;
            emit PresaleFinished(id, true);
        }
    }

    function presalesCount() public view returns (uint256) {
        return presales.length;
    }
}
