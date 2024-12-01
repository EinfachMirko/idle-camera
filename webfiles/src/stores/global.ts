import { defineStore } from "pinia";


export const useGlobalStore = defineStore("app", {
  state: () => ({
    playerData: {
      idleEnabled: false,
    },
  })
});