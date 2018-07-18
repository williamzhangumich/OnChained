import web3 from './web3';
import CampaignFactory from './build/contracts/CampaignManager.json';

const instance = new web3.eth.Contract(
  CampaignFactory.abi,
  '0x815568a735ff06bce1fcb269caddf9626e856dae'
);

export default instance;