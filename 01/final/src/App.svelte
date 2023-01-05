<script>
  import AxisX from "$components/AxisX.svelte";
  import AxisY from "$components/AxisY.svelte";
  import Tooltip from "$components/Tooltip.svelte";
  import data from "$data/data.js";

  import { scaleLinear } from "d3-scale";
  import { max } from "d3-array";

  let width = 400,
    height = 400;

  const margin = { top: 20, right: 15, bottom: 20, left: 0 };
  const radius = 10;

  $: innerWidth = width - margin.left - margin.right;
  let innerHeight = height - margin.top - margin.bottom;

  $: xScale = scaleLinear()
    .domain([0, 100])
    .range([0, innerWidth]);

  let yScale = scaleLinear()
    .domain([0, max(data, d => d.hours)])
    .range([innerHeight, 0]);

  let hoveredData;

  import { fly } from "svelte/transition";
</script>

<h1>Students who studied longer scored higher on their final exams</h1>
<div
  class="chart-container"
  bind:clientWidth={width}
>
  <svg {width} {height} on:mouseleave={() => hoveredData = null}>
    <g class="inner-chart" transform="translate({margin.left}, {margin.top})">
        <AxisY width={innerWidth} {yScale} />
        <AxisX height={innerHeight} width={innerWidth} {xScale} />
        {#each data.sort((a, b) => a.grade - b.grade) as d, index}
          <circle 
            in:fly={{ x: -10, opacity: 0, duration: 500 }}
            cx={xScale(d.grade)}
            cy={yScale(d.hours)}
            fill="purple"
            stroke="black"
            r={hoveredData == d ? radius * 2 : radius}
            opacity={hoveredData ? (hoveredData == d ? 1 : 0.45) : 0.85}
            on:mouseover={() => hoveredData = d}
            on:focus={() => hoveredData = d}
            tabindex="0"
          />
        {/each}
    </g>
  </svg>
  {#if hoveredData}
    <Tooltip {xScale} {yScale} {width} data={hoveredData} />
  {/if}
</div>

<style>
  :global(.tick text, .axis-title) {
    font-weight: 400; /* How thick our text is */
    font-size: 12px; /* How big our text is */
    fill: hsla(212, 10%, 53%, 1); /* The color of our text */
  }

  .chart-container {
    position: relative;
  }

  circle {
    transition: r 300ms ease, opacity 500ms ease;
    cursor: pointer;
  }

  h1 {
    margin: 0 0 0.5rem 0;
    font-size: 1.35rem;
    font-weight: 600;
  }
</style>
