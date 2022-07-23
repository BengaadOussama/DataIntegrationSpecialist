/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
trigger ProjectTrigger on Project__c (after update) {
    BillingCalloutService.callBillingService(Trigger.NEW.get(0).ProjectRef__c,Trigger.NEW.get(0).Billable_Amount__c,Trigger.OLD.get(0).Status__c,Trigger.NEW.get(0).Status__c);
}