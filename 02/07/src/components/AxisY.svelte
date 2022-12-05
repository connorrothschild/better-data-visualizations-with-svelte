<script>
  export let margin;
  export let yScale;
  export let groupByContinent;

  $: ticks = yScale.domain();
  import { fade } from "svelte/transition";
</script>

<g class='axis y' transform="translate({margin.left}, {margin.top})">
    {#if groupByContinent}
        {#each ticks as tick, index}
            <g class='tick' in:fade={{delay: index * 100}} out:fade={{duration: 200}}>
                <text y={yScale(tick)} >{tick}</text>
            </g>
        {/each}
    {/if}
</g>