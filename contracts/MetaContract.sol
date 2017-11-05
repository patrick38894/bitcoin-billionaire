pragma solidity ^0.4.4;

//import "./Utils.sol";

contract MetaContract {
  
	
	uint8 public constant INCOME = 0x80; // coinId | INCOME == coinIncomeStatId
	uint8 public constant WALLET = 0x40; // coinId | WALLET == coinWalletStatId

	struct CoinMeta {
		uint8 id; //id 0 is reserved
		string name; //name of coin, ethereum, bitcoin
		string nameShort; //short name of coin, eth, btc
		string description; //short description about coin
	}

	uint8 coinNextId; //init at 1
	mapping(uint8 => CoinMeta) coinTable;

	struct UpgradeMeta {
		uint16 id; //upgrade id bit
		string name; //name of the upgrade
		string description; //upgrade description
    uint8 stat; //the stat to be modified
		mapping (uint8=>uint64) tierValueMap;
		mapping (uint8=>uint64) tierPriceMap;
		//function (Game) constant returns uint64 customFunc storage; //custom function for PoS and stuff
	}

  //coinID -> upgradeID -> upgrade metadata
	mapping(uint8 => mapping (uint8 => UpgradeMeta)) coinUpgradeTable;

	struct ItemMeta {
		uint8 id; //item id
		uint8 baseDecay; //item decay time. in blocks?
		string name; //item name
		string description; //item description
		uint8 coinId; //0 is any coin
		uint256 basePrice; //base price of the item, in native currency or default
	}

	struct UpgradeTree {
		uint8 id;
		mapping (uint16 => UpgradeMeta) upgrades; //mapping from bit to upgrade item
	}

  //itemID -> upgradeTreeID  -> upgrade metadata
	mapping(uint8 => mapping (uint8 => UpgradeTree)) itemUpgradeTreeTable;
	mapping(uint8 => mapping (uint16 => UpgradeMeta)) itemBaseUpgradeTable;

	function applyUpgradeStat(uint256 _value, uint8 _stat, uint8 _upgradeId, uint8 _tier) returns (uint256) {
     //add a global bit so upgrades of all income types match with specific income types
	}

	function addCoin(string _name, string _description, string _nameShort) {
					//modifiers- onlyOwner, coinTableNotFull
	  CoinMeta _newCoin;
		_newCoin.id = coinNextId++;
		_newCoin.name = _name;
		_newCoin.description = _description;
		_newCoin.nameShort = _nameShort;
		coinTable[_newCoin.id] = _newCoin;
	}
	//function addItem(string name, string description, uint8 decay, uint64 price, uint256 income, uint8 coin) //prerequesites?
	//function addUpgrade(string name, string description, uint8 stat, uint8 op) //tiers?

  //TODO add/remove for contract owner
  //TODO lookup functions for everyone
	//TODO calcBalance function
	//TODO calc prices functions
	//TODO verifyPurchase function

}
