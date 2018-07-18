<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <div class='card'>
        <div class="card-img-top"></div>
        <div class="card-body">
          <h5 class="card-title">
            Create A Project
          </h5>
          <p class="card-text"> <span>+</span> </p>
        </div>     
      </div>
      <div  v-for='(project, i) in projects' v-bind:key='i' class='card'>
        <div class="card-img-top"></div>
        <div class="card-body">
          <h5 class="card-title">
            <router-link :to="`/project/${project.deployedAddress}`">
              {{ project.title }}
            </router-link>
          </h5>
          <p class="card-text"> {{ project.description }} </p>
        </div>     
      </div>
    </div>
  </div>
</template>

<script>
import factory from "../../../ethereum/factory";
import ProjectManager from "../../../ethereum/ProjectManager";
import web3 from "../../../ethereum/web3";

export default {
  name: "Main",
  props: {
    account: String
  },
  data() {
    return {
      projects: [],
      loading: false
    };
  },
  async created() {
    await this.getProjects();
  },

  methods: {
    getProjects: async function() {
      const foo = await ProjectManager.methods.deployedProjects(0).call();
      console.log(foo);
      this.projects = [foo, foo, foo, foo, foo];
      console.log(await ProjectManager.methods.getNumProjects().call());
    },
    getUsers: async function() {
      const foo = await ProjectManager.methods.getUserAccounts().call();
      console.log(foo);
      const userId = await ProjectManager.methods
        .userIdForAccount(foo[0])
        .call();
      console.log(userId);
      // this.projects = [foo, foo, foo, foo, foo];
    }
  }
};
</script>

<style scoped>
  .card {
    width: 18rem;
  }
</style>
