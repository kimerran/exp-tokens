// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Experience is ERC20, Ownable {
    uint256 constant WEI_PER_ETH = 1000000000000000000;
    uint256 private _kudosSize = 100000000000000000000;
    uint256 private _initialKudosBalance = _kudosSize * 100;
    struct Member {
        address wallet;
        string name;
        uint256 kudosBalance;
    }

    mapping(address => Member) experienceMap;
    mapping(string => address) resolveName;

    constructor(
        uint256 initialSupply
    ) ERC20("Experience Token", "EXP") Ownable(msg.sender) {
        _mint(address(this), initialSupply);
    }

    function register(string memory name) public {
        require(
            experienceMap[msg.sender].wallet == address(0),
            "Wallet already registered"
        );

        experienceMap[msg.sender] = Member({
            wallet: msg.sender,
            kudosBalance: _initialKudosBalance,
            name: name
        });
        resolveName[name] = msg.sender;
    }

    function getKudosBalance(address wallet) public view returns (uint256) {
        return experienceMap[wallet].kudosBalance;
    }

    function kudos(address destination) public {
        require(
            experienceMap[msg.sender].kudosBalance >= _kudosSize,
            "No Kudos Left"
        );

        _approve(address(this), msg.sender, _kudosSize);
        transferFrom(address(this), destination, _kudosSize);

        experienceMap[msg.sender].kudosBalance -= _kudosSize;
    }

    function rewardByName(
        uint256 amountInEth,
        string memory name
    ) public onlyOwner {
        require(resolveName[name] != address(0), "Name is not registered");
        address destination = resolveName[name];
        reward(amountInEth, destination);
    }

    function reward(uint256 amountInEth, address destination) public onlyOwner {
        uint256 weiAmount = amountInEth * WEI_PER_ETH;
        _approve(address(this), msg.sender, weiAmount);
        transferFrom(address(this), destination, weiAmount);
    }
}
