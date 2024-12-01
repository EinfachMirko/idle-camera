<template>
   <!-- <div class="background"><img src="./assets/images/hud/background.png"></div> -->
  <v-app style="background: none; overflow: hidden">
    <transition name="fade" appear>
      <UI_IDLE v-if="globalStore.$state.playerData.idleEnabled"></UI_IDLE>
    </transition>
    <UI_SOUNDS></UI_SOUNDS>

  
  </v-app>
</template>

<script setup>
import {  onMounted, onUnmounted } from "vue";
import { useGlobalStore } from "./stores/global";

const globalStore = useGlobalStore();

import UI_IDLE from "./views/UI_IDLE.vue";


const changeGlobalStore = () => {
  globalStore.$state.idleEnabled = true;
  console.log("idleEnabled");
}

const handleMessageListener = (event) => {
  const itemData = event?.data;
  if(itemData) {
    switch(itemData.type){
      case "EnableCamera": {
        console.log("enabling Idle")
        globalStore.$state.playerData.idleEnabled = itemData.payload[0];
        console.log("idleEnabled");
        break;
      }
      case "NUISound": {
        playSound(itemData.payload[0]);
        break;
      }
      case "StopSound": {
        stopSound();
        break;
      }
    }
  }
};
const audio = new Audio();

const playSound = (soundName) => {
  audio.src = "../sounds/song.mp3";
  // Set the audio source  
  // Set the volume (ensure it's between 0.0 and 1.0)
  audio.volume = Math.max(0, Math.min(0.05, 0.09));
  
  // Play the audio
  audio.play().catch(err => {
    console.error("Error playing sound:", err);
  });
};

const stopSound = () => {
  audio.pause();          // Pause the audio playback
  audio.currentTime = 0; // Reset the playback position to the start
};

onMounted(() => {
  window.addEventListener("message", handleMessageListener);
  window.addEventListener('contextmenu', function(event) {
    event.preventDefault();
  });
  // remove these below on release !!! TODO
  // window.toggleShow = toggleShow;
  // window.setPlayerID = setPlayerID;
  window.changeGlobalStore = changeGlobalStore
  // toggleShow('main')
});

onUnmounted(() => {
  window.removeEventListener("message", handleMessageListener);
});

</script>

<style lang="scss">

::-webkit-scrollbar {
  width: 0vh;
  height: 0.75vh;
  background: rgba(0, 0, 0, 0);
}

::-webkit-scrollbar-thumb {
  background-color: black; /* Change this to your desired color */
  border-radius: 5px; /* Optional: rounds the corners of the knob */
}


body {
  user-select: none;
}



</style>

<style scoped>
.bounce-enter-active {
  transition: transform 0.6s cubic-bezier(0.68, -0.55, 0.27, 1.55), opacity 0.6s ease;
}

.bounce-leave-active {
  transition: opacity 0.5s ease;
}

.bounce-enter-from {
  transform: scale(0.8) translate(-60%, -60%);
  opacity: 0;
}

.bounce-enter-to {
  transform: scale(1) translate(-50%, -50%);
  opacity: 1;
}

.bounce-leave-to {
  opacity: 0;
}



.fade-enter-active {
  transition: opacity 0.3s ease;
}

.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
}

.fade-enter-to {
  opacity: 1;
}

.fade-leave-to {
  opacity: 0;
}








</style>