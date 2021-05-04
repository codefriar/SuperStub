@isTest
private class StubExample_Tests {
    @isTest
    static void testStubBuilderWithTwoMethodsMocked() {
        Stub exStub = new Stub.Builder(StubExample.class)
            .mockingMethodCall('getIsTrue')
            .withParameterTypes()
            .returning(true)
            .mockingMethodCall('getGreeting')
            .withParameterTypes()
            .returning('foo bar baz')
            .defineStub();

        // exStub is now a Stub object, but we need to call the test.createStub
        // method in order to have an injectable object

        Test.startTest();
        StubExampleConsumer consumer = new StubExampleConsumer(
            (StubExample) exStub.createStub()
        );
        Boolean isTrue = consumer.getIsTrue();
        String greeting = consumer.getGreeting();
        Test.stopTest();

        System.assert(
            isTrue,
            'Expected the stub object to return true even though the class default is false.'
        );
        System.assertEquals(
            'foo bar baz',
            greeting,
            'Expected Stub object to reutrn foo bar baz, even though class default is hello'
        );
    }

    @isTest
    static void testAutomaticBuildOfInjectableObject() {
        StubExample exampleStub = (StubExample) new Stub.Builder(
                StubExample.class
            )
            .mockingMethodCall('getIsTrue')
            .withParameterTypes()
            .returning(true)
            .mockingMethodCall('getGreeting')
            .withParameterTypes()
            .returning('foo bar baz')
            .defineStub(true);

        Test.startTest();
        StubExampleConsumer consumer = new StubExampleConsumer(exampleStub);
        Boolean isTrue = consumer.getIsTrue();
        String greeting = consumer.getGreeting();
        Test.stopTest();

        System.assert(
            isTrue,
            'Expected the stub object to return true even though the class default is false.'
        );
        System.assertEquals(
            'foo bar baz',
            greeting,
            'Expected Stub object to reutrn foo bar baz, even though class default is hello'
        );
    }

    @isTest
    static void testStubReturnsExceptions() {
        CustomException customException = new CustomException('Custom Message');

        StubExample exampleStub = (StubExample) new Stub.Builder(
                StubExample.class
            )
            .mockingMethodCall('getIsTrue')
            .withParameterTypes()
            .throwingException(customException)
            .mockingMethodCall('getGreeting')
            .withParameterTypes()
            .throwingException()
            .defineStub(true);

        Boolean didCatchCustomException = false;
        Boolean didCatchStubException = false;
        Test.startTest();
        StubExampleConsumer consumer = new StubExampleConsumer(exampleStub);
        try {
            Boolean isTrue = consumer.getIsTrue();
        } catch (CustomException ce) {
            if (ce.getMessage().containsIgnoreCase('Custom Message')) {
                didCatchCustomException = true;
            }
        }
        try {
            String greeting = consumer.getGreeting();
        } catch (Stub.StubException sE) {
            if (sE.getMessage() == MockedMethod.exceptionMessage) {
                didCatchStubException = true;
            }
        }

        Test.stopTest();

        System.assert(
            didCatchCustomException,
            'Expected to have caught the custom exception we created'
        );
        System.assert(
            didCatchStubException,
            'Expected to have caught a Stub.StubException with the default message'
        );
    }

    @isTest
    static void testDispatchToSameMethodReturningDifferentValuesByInput() {
        Stub exampleStub = new Stub.Builder(StubExample.class)
            .mockingMethodCall('add') // returns methodSig.builder
            .withParameterTypes(Integer.class, Integer.class)
            .withParameterValues(2, 2)
            .returning(5)
            .mockingMethodCall('add')
            .withParameterTypes(Integer.class, Integer.class)
            .withParameterValues(3, 3)
            .returning(7)
            .defineStub();

        Test.startTest();
        StubExampleConsumer consumer = new StubExampleConsumer(
            (StubExample) exampleStub.createStub()
        );
        Integer checkSum = consumer.add(2, 2);
        System.assertEquals(
            5,
            checkSum,
            'Expected to find the method returned 5 instead of 4'
        );
        checkSum = consumer.add(3, 3);
        System.assertEquals(
            7,
            checkSum,
            'Expected to find the method returned 7 instead 6'
        );
        exampleStub.assertAllMockedMethodsWereCalled();
        Test.stopTest();
    }

