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
var Types = artifacts.require("./Types.sol");

var metaContract, gameContract;
module.exports = function(deployer) {
  deployer.deploy(Types).then(function() {
    deployer.link(Types,[MetaContract,GameContract]);
    deployer.deploy(MetaContract).then(function() {
      return deployer.deploy(GameContract);
    }).then(function() {
      return GameContract.deployed().then(instance =>
        instance.setMetaContract(setDataContract.address));
   });
 });
};

