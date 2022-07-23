/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
private class BillingCalloutServiceTest {
  
  @TestSetup
  static void makeData(){
    //create opportunity
    Opportunity opp1 = new Opportunity();
    opp1.Name = 'Test Opp1';
    opp1.Type = 'New Project';
    opp1.Amount = 100;
    opp1.CloseDate = Date.today();
    opp1.StageName='New';
    insert opp1;
    //create the Custom Settings
    ServiceCredentials__c servCred= new ServiceCredentials__c();
    servCred.Name='BillingServiceCredential';
    servCred.Password__c = 'serviceUser';
    servCred.Username__c = 'qwertyuiopnjhgft';
    insert servCred;
    //create project
    Project__c pr = new Project__c();
    pr.Status__c = 'Running';
    pr.ProjectRef__c = '12345678';
    pr.Opportunity__c = opp1.Id;
    pr.Billable_Amount__c = 1234;
    insert pr;
  }
  
  
/*   @isTest 
  static void testPositive() {              
    // This causes a fake response to be generated
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    // Call the method that invokes a callout

    test.startTest();    
    Project__c pr = [SELECT id FROM project__c];
    pr.status__c = 'Billable';
    UPDATE pr;
    test.stopTEST();
    
    pr = [SELECT status__c FROM project__c];
    // Verify that a fake result is returned
    System.assertEquals('Billed', pr.status__c); 
  } */

  
  @isTest 
  static void testNegative() {              
    // This causes a fake response to be generated
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    // Call the method that invokes a callout

    test.startTest();    
    Project__c pr = [SELECT id FROM project__c];
    pr.status__c = 'Billable';
    UPDATE pr;
    test.stopTEST();
    
    pr = [SELECT status__c FROM project__c];
    // Verify that a fake result is returned
    System.assertNotEquals('Billed', pr.status__c); 
  }
}
