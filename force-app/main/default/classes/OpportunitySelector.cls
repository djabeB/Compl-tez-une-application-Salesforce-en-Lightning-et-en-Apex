public inherited sharing class OpportunitySelector {
    private static OpportunitySelector instance;
    
    public static OpportunitySelector getInstance() {
        if (instance == null) {
            instance = new OpportunitySelector();
        }
        return instance;
    }
    
    public List<Opportunity> getOpportunitiesByAccountId(Id accountId) {
        return [
            SELECT Id, Name, Amount, CloseDate, StageName 
            FROM Opportunity 
            WHERE AccountId = :accountId
            WITH SECURITY_ENFORCED
            ORDER BY CloseDate DESC
            LIMIT :AccountOpportunitiesController.QUERY_LIMIT
        ];
    }
}