public with sharing class MovieService {
  @AuraEnabled
  public static void insertMovie(Object obj) {
    Map<String, Object> movieActorRecord = (Map<String, Object>) JSON.deserializeUntyped(
      JSON.serialize(obj)
    );
    String movieName = (String) movieActorRecord.get('Name');
    List<Object> actorList = (List<Object>) movieActorRecord.get('Actors');
    List<string> actorStringList = new List<string>();
    for (Object actor : actorList) {
      actorStringList.add(String.valueOf(actor));
    }

    try {
      Movie__c movie = new Movie__c(
        Name = (String) movieActorRecord.get('Name'),
        Category__c = (String) movieActorRecord.get('Category__c'),
        Rating__c = (String) movieActorRecord.get('Rating__c'),
        Description__c = (String) movieActorRecord.get('Description__c'),
        Release_date__c = Date.valueOf(
          (String) movieActorRecord.get('Release_date__c')
        )
      );
      insert movie;

      List<Actor__c> actors = [
        SELECT Id
        FROM Actor__c
        WHERE Name IN :actorStringList
        WITH SECURITY_ENFORCED
      ];
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
    }
  }

  @AuraEnabled
  public static void deleteMovie(String id) {
    try {
      Movie__c movie = [
        SELECT Id
        FROM Movie__c
        WHERE Id = :id
        WITH SECURITY_ENFORCED
      ];
      List<MovieActor__c> movieActors = [
        SELECT Id, Movie__c
        FROM MovieActor__c
        WHERE Movie__c = :id
      ];

      if (movieActors.size() > 0) {
        delete movieActors;
        
      }
      if (movie != null) {
        delete movie;
      }

    } catch (DmlException e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
  public static List<Movie__c> getMoviesWithSearch(String search) {
    String searchKey = '%' + search + '%';
    List<Movie__c> values = [
      SELECT Id, Category__c, Name, Rating__c, Description__c, Release_date__c
      FROM Movie__c
      WHERE
        Name LIKE :searchKey
        OR Rating__c LIKE :searchKey
        OR Category__c LIKE :searchKey
      WITH SECURITY_ENFORCED
    ];
    return values;
  }
}
