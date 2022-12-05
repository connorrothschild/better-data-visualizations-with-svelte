<script>
  export let xScale;
  export let height;
  export let margin;
  export let width;

  $: ticks = xScale.ticks(4);
</script>

<g class='axis x' transform="translate({margin.left}, {margin.top})">
{#each ticks as tick}
        <g class='tick' transform="translate({xScale(tick)}, 0)">
            <text x="3" y={height - margin.bottom - margin.top}>{tick}</text>
            <line x1="0" x2="0" y1="0" y2={height - margin.bottom - margin.top} stroke="hsla(215, 15%, 91%, 1)" />
          </g>
{/each}
<text class="axis-title" 
      x={width} 
      y={height - margin.top} 
      dy="-4"
      text-anchor="end">
    Happiness, out of 10 &rarr;
</text>
</g>