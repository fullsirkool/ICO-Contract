// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ICO is ERC20, Ownable, ReentrancyGuard {

    uint256 private _maxSupply;
    uint256 private _remainAvailabilityNumber;
    address private _creator;

    constructor(uint256 amount) ERC20("Anhihi Token", "ANH") {
        _creator = msg.sender;
        _maxSupply = amount;
        _remainAvailabilityNumber = amount;
    }

    function setMaxSupply(uint256 amount) external {
        require(msg.sender == _creator, "Your are not creator!");
        _maxSupply = amount;
    }

    function setRemainAvailability(uint256 useAmount, string memory sign) private {
        if(keccak256(abi.encodePacked((sign))) == keccak256(abi.encodePacked(("+")))) {
            _remainAvailabilityNumber += useAmount;
        } else {
            _remainAvailabilityNumber -= useAmount;
        }
    }

    function getRemainAvailability() external view returns (uint256) {
        return _remainAvailabilityNumber;
    }

    function getTotalSupply() external view returns (uint256) {
        return _maxSupply;
    }

    function mint(uint256 amount) external onlyOwner returns (bool success) {
      require(amount != uint256(0), "ERC20: function burn invalid input");
      require(amount <= _remainAvailabilityNumber, "ERC20: minting number more than available quantity");

      _mint(_creator, amount * (10**uint256(decimals())));
      setRemainAvailability(amount, "-");
      success = true;
    }

    function burn(address account, uint256 amount) external onlyOwner returns (bool success) {
      require(account != address(0) && amount != uint256(0), "ERC20: function burn invalid input");
      require(balanceOf(account) >= amount, "ERC20: burning number more than own quantity");
      _burn(account, amount);
      setRemainAvailability(amount, "+");
      success = true;
    }

    function buy(uint256 amount) external payable nonReentrant returns (bool success) {
      require(amount < balanceOf(_creator), "ICO: function buy invalid input");
      _transfer(owner(), _msgSender(), amount);
      success = true;
    }

    function transferToken(address to, uint256 amount) external returns (bool success){
        _transfer(msg.sender, to, amount);
        success = true;
    }

    function withdraw(uint256 amount) external onlyOwner returns (bool success) {
      require(amount <= address(this).balance, "ICO: function withdraw invalid input");
      payable(_msgSender()).transfer(amount);
      success = true;
    }
}
