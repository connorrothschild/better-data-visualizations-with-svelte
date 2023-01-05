<script>
  import AxisX from "$components/AxisX.svelte";
  import AxisY from "$components/AxisY.svelte";
  import Legend from "$components/Legend.svelte";
  import Tooltip from "$components/Tooltip.svelte";

  import data from "$data/data.js";
  import { forceSimulation, forceX, forceY, forceCollide } from "d3-force";
  import { scaleLinear, scaleBand, scaleOrdinal, scaleSqrt } from "d3-scale";

  let width = 400,
    height = 400;
  const margin = { top: 0, right: 0, left: 0, bottom: 20 };

  $: innerWidth = width - margin.left - margin.right;
  let innerHeight = height - margin.top - margin.bottom;

  import { mean, rollups } from "d3-array";

  // Generate the average for each continent, so that we can sort according to that
  const continents = rollups(
    data,
    v => mean(v, d => d.happiness),
    d => d.continent
  ) // Group data by continent and return the group-wide mean
    .sort((a, b) => a[1] - b[1]) // Sort according to value
    .map(d => d[0]); // Grab the continent name

  const colorRange = [
    "#dda0dd",
    "#fe7f2d",
    "#fcca46",
    "#a1c181",
    "#619b8a",
    "#eae2b7"
  ];

  let colorScale = scaleOrdinal()
    .domain(continents) // continents was already defined in our code
    .range(colorRange);

  $: radiusScale = scaleSqrt()
    .domain([1, 9]) // The same domain passed to xScale
    .range(width < 568 ? [2, 6] : [3, 8]);

  $: xScale = scaleLinear()
    .domain([1, 9]) // Alternatively, we could pass .domain(extent(data, d => d.happiness))
    .range([0, innerWidth]);

  let yScale = scaleBand()
    .domain(continents)
    .range([innerHeight, 0])
    .paddingOuter(0.5);

  let simulation = forceSimulation(data);
  let nodes = [];
  simulation.on("tick", () => {
    nodes = simulation.nodes();
  });

  $: {
    simulation
      .force(
        "x",
        forceX()
          .x(d => xScale(d.happiness))
          .strength(0.8)
      )
      .force(
        "y",
        forceY()
          .y(d => (groupByContinent ? yScale(d.continent) : innerHeight / 2))
          .strength(0.2)
      )
      .force("collide", forceCollide().radius(d => radiusScale(d.happiness)))
      .alpha(0.3) // [0, 1] The rate at which the simulation finishes. You should increase this if you want a faster simulation, or decrease it if you want more "movement" in the simulation.
      .alphaDecay(0.0005) // [0, 1] The rate at which the simulation alpha approaches 0. you should decrease this if your bubbles are not completing their transitions between simulation states.
      .restart();
  }

  // Highlight hovered circles and deemphasize others
  // If a continent is hovered (from Legend.svelte), highlight relevant circles
  let hovered, hoveredContinent;
  import { fade } from "svelte/transition";

  // Boolean for whether the circles are grouped by continent
  let groupByContinent = false;
</script>

<h1>The Happiest Countries in the World</h1>
<Legend {colorScale} bind:hoveredContinent />
<div
  class="chart-container"
  bind:clientWidth={width}
  on:click={() => {
    groupByContinent = !groupByContinent;
    hovered = null;
  }}
>
  <svg {width} {height}>
    <!-- Reference line -->
    {#if hovered}
      <line
        transition:fade
        x1={hovered.x}
        x2={hovered.x}
        y1={height - margin.bottom}
        y2={hovered.y + margin.top + radiusScale(hovered.happiness)}
        stroke={colorScale(hovered.continent)}
        stroke-width="2"
      />
    {/if}
    <g
      class="inner-chart"
      transform="translate({margin.left}, {margin.top})"
      on:mouseleave={() => (hovered = null)}
    >
      <AxisX {xScale} height={innerHeight} width={innerWidth} />
      <AxisY {yScale} {groupByContinent} />
      {#each nodes as node, i}
        <circle       
          in:fade={{ delay: 200 + 10 * i, duration: 400 }}
          cx={node.x}
          cy={node.y}
          r={radiusScale(node.happiness)}
          fill={colorScale(node.continent)}
          title={node.country}
          opacity={hovered || hoveredContinent
            ? hovered === node || hoveredContinent === node.continent
              ? 1
              : 0.3
            : 1}
          stroke={hovered || hoveredContinent
            ? hovered === node || hoveredContinent === node.continent
              ? "black"
              : "transparent"
            : "#00000090"}
          on:mouseover={() => (hovered = node)}
          on:focus={() => (hovered = node)}
          tabindex="0"
          on:click={(event) => {
            event.stopImmediatePropagation();
          }}
        />
      {/each}
    </g>
  </svg>
  {#if hovered}
    <Tooltip data={hovered} {colorScale} {width} />
  {/if}
</div>

<style>
  :global(*) {
    font-family: Inter, -apple-system, system-ui;
    -moz-osx-font-smoothing: grayscale;
  }

  :global(.tick text, .axis-title) {
    font-size: 12px; /* How big our text is */
    font-weight: 400; /* How bold our text is */
    fill: hsla(212, 10%, 53%, 1); /* The color of our text */
    user-select: none; /* Prevents text from being selected */
  }

  h1 {
    margin: 0 0 0.5rem 0;
    font-size: 1.35rem;
    font-weight: 600;
    text-align: center;
  }

  circle {
    transition: stroke 300ms ease, opacity 300ms ease;
    cursor: pointer;
  }
</style>
