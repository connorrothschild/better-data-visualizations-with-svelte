<script>
  import data from "$data/data.js";
  import { forceSimulation, forceX, forceY, forceCollide } from "d3-force";
  import { scaleLinear, scaleBand } from "d3-scale";

  let width = 400,
    height = 400;
  const margin = { top: 0, right: 0, left: 0, bottom: 20 };
  const RADIUS = 5;

  $: innerWidth = width - margin.right - margin.left;
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

  $: xScale = scaleLinear()
    .domain([1, 9]) // Alternatively, we could pass .domain(extent(data, d => d.happiness))
    .range([0, innerWidth]);

  let yScale = scaleBand()
    .domain(continents)
    .range([innerHeight, 0])
    .paddingOuter(0.5);

  const simulation = forceSimulation(data);

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
          .y(d => yScale(d.continent))
          .strength(0.2)
      )
      .force("collide", forceCollide().radius(RADIUS))
      .alpha(0.3) // [0, 1] The rate at which the simulation finishes. You should increase this if you want a faster simulation, or decrease it if you want more "movement" in the simulation.
      .alphaDecay(0.0005) // [0, 1] The rate at which the simulation alpha approaches 0. you should decrease this if your bubbles are not completing their transitions between simulation states.
      // .stop()
      .restart()
  }

  let nodes = [];
  simulation.on("tick", () => {
    nodes = simulation.nodes();
  });

  $: console.log(nodes);
</script>

<div class='chart-container' bind:clientWidth={width}>
  <svg {width} {height}>
    <g class="inner-chart" transform="translate({margin.left}, {margin.top})">
      {#each nodes as node}
        <circle cx={node.x} cy={node.y} r={RADIUS} fill="steelblue" stroke="black" />
      {/each}
    </g>
  </svg>
</div>