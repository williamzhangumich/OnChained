<template>
  <div id="app">
    <header>
      <span>OnChained</span>
      <NewProjectStatus v-bind:loading="loading"></NewProjectStatus>
     
    </header>
    <main>
      <AccountCallout v-bind:accountAddress="accountAddress"></AccountCallout>
      <router-view 
        v-on:displayProgress="displayProgress"
        v-bind:accountAddress="accountAddress"
        v-bind:projects="projects"
        v-bind:userIds="userIds"
        v-bind:userIdToAddress="userIdToAddress"
        >
      </router-view>
    </main>
  </div>
</template>

<script>
import web3 from "../ethereum/web3";
import ProjectManager from "../ethereum/ProjectManager";
import AccountCallout from "@/components/AccountCallout";
import NewProjectStatus from "@/components/NewProjectStatus";

export default {
  name: "app",
  components: {
    NewProjectStatus,
    AccountCallout
  },
  data() {
    return {
      accountAddress: "",
      projects: [],
      userIds: [],
      userIdToAddress: {},
      loading: false
    };
  },
  async created() {
    await Promise.all([this.getAccount(), this.getProjects(), this.getUsers()]);
    setInterval(() => this.getAccount(), 500);
  },
  methods: {
    getAccount: async function() {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length === 0) {
        this.accountAddress = "";
      } else {
        this.accountAddress = accounts[0];
      }
    },
    getProjects: async function() {
      const numProjects = await ProjectManager.methods.getNumProjects().call();
      const projectPromises = [];
      for (let i = 0; i < numProjects; i++) {
        projectPromises.push(ProjectManager.methods.deployedProjects(i).call());
      }
      this.projects = await Promise.all(projectPromises);
    },
    displayProgress(value) {
      this.loading = true;
      value.then(() => {
        this.loading = false;
        this.getProjects();
      });
    },
    getUsers: async function() {
      const userAddresses = await ProjectManager.methods
        .getUserAccounts()
        .call();
      const usersPromises = userAddresses.map(userAddress =>
        ProjectManager.methods
          .userIdForAccount(userAddress)
          .call()
          .then(userId => ({ id: userId, address: userAddress }))
      );
      const users = await Promise.all(usersPromises);

      this.userIds = users.map(({ id }) => id);
      this.userIdToAddress = Object.assign(
        {},
        ...users.map(({ id, address }) => ({ [id]: address }))
      );
    }
  }
};
</script>

<style>
body {
  margin: 0;
}

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

header {
  margin: 0;
  height: 56px;
  padding: 0 16px 0 24px;
  background-color: #35495e;
  color: #ffffff;
  display: flex;
  flex-direction: row;
  align-items: center;
}

header .btn {
  margin-left: 1rem;
}

header span {
  display: inline-block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: 0.02em;
  font-weight: 400;
  box-sizing: border-box;
  margin-right: auto;
}
</style>
