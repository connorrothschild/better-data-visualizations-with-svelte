<script>
  export let margin;
  export let yScale;

  $: ticks = yScale.domain();
</script>

<g class='axis y' transform="translate({margin.left}, {margin.top})">
    {#each ticks as tick, index}
        <g class='tick'>
            <text y={yScale(tick)} >{tick}</text>
        </g>
    {/each}
</g>