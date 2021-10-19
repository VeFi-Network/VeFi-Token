pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @author Kingsley Victor
contract Token is Context, Ownable, ERC20 {
  mapping(address => bool) _minters;

  modifier onlyMinter() {
    require(
      _minters[_msgSender()],
      "VeFi: Only minter is allowed to mint tokens"
    );
    _;
  }

  constructor(
    string memory name_,
    string memory symbol_,
    uint256 amount_
  ) Ownable() ERC20(name_, symbol_) {
    _mint(_msgSender(), amount_);
  }

  function addMinter(address _minter) external onlyOwner {
    _minters[_minter] = true;
  }

  function mintFor(address _account, uint256 _amount) external onlyMinter {
    _mint(_account, _amount);
  }

  function burnFor(address _account, uint256 _amount) external onlyMinter {
    _burn(_account, _amount);
  }
}
