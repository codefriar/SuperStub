/**
 * @description Class models a callable apex method's 'signature' or combination
 * of Name, Parameter types and Parameter values. This is separate from a
 * MockedMethod, because it can be constructed at runtime for comparison against
 * established MockedMethods.
 */
public with sharing class MethodSignature {
    private String methodName;
    private List<Type> paramTypes;

    /**
     * @description      Constructor requiring a method name and list of
     * parameters. This method cannot be constructed without these.
     * @param methodName
     * @param paramTypes
     */
    public MethodSignature(String methodName, List<Type> paramTypes) {
        this.methodName = methodName;
        this.paramTypes = paramTypes;
    }

    /**
     * @description         This is used to compare the signature of a
     * MockedMethod, against another instance. Used at runtime to compare
     * an actually requested method call against pre-defined mocks.
     * @param otherInstance
     * @return              `Boolean`
     */
    public Boolean verifySignatureMatch(Object otherInstance) {
        if (otherInstance instanceof MethodSignature) {
            MethodSignature otherSignature = (MethodSignature) otherInstance;
            return ((methodName == otherSignature.methodName) &&
            paramTypes.equals(otherSignature.paramTypes));
        }
        return false;
    }

    /**
     * @description While a MethodSignature object can be created directly the
     * more common usecase is to use this Builder class to construct the
     * MethodSignature object in a Fluent api style.
     */
    public class Builder {
        private Stub.Builder builder;
        private String methodName;
        private List<Type> paramTypes;

        // A list of MockedMethod.Builders that have this signature.
        // One MethodSignature may have multiple MockedMethods because the
        // runtime parameter *values* differ.
        List<MockedMethod.Builder> methodBuilders = new List<MockedMethod.Builder>();

        /**
         * @description      Constructor.
         * @param builder    A Stub.Builder object
         * @param methodName String referencing the name of the method minus
         * things like ()
         * @param paramTypes A list of System.Types that define the order and
         * type of parameters for the method.
         */
        public Builder(
            Stub.Builder builder,
            String methodName,
            List<System.Type> paramTypes
        ) {
            this.builder = builder;
            this.methodName = methodName;
            this.paramTypes = paramTypes;
        }

        /**
         * @description This variant handles the situation where a mocked method
         * was called without parameters.
         * @return      `MockedMethod.Builder`
         */
        public MockedMethod.Builder calledWith() {
            return calledWith(new List<Object>());
        }

        /**
         * @description      Omnibus variant that handles a list(N) of
         * parameters.
         * @param parameters
         * @return           `MockedMethod.Builder`
         */
        public MockedMethod.Builder calledWith(List<Object> parameters) {
            MockedMethod.Builder mockedMethodBuilder = new MockedMethod.Builder(
                this,
                parameters
            );
            methodBuilders.add(mockedMethodBuilder);
            return mockedMethodBuilder;
        }

        /**
         * @description This variant handles a single parameter, brokers to
         * omnibus method.
         * @param arg
         * @return      `MockedMethod.Builder`
         */
        public MockedMethod.Builder calledWith(Object arg) {
            return calledWith(new List<Object>{ arg });
        }

        /**
         * @description Two parameter variant. Brokers to omnibus method.
         * @param arg
         * @param arg2
         * @return      `MockedMethod.Builder`
         */
        public MockedMethod.Builder calledWith(Object arg, Object arg2) {
            return calledWith(new List<Object>{ arg, arg2 });
        }

        /**
         * @description Three parameter variant. Brokers to omnibus method.
         * @param arg
         * @param arg2
         * @param arg3
         * @return      `MockedMethod.Builder`
         */
        public MockedMethod.Builder calledWith(
            Object arg,
            Object arg2,
            Object arg3
        ) {
            return calledWith(new List<Object>{ arg, arg2, arg3 });
        }

        /**
         * @description Four parameter variant. Brokers to omnibus method.
         * @param arg
         * @param arg2
         * @param arg3
         * @param arg4
         * @return      `MockedMethod.Builder`
         */
        @SuppressWarnings('PMD.ExcessiveParameterList')
        public MockedMethod.Builder calledWith(
            Object arg,
            Object arg2,
            Object arg3,
            Object arg4
        ) {
            return calledWith(new List<Object>{ arg, arg2, arg3, arg4 });
        }

        /**
         * @description Called at the end of building a method signature.
         * @return      `Stub.Builder`
         */
        public Stub.Builder finalizeSignature() {
            return builder;
        }

        /**
         * @description Creates the MockedMethod matching this method signature.
         * @return      `List<MockedMethod>`
         */
        public List<MockedMethod> buildMockedMethod() {
            MethodSignature signature = new MethodSignature(
                methodName,
                paramTypes
            );
            List<MockedMethod> methodCalls = new List<MockedMethod>();
            for (MockedMethod.Builder mb : methodBuilders) {
                methodCalls.add(mb.createMockedMethod(signature));
            }

            return methodCalls;
        }
    }
}
