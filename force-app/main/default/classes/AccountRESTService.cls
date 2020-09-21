@RestResource(UrlMapping='/Accounts/*')
global with sharing class AccountRESTService {
    @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Account result = [SELECT Id,Name,Description FROM Account WHERE Id = :accountId];
        return result;
    }
    @HttpPost
    global static Id createAccount(
    ) {
        RestRequest request = RestContext.request;
        Account newAccount = (Account) JSON.deserialize(request.requestBody.toString(), Account.class);
        insert newAccount;
        return newAccount.Id;
    }
    @HttpDelete
    global static Boolean deleteAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accountId];
        try {
            delete thisAccount;
            return true;
        } catch (DmlException e) {
            return false;
        }

    }
    @HttpPut
    global static Id upsertAccount() {
        RestRequest request = RestContext.request;
        Account newAccount = (Account) JSON.deserialize(request.requestBody.toString(), Account.class);
        upsert newAccount;
        return newAccount.Id;

    }
    @HttpPatch
    global static Id updateAccountFields() {
        RestRequest request = RestContext.request;
        Account newAccount = (Account) JSON.deserialize(request.requestBody.toString(), Account.class);
        update newAccount;
        return newAccount.Id;
    }

}