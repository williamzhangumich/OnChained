import Vue from "vue";
import Router from "vue-router";
import Hello from "@/components/Hello";
import Main from "@/components/Main";
import Detail from "@/components/Detail";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "Main",
      component: Main
    },

    {
      path: "/detail/:campaignId",
      name: "Detail",
      component: Detail
    }
  ]
});
