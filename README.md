# Super-Stub - A delightful and elegant stubbing framework for Apex

[![CI Workflow](https://github.com/codefriar/SuperStub/workflows/CI/badge.svg)](_https://github.com/codefriar/SuperStub/actions?query=workflow%3ACI_) [![Packaging Workflow](https://github.com/codefriar/SuperStub/workflows/Packaging/badge.svg)](_https://github.com/codefriar/SuperStub/actions?query=workflow%3APackaging_) [![codecov](https://codecov.io/gh/codefriar/SuperStub/branch/main/graph/badge.svg)](_https://codecov.io/gh/codefriar/SuperStub_)
[![Twitter](https://img.shields.io/twitter/follow/Codefriar.svg?style=social)](https://img.shields.io/twitter/follow/Codefriar.svg?style=social)
## ⁇ What is this? / What's it do?

> tl;dr; Super Stub is a delightful and elegant stubbing and mocking framework for Apex. A few weeks ago [@JennyJBennett](https://twitter.com/JennyJBennett) and I did a couple of [codeLive](https://www.youtube.com/watch?v=H2ddKRgofD0&list=PLgIMQe2PKPSKAIMyT3enmEetcnVEszTJL) episodes on Mocking and Stubbing. This library is the product of those two sessions, and a bunch of refactoring.

Apex provides a system interface called StubProvider - [you can learn more about it here.](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_interface_System_StubProvider.htm) There's even advanced instructions for [building a mocking and stubbing framework with the StubProvider interface](https://developer.salesforce.com/docs/atlas.en-us.232.0.apexcode.meta/apexcode/apex_testing_stub_api.htm)

While these documents explain what the `StubProvider` does, the examples given lend themselves to a one-off Stub classes. Unless you want to litter your codebase with one-off stub classes this isn't brilliant; so I and others have set out to build a reusable Stubbing framework. There are other reusable frameworks out there, but this one is 'mine'. Part of what makes creating this kind of framework difficult is the API, or the interface developers use when utilizing this kind of library. Much thought has been put into API of Super-Stub. Specifically, I've tried to make sure the methods names are intuitive and easy to understand.

Super-Stub is built as a series of three classes: `Stub`, `MockedMethod` and `MethodSignature`. Each of these classes has an inner class named Builder. The builder classes exposes fluent interfaces for progressively and intuitively building Stub objects and Mocked methods.


## Who's it for?
🧑‍💻👩🏾‍💻 - Apex developers who write unit tests! (aka: All Apex developers) If you write unit tests, and want to make them faster, and less prone to intermittent failures then you'll want to utilize stubbing.

## Install
### Installation Options:
> Note: Because the code in this repository is all marked @IsTest, there are no unit tests in the pre-packaged versions of this libary.

- SPM Install: This is the preferred method, [but it requires SPM. Find out more here.](https://spm-registry.herokuapp.com/)
```sh
sfdx spm:install -n 'super-stub'
```
- Package Link: Click [this link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5e000000tprvAAA) to install the Super-Stub unlocked package in your org.
- Git Clone: This is an exercise left to the reader.

## How do I use it?
Super-Stub is designed to be used via the `Builder` inner classes for the three main objects: `Stub`, `MockedMethod`, and `MethodSignature`. The builder classes contain methods that help you progressively define one or more mocked methods on a stub object. Let's look at a few examples:

```Apex
StubExample exampleStub = new (StubExample) Stub.Builder(StubExample.class)
                      .mockingMethodCall('getIsTrue')
                      .withParameterTypes()
                      .returning(true)
                      .mockingMethodCall('getGreeting')
                      .withParameterTypes()
                      .returning('foo bar baz')
                      .defineStub(true);
```

In this example, the code generates a `Stub` that has two mocked methods: `getIsTrue` and `getGreeting`. Neither method accepts any parameters, but both mocked methods have an overridden return value. Let's break that down a bit further with one of the methods: `new Stub.Builder(<<ClassToStub>>.class) ` returns a `Stub.Builder` locked to the `ClassToStub` that you specify. That `Stub.Builder` class has a method named `mockingMethodCall` that accepts a string. This adds a new `MockedMethod` Object to the `Stub.Builder`'s list of mocked methods, and returns a `MockedMethod.Builder` object. The `MockedMethod.Builder` object has the `withParameterTypes` method that define what parameters this mocked method should react to - useful for situations where you have overloaded methods. Finally, the `returning` method allows you to specify - at test development time - what the mocked method will return. This is the crucial functionality of a Stubbing and Mocking libary - to allow the developer to define the returned information of the overridden implementation. `returning` also 'finalizes' your mockedMethod and returns back the `Stub.Builder` object allowing you to chain the next mockedMethod.

Let's look at a more complete, and realistic example. Walkthrough in the comments:
```apex
// Creates a 
Stub exampleStub = new Stub.Builder(StubExample.class)
                            // Create a MockedMethod with a single String parameter
                            // This is equivilent to calling 
                            // mockingMethodCall('setGreeting').withParameterTypes(String.class)
                            .mockingMethodCall('setGreeting', String.class)
                            // This tells the framework that this specific mock
                            // should only be used if the runtime parameter its 
                            // called with matches 'Testin123'
                            .withParameterValues('Testin123')
                            // set's a null return type - in this case the mockedMethod is
                            // a setter.
                            .returning()
                            // Create a MockedMethod with two Integer paramters
                            .mockingMethodCall('add', Integer.class, Integer.class)
                            // this MockedMethod only responds when the runtime parameters
                            // are 5, and 5.
                            .withParameterValues(5, 5)
                            // override the return - in this case to something obviously
                            // wrong for demonstration purposes.
                            .returning(11)
                            // Create a MockedMethod with three String parameters
                            .mockingMethodCall(
                                'concatThreeStrings',
                                String.class,
                                String.class,
                                String.class
                            )
                            // this MockedMethod only responds when the runtime parameters 
                            // are 'foo', 'bar', 'baz'. 
                            .withParameterValues('foo', 'bar', 'baz')
                            // Instead of `returning` we're setting this mockedMethod to 
                            // throw a pre-constructed exception.
                            .throwingException(CustomStubTestException)
                            // Create a MockedMethod with 4 integer parameters
                            .mockingMethodCall('addFourNumbers')
                            // instead of using the mockingMethodCall overload with 
                            // (up to 4) parameter types listed, you can call the 
                            // withParameterTypes(List<Type>) method.
                            .withParameterTypes(
                                Integer.class,
                                Integer.class,
                                Integer.class,
                                Integer.class
                            )
                            .withParameterValues(1, 2, 3, 4)
                            .returning(0)
                            .defineStub();
```

For a full set of API Examples, please look at the Tests included in this Repository.

> Note: Because the code in this repository is all marked @IsTest, there are no unit tests in the pre-packaged versions of this libary.


### Definitions
* Stub: In software testing, a Stub is an Object implementation that stands in for some other Object. In Apex there is a 1:1 relationship between a Stub and the Class it's standing in for. In other words, you can create a Stub, but your stub carries the same name, as a pre-existing class. Often, the Stub object implements a subset of the functionality of the class. (hence the name). Super-Stub uses the Stub class to represent this concept.
* Mock: A Mock referrs to a specific function whose implementation is overridden by a Stub. Stubs contain at least one Mock. When the Stub is used, and the tested code invokes the Mock, the Stub's implementation is used, instead of the normal implementation. In Super-Stub, Mocks are represeted by the MockedMethod class.
* Dependency Injection: This refers to the practice of 'injecting' one object into another for use. In practice, this often looks like having an Object's constructor require an instance of another object. Contrast this idea to the idea of having an object create it's own instance of a given object. You can only use the StubProvider interface, and Super-Stub with code that uses Dependency Injection.
* Runtime Parameters: Runtime Parameters refers to the values of the parameters passed into your code by the unit test. If, for instance, you had an `add(int1,int2)` method, the runtime parameters refers to the values of int1 and int2 during the execution of the unit test.

### Limitations
Super-Stub is limited by the same constraints the `System.StubProvider` interface. [You can learn more about those limitations here.](https://developer.salesforce.com/docs/atlas.en-us.232.0.apexcode.meta/apexcode/apex_testing_stub_api.htm) 
## Other Mocking and Stubbing Frameworks
There are other Stubbing and Mocking frameworks for Apex. Others have outright asked me why I reinvented the wheel. Honestly, because none of the others met my needs. Nevertheless, Here's a list of other Stub frameworkds for Apex: (Feel free to submit a PR to have your library listed.)
- [Amoss](https://github.com/bobalicious/amoss)
- [UniversalMock](https://github.com/surajp/universalmock)

## Authors

🧑🏼‍💻 **Kevin Poorman**

* Website: http://www.codefriar.com
* Twitter: [@Codefriar](https://twitter.com/Codefriar)<a href="https://twitter.com/Codefriar" target="_blank">
    <img alt="Twitter: Codefriar" src="https://img.shields.io/twitter/follow/Codefriar.svg?style=social" />
  </a>
* Github: [Codefriar](https://github.com/Codefriar)

👩🏼‍💻 **Jennifer Bennett**
* Twitter: [@JennyJBennett](https://twitter.com/JennyJBennett)

## Show your support

Give a ⭐️ if this project helped you!

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
