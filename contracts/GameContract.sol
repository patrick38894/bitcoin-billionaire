pragma solidity ^0.4.4;

import "MetaContract.sol";

contract GameContract {

	struct Upgrade {
		uint8 id;
    uint8 tier;
	}

	struct UpgradeTree {
		uint8 id;
    Upgrade[] upgrades;
	}

	struct Item {
    uint8 id;
		uint8 currentCoin;
		uint64 amount; //TODO determine appropriate uint size
		UpgradeTree[] upgradeTree;
		Upgrade[] baseUpgrades;
	}

	struct Coin {
    uint8 id;
		uint256 balance; //todo maybe we should scale down to 128 or even 64. decide with math
		uint40 lastUpdate; //the time the balance was accurate
		Upgrade[] upgrades; 
	}

  struct Game {
	  Coin[] coins;
	  Item[] items;
		UpgradeTree[] globalUpgradeTree;
	}

  mapping (address => Game) playerGames;
	MetaContract metaContract;
	address owner;

	function GameContract() {
	  owner = msg.sender;
	}

	function setMetaContract(address _address) {
    metaContract = MetaContract(_address);
	}

	function applyUpgradeTree(uint256 _value, uint8 _stat, UpgradeTree storage _upgradeTree) private returns (uint256) {
	  for (uint256 i = 0; i < _upgradeTree.upgrades.length; ++i) {
			 Upgrade storage _upgrade = _upgradeTree.upgrades[i];
	     _value = metaContract.applyUpgradeStat(_value, _stat, _upgrade.id, _upgrade.tier);
		}
    return _value;
	}

	function getItemStat(Game storage _game, Item storage _item, uint8 _stat) private returns (uint) { 
		uint256 _value = metaContract.getItemBaseStat(_item.id, _stat);
    //apply global base upgrades

		for (uint256 i = 0; i < _game.globalUpgradeTree.length; ++i) {
      UpgradeTree storage _upgradeTree = _game.globalUpgradeTree[i];
		  _value = applyUpgradeTree(_value, _stat, _upgradeTree);
    }

    //apply item upgrade trees
		for (i = 0; i < _item.upgradeTree.length; ++i) {
      _upgradeTree = _item.upgradeTree[i];
		  _value = applyUpgradeTree(_value, _stat, _upgradeTree);
    }

    //apply item base upgrades
		for (i = 0; i < _item.baseUpgrades.length; ++i) {
		  Upgrade storage _upgrade = _item.baseUpgrades[i];
		  _value = metaContract.applyUpgradeStat(_value, _stat, _upgrade.id, _upgrade.tier);
		}
	  return _value;
	}

	function getGameCoin(Game storage _game, uint8 _coinId) private constant returns (Coin storage) {
    for (uint256 i = 0; i < _game.coins.length; ++i) {
			if (_game.coins[i].id == _coinId)
				return _game.coins[i];
    }
		revert();
	}

	function getGameCoinIncome(Game storage _game, Coin storage _coin) private constant returns (uint256)  {
		uint256 _total = 0;
		//todo write out the literal upgrades and see how best to do this
    for (uint i = 0; i < _game.items.length; ++i) {
      uint256 _itemIncome = getItemStat(_game, _game.items[i], _coin.id|metaContract.INCOME());
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

     Game storage _game = playerGames[_user];
		 Coin storage _coin = getGameCoin(_game,_coinId);
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
