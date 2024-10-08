
global class AnonymizeData implements Database.Batchable<SObject> {
    
    // Method to retrieve the key from the custom object
    private String getAnonymizationKey() {
        Crypt_key_storage__c keyStorage = [SELECT Key__c FROM Crypt_key_storage__c LIMIT 1];
        return keyStorage != null ? keyStorage.Key__c : null;
    }

    // Start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query to select records that need anonymization, for example, from a custom object
        return Database.getQueryLocator('SELECT Id,Email,MobilePhone ,FirstName ,LastName FROM contact WHERE LastName = '+'Gonzalez');
    }

    // Execute method
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        String key = getAnonymizationKey();
        if (key == null) {
            throw new CustomException('Anonymization key not found.');
        }

        // Process each record in the scope
        List<contact> recordsToAnonymize = new List<contact>();
        List<Base_donn_es_anonymis__c>  originalRecords = new List<Base_donn_es_anonymis__c>();


        for (SObject s : scope) {
            contact record = (contact) s;

           // Store origina data in hidden object
           Base_donn_es_anonymis__c originalRecord= new Base_donn_es_anonymis__c();
           originalRecords.Contact_id = record.Id; // Link to the original contact
           originalRecords.Pr_nom__c = record.FirstName;
           originalRecords.Nom__c = record.LastName;
           originalRecords.Email__c = record.Email;
           originalRecords.T_l_phone__c = record.MobilePhone;
        

            // Anonymize the sensitive data
            String Firstname_Anonymized = anonymizeData(record.FirstName, key);
            String Lastname_Anonymized = anonymizeData(record.LastName, key);
            String Email_Anonymized = anonymizeData(record.Email, key);
            String Mobilephone_Anonymized = anonymizeData(record.MobilePhone, key);

            record.FirstName = Firstname_Anonymized; // Set the anonymized data
            record.LastName = Lastname_Anonymized;
            record.MobilePhone = Mobilephone_Anonymized;
            record.Email = Email_Anonymized;
            recordsToAnonymize.add(record);
        }

        // Update records
        if (!recordsToAnonymize.isEmpty()) {
            update recordsToAnonymize;
        }
        if (!originalRecords.isEmpty()) {
            update originalRecords;
        }
    }

    // Method to anonymize data using a key
    private String anonymizeData(String sensitiveData, String key) {
        
        if (sensitiveData == null || key == null) return null; // Handle null cases
        StringBuilder anonymizedData = new StringBuilder();
        
        for (Integer i = 0; i < sensitiveData.length(); i++) {
            // Use mod method instead of %
            Integer keyIndex = i.mod(key.length()); // Use mod method for the index
            anonymizedData.append((char)(sensitiveData.charAt(i) ^ key.charAt(keyIndex)));
        }
        
        return anonymizedData.toString();
    }

    // Finish method
    global void finish(Database.BatchableContext BC) {
        // Optional: perform any final actions, like sending notifications
    }

    // Custom exception class
    public class CustomException extends Exception {}
}
