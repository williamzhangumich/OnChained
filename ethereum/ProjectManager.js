import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0x25b9637cdae1be08af4e50d8ff73501fcd0d7896'
);

export default instance;	