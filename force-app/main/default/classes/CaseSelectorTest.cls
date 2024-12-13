/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
private class CaseSelectorTest {
    @TestSetup
    static void setupTestData() {
        // Création du compte de test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Création de plusieurs cases avec différentes priorités
        List<Case> testCases = new List<Case>{
            new Case(
                Subject = 'High Priority Issue',
                AccountId = testAccount.Id,
                Status = 'New',
                Priority = 'High'
            ),
            new Case(
                Subject = 'Medium Priority Issue',
                AccountId = testAccount.Id,
                Status = 'New',
                Priority = 'Medium'
            ),
            new Case(
                Subject = 'Low Priority Issue',
                AccountId = testAccount.Id,
                Status = 'New',
                Priority = 'Low'
            )
        };
        insert testCases;
    }
    
    @IsTest
    static void testGetCasesBySubjectAndAccount_Success() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = CaseSelector.getCasesBySubjectAndAccount('%Priority%', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(3, results.size(), 'Should return all cases with "Priority" in subject');
        Assert.isTrue(results[0].Priority == 'High', 'First case should be High priority');
    }
    
    @IsTest
    static void testGetCasesBySubjectAndAccount_NoResults() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = CaseSelector.getCasesBySubjectAndAccount('%NonExistent%', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(0, results.size(), 'Should return empty list for non-matching search term');
    }
    
    @IsTest
    static void testGetCasesBySubjectAndAccount_InvalidAccount() {
        Id invalidAccountId = '001000000000000'; // ID factice
        
        Test.startTest();
        List<Case> results = CaseSelector.getCasesBySubjectAndAccount('%Priority%', invalidAccountId);
        Test.stopTest();
        
        Assert.areEqual(0, results.size(), 'Should return empty list for invalid account');
    }
    
    @IsTest
    static void testGetCasesBySubjectAndAccount_OrderingByPriority() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = CaseSelector.getCasesBySubjectAndAccount('%Priority%', acc.Id);
        Test.stopTest();
        
        Assert.areEqual('High', results[0].Priority, 'First case should be High priority');
        Assert.areEqual('Medium', results[1].Priority, 'Second case should be Medium priority');
        Assert.areEqual('Low', results[2].Priority, 'Third case should be Low priority');
    }
}