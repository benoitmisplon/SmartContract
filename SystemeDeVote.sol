pragma solidity ^0.8.0;

contract SystemeDeVote {
    address public administrateurDuVote;
    mapping(address => bool) public electeursInscrits;
    Proposal[] public propositions;
    bool public sessionEnregistrementActive;
    bool public sessionVoteActive;

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    modifier onlyAdmin() {
        require(msg.sender == administrateurDuVote, "Seul l'administrateur peut effectuer cette action");
        _;
    }

    modifier onlyDuringRegistration() {
        require(sessionEnregistrementActive, "La session d'enregistrement est terminee");
        _;
    }

    modifier onlyDuringVoting() {
        require(sessionVoteActive, "La session de vote n'est pas active");
        _;
    }

    constructor() {
        administrateurDuVote = msg.sender;
        sessionEnregistrementActive = false;
        sessionVoteActive = false;
    }

    function inscrireElecteur(address _electeur) public onlyAdmin {
        require(!sessionEnregistrementActive, "La session d'enregistrement est en cours");
        electeursInscrits[_electeur] = true;
    }

    function demarrerSessionEnregistrement() public onlyAdmin {
        require(!sessionEnregistrementActive, "La session d'enregistrement est deja active");
        require(!sessionVoteActive, "La session de vote est deja active");
        sessionEnregistrementActive = true;
    }

    function soumettreProposition(string memory _description) public onlyDuringRegistration {
        require(electeursInscrits[msg.sender], "Vous n'etes pas autorise a soumettre une proposition");
        propositions.push(Proposal(_description, 0));
    }

    function retirerProposition() public onlyDuringRegistration {
    require(electeursInscrits[msg.sender], "Vous n'etes pas autorise a retirer une proposition");
    for (uint256 i = 0; i < propositions.length; i++) {
        if (keccak256(abi.encodePacked(propositions[i].description)) == keccak256(abi.encodePacked(msg.sender))) {
            emit PropositionRetiree(msg.sender, i); // Émettre un événement ici
            delete propositions[i];
            break;
        }
    }
}

event PropositionRetiree(address indexed electeur, uint256 indexed propositionIndex);




    function cloturerSessionEnregistrement() public onlyAdmin {
        require(sessionEnregistrementActive, "La session d'enregistrement n'est pas active");
        sessionEnregistrementActive = false;
    }

    function demarrerSessionVote() public onlyAdmin {
        require(!sessionVoteActive, "La session de vote est deja active");
        require(!sessionEnregistrementActive, "La session d'enregistrement est encore active");
        sessionVoteActive = true;
    }

    function voter(uint256 _proposalIndex) public onlyDuringVoting {
        require(electeursInscrits[msg.sender], "Vous n'etes pas autorise a voter");
        require(_proposalIndex < propositions.length, "Indice de proposition invalide");
        propositions[_proposalIndex].voteCount++;
    }

    function cloturerSessionVote() public onlyAdmin {
        require(sessionVoteActive, "La session de vote n'est pas active");
        sessionVoteActive = false;
    }

    function obtenirNombrePropositions() public view returns (uint256) {
        return propositions.length;
    }

    function obtenirDescriptionProposition(uint256 _proposalIndex) public view returns (string memory) {
        require(_proposalIndex < propositions.length, "Indice de proposition invalide");
        return propositions[_proposalIndex].description;
    }

    function obtenirNombreVotes(uint256 _proposalIndex) public view returns (uint256) {
        require(_proposalIndex < propositions.length, "Indice de proposition invalide");
        return propositions[_proposalIndex].voteCount;
    }
}
