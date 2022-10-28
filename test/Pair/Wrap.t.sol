// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../shared/Fixture.t.sol";
import "../../src/Caviar.sol";

contract WrapTest is Fixture {
    uint256[] public tokenIds;

    function setUp() public {
        bayc.setApprovalForAll(address(p), true);

        for (uint256 i = 0; i < 5; i++) {
            bayc.mint(address(this), i);
            tokenIds.push(i);
        }
    }

    function testItTransfersTokens() public {
        // act
        p.wrap(tokenIds);

        // assert
        for (uint256 i = 0; i < tokenIds.length; i++) {
            assertEq(bayc.ownerOf(i), address(p), "Should have sent bayc to pair");
        }
    }

    function testItMintsFractionalTokens() public {
        // arrange
        uint256 expectedFractionalTokens = tokenIds.length * 1e18;

        // act
        p.wrap(tokenIds);

        // assert
        assertEq(p.balanceOf(address(this)), expectedFractionalTokens, "Should have minted fractional tokens to sender");
        assertEq(p.totalSupply(), expectedFractionalTokens, "Should have minted fractional tokens");
    }
}
