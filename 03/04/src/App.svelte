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
    .rotate([0, 0])
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
</script>

<div class='chart-container' bind:clientWidth={width}>
  <svg {width} {height}>
    <!-- Filter for drop shadow -->
    <Glow />

    <!-- Globe -->
    <circle 
      r={width / 2} 
      cx={width / 2} 
      cy={height / 2} 
      fill="#1c1c1c"
      filter="url(#glow)" 
    />

    <!-- Countries -->
    {#each countries as country}
      <path 
        d={path(country)} 
        fill={colorScale(country.population || 0)}
        stroke="none" 
      />
    {/each}

    <!-- Borders -->
    <path d={path(borders)} fill="none" stroke="#1C1C1C" />
  </svg>
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
</style>
