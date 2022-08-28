pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

library IterableMapping {
    struct Map {
        address[10] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
    }

    function getValueOfKey(Map storage map, address key) public view returns (uint) {
        console.log("Getting value of addr: ", key);
        console.log("res ", map.values[key]);
        return map.values[key];
    }

    function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
        console.log("Getting addr at index: ", index);
        return map.keys[index];
    }

    function getIndexOfKey(Map storage map, address key) public view returns (uint) {
        console.log("Getting index of addr at : ", key);
        return map.indexOf[key];
    }

    function setByIndex(Map storage map, uint index, address key, uint val) public {
        map.keys[index] = key;
        map.values[key] = val;
        map.indexOf[key] = index;
    }
    
    function keyExist(Map storage map, address _key) public view returns(bool) {
        for (uint i = 0; i < 10; i++) {
            address key = map.keys[i];
            if(key == _key) return true;
        }
        return false;
    }
}

contract FlappyGame {

  using IterableMapping for IterableMapping.Map;
  IterableMapping.Map private Leaderboard;
  address owner;

  constructor() payable {
    owner = msg.sender;
    for (uint i = 0; i < 10; i++) {
      Leaderboard.setByIndex(i,address(0),0);
    }
  }
  function withdrawToken(address _tokenContract, uint256 _amount) external onlyOwner {
    IERC20 tokenContract = IERC20(_tokenContract);
    tokenContract.transfer(msg.sender, _amount);
  }

    modifier onlyOwner() {
      require(msg.sender == owner, "Not owner");
      _;
    }

    function getLeaderboardScore(address _addr) public view returns (uint) {
      return Leaderboard.getValueOfKey(_addr);
    }

    function getLeaderboardPlace(address _addr) public view returns (uint) {
      return Leaderboard.getIndexOfKey(_addr);
    }

    function setLeaderboardPlace(address _addr, uint256 _score) public onlyOwner {
      for (uint i = 0; i < 10; i++) {
        address key = Leaderboard.getKeyAtIndex(i);
        if (Leaderboard.values[key]<_score) {
          Leaderboard.setByIndex(i, _addr, _score);
          return;
        }
      }
    }

    function resetLeaderBoard() public onlyOwner{
        for (uint i = 0; i < 10; i++) {
            Leaderboard.setByIndex(i,address(0),0);
        }
    }

  receive() external payable {}
  fallback() external payable {}
}
