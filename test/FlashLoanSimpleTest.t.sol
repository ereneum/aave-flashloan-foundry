//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {FlashLoanSimple} from "src/FlashLoanSimple.sol";

contract FlashLoanSimpleTest is Test {
    FlashLoanSimple public flashLoanSimple;

    function setUp() public {
        // Create a new instance of the flashLoanSimple contract.
        flashLoanSimple = new FlashLoanSimple();
        // Give 10 USDC to the flashLoanSimple contract. (6 decimals)
        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(flashLoanSimple), 10_000_000);
    }

    // Request a flash loan of 10,000 USDC.
    function testRequestFlashLoan() public {
        flashLoanSimple.requestFlashLoan(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10_000);
    }

    // Request a flash loan of 10,000 USDC and execute the operation.
    function testExecuteOperation() public {
        flashLoanSimple.requestFlashLoan(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10_000);
        flashLoanSimple.executeOperation(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), 10_000, 10_000_000_000 * 9 / 10000, address(0), ""
        );
    }

    // Withdraw the initial 10 USDC.
    function testWithdraw() public {
        flashLoanSimple.withdraw(address(this), 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10);
    }

    // Request a flash loan of 100,000 USDC, transaction is expected to revert.
    function testRequestFlashLoanFail() public {
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        flashLoanSimple.requestFlashLoan(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 100_000);
    }

    // Withdraw 11 USDC, which is more than the initial amount.
    function testWithdrawBalanceFail() public {
        vm.expectRevert("Insufficient balance.");
        flashLoanSimple.withdraw(address(this), 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 11);
    }

    // Withdrawal with non-owner address.
    function testWithdrawOwnerFail() public {
        vm.prank(address(1));
        vm.expectRevert("Only callable by the owner.");
        flashLoanSimple.withdraw(address(this), 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10);
    }
}
