<template>
  <div id="app">
    <header>
      <span>OnChained</span>
      <button ref="foo" v-b-modal.new-project-modal class="btn btn-default float-right">Create Project</button>
    </header>
    <main>
      <AccountCallout v-bind:accountAddress="accountAddress"></AccountCallout>
      <router-view v-bind:accountAddress="accountAddress"></router-view>
    </main>
  </div>
</template>

<script>
import web3 from "../ethereum/web3";
import AccountCallout from "@/components/AccountCallout";

export default {
  name: "app",
  components: { AccountCallout },
  data() {
    return {
      accountAddress: ""
    };
  },
  async created() {
    await this.getAccount();
    setInterval(() => this.getAccount(), 500);
  },
  // updated() {
  //   this.$refs.foo.click()
  // },
  methods: {
    getAccount: async function() {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length === 0) {
        this.accountAddress = "";
      } else {
        this.accountAddress = accounts[0];
      }
    }
  }
};
</script>

<style>
body {
  margin: 0;
}

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

header {
  margin: 0;
  height: 56px;
  padding: 0 16px 0 24px;
  background-color: #35495e;
  color: #ffffff;
  display: flex;
  flex-direction: row;
  align-items: center;
}

header .btn {
  margin-left: auto;
}

header span {
  display: inline-block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: 0.02em;
  font-weight: 400;
  box-sizing: border-box;
}

</style>
