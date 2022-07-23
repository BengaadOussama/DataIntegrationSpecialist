/**
 * @description       : 
 * @author            : Oussama Bengaad  (obengaad@salesforce.com)
 * @group             : 
 * @last modified on  : 07-23-2022
 * @last modified by  : Oussama Bengaad  (obengaad@salesforce.com)
**/

@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   //Implement http mock callout here
   public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatus('Bad Response');
      res.setStatusCode(500);
      return res;
  }
}