pragma solidity ^0.4.4;

//import "./Utils.sol";

contract MetaContract {
  
	//constants
	//modifiers coin -> othertype
	uint8 public constant INCOME = 0x80; // coinId | INCOME == coinIncomeStatId
	uint8 public constant WALLET = 0x40; // coinId | WALLET == coinWalletStatId
	//stats

  //todo: move these types into a library

	struct CoinMeta {
		uint8 id; //id 0 is reserved
		string name; //name of coin, ethereum, bitcoin
		string nameShort; //short name of coin, eth, btc
		string description; //short description about coin
	}

	uint8 coinNextId; //init at 1
	mapping(uint8 => CoinMeta) coinTable;

	struct ItemMeta {
		uint8 id; //item id
		string name; //item name
		string description; //item description
		uint8 coinId; //0 is any coin
		uint256 basePrice; //base price of the item, in abstract currency
		uint256 baseIncome; //base price of the item, in abstract currency
	}

	uint8 itemNextId; //init at 1
	mapping(uint8 => ItemMeta) itemTable;

	struct UpgradeMeta {
		uint16 id; //upgrade id bit
		string name; //name of the upgrade
		string description; //upgrade description
    uint8 stat; //the stat to be modified
		mapping (uint8=>uint64) tierValueMap;
		mapping (uint8=>uint64) tierPriceMap;
		//function (Game) constant returns uint64 customFunc storage; //custom function for PoS and stuff
	}

	struct UpgradeTree {
		uint8 id;
		mapping (uint16 => UpgradeMeta) upgrades; //mapping from bit to upgrade item
	}

	mapping(uint8 => mapping (uint8 => UpgradeMeta)) coinUpgradeTable;
	mapping(uint8 => mapping (uint8 => UpgradeTree)) itemUpgradeTreeTable;
	mapping(uint8 => mapping (uint16 => UpgradeMeta)) itemBaseUpgradeTable;

	function addCoin(string _name, string _description, string _nameShort) {
					//modifiers- onlyOwner, coinTableNotFull
	  CoinMeta memory _newCoin;
		_newCoin.id = coinNextId++;
		_newCoin.name = _name;
		_newCoin.description = _description;
		_newCoin.nameShort = _nameShort;
		coinTable[_newCoin.id] = _newCoin;
	}

	function addItem(string _name, string _description, uint64 _basePrice, uint256 _baseIncome, uint8 _coinId) {
	 //modifiers- ownlyOwner, ItemTableNotFull
	  ItemMeta memory _newItem;
    _newItem.id = itemNextId++;
		_newItem.name = _name;
		_newItem.description = _description;
		itemTable[_newItem.id] = _newItem;
	}

	function convertBaseIncome(uint256 _baseIncome, uint8 _coinId) returns (uint256) {
		require (coinTable[_coinId].id != 0); //make sure the coin exists and is non abstract
      CoinMeta storage _coin = coinTable[_coinId];
    //placeholder -- eventually ask the exchange for the conversion rate
    return _baseIncome;
	}

	function getItemBaseStat(uint8 _itemId, uint8 _stat) returns (uint256) {
    //todo: add more stats;
		require (itemTable[_itemId].id != 0);
	    ItemMeta storage _item = itemTable[_itemId];
		if (_stat | INCOME != 0) {
		  return convertBaseIncome(_item.baseIncome, _stat ^ INCOME); //stat XOR INCOME = coinid
		}
    else
      revert();
	}
  function applyUpgradeStat(uint256 _value, uint8 _stat, uint8 upgradeId, uint8 tier) constant returns (uint256) {
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
