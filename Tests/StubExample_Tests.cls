@isTest
private class StubExample_Tests {
    static StubExample exampleStub = new StubExample();

    @isTest
    static void testPropertiesWithDefaults() {
        Test.startTest();
        System.assertEquals(
            false,
            exampleStub.isTrue,
            'expected default isTrue to be false.'
        );
        System.assertEquals(
            'hello',
            exampleStub.greeting,
            'expected greeting to be hello'
        );
        Test.stopTest();
    }

    @isTest
    static void testGetters() {
        Test.startTest();
        System.assertEquals(
            false,
            exampleStub.getIsTrue(),
            'expected getter to return false'
        );
        System.assertEquals(
            'hello',
            exampleStub.getGreeting(),
            'expected getter to return hello'
        );
        Test.stopTest();
    }

    @isTest
    static void testSetGeeting() {
        Test.startTest();
        exampleStub.setGreeting('foo');
        Test.stopTest();
        System.assertEquals(
            'foo',
            exampleStub.greeting,
            'expected to see foo as new greeting'
        );
    }

    @isTest
    static void testAdd() {
        Test.startTest();
        Integer sum = exampleStub.add(1, 2);
        Test.stopTest();

        System.assertEquals(3, sum, 'expected 1+2 to equal 3');
    }

    @isTest
    static void testConcatThreeStrings() {
        Test.startTest();
        String checkString = exampleStub.concatThreeStrings(
            'foo',
            'bar',
            'baz'
        );
        Test.stopTest();

        System.assertEquals(
            'foobarbaz',
            checkString,
            'expected to get foobarbaz'
        );
    }

    @isTest
    static void testAddFourNumbers() {
        Test.startTest();
        Integer sum = exampleStub.addFourNumbers(1, 2, 3, 4);
        Test.stopTest();
        System.assertEquals(
            10,
            sum,
            'expected to get 10, when summing 1,2,3,4'
        );
    }

    @isTest
    static void testGetAccounts() {
        List<Account> accounts = new List<Account>{ new Account(name = 'foo') };
        Test.startTest();
        List<Account> checkList = exampleStub.getAccounts(accounts);
        Test.stopTest();

        System.assertEquals(
            checkList,
            accounts,
            'expected the input list to equal the output list'
        );
    }
}
