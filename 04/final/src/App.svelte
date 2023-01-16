<script>
  import Tooltip from "$components/Tooltip.svelte";
  import data from "$data/data.js";

  import { scaleLinear } from "d3-scale";
  import { max } from "d3-array";

  let width = 400,
    height = 400;

  const margin = { top: 25, right: 25, bottom: 30, left: 10 };
  const radius = 10;

  $: innerWidth = width - margin.left - margin.right;
  $: innerHeight = height - margin.top - margin.bottom;

  $: xScale = scaleLinear()
    .domain([0, 100])
    .range([0, innerWidth]);

  $: yScale = scaleLinear()
    .domain([0, max(data, d => d.hours)])
    .range([innerHeight, 0]);

  let hoveredData;

  // Scrollytelling
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

  import SampleText from "$components/SampleText.svelte";
  import Chart from "$components/Chart.svelte";
  import Steps from "$components/Steps.svelte";
</script>

<main>
  <h1>Students who studied longer scored higher on their final exams</h1>
  <SampleText />
  <section>
    <Chart
      {margin}
      {currentStep}
      {innerWidth}
      {innerHeight}
      {yScale}
      {xScale}
      {renderedData}
      {radius}
      bind:width={width}
      bind:height={height}
      bind:hoveredData={hoveredData}
    />
    <Steps bind:currentStep={currentStep} />
  </section>
  <SampleText />
</main>

<style>
  main {
    max-width: 768px;
    margin: auto;
    padding: 8px;
  }

  h1 {
    margin: 0.5rem 0 1rem 0;
    font-size: 1.35rem;
    font-weight: 600;
  }
</style>
