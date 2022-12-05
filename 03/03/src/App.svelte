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
      <path d={path(country)} fill="#26362e" stroke="none" />
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
