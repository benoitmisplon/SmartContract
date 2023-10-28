const Voting = artifacts.require("SystemeDeVote");

module.exports = function (deployer) {
    deployer.deploy(Voting);
};
