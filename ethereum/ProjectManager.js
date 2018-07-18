import web3 from './web3';
import ProjectManager from './build/contracts/ProjectManager.json';

const instance = new web3.eth.Contract(
  ProjectManager.abi,
  '0xdf674f505365551948810797b8f6a2d0805d2ada'
);

export default instance;	