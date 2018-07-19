<template>
  <b-modal 
    id="new-project-modal" 
    ref="newProjectModal" 
    title="Create A New Project">
    <div class="container">
      <div class="form-group">
        <label class="project-label">Title</label>
        <small v-if="!status.title.ok" class="form-text text-muted" style="color:red !important;">
          {{ status.title.message }}
        </small>
        <small v-else class="form-text text-muted">Enter a title for your project.</small>
        <input v-model="title" type="text" class="form-control">
      </div>
      <div class="form-group">
        <label class="project-label">Description</label>
        <small v-if="!status.description.ok" class="form-text text-muted" style="color:red !important;">
          {{ status.description.message }}
        </small>        
        <small v-else class="form-text text-muted">Enter a short description.</small>
        <textarea v-model="description" type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <label class="project-label">Contributors</label>
        <small v-if="!status.contributors.ok" class="form-text text-muted" style="color:red !important;">
          {{ status.contributors.message }}
        </small>        
        <small v-else class="form-text text-muted">Select the contributors.</small>
        <Multiselect
          v-model="selected" 
          v-bind:options="options"
          v-bind:multiple="true"
        ></Multiselect>
      </div>
    </div>
    <div slot="modal-footer">
      <b-btn size="sm" variant="secondary" v-on:click="hideModal">
        Close
      </b-btn>      
      <b-btn size="sm" variant="primary" v-on:click="save">
        Save
      </b-btn>
    </div>
  </b-modal>
</template>

<script>
import Multiselect from "vue-multiselect";
import ProjectManager from "../../../ethereum/ProjectManager";

export default {
  name: "NewProject",
  components: { Multiselect },
  data() {
    return {
      title: "",
      description: "",
      selected: [],
      status: {
        title: { ok: true, message: "Title Required" },
        description: { ok: true, message: "Desciption Required" },
        contributors: { ok: true, message: "At least one contributor Required" }
      },
    };
  },
  props: {
    accountId: String,
    options: Array,
    userIdToAddress: Object
  },
  methods: {
    async save() {
      // this.title, this.description, Array.from(this.selected)
      // this.title
      // this.description
      let ok = true;
      const selectedIds = Array.from(this.selected);

      this.status.title.ok = true;
      this.status.description.ok = true;
      this.status.contributors.ok = true;

      if (this.title.trim() === "") {
        this.status.title.ok = false
        ok = false;
      }

      if (this.description.trim() === "") {
        this.status.description.ok = false
        ok = false;
      }

      if (selectedIds.length === 0) {
        this.status.contributors.ok = false;
        ok = false
      }

      if (ok === false) return;      

      const selectedAddresses = selectedIds.map(id => this.userIdToAddress[id]);
      console.log(this.title, this.description, this.accountId, selectedAddresses);

      // const newProjectPromise = ProjectManager.methods.newProject(
      //   this.title,
      //   this.description,
      //   contributors).send({
      //     from: this.accountId,
      //     gas: '1000000'
      //   });

      // const newProject = await newProjectPromise;
      // console.log(newProject);

      this.hideModal();
    },
    hideModal() {
      this.$refs.newProjectModal.hide();
    }
  }
};

// const result = await ProjectManager.methods.newProject('test title', 'test desc',
//   ['0xc66ae400ab10127cc3939326146a6924ff72d578',
//   '0x0c7c1d31448b0a1f85b23db2b11c1efdd2a02cca',
//   '0x7c48c0e144ade759155067502e1aac41df9dc28c']).send({
//     from: this.account,
//     gas: '1000000'
//   })
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>
.modal-header {
  background-color: steelblue;
}
label.project-label {
  margin-bottom: 0;
}
</style>
