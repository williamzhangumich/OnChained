import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0xdbf953177d9b0bf6973844e31ea0471160728c76'
);

export default instance;	