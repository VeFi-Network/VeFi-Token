pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/** @author Kingsley Victor */
contract Token is Context, Ownable, ERC20 {
  mapping(address => bool) _minters;

  modifier onlyMinter() {
    require(
      _minters[_msgSender()],
      "VeFi: Only minter is allowed to mint or burn tokens"
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

  /** @dev Adds a minter. Can only be called by contract owner
   *  @param _minter The address that's added as minter
   */
  function addMinter(address _minter) external onlyOwner {
    _minters[_minter] = true;
  }

  /** @dev Removes a minter. Can only be called by contract owner
   *  @param _minter The address that's removed as minter
   */
  function removeMinter(address _minter) external onlyOwner {
    _minters[_minter] = false;
  }

  /** @dev Mints tokens for a specific address. Can only be called by a minter
   *  @param _account The address to mint tokens for
   *  @param _amount The amount of tokens to be minted
   */
  function mintFor(address _account, uint256 _amount) external onlyMinter {
    _mint(_account, _amount);
  }

  /** @dev Burns tokens for a specific address. Can only be called by a minter
   *  @param _account The address whose tokens should be burnt
   *  @param _amount The amount of tokens to be burnt
   */
  function burnFor(address _account, uint256 _amount) external onlyMinter {
    _burn(_account, _amount);
  }

  /** @dev Return tokens or BNB sent to contract to specified recipient
   *  @param _token The address of the ERC20 token. If zero address, represents BNB
   *  @param _recipient The address to send asset to
   *  @param _amount The amount to send
   */
  function retrieveERC20OrBNB(
    address _token,
    address _recipient,
    uint256 _amount
  ) external onlyOwner {
    require(_recipient != address(0), "VeFi: Sending to zero address");

    if (_token == address(0)) {
      uint256 _balance = address(this).balance;
      address payable recipient_ = payable(_recipient);
      require(_balance >= _amount, "VeFi: Not enough balance");
      recipient_.transfer(_amount);
    } else {
      require(
        IERC20(_token).balanceOf(address(this)) >= _amount,
        "VeFi: Not enough tokens"
      );
      require(
        IERC20(_token).transfer(_recipient, _amount),
        "VeFi: Unable to transfer tokens"
      );
    }
  }
}
