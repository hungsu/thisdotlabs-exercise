<template>
  <div class="home">
    <form v-on:submit.prevent="onSubmit">
      <input type="search" v-model="query">
    </form>
    <Results :results="results" />

    <p v-if="query.length > 0 && querySubmitted">{{ resultCount }} results found.</p>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Results from "@/components/Results.vue";
import Axios from "axios"

@Component({
  data: function () {
    return {
      query: '', // Up to 256 characters https://docs.github.com/en/free-pro-team@latest/rest/reference/search#limitations-on-query-length
      querySubmitted: false,
      results: [],
      resultCount: 0
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
        this.resultCount = 0 + response.data.total_count
        this.querySubmitted = true
      })
    }
  },
  watch: {
    query: () => {
      this.querySubmitted = false
    }
  }
})
export default class Home extends Vue {}
</script>
