@isTest
private class StubExample_Tests {
    @isTest
    static void testStubBuilderWithTwoMethodsMocked() {
        Stub exStub = new Stub.Builder(StubExample.class)
            .mockingMethodCall('getIsTrue')
            .calledWith()
            .returning(true)
            .mockingMethodCall('getGreeting')
            .calledWith()
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
            .calledWith()
            .returning(true)
            .mockingMethodCall('getGreeting')
            .calledWith()
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
            .calledWith()
            .throwingException(customException)
            .mockingMethodCall('getGreeting')
            .calledWith()
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
        StubExample exampleStub = (StubExample) new Stub.Builder(
                StubExample.class
            )
            .mockingMethodCall('add')
            .calledWith(2, 2)
            .returning(5)
            .mockingMethodCall('setGreeting')
            .calledWith(3, 3)
            .returning(7)
            .defineStub(true);

        Test.startTest();
        StubExampleConsumer consumer = new StubExampleConsumer(exampleStub);
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
        checkSum = consumer.add(5, 5);
        system.assertEquals(10, checkSum, 'Expected valid results');
        Test.stopTest();
    }
}
