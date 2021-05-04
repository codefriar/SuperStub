public with sharing class StubExample {
    public Boolean isTrue = false;
    public String greeting = 'hello';
    public Boolean notMocked; // this is null on purpose for testing.

    public Boolean getIsTrue() {
        return this.isTrue;
    }

    public String getGreeting() {
        return this.greeting;
    }

    public void setGreeting(String greeting) {
        this.greeting = greeting;
    }

    public void setGreeting(Integer greeting) {
        this.greeting = String.valueOf(greeting);
    }

    public Integer add(Integer first, Integer second) {
        return first + second;
    }

    public String concatThreeStrings(
        String first,
        String second,
        String third
    ) {
        return first + second + third;
    }

    public Integer addFourNumbers(
        Integer one,
        Integer two,
        Integer three,
        Integer four
    ) {
        return one + two + three + four;
    }

    public List<Account> getAccounts(List<Account> accounts) {
        return new List<Account>();
    }
}
