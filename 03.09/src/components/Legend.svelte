<script>
  export let colorScale;
  export let data;

  $: percentOfMax = (data?.population / colorScale.domain()[1]) * 100;

  import { fade } from "svelte/transition";

  import { format } from "d3-format";
  const suffixFormat = d => format(".2~s")(d).replace(/G/, "B");
</script>

<div class="legend" aria-hidden="true">
  <span class="label">0</span>
  <div
    class="bar"
    style:background="linear-gradient(to right, {colorScale.range()[0]}, {colorScale.range()[1]})"
  >
    {#if percentOfMax}
      <span transition:fade class="line" style="left: {percentOfMax}%;" />
    {/if}
  </div>
  <span class="label">{suffixFormat(colorScale.domain()[1])}</span>
</div>

<style>
  .bar {
    height: 15px;
    width: 100%;
    position: relative;
  }

  .legend {
    display: flex;
    gap: 6px;
  }

  .label {
    color: white;
    font-size: 0.85rem;
    user-select: none;
  }

  .line {
    position: absolute;
    top: 0;
    height: 15px;
    width: 2px;
    background: white;
    transition: left 800ms cubic-bezier(1, 0, 0, 1);
  }
</style>
