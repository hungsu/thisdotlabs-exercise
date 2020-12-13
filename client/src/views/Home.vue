<template>
  <div class="home">
    <form v-on:submit.prevent="onSubmit">
      <input type="search" v-model="query">
    </form>
    <Results :results="results" />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Results from "@/components/Results.vue";
import Axios from "axios"

@Component({
  data: function () {
    return {
      query: '',
      results: []
    }
  },
  components: {
    Results
  },
  methods: {
    onSubmit: function() {
      const url = 'https://api.github.com/search/users?q=' + this.query
      const config = {}
      Axios.get(url,config).then(response => {
        this.results = response.data.items
      })
    }
  }
})
export default class Home extends Vue {}
</script>
