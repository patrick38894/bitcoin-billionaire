/*
var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
};
*/

var MetaContract = artifacts.require("./MetaContract.sol");
var GameContract = artifacts.require("./GameContract.sol");

var metaContract, gameContract;
module.exports = function(deployer) {
  deployer.deploy(MetaContract).then(function() {
    return deployer.deploy(GameContract);
  }).then(function() {
    var gameContract = GameContract.deployed();
    return GameContract.deployed().then(instance =>
      instance.setMetaContract(MetaContract.address));
 });
};

//module.exports = function(deployer) {
//  deployer.then(function() {
//    return MetaContract.deployed();
//  }).then(function(instance) {
//    metaContract = instance;
//    return GameContract.deployed();
//  }).then(function(instance) {
//    gameContract = instance;
//    //return b.setMetaContract(metaContract.address);
//  });
//};







