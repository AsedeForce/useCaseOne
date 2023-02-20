public with sharing class ActorService {
    
    @AuraEnabled(cacheable=true)
    public static List<Actor__c> getActors() {
        List<Actor__c> values = [SELECT Id, Name FROM Actor__c];
        return values;
    }
}