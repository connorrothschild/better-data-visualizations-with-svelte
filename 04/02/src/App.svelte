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

  // Scrollytelling
  import Scrolly from "./helpers/Scrolly.svelte";
  let currentStep;

  let initialData = data.sort((a, b) => a.grade - b.grade);
  let renderedData = initialData;

  $: X_MIDPOINT = (xScale.domain()[0] + xScale.domain()[1]) / 2;
  $: Y_MIDPOINT = (yScale.domain()[0] + yScale.domain()[1]) / 2;

  $: {
    if (currentStep === 0) {
      renderedData = initialData.map(d => ({
        ...d,
        hours: Y_MIDPOINT,
        grade: X_MIDPOINT
      }));
      hoveredData = null;
    } else if (currentStep === 1) {
      renderedData = initialData.map(d => ({ ...d, hours: Y_MIDPOINT }));
      hoveredData = null;
    } else if (currentStep === 2) {
      renderedData = initialData;
      hoveredData = initialData[13];
    }
  }
</script>

<section>
<div class='sticky'>
  <h1>Students who studied longer scored higher on their final exams</h1>
  <div
    class="chart-container"
    bind:clientWidth={width}
  >
    <svg {width} {height} on:mouseleave={() => hoveredData = null}>
      <g class="inner-chart" transform="translate({margin.left}, {margin.top})">
          <AxisY width={innerWidth} {yScale} />
          <AxisX height={innerHeight} width={innerWidth} {xScale} />
          {#each renderedData as d}
            <circle 
              in:fly={{ x: -10, opacity: 0, duration: 500 }}
              cx={xScale(d.grade)}
              cy={yScale(d.hours)}
              fill="purple"
              stroke="black"
              r={hoveredData == d ? radius * 2 : radius}
              opacity={hoveredData ? (hoveredData == d ? 1 : 0.45) : 0.85}
              on:mouseover={() => (currentStep >= 2 ? hoveredData = d : null)}
              on:focus={() => (currentStep >= 2 ? hoveredData = d : null)}
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

  <div class='steps'>
    <Scrolly bind:value={currentStep}>
        {#each ['Hello', 'Scrollytelling', 'World!'] as text, i}
            <div class="step" class:active={currentStep === i}>
              <div class='step-content'>
                <p>{text}</p> 
                </div>
            </div>
        {/each}
    </Scrolly>
  </div>
</section>

<style>
  :global(.tick text, .axis-title) {
    font-weight: 400;
    font-size: 12px;
    fill: hsla(212, 10%, 53%, 1);
  }

  .chart-container {
    position: relative;
  }

  circle {
    transition: r 300ms ease, opacity 500ms ease,
      cx 500ms cubic-bezier(0.76, 0, 0.24, 1),
      cy 500ms cubic-bezier(0.76, 0, 0.24, 1); /* https://easings.net/#easeInOutQuart */
    cursor: pointer;
  }

  h1 {
    margin: 0 0 0.5rem 0;
    font-size: 1.35rem;
    font-weight: 600;
  }

  .step {
    height: 90vh;
    opacity: 0.3;
    transition: opacity 300ms ease;
    display: flex;
    justify-content: center;
    place-items: center;
  }

  .step.active {
    opacity: 1;
  }

  section {
    position: relative;
  }

  .sticky {
    position: sticky;
    top: 0;
    z-index: 1;
  }

  .steps {
    z-index: 2;
    position: relative;
    pointer-events: none;
  }

  .step-content {
    padding: 0.75rem 1rem;
    border: 1px solid black;
    border-radius: 3px;
    background: white;
  }
</style>
