public with sharing class MovieActorTriggerHelper {
  public static void updateMovieNumbersAndGenderPercentages(
    Map<Id, MovieActor__c> movieActorMap
  ) {
    Map<Id, Actor__c> actorsMap = new Map<Id, Actor__c>();
    Map<Id, Movie__c> moviesMap = new Map<Id, Movie__c>();
    Map<Id, Decimal> numMaleMovieActors = new Map<Id, Decimal>();
    Map<Id, Decimal> numFemaleMovieActors = new Map<Id, Decimal>();

    for (MovieActor__c movieActor : movieActorMap.values()) {
      actorsMap.put(
        movieActor.Actor__c,
        new Actor__c(Id = movieActor.Actor__c, Number_of_movies__c = 0)
      );
      if (!moviesMap.keySet().contains(movieActor.Movie__c))
        moviesMap.put(
          movieActor.Movie__c,
          new Movie__c(Id = movieActor.Movie__c, MaleActorsPercentage__c = 0, FemaleActorsPercentage__c = 0 )
        );
    }

    for (AggregateResult result : [
      SELECT COUNT(Id) counter, Actor__c
      FROM MovieActor__c
      WHERE Actor__c IN :actorsMap.keySet()
      GROUP BY Actor__c
    ]) {
      Id actorId = (Id) result.get('Actor__c');
      Integer movieCount = (Integer) result.get('counter');
      Actor__c actor = actorsMap.get(actorId);
      actor.Number_of_movies__c = movieCount;
      actorsMap.put(actorId, actor);
    }

    for (AggregateResult result : [
      SELECT COUNT(Id) counter, Movie__c
      FROM MovieActor__c
      WHERE Movie__c IN :moviesMap.keySet() AND Actor__r.Gender__c = 'Male'
      GROUP BY Movie__c
    ]) {
      numMaleMovieActors.put(
        (Id) result.get('Movie__c'),
        (Decimal) result.get('counter')
      );
    }

    for (AggregateResult result : [
      SELECT COUNT(Id) counter, Movie__c
      FROM MovieActor__c
      WHERE Movie__c IN :moviesMap.keySet() AND Actor__r.Gender__c = 'Female'
      GROUP BY Movie__c
    ]) {
      numFemaleMovieActors.put(
        (Id) result.get('Movie__c'),
        (Decimal) result.get('counter')
      );
    }

    for (Movie__c movie : moviesMap.values()) {
      Decimal numberFemaleActor = 0;
      if ( numFemaleMovieActors.get(movie.Id) != null ) {
        numberFemaleActor = numFemaleMovieActors.get(movie.Id);
      }
      Decimal numberMaleActor = 0;
      if ( numMaleMovieActors.get(movie.Id) != null ) {
        numberMaleActor = numMaleMovieActors.get(movie.Id);
      }
      Decimal numberOfActors = numberMaleActor + numberFemaleActor;
      movie.MaleActorsPercentage__c = (numberMaleActor / numberOfActors) * 100;
      movie.FemaleActorsPercentage__c = (numberFemaleActor / numberOfActors) * 100;
    }
    update moviesMap.values();
    update actorsMap.values();
  }
}
