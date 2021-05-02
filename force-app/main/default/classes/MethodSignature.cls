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
    public class Builder{
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
        public Builder(Stub.Builder builder, String methodName,
            List<System.Type> paramTypes
        ) {
            this.builder = builder;
            this.methodName = methodName;
            this.paramTypes = paramTypes;
        }

        public MockedMethod.Builder called() {
            return calledWith(new List<Object>());
        }

        public MockedMethod.Builder calledWith(List<Object> args) {
            MockedMethod.Builder mb = new MockedMethod.Builder(this, args);
            methodBuilders.add(mb);
            return mb;
        }

        public MockedMethod.Builder calledWith(Object arg) {
            return calledWith(new List<Object>{ arg });
        }

        public MockedMethod.Builder calledWith(Object arg, Object arg2) {
            return calledWith(new List<Object>{ arg, arg2 });
        }

        public MockedMethod.Builder calledWith(Object arg, Object arg2, Object arg3) {
            return calledWith(new List<Object>{ arg, arg2, arg3 });
        } 

        @SuppressWarnings('PMD.ExcessiveParameterList')
        public MockedMethod.Builder calledWith(
            Object arg,
            Object arg2,
            Object arg3,
            Object arg4
        ) {
            return calledWith(new List<Object>{ arg, arg2, arg3, arg4 });
        }

        public Stub.Builder endSignature() {
            return builder;
        }

        public List<MockedMethod> buildMockedMethod() {
            MethodSignature signature = new MethodSignature(methodName, paramTypes);
            List<MockedMethod> methodCalls = new List<MockedMethod>();
            for (MockedMethod.Builder mb : methodBuilders) {
                methodCalls.add(mb.createMockedMethod(signature));
            }

            return methodCalls;
        }
    }

}
