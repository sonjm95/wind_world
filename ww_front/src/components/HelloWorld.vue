<template>
  <div>
   <input type="text" v-model="id" />
   <button v-on:click="add()">등록</button>
  </div>
</template>

<script>
import http from "@/util/http-common";

export default {
  name: "Add",
  props: {
    type: { type: String }
  },
  data: function(){
    return {
      id:""
    };
  },
  methods: {
    add: function(){

       http
        .post("/kamco/memberRest/add", {
          id: this.id,
          
        })
        .then(({ data }) => {
          let msg = "등록 처리시 문제가 발생했습니다.";
          if (data === "success") {
            msg = "등록이 완료되었습니다.";
          }
          alert(data);
          
        });
     

    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style>

</style>
