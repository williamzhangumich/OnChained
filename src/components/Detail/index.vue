<template>
  <div> 
  
  <div id='app' class='container' style='width: 95%'>
      <div class='row'>
        <div class='col-lg-12'>
          <h4>{{ projectName }}</h4>
          Address: <span>{{ projectAddress }} </span>


          
          <template v-if="votedStatus">
            <div>
              <p class='text-success'><h5>You've already voted, thanks!</h5></p>              
            </div>
            
          </template>
          <template v-else>
            <div>
              <p class='text-info'><h5>Plus Submit Your Vote Below</h5></p>
              <table class='table table-striped'>
                <thead>

                </thead>

                <tbody>
                  <tr v-for="(user, index) in contributors" >
                    <td>{{ user.userId }}</td>
                    <td>{{ user.address }}</td>
                    <td><input v-model="user.share" type="number"> </td>  
                  </tr>
                </tbody>
              </table>

            </div>
            
          </template>
        </div>
      </div>
    </div>
  </div>

    

</template>

<script>
  import SharesVoteProject from "../../../ethereum/SharesVoteProject";
  import ProjectManager from "../../../ethereum/ProjectManager";

  import web3 from "../../../ethereum/web3";
  export default {
    name: "Detail",
    props: {
      account: String
    },
    data() {
      return {
        projectAddress: this.$route.params.projectAddress,
        projectInstance: null,
        projectName: '',
        votedStatus: null,
        contributors:[]
      };
    },
    async created() {

      this.projectInstance = SharesVoteProject(this.projectAddress);
      this.projectName = await this.projectInstance.methods.title().call();

      this.votedStatus = await this.projectInstance.methods.getVotedStatus(this.account).call();

      const userAddresses = await this.projectInstance.methods.getShareHolderAccounts().call();
      console.log(userAddresses);
      const usersromises = userAddresses.map(userAddress => 
        ProjectManager.methods.userIdForAccount(userAddress)
          .call()
          .then(userId => ({ userId: userId, address: userAddress, share: 0 }))
      );
      this.contributors = await Promise.all(usersromises);
      console.log(this.contributors)

    },
    methods: {}
  };
</script>

<style>
</style>
