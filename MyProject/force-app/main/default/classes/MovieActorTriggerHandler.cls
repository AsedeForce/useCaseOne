public class MovieActorTriggerHandler extends TriggerHandler{
    private Map<Id, MovieActor__c> newMovieActorMap;
    private Map<Id, MovieActor__c> oldMovieActorMap;




    public MovieActorTriggerHandler() {
        this.newMovieActorMap = (Map<Id, MovieActor__c>) Trigger.newMap;
        this.oldMovieActorMap = (Map<Id, MovieActor__c>) Trigger.oldMap;

      }

    public override void afterInsert() {
        MovieActorTriggerHelper.updateMovieNumbersAndGenderPercentages(newMovieActorMap);
      }
    public override void afterDelete() {
        MovieActorTriggerHelper.updateMovieNumbersAndGenderPercentages(oldMovieActorMap);
    }
}