import { LightningElement, track, wire } from "lwc";
import { subscribe, MessageContext } from "lightning/messageService";
import Preview from "@salesforce/messageChannel/Preview__c";
import deleteMovie from "@salesforce/apex/MovieController.deleteMovie";

export default class MoviePreviewLwc extends LightningElement {
  // Properties
  @track
  movie;

  // Wired Properties
  @wire(MessageContext)
  messageContext;
  subscribeToMessageChannel() {
    this.subscription = subscribe(this.messageContext, Preview, (message) =>
      this.handleMessage(message)
    );
  }

  // Event Handlers
  handleMessage(message) {
    this.movie = message;
  }

  deleteMovie() {
    deleteMovie({ id: this.movie.id })
      .then(() => {
        this.movie = null;
        const deletedEvent = new CustomEvent("delete");
        this.dispatchEvent(deletedEvent);
      })
      .catch((error) => {
        console.log(error);
        console.log(this.movie.id);
      });
  }
  // Lifecycle hooks

  connectedCallback() {
    this.subscribeToMessageChannel();
  }
}
