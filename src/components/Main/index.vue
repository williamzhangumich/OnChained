<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <div class='col-sm-6'>
        <AccountCallout v-bind:account="account"></AccountCallout>    
      </div>
      <div class='col-sm-6'>
        <input  v-model="minContrib"/>
      </div>
    </div>
    <hr>
    <div class='row'>
      <div class='col-sm-12'>
        <ul class="list-group">
          <li v-for='(project, i) in projects'
            v-bind:key='i'
            class='list-group-item' style='overflow: hidden;'>
            <router-link :to="'/detail/'+ project.deployedAddress">{{ project.title }}</router-link>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import factory from "../../../ethereum/factory";
import ProjectManager from "../../../ethereum/ProjectManager";
import web3 from "../../../ethereum/web3";
import AccountCallout from "@/components/Main/AccountCallout";

export default {
  name: "Main",
  components: { AccountCallout },
  data() {
    return {
      accountFound: false,
      account: "",
      projects: [],
      minContrib: 10000,
      loading: false
    };
  },
  async created() {
    await this.getAccount();
    await this.getProjects();

    setInterval(
      () => this.getAccount(),
      500
    );
  },

  methods: {
    getAccount: async function() {
      const accounts = await web3.eth.getAccounts();
      if (accounts.length === 0) {
        this.account = "";
      } else {
        this.account = accounts[0];
      }
    },

    getProjects: async function() {
      const foo = await ProjectManager.methods.deployedProjects(0).call();
      console.log(foo);
      this.projects = [foo, foo, foo, foo, foo];


      console.log(await ProjectManager.methods.getNumProjects().call());
    },

    getUsers: async function() {
      const foo = await ProjectManager.methods.getUserAccounts().call();
      console.log(foo);
      const userId = await ProjectManager.methods.userIdForAccount(foo[0]).call();
      console.log(userId)
      // this.projects = [foo, foo, foo, foo, foo];
    }
  }
};
</script>

<style>
</style>
