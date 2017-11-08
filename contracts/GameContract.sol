pragma solidity ^0.4.4;

import "./DataContract.sol";

contract GameContract {

  mapping (address => Types.Game) playerGames;
  DataContract dataContract;
  address owner;

  function GameContract() {
    owner = msg.sender;
  }

  function setDataContract(address _address) {
    dataContract = DataContract(_address);
  }

  function applyUpgradeTree(uint256 _value, uint8 _stat, Types.UpgradeTree storage _upgradeTree) private returns (uint256) {
    for (uint256 i = 0; i < _upgradeTree.upgrades.length; ++i) {
       Types.Upgrade storage _upgrade = _upgradeTree.upgrades[i];
       _value = dataContract.applyUpgradeStat(_value, _stat, _upgrade.id, _upgrade.tier);
    }
    return _value;
  }

  function getItemStat(Types.Game storage _game, Types.Item storage _item, uint8 _stat) private returns (uint) { 
    uint256 _value = dataContract.getItemBaseStat(_item.id, _stat);
    //apply global base upgrades

    for (uint256 i = 0; i < _game.globalUpgradeTree.length; ++i) {
      Types.UpgradeTree storage _upgradeTree = _game.globalUpgradeTree[i];
      _value = applyUpgradeTree(_value, _stat, _upgradeTree);
    }

    //apply item upgrade trees
    for (i = 0; i < _item.upgradeTree.length; ++i) {
      _upgradeTree = _item.upgradeTree[i];
      _value = applyUpgradeTree(_value, _stat, _upgradeTree);
    }

    //apply item base upgrades
    for (i = 0; i < _item.baseUpgrades.length; ++i) {
      Types.Upgrade storage _upgrade = _item.baseUpgrades[i];
      _value = dataContract.applyUpgradeStat(_value, _stat, _upgrade.id, _upgrade.tier);
    }
    return _value;
  }

  function getGameCoin(Types.Game storage _game, uint8 _coinId) private constant returns (Types.Coin storage) {
    for (uint256 i = 0; i < _game.coins.length; ++i) {
      if (_game.coins[i].id == _coinId)
        return _game.coins[i];
    }
    revert();
  }

  function getGameCoinIncome(Types.Game storage _game, Types.Coin storage _coin) private constant returns (uint256)  {
    uint256 _total = 0;
    //todo write out the literal upgrades and see how best to do this
    for (uint i = 0; i < _game.items.length; ++i) {
      uint256 _itemIncome = getItemStat(_game, _game.items[i], _coin.id|dataContract.INCOME());
      _total += _itemIncome;
    }
    return _total;
  }

  function coinsGained(address _user, uint8 _coinId) returns (uint256) {
    /*
    the balance of each coin is updated on each of the following triggers:

    - a coin specific upgrade is purchased
    - global upgrade is purchased
    - the coin is spent on an item or upgrade
    - the coin is tranferred or recieved
    - an item is purchased which mines the coin
    - an item is set to mine the coin

     this simplifiies the coinsgained function to be:
     base_balance+sum over items(item_rate*item_upgrades*num_items)*time
    */

     Types.Game storage _game = playerGames[_user];
     Types.Coin storage _coin = getGameCoin(_game,_coinId);
     uint256 _timeElapsed = block.timestamp - _coin.lastUpdate;
     uint256 _income = getGameCoinIncome(_game,_coin);

  } 


  //function balanceOf(address _user, uint8 _coinId) returns (uint256 balance) {

  //}
  //writeable functions
  //
  //register
  //purchaseItem
  //purchaseCoinUpgrade
  //purchaseItemUpgradeTree
  //purchaseItemUpgradeTreeUpgrade

  //constant functions:
  //
  //getPlayerItems 
  //getPlayerCoinUpgrades 
  //getPlayerCoinUpgrades 



}
