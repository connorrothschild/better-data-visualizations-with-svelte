<script>
  export let colorScale;
</script>

<div class='legend'>
  {#each colorScale.domain() as continent}
      <p>
          <span style="background-color: {colorScale(continent)}"></span>
          {continent}
      </p>
  {/each}
</div>

<style>
  .legend {
    display: flex;
    justify-content: center;
    flex-direction: row;
    flex-wrap: wrap;
    column-gap: 10px;
    row-gap: 5px;
    margin-bottom: 0.25rem;
  }

  p {
    margin: 0;
    font-size: 0.8rem;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    column-gap: 3px;
  }

  span {
    width: 9px;
    height: 9px;
    display: inline-block;
    border-radius: 50%;
    border: 1px solid rgba(0, 0, 0, 0.5);
  }
</style>