<template>

  <div id='app' class='container' style='width: 95%'>

    <button ref="foo" v-b-modal.new-project-modal class="btn btn-success float-right"
      id='createProject'>
        Create Project
    </button>

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
.row {
  display: flex;

}

#createProject {
  position:fixed;
  right: 50px;
  bottom: 50px;
  z-index: 99999;
}
</style>
