import { LightningElement, api } from 'lwc';
import { createMessageContext, MessageContext, releaseMessageContext, publish} from 'lightning/messageService';
import Preview from "@salesforce/messageChannel/Preview__c";


export default class MovieTileLwc extends LightningElement {
    @api
    movie;

    messageContext = createMessageContext();
    cardClick() {
        publish(this.messageContext, Preview, this.movie);
    }
}