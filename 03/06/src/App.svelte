<script>
  // Import geojson objects
  import world from "$data/world-110m.json"; // From https://unpkg.com/world-atlas@1.1.4/world/110m.json
  import * as topojson from "topojson-client";

  let countries = topojson.feature(world, world.objects.countries).features;
  let borders = topojson.mesh(world, world.objects.countries, (a, b) => a !== b);

  import { geoOrthographic, geoPath } from "d3-geo";

  let width = 400;
  $: height = width;

  $: projection = geoOrthographic()
    .scale(width / 2)
    .rotate([$xRotation, $yRotation])
    .translate([width / 2, height / 2]);

  $: path = geoPath(projection);

  import Glow from "./components/Glow.svelte";

  import data from "$data/data.json"; // https://data.worldbank.org/indicator/SP.POP.TOTL

  // Restructure countries array to include population
  countries.forEach(country => {
    const metadata = data?.find(d => d.id === country.id);
    if (metadata) {
      country.population = metadata.population;
      country.country = metadata.country;
    }
  });

  // Color scale
  import { max } from "d3-array";
  import { scaleLinear } from "d3-scale";

  const colorScale = scaleLinear()
    .domain([0, max(data, d => d.population)])
    .range(["#26362e", "#0DCC6C"]);

  // Auto rotate the globe, 0.5 degrees per second
  import { interval } from "d3-timer";
  import { tweened } from "svelte/motion";
  import { circOut } from "svelte/easing";

  let xRotation = tweened(0, {
    duration: 800,
    easing: circOut
  });

  let yRotation = tweened(-30, {
    duration: 800,
    easing: circOut
  });
  const degreesPerSecond = 0.5;

  const t = interval(() => {
    if (dragging || tooltipData) return;
    $xRotation += degreesPerSecond;
  }, 1);

  // Add user interaction
  import { onMount } from "svelte";
  import { select } from "d3-selection";
  import { drag } from "d3-drag";

  let globe;
  let dragging = false;
  const DRAG_SENSITIVITY = 3;

  onMount(() => {
    const element = select(globe);
    element.call(
      drag()
        .on("drag", event => {
          dragging = true;
          ($xRotation = $xRotation + event.dx * DRAG_SENSITIVITY),
            ($yRotation = $yRotation - event.dy * DRAG_SENSITIVITY); // We subtract here because the y-axis is inverted
        })
        .on("end", event => {
          // Begin autorotation again after 800ms (once tweened to new position)
          setTimeout(() => {
            dragging = false;
          }, 800);
        })
    );
  });

  // Tooltips
  let tooltipData;
  import Tooltip from "$components/Tooltip.svelte";

  // Alongside existing script tag code...
  import { geoCentroid } from "d3-geo";

  // Whenever tooltipData changes, calculate the center of the country and rotate to it
  $: if (tooltipData) {
    const center = geoCentroid(tooltipData);
    $xRotation = -center[0];
    $yRotation = -center[1];
  }

  import { draw } from "svelte/transition";
</script>

<div class='chart-container' bind:clientWidth={width}>
  <svg {width} {height} bind:this={globe} class:dragging>
    <!-- Filter for drop shadow -->
    <Glow />

    <!-- Globe -->
    <circle 
      r={width / 2} 
      cx={width / 2} 
      cy={height / 2} 
      fill="#1c1c1c"
      filter="url(#glow)" 
      on:click={() => (tooltipData = null)}
    />

    <!-- Countries -->
    {#each countries as country}
      <path 
        d={path(country)} 
        fill={colorScale(country.population || 0)}
        stroke="none" 
        on:click={() => (tooltipData = country)}
        on:focus={() => (tooltipData = country)}
        tabIndex="0"
      />
    {/each}

    <!-- Borders -->
    <path d={path(borders)} fill="none" stroke="#1C1C1C" />

    <!-- Clicked country border -->
    {#if tooltipData}
      {#key tooltipData.id}
        <path
          d={path(tooltipData)}
          fill="transparent"
          stroke="white"
          stroke-width="2"
          pointer-events="none"
          in:draw
        />
      {/key}
    {/if}
  </svg>
  <Tooltip data={tooltipData} />
</div>

<style>
  .chart-container {
    max-width: 468px;
    margin: auto;
  }

  :global(body) {
    background-color: rgb(40, 40, 40);
  }

  svg {
    overflow: visible;
  }

  .dragging {
    cursor: move;
  }

  path {
    cursor: pointer;
  }

  path:focus,
  path:focus-visible {
    outline: none;
  }
</style>
