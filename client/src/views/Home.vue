<template>
  <div class="home">
    <form v-on:submit.prevent="onSubmit">
      <label for="user-search"> Search for Github users:</label>
      <input
        id="user-search"
        type="search"
        v-model="query"
        placeholder="example: arthyn"
      />
      <input type="submit" value="🔍" aria-label="Search" />
    </form>
    <Results :results="results" />
    <div v-if="pageTotal">
      <button v-if="pageNumber > 1" @click="getPrevious">Previous</button>
      Page {{ pageNumber }} of {{ pageTotal }}
      <button v-if="pageNumber < pageTotal" @click="getNext">Next</button>
    </div>
    <p v-if="previousQuery.length > 0">{{ resultsCountString }}</p>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import Results from "@/components/Results.vue";
import Axios from "axios";

interface GithubResult {
  id?: string;
}

@Component({
  components: {
    Results
  }
})
export default class Home extends Vue {
  pageNumber = 1;
  previousQuery = "";
  query = "";
  results: GithubResult[] = [];
  resultCount = 0;

  get pageTotal() {
    return Math.ceil(this.resultCount / 30);
  }
  get resultsCountString() {
    const noun = this.resultCount > 1 ? "results" : "result";
    return `${this.resultCount} ${noun} found.`;
  }
  onSubmit() {
    this.pageNumber = 1;
    this.getResults(this.query);
  }
  getNext() {
    this.pageNumber++;
    this.getResults(this.query);
  }
  getPrevious() {
    this.pageNumber--;
    this.getResults(this.query);
  }
  getResults(query: string) {
    const url = `https://api.github.com/search/users?type=user&page=${this.pageNumber}&q=${query}`;

    const config = {};
    Axios.get(url, config).then(response => {
      this.results = response.data.items;
      this.resultCount = 0 + response.data.total_count;
      this.previousQuery = query;
    });
  }
}
</script>
