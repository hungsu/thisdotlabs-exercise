<template>
  <div class="results-container">
    <ul class="results">
      <li v-for="result in results" v-bind:key="result.id">
        <a :href="result.html_url" target="_blank">
            <img :src="result.avatar_url" /> {{result.login}}
        </a>
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";

@Component({
    props: {
        results: {
            required: true,
            type: Array
        },
    }
})
export default class Results extends Vue {}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
