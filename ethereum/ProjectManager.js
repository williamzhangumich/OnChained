import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0x7506c2dd5117d7ba4ac59d3d19197196e3e71217'
);

export default instance;	