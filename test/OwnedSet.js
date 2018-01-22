var OwnedSet = artifacts.require("./OwnedSet.sol");

contract('Dispatcher and buildingBlocksV1', function(accounts){
	it('Deployment', function(){
		var ownedSet;
		return OwnedSet.deployed().then(function(instance){
			ownedSet = instance;
			console.log('contract address: ', ownedSet.address);
			return ownedSet.owner();
		}).then(function(a){
			console.log(a);
			return ownedSet.getPending();
		}).then(function(a){
			console.log(a);
			return ownedSet.getValidators();
		}).then(function(a){
			console.log(a);
			return ownedSet.getIsIn(accounts[2]);
		}).then(function(a){
			console.log(a);
			return ownedSet.finalized();
		}).then(function(a){
			console.log(a);
			return ownedSet.removeValidator(accounts[3]);
		}).then(function(a){
			console.log(a);
			return ownedSet.getPending();
		}).then(function(a){
			console.log(a);
			return ownedSet.getValidators();
		}).then(function(a){
			console.log(a);
		});
	});
});
