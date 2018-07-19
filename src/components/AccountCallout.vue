
<template>
  <div v-if="accountFound" class="alert alert-success">
    Account Found! 
  </div>
  <div v-else class="alert alert-danger">
    No Account Found
  </div>   
</template>

<script>
export default {
  name: "AccountCallout",
  data() {
    return {
      accountFound: ""
    }
  },
  watch: {
    accountAddress() {
      this.accountFound = this.accountAddress !== "";
    }
  },
  props: {
    accountAddress: String
  }
};
</script>

<style>
</style>

