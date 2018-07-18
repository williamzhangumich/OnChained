import Web3 from 'web3';

let web3;

if (typeof window.web3 !== 'undefined' && typeof window.web3.currentProvider !== 'undefined') {
  web3 = new Web3(window.web3.currentProvider);
} else {
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/orDImgKRzwNrVCDrAk5Q'
  );
  web3 = new Web3(provider);
}
// console.log(web3.providers)

export default web3;