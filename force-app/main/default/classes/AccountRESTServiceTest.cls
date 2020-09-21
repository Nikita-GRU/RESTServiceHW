/**
 * Created by JJ93 on 21.09.2020.
 */
@IsTest
private class AccountRESTServiceTest {
    private static final String REST_SERVICE_ENDPOINT =
            'https://wise-bear-t0v9lv-dev-ed.my.salesforce.com/services/apexrest/Accounts/';

    @IsTest
    static void getAccountByIdTest() {
        Id testAccountId = createTestAccountOnServer();
        RestRequest testRequest = new RestRequest();
        testRequest.requestURI = REST_SERVICE_ENDPOINT + testAccountId;
        testRequest.httpMethod = 'GET';
        RestContext.request = testRequest;

        Account thisAccount = AccountRESTService.getAccountById();
        System.assert(thisAccount != null);
        System.assertEquals('Account generated from test class of Account REST service', thisAccount.Description);

    }
    private static Id createTestAccountOnServer() {
        Account testAccount = new Account(Name = 'AccForTest',
                Description = 'Account generated from test class of Account REST service');
        insert testAccount;
        return testAccount.Id;
    }
    @IsTest
    static void createAccountTest() {
        RestRequest testRequest = new RestRequest();
        testRequest.requestURI = REST_SERVICE_ENDPOINT;
        testRequest.httpMethod = 'POST';
        testRequest.addHeader('Content-Type', 'application/json');
        testRequest.requestBody = Blob.valueOf(JSON.serialize(new Account(Name = 'AccTestServicePOST',
                Description = 'Account generated from test class')));
        RestContext.request = testRequest;

        Id thisAccountId = AccountRESTService.createAccount();
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Name, Description FROM Account WHERE Id = :thisAccountId];
        System.assertEquals('AccTestServicePOST', thisAccount.Name);
        System.assertEquals('Account generated from test class', thisAccount.Description);


    }
    @IsTest
    static void deleteAccountTest() {
        Id testAccountId = createTestAccountOnServer();
        RestRequest testRequest = new RestRequest();
        testRequest.requestURI = REST_SERVICE_ENDPOINT + testAccountId;
        testRequest.httpMethod = 'DELETE';
        RestContext.request = testRequest;

        Boolean isDeleted = AccountRESTService.deleteAccount();
        System.assert(isDeleted == true);
        List <Account> accounts = [SELECT Id FROM Account WHERE Id = :testAccountId];
        System.assert(accounts.size() == 0);

    }

    @IsTest
    static void updateAccountTest() {
        Id testAccountId = createTestAccountOnServer();
        RestRequest testRequest = new RestRequest();
        testRequest.requestURI = REST_SERVICE_ENDPOINT;
        testRequest.httpMethod = 'UPDATE';
        testRequest.requestBody = Blob.valueOf(JSON.serialize(new Account(Id = testAccountId, Name = 'UpdatedAccREST',
                Description = 'Updated account from rest service test class')));
        RestContext.request = testRequest;

        Id thisAccountId = AccountRESTService.updateAccountFields();
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Name, Description FROM Account WHERE Id = :thisAccountId];
        System.assertEquals('UpdatedAccREST', thisAccount.Name);
        System.assertEquals('Updated account from rest service test class', thisAccount.Description);

    }

    @IsTest
    static void upsertAccountTest() {
        RestRequest testRequest = new RestRequest();
        testRequest.requestURI = REST_SERVICE_ENDPOINT;
        testRequest.httpMethod = 'UPSERT';
        testRequest.requestBody = Blob.valueOf(JSON.serialize(new Account(Name = 'UpsertedNEWAccREST',
                Description = 'Upserted new account from rest service test class')));
        RestContext.request = testRequest;

        Id thisAccountId = AccountRESTService.upsertAccount();
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Id, Name, Description FROM Account WHERE Id = :thisAccountId];
        System.assertEquals('UpsertedNEWAccREST', thisAccount.Name);
        System.assertEquals('Upserted new account from rest service test class', thisAccount.Description);

        testRequest.requestBody = Blob.valueOf(JSON.serialize(new Account(Id = thisAccountId, Name = 'UpsertedEXISTEDAccREST',
                Description = 'Upserted existed account from rest service test')));
        RestContext.request = testRequest;

        Id thisAccountId2 = AccountRESTService.upsertAccount();
        System.assertEquals(thisAccountId, thisAccountId2);
        thisAccount = [SELECT Name, Description FROM Account WHERE Id = :thisAccountId2];
        System.assertEquals('UpsertedEXISTEDAccREST', thisAccount.Name);
        System.assertEquals('Upserted existed account from rest service test', thisAccount.Description);


    }
}