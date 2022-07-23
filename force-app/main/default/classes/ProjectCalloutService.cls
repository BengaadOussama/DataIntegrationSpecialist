/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/

public class ProjectCalloutService {

    @InvocableMethod(label='Post to PMS' category='Opportunity')
	public static void postOpportunityToPMS(List<ID> ids){
        Opportunity opp = [SELECT Id,Name,Account.Name,CloseDate,Amount FROM Opportunity WHERE Id in :ids];

        QueueablePMSCall qPMS = new QueueablePMSCall(opp);
        System.enqueueJob(qPMS);
    }

    public class QueueablePMSCall implements queueable, Database.AllowsCallouts{
        Opportunity opp;
        
        QueueablePMSCall(Opportunity opp){
            this.opp = opp;
        }

        public void execute(QueueableContext context) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            ServiceTokens__c st = ServiceTokens__c.getValues('ProjectServiceToken');
            req.setHeader('token', st.token__c);
            req.setHeader('Content-Type', 'application/json');
            req.setBody(WrapperClass.serialize(opp));
            Http http = new Http();
            HTTPResponse res = http.send(req);
            if(res.getStatusCode() == 201){
                Opportunity o = new Opportunity(Id = this.opp.Id, StageName = 'Submitted Project');
                UPDATE o;
            }else{
                Opportunity o = new Opportunity(Id = this.opp.Id, StageName = 'Resubmit Project');
                UPDATE o;
            }
        }

    }
    
    public class WrapperClass{
        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Decimal amount;
    }

    public static WrapperClass parse(String json) {
        return (WrapperClass) System.JSON.deserialize(json, WrapperClass.class);
    }

    public static String serialize(Opportunity opp) {
        WrapperClass wc = new WrapperClass();
        wc.opportunityId = opp.id;
        wc.opportunityName = opp.name;
        wc.accountName = opp.account.name;
        wc.closeDate = string.valueOfGmt(opp.closeDate);
        wc.amount = opp.amount;
        return System.JSON.serialize(wc);
    }
}