import { LightningElement, api } from "lwc";
import { createMessageContext, publish } from "lightning/messageService";
import Preview from "@salesforce/messageChannel/Preview__c";

export default class MovieTileLwc extends LightningElement {
  // Template Properties
  @api
  movie;

  // Message channel setup
  messageContext = createMessageContext();
  cardClick() {
    publish(this.messageContext, Preview, this.movie);
  }
}
