
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
    account() {
      this.accountFound = this.account !== "";
    }
  },
  props: {
    account: String
  }
};
</script>

<style>
</style>