    @isTest
    static void testThrowsExceptionOnUnmatchedMethod() {
        StubExample exampleStub = (StubExample) new Stub.Builder(
                StubExample.class
            )
            .mockingMethodCall('add') // returns methodSig.builder
            .withParameterTypes(Integer.class, Integer.class)
            .withParameterValues(2, 2)
            .returning(5)
            .defineStub(true);

        StubExampleConsumer consumer = new StubExampleConsumer(exampleStub);
        Boolean didCatchStubException = false;

        Test.startTest();
        try {
            consumer.add(0, 0);
        } catch (Stub.StubException stubException) {
            if (
                stubException.getMessage()
                    .containsIgnoreCase(
                        'add was called on a Stubbed StubExample object but no mocked method matched it'
                    )
            ) {
                didCatchStubException = true;
            }
        }
        Test.stopTest();
        System.assert(
            didCatchStubException,
            'Expected to recieve a Stub.StubException when no matching method was found'
        );
    }

    @isTest
    static void testMockingMethodCallOverloads() {
        Stub exampleStub = new Stub.Builder(StubExample.class)
            // Create a MockedMethod with a single String parameter
            .mockingMethodCall('setGreeting', String.class)
            .withParameterValues('Testin123')
            .returning()
            // Create a MockedMethod with two Integer paramters
            .mockingMethodCall('add', Integer.class, Integer.class)
            .withParameterValues(5, 5)
            .returning(11)
            // Create a MockedMethod with three String parameters
            .mockingMethodCall(
                'concatThreeStrings',
                String.class,
                String.class,
                String.class
            )
            .withParameterValues('foo', 'bar', 'baz')
            .returning('bobsYourUncle')
            // Create a MockedMethod with 4 integer parameters
            .mockingMethodCall(
                'addFourNumbers',
                Integer.class,
                Integer.class,
                Integer.class,
                Integer.class
            )
            .withParameterValues(1, 2, 3, 4)
            .returning(0)
            .defineStub();

        StubExampleConsumer consumer = new StubExampleConsumer(
            (StubExample) exampleStub.createStub()
        );
        Test.startTest();
        consumer.setGreeting('Testin123');
        exampleStub.mockedMethods[0].assertMockedMethodWasCalled();
        System.assertEquals(
            11,
            consumer.add(5, 5),
            'Expected the constructed mock to return 11, even though the input parameters sum to 10'
        );
        System.assertEquals(
            consumer.concatThreeStrings('foo', 'bar', 'baz'),
            'bobsYourUncle',
            'Expected the constructed mock to return the overrided'
        );
        System.assertEquals(
            consumer.addFourNumbers(1, 2, 3, 4),
            0,
            'Expected the constructed mock to return the override'
        );
        Test.stopTest();
    }

    @isTest
    static void testAssertMockeMethodThrowsWhenNotCalled() {
        Stub exampleStub = new Stub.Builder(StubExample.class)
            .mockingMethodCall('add') // returns methodSig.builder
            .withParameterTypes(Integer.class, Integer.class)
            .withParameterValues(2, 2)
            .returning(5)
            .defineStub();

        Test.startTest();
        Boolean didCatchStubException = false;
        try {
            exampleStub.mockedMethods[0].assertMockedMethodWasCalled();
        } catch (Stub.StubException expt) {
            if (
                expt.getMessage().containsIgnoreCase('this bound method (add)')
            ) {
                didCatchStubException = true;
            }
        }
        Test.stopTest();
        system.assert(
            didCatchStubException,
            'expected to have caught an assertion exception'
        );
    }

    @isTest
    static void testReturnListOfIds() {
        List<Id> ids = StubUtilities.generateSObjectIds('account', 5);
        List<Account> accounts = new List<account>();
        for (Id id : ids) {
            accounts.add(new Account(id = id));
        }
        StubExample exampleStub = (StubExample) new Stub.Builder(
                StubExample.class
            )
            .mockingMethodCall('getAccounts') // returns methodSig.builder
            .withParameterTypes(List<Account>.class)
            .withParameterValues(accounts)
            .returning(ids)
            .defineStub(true);

        StubExampleConsumer consumer = new StubExampleConsumer(exampleStub);
        Test.startTest();
        List<Account> checkAccounts = (List<Account>) consumer.getAccounts(
            accounts
        );
        Test.stopTest();

        System.assertEquals(checkAccounts.size(), ids.size());
    }
}
