//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Duke Le on 2/1/15.
//  Copyright (c) 2015 Duke Le. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;


@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init]; // allocating a new array
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this for extra credit";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation]; // adding operation to array
    return [[self class] runProgram:self.program];
}

-(void)clearArray
{
    [self.programStack removeAllObjects]; // deletes all objects from array
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack; // comparing various strings to their respective operations and performing the operations by removing the numbers from the array
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        }
    
        else if([@"*" isEqualToString:operation])
        {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        }
    
        else if([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        }
    
        else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }
    
        else if ([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffProgramStack:stack]);
        }
    
        else if ([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffProgramStack:stack]);
        }
    
        else if ([operation isEqualToString:@"sqrt"])
        {
            result = sqrt([self popOperandOffProgramStack:stack]);
        }

        else if ([operation isEqualToString:@"pi"])
        {
            result = M_PI;
        }
    }

    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}
             
             
@end
