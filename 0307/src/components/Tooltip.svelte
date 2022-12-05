<script>
  export let data;
  import { format } from "d3-format";
  const suffixFormat = d => format(".2~s")(d).replace(/G/, "B");
</script>

{#if data?.country}
  <div>
    <h2>{data.country}</h2>
    <h3>Population of {suffixFormat(data.population)}</h3>
  </div>
{/if}

<style>
  div {
    position: absolute;
    bottom: 30px;
    right: 0;
    text-align: right;
  }

  h2 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 0.5rem;
    color: white;
  }

  h3 {
    font-size: 1.15rem;
    font-weight: 200;
    color: rgba(255, 255, 255, 0.7);
  }
</style>