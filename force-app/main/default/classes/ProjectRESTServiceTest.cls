/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@isTest
private class ProjectRESTServiceTest {
  
  @TestSetup
  static void makeData(){
    Opportunity opp = new Opportunity(Name='Test',DeliveryInstallationStatus__c='Yet to begin',StageName='New',CloseDate=Date.newInstance(2022, 12, 9));
    INSERT opp;
  }

  @isTest
  static void testPostPositive() {
    Opportunity opp = [SELECT Id FROM opportunity];
    Project__c p = new Project__c( ProjectRef__c='1234567', Name ='707-555-1234',Opportunity__c =opp.Id, Billable_Amount__c = 12345);
    
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        RestContext.request.requestURI = '/services/apexrest/project';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueOf(serialize(p));
        
        Test.startTest();
        ProjectRESTService.postProjectData(p.ProjectRef__c, 
          p.Name, 
          p.Opportunity__c, 
          null, 
        	null, 
        	p.Billable_Amount__c, 
        	null);
        Test.stopTest();
        
        opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :Opp.Id];
        
        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
    }
    
  @isTest
  static void testPostNegative() {
    Project__c p = new Project__c( ProjectRef__c='1234567', Name ='707-555-1234', Billable_Amount__c = 12345);
    
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();

        RestContext.request.requestURI = '/services/apexrest/project';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueOf(serialize(p));
        
        Test.startTest();
        ProjectRESTService.postProjectData(p.ProjectRef__c, 
          p.Name, 
          null, 
          null, 
        	null, 
        	p.Billable_Amount__c, 
        	null);
        Test.stopTest();
        
        Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity];
        
        System.assertEquals('Yet to begin', opp.DeliveryInstallationStatus__c);
    }
    

  public class ProjectWrapper{
    String ProjectRef;
    String ProjectName;
    String OpportunityId;
    Decimal Amount;
  }

  public static String serialize(Project__c p) {
      ProjectWrapper wc = new ProjectWrapper();
      wc.ProjectRef = p.ProjectRef__c;
      wc.ProjectName = p.name;
      wc.OpportunityId = p.Opportunity__c;
      wc.amount = p.Billable_Amount__c;
      return System.JSON.serialize(wc);
  }
}
