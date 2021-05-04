@isTest
public with sharing class StubUtilities {
    private static Integer counter {
        get {
            if (counter == null) {
                counter = 0;
            }
            counter++;

            return counter;
        }
        set;
    }
    public static List<Id> generateSObjectIds(
        String sObjectTypeString,
        Integer size
    ) {
        SObjectType sObjectType = ((SObject) Type.forName(sObjectTypeString)
                .newInstance())
            .getSObjectType();

        String keyPrefix = sObjectType.getDescribe().getKeyPrefix();
        List<Id> ids = new List<Id>();

        for (Integer i = 0; i < size; i++) {
            Integer uniqueCounter = counter;
            ids.add(
                keyPrefix +
                '0'.repeat(12 - String.valueOf(uniqueCounter).length()) +
                uniqueCounter
            );
        }

        return ids;
    }
}
