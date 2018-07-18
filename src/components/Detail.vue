<template>
  <div id='app' class='container' style='width: 95%'>


    <div class='row'>

      <div class='col-sm-6'>
        <h4> Selected Campaign </h4>
        <template v-if="selectedCampaign.address">
          <p> address: {{selectedCampaign.address}} </p>
          <p> manager: {{selectedCampaign.manager}} 
            <span class='badge badge-info' v-if="selectedCampaign.manager==account">
              You!
            </span>
         
          </p>
          <p> minimumContribution: {{selectedCampaign.minimumContribution}} </p>
          <p> balance: {{selectedCampaign.balance}} ether </p>
          <p> requestsLength: {{selectedCampaign.requestsLength}} </p>
          <p> approversCount: {{selectedCampaign.approversCount}} </p>

          <input v-model='contribAmount'/>
          <a class='btn btn-sm btn-success'
            v-on:click='contributeToCampaign'>
            Contribute!!</a>
        </template>
        <template v-else>
          pick one!
        </template>

         

      </div>
    </div>
        
  </div>
</template>

<script>
import Campaign from "../../ethereum/campaign";
import web3 from "../../ethereum/web3";

export default {
  name: "detail",
  data() {
    return {
      message: this.$route.params.campaignId,
      account: "",
      selectedCampaign: {
        address: "",
        minimumContribution: 0,
        balance: 0,
        requestsLength: 0,
        approversCount: 0,
        manager: ""
      },
      contribAmount: 0.5 // ether
    };
  },
  async created() {
    await this.getAccount();
    const this_app = this;
    setInterval(function() {
      this_app.getAccount();
    }, 500);

    await this.campaignDetail(this.$route.params.campaignId);
  },
  methods: {
    getAccount: async function() {
      var accounts = await web3.eth.getAccounts();
      if (accounts.length == 0) {
        alert("no eth account detection, enable metamask!");
      }
      this.message = "Bitconneeeeect!!";
      this.account = accounts[0];
    },
    contributeToCampaign: async function() {
      const campaign = Campaign(this.selectedCampaign.address);

      const result = await campaign.methods.contribute().send({
        from: this.account,
        gas: "1000000",
        value: web3.utils.toWei(this.contribAmount + "")
      });
      alert("done!");
      this.campaignDetail(this.selectedCampaign.address);
    },
    campaignDetail: async function(camp_address) {
      const campaign = Campaign(camp_address);
      const result = await campaign.methods.getSummary().call();
      const [
        minimumContribution,
        balance,
        requestsLength,
        approversCount,
        manager
      ] = Object.keys(result).map(d => {
        return result[d];
      });
      this.selectedCampaign.address = camp_address;
      this.selectedCampaign.minimumContribution = +minimumContribution;
      this.selectedCampaign.balance = web3.utils.fromWei("" + balance, "ether");
      this.selectedCampaign.requestsLength = +requestsLength;
      this.selectedCampaign.approversCount = +approversCount;
      this.selectedCampaign.manager = manager;
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>
h1,
h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #35495e;
}
</style>
