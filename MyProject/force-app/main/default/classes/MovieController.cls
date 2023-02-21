public with sharing class MovieController {

    @AuraEnabled(cacheable=true)
    public static List<Movie__c> getMoviesWithSearch(String search) {
        return MovieService.getMoviesWithSearch(search);

    }

    @AuraEnabled
    public static void insertMovie(Object obj) {
        MovieService.insertMovie(obj);
    }

    @AuraEnabled
    public static void deleteMovie(String id) {
        MovieService.deleteMovie(id);
    }

}