import { LightningElement, track, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import Preview from "@salesforce/messageChannel/Preview__c";

export default class MoviePreviewLwc extends LightningElement {
    @track
    movie;

    @wire(MessageContext)
    messageContext;
    subscribeToMessageChannel() {
        this.subscription = subscribe(
          this.messageContext,
          Preview,
          (message) => this.handleMessage(message)
        );
      }
    
    handleMessage(message) {
        console.log("test");
        this.movie = message;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();
  }
}