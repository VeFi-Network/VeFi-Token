pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/Context.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

/** @author Kingsley Victor */
contract Token is Context, Ownable, ERC20 {
  constructor(
    string memory name_,
    string memory symbol_,
    uint256 amount_
  ) Ownable() ERC20(name_, symbol_) {
    _mint(_msgSender(), amount_);
  }

  /** @dev Transfer token using selector */
  function _safeTransfer(
    address _token,
    address _recipient,
    uint256 _amount
  ) private returns (bool) {
    (bool success, bytes memory data) = _token.call(
      abi.encodeWithSelector(bytes4(keccak256(bytes('transfer(address,uint256)'))), _recipient, _amount)
    );
    require(success && (data.length == 0 || abi.decode(data, (bool))), 'vefi: could not call via selector');
    return true;
  }

  function _safeTransferETH(address _to, uint256 _value) private returns (bool) {
    (bool success, ) = _to.call{value: _value}(new bytes(0));
    require(success, 'vefi: eth transfer failed');
    return true;
  }

  /** @dev Return tokens or Ether sent to contract to specified recipient
   *  @param _token The address of the ERC20 token. If zero address, represents Ether
   *  @param _recipient The address to send asset to
   *  @param _amount The amount to send
   */
  function retrieveERC20OrEther(
    address _token,
    address _recipient,
    uint256 _amount
  ) external onlyOwner {
    require(_recipient != address(0), 'vefi: sending to zero address');

    if (_token == address(0)) {
      uint256 _balance = address(this).balance;
      address payable recipient_ = payable(_recipient);
      require(_balance >= _amount, 'vefi: not enough balance');
      require(_safeTransferETH(recipient_, _amount), 'vefi: unable to transfer eth');
    } else {
      require(IERC20(_token).balanceOf(address(this)) >= _amount, 'vefi: not enough tokens');
      require(_safeTransfer(_token, _recipient, _amount), 'vefi: unable to transfer tokens');
    }
  }

  receive() external payable {}
}
