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
</script>

<svg {width} {height}>
  <!-- Globe -->
  <circle r={width / 2} cx={width / 2} cy={height / 2} fill="lightblue" />

  <!-- Countries -->
  {#each countries as country}
    <path d={path(country)} fill="lightgreen" stroke="none" />
  {/each}

  <!-- Borders -->
  <path d={path(borders)} fill="none" stroke="white" />
</svg>

<style>
</style>
