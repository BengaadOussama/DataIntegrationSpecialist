/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/
public class BillingCalloutService {
    
    @future(callout=true)
    public static void callBillingService(String ProjectRef, Decimal Amount, String oldStatus, String newStatus){
        if((oldStatus != newStatus) && newStatus == 'Billable'){
    
            BillingServiceProxy.project p = new BillingServiceProxy.project();
            p.projectid = ProjectRef;
            p.billAmount = Amount;
            p.username = ServiceCredentials__c.getValues('BillingServiceCredential').Username__c;
            p.password = ServiceCredentials__c.getValues('BillingServiceCredential').Password__c;

            BillingServiceProxy.InvoicesPortSoap11 soapCallout = new BillingServiceProxy.InvoicesPortSoap11();
            String result = soapCallout.billProject(p);

        }
    }
}