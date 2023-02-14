import { LightningElement, wire } from 'lwc';

export default class MovieManagerContainer extends LightningElement {

    isshowmodal = false;
    movies = [];

    handleNewMovieModal() {
        this.isshowmodal = true;
    }
    handleModalClosed() {
        this.isshowmodal = false;
    }

    handleFiltered( event ) {
        this.movies = event.detail.map(value => ({
            id: value.Id,
            type: value.Category__c,
            description : value.Description__c,
            rating : value.Rating__c,
            releaseDate : value.Release_date__c,
            name : value.Name
        }));
    }

}