<template>
  <b-modal id="new-project-modal" ref="myModalRef" title="Create A New Project">
    <div class="container">
      <div class="form-group">
        <label class="project-label">Title</label>
        <small class="form-text text-muted">Enter a title for your project.</small>
        <input type="text" class="form-control">
      </div>
      <div class="form-group">
        <label class="project-label">Description</label>
        <small class="form-text text-muted">Enter a short description.</small>
        <textarea type="text" class="form-control"/>
      </div>
      <div class="form-group">
        <label class="project-label">Contributors</label>
        <small class="form-text text-muted">Select the contributors.</small>
        <Multiselect
          v-model="selected" 
          v-bind:options="options"
          v-bind:multiple="true"
        ></Multiselect>
      </div>
    </div>
    <div slot="modal-footer">
      <b-btn size="sm" class="float-right" style="margin-right=6px" variant="primary" @click="show=false">
        Save
      </b-btn>
      <b-btn size="sm" class="float-right" variant="secondary" @click="show=false">
        Close
      </b-btn>
    </div>
  </b-modal>
</template>

<script>
import Multiselect from "vue-multiselect";

export default {
  name: "NewProject",
  components: { Multiselect },
  data() {
    return {
      selected: null,
      options: ['list', 'of', 'options']
    }
  },
  props: {
    display: false
  }
};
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
