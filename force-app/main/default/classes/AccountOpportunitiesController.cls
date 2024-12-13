public with sharing class AccountOpportunitiesController {
    private static final String ERROR_MESSAGE = 'Erreur lors de la récupération des opportunités: {0}';
    
    public static final Integer QUERY_LIMIT = 1000; // Changé en public

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
        try {
            validateInput(accountId);
            return OpportunitySelector.getInstance().getOpportunitiesByAccountId(accountId);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 
                'Error in AccountOpportunitiesController.getOpportunities: ' + 
                e.getMessage() + '\n' + e.getStackTraceString());
            throw new AuraHandledException(String.format(ERROR_MESSAGE, 
                new List<String>{ e.getMessage() }));
        }
    }
    
    private static void validateInput(Id accountId) {
        if (accountId == null) {
            throw new AccountOpportunitiesException('L\'ID du compte est requis');
        }
    }
    
    public class AccountOpportunitiesException extends Exception {}
}