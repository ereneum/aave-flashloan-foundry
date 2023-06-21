//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {FlashLoanSimple} from "src/FlashLoanSimple.sol";

contract FlashLoanSimpleTest is Test {
    function test_fn_RequestFlashLoan() public {
        // Create a new instance of the flashLoanSimple contract.
        FlashLoanSimple flashLoanSimple = new FlashLoanSimple();

        // Give 10 USDC to the flashLoanSimple contract. (6 decimals)
        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(flashLoanSimple), 10_000_000);

        // Request a flash loan of 10,000 USDC.
        flashLoanSimple.fn_RequestFlashLoan(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10_000);
    }

    function test_executeOperation() public {
        // Create a new instance of the flashLoanSimple contract.
        FlashLoanSimple flashLoanSimple = new FlashLoanSimple();

        // Give 10 USDC to the flashLoanSimple contract. (6 decimals)
        deal(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, address(flashLoanSimple), 10_000_000);

        // Request a flash loan of 10,000 USDC.
        flashLoanSimple.fn_RequestFlashLoan(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 10_000);

        // Execute the operation.
        flashLoanSimple.executeOperation(
            address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), 10_000, 10_000_000_000 * 9 / 10000, address(0), ""
        );
    }
}
