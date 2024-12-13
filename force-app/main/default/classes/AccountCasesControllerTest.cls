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
private class AccountCasesControllerTest {
    @TestSetup
    static void setupTestData() {
        // Création du compte test
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Création de plusieurs cases avec différents sujets
        List<Case> testCases = new List<Case>{
            new Case(
                Subject = 'Problème Technique',
                AccountId = testAccount.Id,
                Status = 'New',
                Origin = 'Web'
            ),
            new Case(
                Subject = 'Question Support',
                AccountId = testAccount.Id,
                Status = 'New',
                Origin = 'Web'
            ),
            new Case(
                Subject = 'Autre Problème',
                AccountId = testAccount.Id,
                Status = 'New',
                Origin = 'Web'
            )
        };
        insert testCases;
    }
    
    @IsTest
    static void testFindCasesBySubject_WithSearchTerm() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = AccountCasesController.findCasesBySubject('Problème', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(2, results.size(), 'Should return 2 cases containing "Problème"');
        for(Case c : results) {
            Assert.isTrue(c.Subject.contains('Problème'), 'Case subject should contain search term');
        }
    }
    
    @IsTest
    static void testFindCasesBySubject_EmptySearchTerm() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = AccountCasesController.findCasesBySubject('', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(3, results.size(), 'Should return all cases when search term is empty');
    }
    
    @IsTest
    static void testFindCasesBySubject_NullAccountId() {
        Test.startTest();
        try {
            AccountCasesController.findCasesBySubject('Test', null);
            Assert.fail('Should throw an exception for null accountId');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('AccountId cannot be null'), 
                'Should throw correct error message');
        }
        Test.stopTest();
    }
    
    @IsTest
    static void testFindCasesBySubject_NoResults() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = AccountCasesController.findCasesBySubject('XYZ123NonExistent', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(0, results.size(), 'Should return empty list when no matches found');
    }
    
    @IsTest
    static void testFindCasesBySubject_SpecialCharacters() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Case> results = AccountCasesController.findCasesBySubject('\'SELECT\'', acc.Id);
        Test.stopTest();
        
        Assert.areEqual(0, results.size(), 'Should safely handle special characters');
    }
}