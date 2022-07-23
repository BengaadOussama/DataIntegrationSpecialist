/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
@RestResource(urlMapping='/project')
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(
    String	ProjectRef, 
    String	ProjectName, 
    String	OpportunityId, 
    Date	StartDate, 
    Date	EndDate, 
    Decimal	Amount, 
    String	Status) {
        Project__c project = new Project__c();
        project.ProjectRef__c = ProjectRef;
        project.Name = ProjectName;
        project.Opportunity__c = OpportunityId;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = Status;
        Opportunity opp = new Opportunity(Id=OpportunityId, DeliveryInstallationStatus__c='In progress');

        Savepoint sp = Database.setSavepoint();
        try{
            if(opp!=null){
                upsert project ProjectRef__c;
                update opp;
                return 'OK';
            }
            Database.rollback(sp);
        }
        catch(exception ex){
            Database.rollback(sp);
            return ex.getMessage();
        }

        return 'Error';


        
    }
}