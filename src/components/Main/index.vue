<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <NewProject></NewProject>
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

</style>
