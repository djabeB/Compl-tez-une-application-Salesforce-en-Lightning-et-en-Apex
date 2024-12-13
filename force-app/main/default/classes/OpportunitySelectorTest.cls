@IsTest
private class OpportunitySelectorTest {
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            AccountId = testAccount.Id,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert opp;
    }
    
    @IsTest
    static void testGetOpportunitiesByAccountId() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<Opportunity> results = OpportunitySelector.getInstance().getOpportunitiesByAccountId(acc.Id);
        Test.stopTest();
        
        Assert.areEqual(1, results.size(), 'Should return 1 opportunity');
        Assert.areEqual('Test Opp', results[0].Name, 'Should return correct opportunity');
    }
}