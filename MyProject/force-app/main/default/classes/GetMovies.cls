public with sharing class GetMovies {

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

}