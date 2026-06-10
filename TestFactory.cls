@SuppressWarnings('PMD.ApexDoc, PMD.ClassNamingConventions, PMD.CognitiveComplexity')
@isTest
public class TestFactory {
    private static Map<Schema.SObjectType, Schema.SObjectField> nameFieldMap = new Map<Schema.SObjectType, Schema.SObjectField>{
        Contact.sObjectType => Contact.LastName,
        Case.sObjectType => Case.CaseNumber
    };

    public static SObject createSObject(SObject sObj) {
        String objectName = String.valueOf(sObj.getSObjectType());
        String defaultClassName = objectName.replaceAll('__(c|C)$|__', '') + 'Defaults';
        if (Type.forName('TestFactoryDefaults.' + defaultClassName) != null) {
            sObj = createSObject(sObj, 'TestFactoryDefaults.' + defaultClassName);
        }
        return sObj;
    }

    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    public static SObject createSObject(SObject sObj, String defaultClassName) {
        Type t = Type.forName(defaultClassName);
        if (t == null) {
            throw new TestFactoryException('Invalid defaults class.');
        }
        FieldDefaults defaults = (FieldDefaults) t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retObject = createSObject(sObj, defaultClassName);
        if (doInsert) {
            insert retObject;
        }
        return retObject;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, (String) null);
    }

    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, (String) null);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, defaultClassName);
        if (doInsert) {
            insert retList;
        }
        return retList;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new List<SObject>{};
        SObject newObj;

        if (defaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }

        String nameField = String.valueOf(nameFieldMap.get(sObj.getSObjectType()));
        if (nameField == null) {
            nameField = 'Name';
        }
        Boolean nameIsAutoNumber = sObj.getSobjectType().getDescribe().fields.getMap().get(nameField).getDescribe().isAutoNumber();

        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);
            if (!nameIsAutoNumber) {
                clonedSObj.put(nameField, (String) clonedSObj.get(nameField) + ' ' + i);
            }
            sObjs.add(clonedSObj);
        }
        return sObjs;
    }

    private static void addFieldDefaults(SObject sObj, Map<Schema.SObjectField, Object> defaults) {
        Map<String, Object> populatedFields = sObj.getPopulatedFieldsAsMap();
        for (Schema.SObjectField field : defaults.keySet()) {
            if (!populatedFields.containsKey(String.valueOf(field))) {
                sObj.put(field, defaults.get(field));
            }
        }
    }

    public class TestFactoryException extends Exception {
    }

    public interface FieldDefaults {
        Map<Schema.SObjectField, Object> getFieldDefaults();
    }

    public static User createMinAccessUser(Boolean doInsert) {
        Id profileId = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Minimum Access - Salesforce'
        ]
        .Id;
        return TestFactory.createTestUser(profileId, doInsert);
    }

    public static User createTestUser(Id profileId, boolean doInsert) {
        User u = new User(
            profileId = profileId,
            LastName = 'last',
            Email = 'testuser@test.com',
            Username = 'testuser@test.example.com' + Crypto.getRandomInteger(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        if (doInsert) {
            insert u;
        }
        return u;
    }

    public static User createMarketingUser(Boolean doInsert) {
        Id profileId = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Marketing User'
        ]
        .Id;
        return TestFactory.createTestUser(profileId, doInsert);
    }

    public static Id getProfileId(String profileName) {
        Id profileId;
        Profile profile = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1];
        profileId = profile.Id;
        return profileId;
    }
}
