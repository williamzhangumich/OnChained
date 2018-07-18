<template>
  <div> {{ projectAddress }} </div>
</template>

<script>
import Campaign from "../../../ethereum/campaign";
import web3 from "../../../ethereum/web3";
export default {
  name: "Detail",
  props: {
    account: String
  },
  data() {
    return {
      projectAddress: this.$route.params.projectAddress
    };
  },
  async created() {
    // await this.campaignDetail(this.$route.params.campaignId);
  },
  methods: {}
};
</script>

<style>
</style>
