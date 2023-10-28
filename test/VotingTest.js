const SystemeDeVote = artifacts.require("SystemeDeVote");

contract("SystemeDeVote", (accounts) => {
  let systemeDeVoteInstance;

  before(async () => {
    systemeDeVoteInstance = await SystemeDeVote.deployed();
  });

  it("devrait permettre à l'administrateur d'inscrire un électeur", async () => {
    const electeur = accounts[1];
    await systemeDeVoteInstance.inscrireElecteur(electeur, { from: accounts[0] });
    const estInscrit = await systemeDeVoteInstance.electeursInscrits(electeur);
    assert.equal(estInscrit, true, "L'électeur n'a pas été inscrit.");
  });

  it("ne devrait pas permettre à un électeur non autorisé d'inscrire un autre électeur", async () => {
    const electeur = accounts[2];
    try {
      await systemeDeVoteInstance.inscrireElecteur(electeur, { from: accounts[1] });
      assert.fail("L'électeur non autorisé a pu inscrire un autre électeur.");
    } catch (error) {
      assert(error.reason.includes("Seul l'administrateur peut effectuer cette action"), "Erreur inattendue : " + error);
    }
  });

  it("devrait permettre à l'administrateur de démarrer la session d'enregistrement", async () => {
    await systemeDeVoteInstance.demarrerSessionEnregistrement({ from: accounts[0] });
    const sessionActive = await systemeDeVoteInstance.sessionEnregistrementActive();
    assert.equal(sessionActive, true, "La session d'enregistrement n'a pas été démarrée.");
  });





  
});
