public with sharing class MovieController {

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getMoviesWithSearch(String search) {
        String searchKey = '%' + search + '%';
        List<Movie__c> values = [ 
            SELECT Id, Category__c, Name, Rating__c, Description__c, Release_date__c 
            FROM Movie__c 
            WHERE Name Like :searchKey 
            OR Rating__c LIKE :searchKey
            OR Category__c LIKE :searchKey
            WITH SECURITY_ENFORCED];
        return values;
    }

    @AuraEnabled
    public static Movie__c insertMovie(Object obj) {
        Map<String,Object> movieActorRecord = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
        String movieName = (String) movieActorRecord.get('Name');
        List<Object> actorList = (List<Object>) movieActorRecord.get('Actors');
        List<string> actorStringList = new List<string> ();
        for(Object actor: actorList){
            actorStringList.add(String.valueOf(actor));
        }
        try {
            Movie__c movie = new Movie__c(Name = (String) movieActorRecord.get('Name'), 
                            Category__c = (String)movieActorRecord.get('Category__c'), 
                            Rating__c = (String) movieActorRecord.get('Rating__c'), 
                            Description__c = (String) movieActorRecord.get('Description__c'));
            insert movie;
            List<Actor__c> actors = [SELECT Id FROM Actor__c WHERE Name IN :actorStringList WITH SECURITY_ENFORCED];
            List<MovieActor__c> movieActors = new List<MovieActor__c>();

            for (Actor__c actor : actors) {
                MovieActor__c movieActorJunction = new MovieActor__c(
                    Movie__c = movie.Id,
                    Actor__c = actor.Id
                );
                movieActors.add(movieActorJunction);
            }
            insert movieActors;
        } catch (DmlException e) {
            throw new AuraHandledException(e.getMessage());
            // Handle any DML exceptions here
        }
    }


}