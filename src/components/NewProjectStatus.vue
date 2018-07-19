<template>
  <button
    v-if="loading"
    class="btn btn-sm btn-warning">
    <i class="fas fa-spinner fa-spin"></i> 
    New Project Being Created
  </button>
</template>

<script>
export default {
  name: "NewProjectStatus",
  props: {
    loading: Boolean
  }
};
</script>

<style>
</style>

