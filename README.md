
Jennifer Bennett  4:47 PM
Looks awesome, I had a couple questions and then some naming thoughts...
Stub
line 102 - should be lower case mockedMethod
line 109 - Nice exception when a method does not get called - do the comments need to be updated?
line 227 / 248 / 303 - Why .withParameterTypes()?
line 312 - nice idea being able to bypass storing the stub all together and just creating the instance.
line 317 - for consistency should we label that variable mockedMethods vs methodCalls (carryover?)
MethodSignature
line 127...168 - Should the parameter names be parameter vs arg?
line 18 - I find the executiontime vs runtime naming a little confusing... what do you think about calling this expectedArgs?
line 175 - we could rename to runtimeArg
line 153 - runtimeParameters comment says it represents the expected but this is the actual method call
MockedMethod
line 218 - with ParmaterValues all missing comments
line 328 - for consistency should we label that variable mockedMethod vs methodCall (carryover?)