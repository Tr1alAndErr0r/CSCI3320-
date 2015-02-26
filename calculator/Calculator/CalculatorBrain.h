//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Duke Le on 2/1/15.
//  Copyright (c) 2015 Duke Le. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)clearArray;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
