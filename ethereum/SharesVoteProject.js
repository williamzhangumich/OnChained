import web3 from './web3';
import SharesVoteProject from './build/contracts/SharesVoteProject.json';

export default address => {
  return new web3.eth.Contract(SharesVoteProject.abi, address);
};