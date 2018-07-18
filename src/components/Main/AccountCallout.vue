<template>
  <div>
  <template v-if="accountFound">
    <h3>Account:</h3> {{ account }}
  </template>
  <template v-else>
    No account
  </template>   
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

