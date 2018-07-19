<template>
  <div> 
  
  <div id='app' class='container' style='width: 95%'>
      <div class='row'>
        <div class='col-lg-12'>
          <h4>{{ projectName }}</h4>
          <p>Description: <span>{{ description }} </span></p> 
          <p>Address: <span>{{ projectAddress }} </span></p>
          <p>Votes Submitted: <strong>{{ votedCount }} / {{ contributors.length }} </strong></p>
          

          <template v-if="isContributor">
            <template v-if="shareDetermined">
              
              <h4 class='text-success'>Equity Share Finalized!</h4>
              

              <table class='table table-striped'>
                  <thead>
                    <th>User Name</th>
                    <th>Address</th>
                    <th>Share</th>
                  </thead>

                  <tbody>
                    <tr v-for="(user, index) in finalShares" >
                      <td>{{ user.userId }}</td>
                      <td>{{ user.address }}</td>
                      <td><input readonly v-model="user.share" type="number" v-on:keyup="shareHandler"> </td>  
                    </tr>
                    
                  </tbody>
                </table>
              
            </template>

            <template v-else>

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
                        <td><input v-model="user.share" type="number" v-on:keyup="shareHandler"> </td>  
                      </tr>
                      <tr>
                        <td></td>
                        <td>Shares Assigned:</td>
                        <td><input v-model="totalShares" type="number" readonly> </td>  
                      </tr>
                      <tr>
                        <td></td>
                        <td>Remaining Shares:</td>
                        <td><input v-model="remainigShares" type="number" readonly> </td>  
                      </tr>
                    </tbody>
                  </table>

                  <div v-if="totalShares==100" class="alert alert-success">
                    Ready to Submit Vote!
                  </div>
                  <div v-else class="alert alert-warning">
                    Please make sure the ownership percentail sum up to 100%
                  </div>   

                </div>
                <button class='btn btn-info pull-right' 
                  v-bind:disabled="disableSubmit"
                  ref='submit'
                  v-on:click="SubmitVote">Submit Vote!</button>
               
              </template>

              <template v-if="voteComplete && !shareDetermined">

                <button class='btn btn-info pull-right' 
                  v-bind:disabled="disableFinalize"
                  ref='submit'
                  v-on:click="finalizeShares">Finalize Shares!</button>
              </template>

            </template>
            
          </template>


          <template v-else>
            
            
            <template v-if="shareDetermined">

              
              <button class='btn btn-info pull-right' 
                  v-bind:disabled="disablePay"
                  ref='submit'
                  v-on:click="pay"><i class="fas fa-dollar-sign"></i> Donate to this project</button>
              <input v-model="donateEthAmount" type="number" style='width: 50px;'> Ether
              
            </template>
            <template v-else>
              <span class='text-info'>You are not a contributor so you can't vote</span> 
            </template>
          </template>


          <div v-if="loading" class="alert alert-warning" style='margin-top:15px;'>
            <i class="fas fa-spinner fa-spin"></i> Processing ethereum transaction. Please wait 15-20 seconds!
          </div>

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
      accountAddress: String
    },
    data() {
      return {
        projectAddress: this.$route.params.projectAddress,
        projectInstance: null,
        projectName: '',
        votedStatus: null,
        contributors:[],
        remainigShares: 100,
        totalShares:0,
        votedCount:0,
        voteComplete: false,
        shareDetermined: false,

        finalShares: [],

        isContributor: false,
        disableSubmit: true,
        disableFinalize: false,
        disablePay: false,

        loading:false,

        donateEthAmount: 0,

        title:'',
        description:'',
      };
    },
    async created() {

      this.projectInstance = SharesVoteProject(this.projectAddress);
      this.projectName = await this.projectInstance.methods.title().call();
      this.description = await this.projectInstance.methods.description().call();
      this.voteComplete = await this.projectInstance.methods.voteComplete().call();
      this.shareDetermined = await this.projectInstance.methods.shareDetermined().call();

      this.votedStatus = await this.projectInstance.methods.getVotedStatus(this.accountAddress).call();
      this.votedCount = await this.projectInstance.methods.numVotes().call();

      const userAddresses = await this.projectInstance.methods.getShareHolderAccounts().call();
      
      const usersromises = userAddresses.map(userAddress => 
        ProjectManager.methods.userIdForAccount(userAddress)
          .call()
          .then(userId => ({ userId: userId, address: userAddress, share: 0 }))
      );
      this.contributors = await Promise.all(usersromises);

      for (var i=0; i<this.contributors.length; i++){
          if (this.contributors[i].address == this.accountAddress){
            this.isContributor = true;
            break
          }
        }

      if (this.shareDetermined){
         const holdersPromises = this.contributors.map(contributor => 
          this.projectInstance.methods.getFinalShare(contributor.address)
            .call()
            .then(finalShare => ({ 
              userId: contributor.userId, 
              address: contributor.address, 
              share: finalShare }))
        );
        this.finalShares = await Promise.all(holdersPromises);
        console.log(this.finalShares)
      }
      // console.log(this.contributors)

    },
    methods: {
      shareHandler: function(){
        
        let total = 0;
        for (var i=0; i<this.contributors.length; i++){
          total += +this.contributors[i].share
        }
        this.totalShares = total;
        this.remainigShares = 100 - total;
        this.disableSubmit= this.totalShares != 100;

      },
      SubmitVote: async function(){

        this.disableSubmit = true;
        const accounts = this.contributors.map((d)=>{
          return d.address;
        })
        const shares = this.contributors.map((d)=>{
          return +d.share;
        })
        // console.log(+accounts)
        // console.log(shares)

        this.loading=true;

        const voteResult = await this.projectInstance.methods.vote(
          accounts,
          shares,
        ).send({
          from: this.accountAddress,
          // gas: '10000000'
        });
        this.$router.go(this.$router.currentRoute)
        
      // console.log(newProject);
      },
      finalizeShares: async function(){
        this.disableFinalize=true;
        this.loading=true;

        const voteResult = await this.projectInstance.methods.finalizeShares().send({
          from: this.accountAddress,
          // gas: '10000000'
        });
        this.$router.go(this.$router.currentRoute)

      },

      pay: async function(){
        this.disablePay=true;
        this.loading=true;

        const voteResult = await this.projectInstance.methods.pay().send({
          from: this.accountAddress,
          value: web3.utils.toWei(this.donateEthAmount+'', 'ether')
        });
        this.$router.go(this.$router.currentRoute)

      }

      

    }
  };
</script>

<style>
</style>
