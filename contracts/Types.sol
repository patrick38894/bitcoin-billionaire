pragma solidity ^0.4.4;

library Types {

  //constants
  //modifiers coin -> othertype
  uint8 public constant INCOME = 0x80; // coinId | INCOME == coinIncomeStatId
  uint8 public constant WALLET = 0x40; // coinId | WALLET == coinWalletStatId
  //stats

  struct CoinData {
    uint8 id; //id 0 is reserved
    string name; //name of coin, ethereum, bitcoin
    string nameShort; //short name of coin, eth, btc
    string description; //short description about coin
  }

  struct ItemData {
    uint8 id; //item id
    string name; //item name
    string description; //item description
    uint8 coinId; //0 is any coin
    uint256 basePrice; //base price of the item, in abstract currency
    uint256 baseIncome; //base price of the item, in abstract currency
  }

  struct UpgradeData {
    uint16 id; //upgrade id bit
    string name; //name of the upgrade
    string description; //upgrade description
    uint8 stat; //the stat to be modified
    mapping (uint8=>uint64) tierValueMap;
    mapping (uint8=>uint64) tierPriceMap;
    //function (Game) constant returns uint64 customFunc storage; //custom function for PoS and stuff
  }

  struct UpgradeTreeData {
    uint8 id;
    mapping (uint16 => UpgradeData) upgrades; //mapping from bit to upgrade item
  }
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

}
