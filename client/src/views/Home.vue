<template>
  <div class="home">
    <form v-on:submit.prevent="onSubmit">
      <label for="user-search"> Search for Github users:</label>
      <input id="user-search" type="search" v-model="query" placeholder="example: arthyn">
      <input type="submit" value="🔍">
    </form>
    <Results :results="results" />
    <div v-if="pageTotal">
      <button v-if="pageNumber > 1" @click="getPrevious">Previous</button>
      Page {{pageNumber}} of {{pageTotal}}
      <button v-if="pageNumber < pageTotal" @click="getNext">Next</button>
    </div>
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
      pageNumber: 1,
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
    pageTotal: function () {
      return Math.ceil(this.resultCount / 30)
    },
    resultsCountString: function() {
      const noun = this.resultCount > 1 ? 'results' : 'result'
      return `${this.resultCount} ${noun} found.`
    }
  },
  methods: {
    onSubmit: function() {
      this.pageNumber = 1
      this.getResults(this.query)
    },
    getNext: function () {
      this.pageNumber++
      this.getResults(this.query)
    },
    getPrevious: function () {
      this.pageNumber--
      this.getResults(this.query)
    },
    getResults: function (query) {
      const url = `https://api.github.com/search/users?type=user&page=${this.pageNumber}&q=${query}`

      const config = {}
      Axios.get(url,config).then(response => {
        this.results = response.data.items
        this.resultCount = 0 + response.data.total_count
        this.previousQuery = query
      })
    }
  }
})
export default class Home extends Vue {}
</script>
