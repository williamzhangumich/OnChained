import Vue from "vue";
import Router from "vue-router";
import Main from "@/components/Main/index";
import Detail from "@/components/Detail/index";

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: "/",
      name: "Main",
      component: Main,
      props: true
    },
    {
      path: "/project/:projectAddress",
      name: "Detail",
      component: Detail,
      props: true
    }
  ]
});
