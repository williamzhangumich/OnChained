import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0x23aA303Ea9682B65b94AD6E5E2f49EE2DDE28C0D'
);

export default instance;	