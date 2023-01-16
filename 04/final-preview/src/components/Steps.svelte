<script>
  export let currentStep;
  import Scrolly from "../helpers/Scrolly.svelte";
</script>

<div class="steps">
  <Scrolly bind:value={currentStep}>
    {#each ["Hello", "Scrollytelling", "World!"] as text, i}
      <div class="step" class:active={currentStep === i}>
        <div class="step-content">
          <p>{text}</p>
        </div>
      </div>
    {/each}
  </Scrolly>
</div>

<style>
  .step {
    height: 90vh;
    opacity: 0.3;
    transition: opacity 300ms ease;
    display: flex;
    justify-content: center;
    place-items: center;
  }

  .step.active {
    opacity: 1;
  }

  .steps {
    z-index: 2;
    position: relative;
    pointer-events: none;
  }

  .step-content {
    padding: 0.75rem 1rem;
    border: 1px solid black;
    border-radius: 3px;
    background: white;
  }
</style>