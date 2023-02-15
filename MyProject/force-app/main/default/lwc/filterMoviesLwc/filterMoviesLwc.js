import { LightningElement, wire } from 'lwc';
import getMoviesWithSearch from '@salesforce/apex/MovieController.getMoviesWithSearch';


export default class FilterMoviesLwc extends LightningElement {
    
    movies = []; 
    search = '';

    sendMovieResults( ){
        console.log(this.search);
        const movieEvent = new CustomEvent('filtered', 
        {detail : this.search}
        );
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