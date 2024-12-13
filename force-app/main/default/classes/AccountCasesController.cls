public inherited sharing class AccountCasesController {
    
    @TestVisible private static final String SEARCH_WILDCARD = '%';
    
    @AuraEnabled(cacheable=true)
    public static List<Case> findCasesBySubject(String searchTerm, String accountId) {
        // Validation des paramètres
        if (String.isBlank(accountId)) {
            throw new AuraHandledException('AccountId cannot be null');
        }
        try {
            // Logging
            System.debug(LoggingLevel.DEBUG, 'findCasesBySubject executing with accountId: ' + accountId);
            
            // Échappement et préparation du terme de recherche
            String searchTermEscaped = String.isBlank(searchTerm) ? 
                SEARCH_WILDCARD : 
                SEARCH_WILDCARD + String.escapeSingleQuotes(searchTerm) + SEARCH_WILDCARD;
            
            // Requête SOQL avec pattern Repository
            return CaseSelector.getCasesBySubjectAndAccount(searchTermEscaped, accountId);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Error in findCasesBySubject: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving cases: ' + e.getMessage());
        }
    }
}