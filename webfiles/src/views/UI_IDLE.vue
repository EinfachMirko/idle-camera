<template>
    <div class="full_window">
        <div class="top_border">
        </div>
        <div class="bottom_border">
        </div>
    </div>
</template>

<script lang="ts">

</script>

<style lang="scss">
.full_window {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    z-index: 99999;
}

.top_border {
    position: absolute;
    width: 100%;
    height: 15%;
    top: 0;
    background-color: black;
}

.bottom_border {
    position: absolute;
    width: 100%;
    height: 15%;
    bottom: 0;
    background-color: black;
}
</style>