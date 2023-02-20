import { LightningElement, wire, api, track } from "lwc";
import getActors from "@salesforce/apex/ActorSelector.getActors";
import movieName from "@salesforce/schema/Movie__c.Name";
import movieType from "@salesforce/schema/Movie__c.Category__c";
import movieRating from "@salesforce/schema/Movie__c.Rating__c";
import movieDescription from "@salesforce/schema/Movie__c.Description__c";
import movieRelease from "@salesforce/schema/Movie__c.Release_date__c";
import insertMovie from "@salesforce/apex/MovieController.insertMovie";
//import movieActors from  '@salesforce/schema/Movie__c.Actors';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class NewMoviesModalLwc extends LightningElement {
  // Template Properties
  @api
  isshowmodal = false;

  // Properties
  isPicklistDisabled = false;
  isAttributeRequired = false;
  ratingOptions = [
    {
      value: 1,
      label: "1"
    },
    {
      value: 2,
      label: "2"
    },
    {
      value: 3,
      label: "3"
    },
    {
      value: 4,
      label: "4"
    },
    {
      value: 5,
      label: "5"
    }
  ];
  typeOptions = [
    {
      value: "Horror",
      label: "Horror"
    },
    {
      value: "Adventure",
      label: "Adventure"
    },
    {
      value: "Action",
      label: "Action"
    },
    {
      value: "Drama",
      label: "Drama"
    },
    {
      value: "Comedy",
      label: "Horror"
    }
  ];
  actorsOptions = [];

  // Wired Properties
  @wire(getActors)
  wiredValues({ error, data }) {
    if (data) {
      this.actorsOptions = data.map((value) => ({
        label: value.Name,
        value: value.Name
      }));
    } else if (error) {
      console.error(error);
    }
  }

  @track
  selectedActors = [];
  @track
  selectedActor;
  @track
  newMovieRecord = {
    Name: movieName,
    Category__c: movieType,
    Rating__c: movieRating,
    Description__c: movieDescription,
    Release_date__c: movieRelease,
    Actors: ""
  };

  saveNewMovie() {
    insertMovie({ obj: this.newMovieRecord })
      .then(() => {
        this.hideModalBox();
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Movie created",
            variant: "success"
          })
        );
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }

  // Event Handlers

  handleChange(event) {
    this.value = event.detail.value;
  }

  hideModalBox() {
    this.isshowmodal = false;
    const closeEvent = new CustomEvent("modalclosed");
    this.dispatchEvent(closeEvent);
    this.selectedActors = [];
    this.selectedActor = "";
    this.newMovieRecord = {};
  }

  addActor() {
    if (!this.selectedActors.includes(this.selectedActor)) {
      this.selectedActors.push(this.selectedActor);
      this.newMovieRecord.Actors = this.selectedActors.map(
        (value) => value.label
      );
    }
  }

  removeActor(event) {
    this.selectedActors = this.selectedActors.filter(
      (item) => item.label !== event.target.value
    );
    this.newMovieRecord.Actors = this.selectedActors.map(
      (value) => value.label
    );
  }

  actorSelectionChangeHandler(event) {
    this.selectedActor = {
      label: event.target.value,
      value: event.target.value
    };
    //this.newMovieRecord.Actors = event.target.value;
  }

  typeSelectionChangeHandler(event) {
    this.newMovieRecord.Category__c = event.target.value;
  }

  ratingSelectionChangeHandler(event) {
    this.newMovieRecord.Rating__c = event.target.value;
  }

  descriptionChangeHandler() {
    this.newMovieRecord.Description__c =
      this.template.querySelector("lightning-textarea").value;
  }

  nameChangeHandler(event) {
    this.newMovieRecord.Name = event.target.value;
  }

  dateChangeHandler(event) {
    this.newMovieRecord.Release_date__c = event.target.value;
  }
}
