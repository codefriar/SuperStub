public with sharing class StubExampleConsumer {
    StubExample stub;

    public StubExampleConsumer(StubExample stub) {
        this.stub = stub;
    }

    public Boolean getIsTrue() {
        return this.stub.getIsTrue();
    }

    public String getGreeting() {
        return this.stub.getGreeting();
    }

    public void setGreeting(String greeting) {
        this.stub.setGreeting(greeting);
    }

    public Integer add(Integer first, Integer second) {
        return this.stub.add(first, second);
    }

    public String concatThreeStrings(
        String first,
        String second,
        String third
    ) {
        return this.stub.concatThreeStrings(first, second, third);
    }

    @SuppressWarnings('PMD.ExcessiveParameterList')
    public Integer addFourNumbers(
        Integer one,
        Integer two,
        Integer three,
        Integer four
    ) {
        return this.stub.addFourNumbers(one, two, three, four);
    }

    public List<Account> getAccounts(List<Account> accounts) {
        return this.stub.getAccounts(accounts);
    }
}
