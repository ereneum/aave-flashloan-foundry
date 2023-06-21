//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {FlashLoanSimpleReceiverBase} from "aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {ERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/ERC20.sol";
import {IERC20} from "aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoanSimple is FlashLoanSimpleReceiverBase {
    address payable owner;

    // Using Ethereum Mainnet PoolAddressesProvider. To change: https://docs.aave.com/developers/deployed-contracts/v3-mainnet
    constructor() FlashLoanSimpleReceiverBase(IPoolAddressesProvider(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e)) {
        owner = payable(msg.sender);
    }

    function fn_RequestFlashLoan(address _asset, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _asset;
        uint256 amount = _amount * 10 ** ERC20(_asset).decimals();
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function executeOperation(
        address _asset,
        uint256 _amount,
        uint256 _premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Your customized codes.
        uint256 amount = _amount * 10 ** ERC20(_asset).decimals();
        uint256 premium = amount * 9 / 10000;
        uint256 totalAmount = amount + premium;
        IERC20(_asset).approve(address(POOL), totalAmount);

        return true;
    }

    function withdraw(address _recipient, address _asset, uint256 _amount) external {
        uint256 amount = _amount * 10 ** ERC20(_asset).decimals();
        require(amount <= ERC20(_asset).balanceOf(address(this)), "Insufficient balance.");
        require(msg.sender == owner, "Only callable by the owner.");

        IERC20(_asset).transfer(_recipient, amount);
    }

    receive() external payable {}
}
