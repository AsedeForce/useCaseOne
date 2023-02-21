@isTest
public with sharing class ActorControllerTest {

    @isTest
    public static void testgetActors(){
        List<Actor__c> actors = (List<Actor__c>) TestDataFactory.createSObjectList(
            'Actor__c',
            10
          );
        List<Actor__c> actorsFromController = ActorController.getActors();
        System.assertEquals(10, actorsFromController.size(), 'should be 10');

    }
    

}