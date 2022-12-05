<script>
  import data from "$data/data.js";

  import { scaleLinear } from "d3-scale";
  import { max } from "d3-array";

  let width = 400;
  let height = 400;

  let xScale = scaleLinear()
    .domain([0, 100])
    .range([0, width]);

  let yScale = scaleLinear()
    .domain([0, max(data, d => d.hours)])
    .range([height, 0]);
</script>

<svg {width} {height}>
  {#each data as d}
    <circle
      cx={xScale(d.grade)}
      cy={yScale(d.hours)}
      r={10}
      fill="purple"
      stroke="black"
      stroke-width={1}
    />
  {/each}
</svg>