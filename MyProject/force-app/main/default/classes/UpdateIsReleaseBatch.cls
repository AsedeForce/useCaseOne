public class UpdateIsReleaseBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, IsReleased__c, ReleaseDate__c FROM Movie__c WHERE IsReleased__c = false AND ReleaseDate__c < TODAY');
    }

    public void execute(Database.BatchableContext context, List<SObject> records) {
        
        List<Movie__c> moviesToUpdate = new List<Movie__c>();
        for (sObject record : records) {
          Movie__c movie = (Movie__c) record;
          movie.IsReleased__c = true;
          moviesToUpdate.add(movie);
        }
    
        update moviesToUpdate;
    }

    public void finish(Database.BatchableContext context) {
        // Perform cleanup tasks
    }
}