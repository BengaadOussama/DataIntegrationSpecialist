/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
private class ProjectCalloutServiceTest {

  @testSetup static void testSetupdata(){
    //create the opportunity record
    Opportunity opp1 = new Opportunity();
    opp1.Name = 'Test Opp1';
    opp1.Type = 'New Project';
    opp1.Amount = 100;
    opp1.CloseDate = Date.today();
    opp1.StageName='New';
    insert opp1;
    //create the Custom Settings
    ServiceTokens__c servToken = new ServiceTokens__c();
    servToken.Name = 'ProjectServiceToken';
    servToken.Token__c = 'qwertyuiopnjhgft';
    insert servToken;
  }
  
  @isTest 
  static void testPositiveCallout(){
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
    Opportunity opp = [SELECT Name,Account.Name,StageName,Amount,type,CloseDate FROM opportunity WHERE name='Test Opp1'];
    
    Test.startTest();
    opp.StageName='Closed Won';
    UPDATE opp;
    Test.stopTest();
    
    // Verify response received contains fake values
    opp = [SELECT StageName FROM opportunity WHERE Id= :opp.Id];
    System.assertEquals('Submitted Project', opp.StageName);
  } 

  @isTest 
  static void testNegativeCallout(){
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
    Opportunity opp = [SELECT Name,Account.Name,StageName,Amount,type,CloseDate FROM opportunity WHERE name='Test Opp1'];
    
    Test.startTest();
    opp.StageName='Closed Won';
    UPDATE opp;
    Test.stopTest();
    
    // Verify response received contains fake values
    opp = [SELECT StageName FROM opportunity WHERE Id= :opp.Id];
    System.assertEquals('Resubmit Project', opp.StageName);
  } 
}