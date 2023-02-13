import { LightningElement, track, api } from 'lwc';

export default class NewMoviesModalLwc extends LightningElement {
    @api
    isshowmodal = false;

    ratingOptions = [
        {
            value : 1,
            label : '1'
        },
        {
            value : 2,
            label : '2'
        },
        {
            value : 3,
            label : '3'
        },
        {
            value : 4,
            label : '4'
        },
        {
            value : 5,
            label : '5'
        },
    ];

    typeOptions = [
        {
            value : 'Horror',
            label : 'Horror'
        },
        {
            value : 'Adventure',
            label : 'Adventure'
        },
        {
            value : 'Action',
            label : 'Action'
        },
        {
            value : 'Drama',
            label : 'Drama'
        },
        {
            value : 'Comedy',
            label : 'Horror'
        },
    ];

    actorsOptions = [
        {
            value : 'Clint EastWood',
            label : 'Clint EastWood'
        },
        {
            value : 'Mark Ruffalo',
            label : 'Mark Ruffalo'
        },
        {
            value : 'Leonardo Dicaprio',
            label : 'Leonardo Dicaprio'
        },
        {
            value : 'Heath Ledger',
            label : 'Heath Ledger'
        },
        {
            value : 'Steve Martin',
            label : 'Steve Marting'
        },
    ];


    isPicklistDisabled = false;

    isAttributeRequired = false;

    selectionChangeHandler() {
        //to implement
    }

    showModalBox() {  
        this.isshowmodal = true;
    }

    hideModalBox() {  
        this.isshowmodal = false;
        const closeEvent = new CustomEvent('modalclosed');
        this.dispatchEvent(closeEvent);
    }

    selectionChangeHandler() {
        //to implement
    }

}