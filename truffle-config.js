module.exports = {
    networks: {
      development: {
        host: "127.0.0.1", // Adresse de votre nœud Ethereum local
        port: 8545, // Port de votre nœud Ethereum local
        network_id: "*", // ID du réseau (utilisez '*' pour le réseau local)
      },
    },
    compilers: {
      solc: {
        version: "0.8.0", // Version de Solidity que vous utilisez
      },
    },
  };
  