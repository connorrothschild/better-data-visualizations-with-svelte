<script>
  export let width;
  export let height;
  export let currentStep;
  export let hoveredData;
  export let margin;
  export let innerWidth;
  export let innerHeight;
  export let yScale;
  export let xScale;
  export let renderedData;
  export let radius;

  import { fly } from "svelte/transition";

  import AxisX from "$components/AxisX.svelte";
  import AxisY from "$components/AxisY.svelte";
  import Tooltip from "$components/Tooltip.svelte";
</script>

<div class="sticky">
<div
  class="chart-container"
  bind:clientWidth={width}
  bind:clientHeight={height}
>
  <svg {width} {height} on:mouseleave={() => (hoveredData = null)}>
    <g class="inner-chart" transform="translate({margin.left}, {margin.top})">
      {#if currentStep > 1}
        <AxisY width={innerWidth} {yScale} />
      {/if}
      {#if currentStep > 0}
        <AxisX height={innerHeight} width={innerWidth} {xScale} />
      {/if}
      {#each renderedData as d}
        <circle
          in:fly={{ x: -10, opacity: 0, duration: 500 }}
          cx={xScale(d.grade)}
          cy={yScale(d.hours)}
          fill="purple"
          stroke="black"
          r={hoveredData == d ? radius * 2 : radius}
          opacity={hoveredData ? (hoveredData == d ? 1 : 0.45) : 0.85}
          on:mouseover={() => (currentStep >= 2 ? (hoveredData = d) : null)}
          on:focus={() => (currentStep >= 2 ? (hoveredData = d) : null)}
          tabindex="0"
        />
      {/each}
    </g>
  </svg>
  {#if hoveredData}
    <Tooltip {xScale} {yScale} {width} data={hoveredData} />
  {/if}
</div>
</div>

<style>
  :global(.tick text, .axis-title) {
    font-weight: 400;
    font-size: 12px;
    fill: hsla(212, 10%, 53%, 1);
  }

  .sticky {
    position: sticky;

    top: 0;
    z-index: 1;

    height: 95vh;
    width: 100%;
    top: 2.5vh;
    margin-bottom: 1rem;

    /* Optional */
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .chart-container {
    position: relative;
    width: 100%;
    height: 100%;

    background: white;
    box-shadow: 1px 1px 30px rgba(252, 220, 252, 1);
    border: 1px solid plum;
    border-radius: 6px;

    /* Optional */
    max-width: 700px;
    max-height: 450px;
  }

  circle {
    transition: r 300ms ease, opacity 500ms ease,
      cx 500ms cubic-bezier(0.76, 0, 0.24, 1),
      cy 500ms cubic-bezier(0.76, 0, 0.24, 1); /* https://easings.net/#easeInOutQuart */
    cursor: pointer;
  }
</style>