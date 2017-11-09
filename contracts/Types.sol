pragma solidity ^0.4.4;

library Types {

  ////game types
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
