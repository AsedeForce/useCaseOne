import { LightningElement } from "lwc";

export default class FilterMoviesLwc extends LightningElement {
  // Properties
  movies = [];
  search = "";

  // Event Handlers
  sendMovieResults() {
    const movieEvent = new CustomEvent("filtered", { detail: this.search });
    this.dispatchEvent(movieEvent);
  }

  handleKeyChange(event) {
    window.clearTimeout(this.delayTimeout);
    const search = event.target.value;
    this.delayTimeout = setTimeout(() => {
      this.search = search;
      this.sendMovieResults();
    }, 300);
  }
}
