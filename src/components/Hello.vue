<template>
  <div id='app' class='container' style='width: 95%'>
    <div class='row'>
      <div class='col-sm-6'>
        <h4>Account: </h4>
        {{ account }}
        {{ message }}
      </div>
      <div class='col-sm-6'>
        <input  v-model="minContrib"/>
        <a class='btn btn-secondary' v-on:click="newCampaign" v-bind:class="{ disabled: loading }">
          new campaign
        </a>
      </div>
      <a class='btn btn-primary' v-on:click='test'>test</a>
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
import factory from "../../ethereum/factory";
import ProjectManager from "../../ethereum/ProjectManager";
import web3 from "../../ethereum/web3";

export default {
  name: "hello",
  data() {
    return {
      message: "",
      account: "",
      campaigns: [""],
      projects: [],
      minContrib: 10000,
      loading: false
    };
  },
  async created() {
    await this.getAccount();
    await this.getCampaigns();
    await this.getProjects();

    const this_app = this;
    setInterval(function() {
      this_app.getAccount();
    }, 500);
  },
  // watch: {
  //   // everytime a route is changed refresh the activeUser
  //   '$route': 'refreshActiveUser'
  // },

  methods: {
    getAccount: async function() {
      var accounts = await web3.eth.getAccounts();
      if (accounts.length == 0) {
        alert("no eth account detection, enable metamask!");
      }
      this.message = "Bitconneeeeect!!";
      this.account = accounts[0];
    },

    getCampaigns: async function() {
      this.campaigns = await factory.methods.getDeployedContracts().call();
    },

    newCampaign: async function() {
      console.log("new campaign");
      console.log(this.minContrib);
      this.loading = true;
      try {
        const result = await factory.methods
          .newCampaign(+this.minContrib)
          .send({
            from: this.account,
            gas: "1000000"
          });
        alert(`campaign created, txhash:${result.transactionHash}`);
        this.getCampaigns();
      } catch (err) {
        alert(err.message);
      } finally {
        this.loading = false;
      }
    },

    getProjects: async function() {
      const foo = await ProjectManager.methods.deployedProjects(0).call();
      console.log(foo);
      this.projects = [foo, foo, foo, foo, foo];
    },

    test: async function() {

      const results = await ProjectManager.methods.userIds(0).call();
      console.log(results);

      const results2 = await ProjectManager.methods.deployedProjects(0).call();
      console.log(results2);

      // const result = await ProjectManager.methods.newProject('test title', 'test desc',
      //   ['0xc66ae400ab10127cc3939326146a6924ff72d578',
      //   '0x0c7c1d31448b0a1f85b23db2b11c1efdd2a02cca',
      //   '0x7c48c0e144ade759155067502e1aac41df9dc28c']).send({
      //     from: this.account,
      //     gas: '1000000'
      //   })
    }
  }
};
</script>

<style>
</style>
