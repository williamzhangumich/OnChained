import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0x05118e48b3cf198f9e3aaedf56e7cbed3abbc270'
);

export default instance;	