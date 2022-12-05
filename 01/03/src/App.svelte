<script>
  import AxisX from "$components/AxisX.svelte";
  import AxisY from "$components/AxisY.svelte";
  import data from "$data/data.js";

  import { scaleLinear } from "d3-scale";
  import { max } from "d3-array";

  let width = 400;
  let height = 400;

  const margin = { top: 20, right: 15, bottom: 20, left: 0 };

  $: xScale = scaleLinear()
    .domain([0, 100])
    .range([0, width - margin.right - margin.left]);

  let yScale = scaleLinear()
    .domain([0, max(data, d => d.hours)])
    .range([height - margin.bottom - margin.top, 0]);
</script>

<div class='chart-container' bind:clientWidth={width}>
  <svg {width} {height}>
      <AxisY {yScale} {width} {margin} />
      <AxisX {height} {width} {xScale} {margin} />
      <g class='inner-chart' transform="translate({margin.left}, {margin.top})">
      {#each data as d}
        <circle
          cx={xScale(d.grade)}
          cy={yScale(d.hours)}
          r={10}
          fill="purple"
          stroke="black"
          stroke-width={1}
        />
      {/each}
    </g>
  </svg>
</div>

<style>
  :global(.tick text, .axis-title) {
    font-weight: 400; /* How thick our text is */
    font-size: 12px; /* How big our text is */
    fill: hsla(212, 10%, 53%, 1); /* The color of our text */
  }
</style>