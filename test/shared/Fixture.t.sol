// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/tokens/ERC721.sol";
import {RoyaltyRegistry} from "royalty-registry-solidity/RoyaltyRegistry.sol";
import "reservoir-oracle/ReservoirOracle.sol";

import "../../src/Caviar.sol";
import "../../src/Pair.sol";
import "../../src/CaviarEthRoyaltyRouter.sol";
import "../../src/StolenNftFilterOracle.sol";
import "./mocks/MockERC721.sol";
import "./mocks/MockERC20.sol";
import "./mocks/MockERC721WithRoyalty.sol";
import "../../script/CreatePair.s.sol";

contract Fixture is Test, ERC721TokenReceiver {
    MockERC721WithRoyalty public bayc;
    MockERC20 public usd;

    CreatePairScript public createPairScript;
    Caviar public c;
    Pair public p;
    LpToken public lpToken;
    Pair public ethPair;
    LpToken public ethPairLpToken;
    CaviarEthRoyaltyRouter public router;
    StolenNftFilterOracle public stolenNftFilterOracle;

    address public babe = address(0xbabe);

    constructor() {
        createPairScript = new CreatePairScript();
        stolenNftFilterOracle = new StolenNftFilterOracle();

        c = new Caviar(address(0));

        bayc = new MockERC721WithRoyalty("yeet", "YEET");
        usd = new MockERC20("us dollar", "USD", 6);

        p = c.create(address(bayc), address(usd), bytes32(0));
        lpToken = LpToken(p.lpToken());

        ethPair = c.create(address(bayc), address(0), bytes32(0));
        ethPairLpToken = LpToken(ethPair.lpToken());

        address registry = address(new RoyaltyRegistry(address(0)));
        router = new CaviarEthRoyaltyRouter(registry);

        vm.label(babe, "babe");
        vm.label(address(c), "caviar");
        vm.label(address(bayc), "bayc");
        vm.label(address(usd), "usd");
        vm.label(address(p), "pair");
        vm.label(address(lpToken), "LP-token");
        vm.label(address(ethPair), "ethPair");
        vm.label(address(ethPairLpToken), "ethPair-LP-token");
        vm.label(address(router), "router");
        vm.label(address(registry), "registry");
    }

    receive() external payable {}
}
