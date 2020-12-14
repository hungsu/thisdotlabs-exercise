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
import { Component, Vue, Watch } from "vue-property-decorator";
import Results from "@/components/Results.vue";
import Axios, { AxiosBasicCredentials, AxiosRequestConfig } from "axios";

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

  @Watch('$route', { immediate: true, deep: true })
  onUrlChange(newVal: any) {
    this.pageNumber = parseInt(newVal.query.page,10)
    if (newVal.query.q.length > 0) this.getResults(newVal.query.q);
  }

  get pageTotal() {
    return Math.ceil(this.resultCount / 30);
  }
  get resultsCountString() {
    const noun = this.resultCount > 1 ? "results" : "result";
    return `${this.resultCount} ${noun} found.`;
  }
  get AxiosQuery() {
    return {type: 'user', page: this.pageNumber.toString(), q: this.query}
  }
  onSubmit() {
    this.pageNumber = 1;
    this.$router.push({name: 'Home', query: this.AxiosQuery})
  }
  getNext() {
    this.pageNumber++;
    this.$router.push({name: 'Home', query: this.AxiosQuery})
  }
  getPrevious() {
    this.pageNumber--;
    this.$router.push({name: 'Home', query: this.AxiosQuery})
  }
  getResults(query: string) {
    const path = this.$route.fullPath.substring(1)
    const url = `https://api.github.com/search/users${path}`;

    const config:AxiosRequestConfig = {
      headers: {
        authorization: 'token 0e85c458816135eb8497c79f0e1d4ef967a9eef9'
      }
    };
    Axios.get(url, config).then(response => {
      this.results = response.data.items || [];
      this.resultCount = 0 + response.data.total_count;
      this.previousQuery = query;
    });
  }
}
</script>
