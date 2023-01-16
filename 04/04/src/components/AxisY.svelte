<script>
  export let width;
  export let yScale;

  let yTicks = yScale.ticks(4);

  import { fade } from "svelte/transition";
</script>

<g class="axis y">
  {#each yTicks as tick, index}
    <g
      transition:fade={{ delay: index * 200 }}
      class="tick"
      transform="translate(0, {yScale(tick)})"
    >
      <line
        x1={0}
        x2={width}
        y1={0}
        y2={0}
        stroke={index === 0 ? "#8f8f8f" : "#e5e7eb"}
      />
      <text y={-3}
        >{index === yTicks.length - 1 ? `${tick} hours studied` : tick}</text
      >
    </g>
  {/each}
</g>
