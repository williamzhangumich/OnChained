<template>
  <div id="app">
    <header>
      <span>OnChained</span>
    </header>
    <main>
      <AccountCallout v-bind:account="account"></AccountCallout>
      <router-view v-bind:account="account"></router-view>
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
      account: ""
    };
  },
  async created() {
    await this.getAccount();
    setInterval(() => this.getAccount(), 500);
  },
  methods: {
    getAccount: async function() {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length === 0) {
        this.account = "";
      } else {
        this.account = accounts[0];
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

main {
  text-align: center;
}

header {
  margin: 0;
  height: 56px;
  padding: 0 16px 0 24px;
  background-color: #35495e;
  color: #ffffff;
}

header span {
  display: block;
  position: relative;
  font-size: 20px;
  line-height: 1;
  letter-spacing: 0.02em;
  font-weight: 400;
  box-sizing: border-box;
  padding-top: 16px;
}
</style>
