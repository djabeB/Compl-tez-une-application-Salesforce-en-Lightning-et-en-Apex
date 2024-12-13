public inherited sharing class CaseSelector {
    
    public static List<Case> getCasesBySubjectAndAccount(String searchTerm, String accountId) {
        return [
            SELECT Subject, Status, Priority, CaseNumber
            FROM Case 
            WHERE Subject LIKE :searchTerm 
            AND AccountId = :accountId
            WITH SECURITY_ENFORCED
            ORDER BY Priority
            LIMIT 1000
        ];
    }
}