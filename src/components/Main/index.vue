<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <NewProject
        v-on:saveProject="displayProgress"
        v-bind:accountAddress="accountAddress"
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
import web3 from "../../../ethereum/web3";
import ProjectCard from "@/components/Main/ProjectCard";
import NewProject from "@/components/Main/NewProject";

export default {
  name: "Main",
  components: { NewProject, ProjectCard },
  props: {
    accountAddress: String,
    projects: Array,
    userIds: Array,
    userIdToAddress: Object
  },
  methods: {
    displayProgress(value) {
      this.$emit("displayProgress", value);
    },
  }
};
</script>

<style scoped>
</style>
