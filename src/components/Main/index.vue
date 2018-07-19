<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <NewProject
        v-bind:accountId="accountId"
        v-bind:options="userIds"
        v-bind:userIdToAddress="userIdToAddress"
      ></NewProject>
      <ProjectCard v-for='(project, i) in projects' v-bind:key='i'
        v-bind:title="project.title"
        v-bind:address="project.deployedAddress"
        v-bind:description="project.description"
      ></ProjectCard>
    </div>
  </div>
</template>

<script>
import factory from "../../../ethereum/factory";
import ProjectManager from "../../../ethereum/ProjectManager";
import web3 from "../../../ethereum/web3";
import ProjectCard from "@/components/Main/ProjectCard";
import NewProject from "@/components/Main/NewProject";

export default {
  name: "Main",
  components: { NewProject, ProjectCard },
  props: {
    accountId: String
  },
  data() {
    return {
      projects: [],
      userIds: [],
      userIdToAddress: {},
      loading: false
    };
  },
  async created() {
    await Promise.all([
      this.getProjects(), 
      this.getUsers()
    ]);
  },

  methods: {
    getProjects: async function() {
      const numProjects = await ProjectManager.methods.getNumProjects().call();
      const projectPromises = [];
      for (let i = 0; i < numProjects; i++) {
        projectPromises.push(ProjectManager.methods.deployedProjects(i).call());
      }
      this.projects = await Promise.all(projectPromises)
    },
    getUsers: async function() {
      const userAddresses = await ProjectManager.methods.getUserAccounts().call();
      const usersromises = userAddresses.map(userAddress => 
        ProjectManager.methods.userIdForAccount(userAddress)
          .call()
          .then(userId => ({ id: userId, address: userAddress }))
      );
      const users = await Promise.all(usersromises);

      this.userIds = users.map(({id}) => id);
      this.userIdToAddress = Object.assign(
        {}, 
        ...users.map(({id, address}) => ({[id]: address}))
      );
    }
  }
};
</script>

<style scoped>
</style>
