<template>
  <div class='card'>
    <div class="card-img-top"></div>
    <div class="card-body">
      <h5 class="card-title">
      <router-link :to="`/project/${address}`">
          {{ title }}
      </router-link>
      </h5>
      <p class="card-text"> {{ description }} </p>
    </div>     
  </div>
</template>

<script>
export default {
  name: "ProjectCard",
  props: {
    address: String,
    title: String,
    description: String
  }
};
</script>

<style scoped>
  .card-img-top {
    background-color: steelblue;
    height: 1rem;
    border-top-left-radius: 0;
    border-top-right-radius: 0;
  }

  .card {
    width: 18rem;
    min-height: 12rem;
    margin: 1rem auto;
    border: none;
  }

  .card-body {
    border: 1px solid rgba(0, 0, 0, 0.125);
    border-radius: 0 0 0.25rem 0.25rem;
  }

  .create-new-project {
    font-size: 4rem;
    color: green;
  }
</style>

