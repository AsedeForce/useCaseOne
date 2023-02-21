@isTest
public class MovieControllerTest {

    @isTest
    static void testGetMovies() {
        List<Movie__c> movies = (List<Movie__c>) TestDataFactory.createSObjectList(
            'Movie__c',
            10
          );
        List<Movie__c> moviesFromController = MovieController.getMoviesWithSearch('');
        System.assertEquals(10, moviesFromController.size(), 'Getting movies from database');

    }

    @isTest
    static void testGetMovieSearch() {
        Movie__c movie = (Movie__c) TestDataFactory.createSObject('Movie__c', new Map<String,Object>{
            'Name' => 'Interstellar'
          });
        List<Movie__c> moviesFromController = MovieController.getMoviesWithSearch('Interstellar');
        System.assertEquals('Interstellar', moviesFromController[0].Name, 'getting movies from database with search');
        
    }

    @isTest
    static void testInsertMovieWithMovieActors() {

        String jaysone = '{"Name" : "InterStellar", "Category__c" : "Horror",' +
        '"Rating__c": "4", "Release_date__c" : "2023-12-12", "Description" : "una description",'+ 
        ' "Actors" : [{ "Name" : "Jhon Voight" }, { "Name" : "Mark Walberg" }]}';

        Actor__c actor1 = (Actor__c) TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'Jhon Voight',
            'Gender__c' => 'Male'
          });
        Actor__c actor2 = (Actor__c) TestDataFactory.createSObject('Actor__c', new Map<String,Object>{
            'Name' => 'Mark Walberg',
            'Gender__c' => 'Male'
          });

        Map<String, Object> parsedJaysone = (Map<String, Object>) JSON.deserializeUntyped(jaysone);
        
        Object obj = parsedJaysone.values()[0];
        MovieController.insertMovie(parsedJaysone);

        List<Movie__c> movieList = [ SELECT Name FROM Movie__c WHERE Name = 'InterStellar'];
        System.assertEquals(1, movieList.size(),'movie was inserted');
    }

    @isTest
    static void testGetMovieSearchShouldFindNone() {
        List<Movie__c> movies = (List<Movie__c>) TestDataFactory.createSObjectList('Movie__c', new Map<String,Object>{
            'Name' => 'Interstellar'
          }, 1);
          
        MovieController.deleteMovie((String) movies[0].Id);
        List<Movie__c> moviesFromController = MovieController.getMoviesWithSearch('Interstellar');
        System.assertEquals(0, moviesFromController.size(), 'should find 0 results');
        
    }






}