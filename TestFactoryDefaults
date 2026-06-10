@IsTest
public class TestFactoryDefaults {
    public class AccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Account.Name => 'Test Account' };
        }
    }

    public class MyAccountDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Account.Name => 'My Test Account' };
        }
    }

    public class ContactDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Contact.FirstName => 'First', Contact.LastName => 'Last' };
        }
    }

    public class OpportunityDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{
                Opportunity.Name => 'Test Opportunity',
                Opportunity.StageName => 'Closed Won',
                Opportunity.CloseDate => System.today()
            };
        }
    }

    public class CaseDefaults implements TestFactory.FieldDefaults {
        public Map<Schema.SObjectField, Object> getFieldDefaults() {
            return new Map<Schema.SObjectField, Object>{ Case.Subject => 'Test Case' };
        }
    }
}
