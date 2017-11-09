pragma solidity ^0.4.4;

import "./Types.sol";

contract DataContract {
  
  //constants
  //modifiers coin -> othertype
  uint8 public constant INCOME = 0x80; // coinId | INCOME == coinIncomeStatId
  uint8 public constant WALLET = 0x40; // coinId | WALLET == coinWalletStatId
  //stats
  uint8 public constant PRICE = 0xC0; // coinId | WALLET == coinWalletStatId
  uint8 public constant ID = 0x60; // coinId | WALLET == coinWalletStatId
  uint8 public constant STAT = 0x20; // coinId | WALLET == coinWalletStatId
  //first bits are for coin ids so max coins == 2^5

  //todo: move these types into a library
  //all 

  struct CoinData {
    uint8 id; //id 0 is reserved
    string name; //name of coin, ethereum, bitcoin
    string nameShort; //short name of coin, eth, btc
  }

  uint8 public coinNextId = 1; //init at 1
  mapping(uint8 => CoinData) public coinTable;

  struct ItemData {
    uint8 id; //item id
    string name; //item name
    uint8 coinId; //0 is any coin
    uint256 basePrice; //base price of the item, in abstract currency
    uint256 baseIncome; //base price of the item, in abstract currency
  }

  uint8 public itemNextId; //init at 1
mapping(uint8 => ItemData) public itemTable;

  struct UpgradeData {
    uint16 id; //upgrade id bit
    string name; //name of the upgrade
    uint8 stat; //the stat to be modified
    mapping (uint8=>uint64) tierValueMap;
    mapping (uint8=>uint64) tierPriceMap;
    //function (Game) constant returns uint64 customFunc storage; //custom function for PoS and stuff
  }

  struct UpgradeTreeData {
    uint8 id;
    mapping (uint16 => UpgradeData) upgrades; //mapping from bit to upgrade item
  }

  struct AbstractGame {
    CoinData[] coins;
    ItemData[] items;
    UpgradeTreeData[] upgrades;
  }

  //todo need to store an abstract upgrade tree to to copy from
  // or store a whole abstract player?

  mapping(uint8 => mapping (uint8 => UpgradeData)) public coinUpgradeTable;
  mapping(uint8 => mapping (uint8 => UpgradeTreeData)) public itemUpgradeTreeTable;
  mapping(uint8 => mapping (uint16 => UpgradeData)) public itemBaseUpgradeTable;



  AbstractGame baseGame; //struct for storing the topology of a game, pointers to all

  address public owner;

  function DataContract() {
    owner = msg.sender;
    coinNextId = 1; //0 is reserved
    itemNextId = 1; //^

  }

  function addCoin(string _name, string _nameShort) returns (uint8) {
    //modifiers- onlyOwner, coinTableNotFull, coinDoesNotExist
    CoinData storage _newCoin = coinTable[coinNextId];
    _newCoin.id = coinNextId;
    _newCoin.name = _name;
    _newCoin.nameShort = _nameShort;
    baseGame.coins.push(_newCoin);
    return coinNextId++;
  }

  function addItem(string _name, uint64 _basePrice, uint256 _baseIncome, uint8 _coinId) returns (uint8) {
   //modifiers- ownlyOwner, itemTableNotFull, itemDoesNotExist
    ItemData storage _newItem = itemTable[_newItem.id];
    _newItem.id = itemNextId;
    _newItem.name = _name;
    _newItem.basePrice = _basePrice;
    _newItem.baseIncome = _baseIncome;
    _newItem.coinId = _coinId;
    baseGame.items.push(_newItem);
    return itemNextId++;
  }

  function convertBaseIncome(uint256 _baseIncome, uint8 _coinId) constant returns (uint256) {
    require (coinTable[_coinId].id != 0); //make sure the coin exists and is non abstract
      CoinData storage _coin = coinTable[_coinId];
    //placeholder -- eventually ask the exchange for the conversion rate
    return _baseIncome;
  }

  function setItemBaseStat(uint8 _itemId, uint8 _stat, uint256 _value) {
    ItemData storage _item = itemTable[_itemId];
    if (_stat == INCOME)
      _item.baseIncome = _value;
    else if (_stat == PRICE)
      _item.basePrice = _value;
    else
      revert();
  }

  function getItemBaseStat(uint8 _itemId, uint8 _stat) constant returns (uint256) {
    //todo: add more stats;
    require (itemTable[_itemId].id != 0);
    ItemData storage _item = itemTable[_itemId];
    if (_stat | INCOME != 0) {
      return convertBaseIncome(_item.baseIncome, _stat ^ INCOME); //stat XOR INCOME = coinid
    }
    else
      revert();
  }

  function applyUpgradeStat(uint256 _value, uint8 _stat, uint8 _upgradeId, uint8 tier) constant returns (uint256) {
    //placeholder function
    return _value;
  }

  //function addUpgrade(string name, string description, uint8 stat, uint8 op) //tiers?

  //TODO add/remove for contract owner
  //TODO lookup functions for everyone
  //TODO calcBalance function
  //TODO calc prices functions
  //TODO verifyPurchase function

}
