<template>
  <div class="home">
    <form v-on:submit.prevent="onSubmit">
      <input type="search" v-model="query">
    </form>
    <Results :results="results" />

    <p v-if="previousQuery.length > 0">{{ resultsCountString }}</p>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Results from "@/components/Results.vue";
import Axios from "axios"

@Component({
  data: function () {
    return {
      previousQuery: '',
      query: '', // Up to 256 characters https://docs.github.com/en/free-pro-team@latest/rest/reference/search#limitations-on-query-length
      results: [],
      resultCount: 0
    }
  },
  components: {
    Results
  },
  computed: {
    resultsCountString: function() {
      const noun = this.resultCount > 1 ? 'results' : 'result'
      return `${this.resultCount} ${noun} found.`
    }
  },
  methods: {
    onSubmit: function() {
      const url = 'https://api.github.com/search/users?type=user&q=' + this.query
      const config = {}
      Axios.get(url,config).then(response => {
        this.results = response.data.items
        this.resultCount = 0 + response.data.total_count
        this.previousQuery = this.query
      })
    }
  }
})
export default class Home extends Vue {}
</script>
