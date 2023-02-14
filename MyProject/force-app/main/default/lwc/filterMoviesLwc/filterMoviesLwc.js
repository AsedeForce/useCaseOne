import { LightningElement, wire } from 'lwc';
import getMoviesWithSearch from '@salesforce/apex/MovieController.getMoviesWithSearch';


export default class FilterMoviesLwc extends LightningElement {
    
    movies = []; 
    search = '';

    @wire(getMoviesWithSearch, { search: '$search' })
    wiredValues({ error, data }) {
        if (data) {
            this.sendMovieResults(data);
        } else if (error) {
            // TODO : handle error
            console.error(error);
        }
    }


    sendMovieResults( data ){
        const movieEvent = new CustomEvent('filtered', 
        {detail : [...data]}
        );
        this.dispatchEvent(movieEvent);
    }


    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const search = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.search = search;
        }, 300);
    }


}