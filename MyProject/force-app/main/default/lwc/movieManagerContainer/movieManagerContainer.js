import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getMoviesWithSearch from '@salesforce/apex/MovieController.getMoviesWithSearch';



export default class MovieManagerContainer extends LightningElement {

    isshowmodal = false;
    movies = [];
    wiredAccountsResult;
    search = '';

    @wire(getMoviesWithSearch, { search: '$search' })
    wiredValues( wireResult ) {
        const { data, error } = wireResult;
        this.wiredAccountsResult = wireResult;
        if (data) {
            this.movies = wireResult.data.map(value => ({
                id: value.Id,
                type: value.Category__c,
                description : value.Description__c,
                rating : value.Rating__c,
                releaseDate : value.Release_date__c,
                name : value.Name
            }));
            console.log(JSON.parse(JSON.stringify(this.movies)));
        } else if (error) {
            // TODO : handle error
            console.error(error);
        }
    }

    handleDeletingMovie(){
        console.log(this.movies);
        refreshApex(this.wiredAccountsResult);
    }

    handleNewMovieModal() {
        this.isshowmodal = true;
    }

    handleModalClosed() {
        this.isshowmodal = false;
        refreshApex(this.wiredAccountsResult);
    }

    handleFiltered( event ) {
        console.log(event.detail);
        this.search = event.detail;
    }

}