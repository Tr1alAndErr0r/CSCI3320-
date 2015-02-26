//
//  ViewController.m
//  Calculator
//
//  Created by Duke Le on 2/1/15.
//  Copyright (c) 2015 Duke Le. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL notLegalFloatingPointNumber;
@property (nonatomic) BOOL secondDisplayCheck;
@property (nonatomic) BOOL displayOneContainsEqualSign;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation ViewController
@synthesize display;
@synthesize displayTwo;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize notLegalFloatingPointNumber;
@synthesize secondDisplayCheck;
@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
    if(!_brain)_brain=[[CalculatorBrain alloc]init];
    return _brain;
}

- (IBAction)clearPressed:(UIButton *)sender
{
    self.display.text = @"0"; // setting ui display to 0
    self.displayTwo.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO; // reseting bool values to 0
    self.notLegalFloatingPointNumber = NO;
    self.secondDisplayCheck = NO;
    [self.brain clearArray]; // deleting all contents of array
    
}

- (IBAction)backSpacePressed:(UIButton *)sender
{
    NSString *stringDisplayOne = self.display.text;
    NSString *stringDisplayTwo = self.displayTwo.text;

    if (!self.displayOneContainsEqualSign)
    {
        if ([stringDisplayOne length] > 0)
        {
            self.display.text = [stringDisplayOne substringToIndex:[stringDisplayOne length] - 1];
            self.displayTwo.text = [stringDisplayTwo substringToIndex:[stringDisplayTwo length] - 1];
            if ([self.display.text rangeOfString:@"."].location == NSNotFound)
            {
                self.notLegalFloatingPointNumber = NO;
            }
            if ([stringDisplayOne length] == 1 && [stringDisplayTwo length] == 1)
            {
                self.display.text = @"0";
                self.displayTwo.text = @"0";
                self.secondDisplayCheck = NO;
                self.userIsInTheMiddleOfEnteringANumber = NO;
            }
        }
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];

    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.displayTwo.text = [self.displayTwo.text stringByAppendingString:digit];
    }
    
    else
    {
        if(self.secondDisplayCheck)
        {
        self.display.text = digit;
        self.displayTwo.text = [self.displayTwo.text stringByAppendingString:@" "];
        self.displayTwo.text = [self.displayTwo.text stringByAppendingString:digit];
        self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        
        else
        {
            self.display.text = digit;
            self.displayTwo.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.secondDisplayCheck = YES;
        }
    }
    self.displayOneContainsEqualSign = NO;
}

- (IBAction)dotPressed:(UIButton *)sender
{
    NSString *dot = [sender currentTitle];
   
    if (self.notLegalFloatingPointNumber == NO) // bool check to see if dot/floating point has already been pressed
    {
        if (self.userIsInTheMiddleOfEnteringANumber)
        {
            self.display.text = [self.display.text stringByAppendingString:dot]; // adding floating point to display
            self.displayTwo.text = [self.displayTwo.text stringByAppendingString:dot];
            self.notLegalFloatingPointNumber = YES; // sets off bool to mark that floating point has already been used in current integer
        }
        
        else if ([self.displayTwo.text length] > 0)
        {
            self.display.text = dot;
            self.displayTwo.text = [self.displayTwo.text stringByAppendingString:@" "]; // if 2nd display already has values then create a space between them
            self.displayTwo.text = [self.displayTwo.text stringByAppendingString:dot];
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.notLegalFloatingPointNumber = YES;
        }
        else // handles first case of floating point pressed, just sets display with floating point
        {
            self.display.text = dot;
            self.displayTwo.text = dot;
            self.userIsInTheMiddleOfEnteringANumber = YES;
            self.notLegalFloatingPointNumber = YES;
        }
    }
    self.displayOneContainsEqualSign = NO;
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]]; // pushes value on display to brain
    self.userIsInTheMiddleOfEnteringANumber = NO; // resets bools back to 0
    self.notLegalFloatingPointNumber = NO;
}


- (IBAction)operationPressed:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterPressed]; // calls enter to push current value in display onto stack
    }
    NSString *operation = [sender currentTitle];
    self.displayTwo.text = [self.displayTwo.text stringByAppendingString:@" "]; // puts a delimiter to seperate values and operator on display
    self.displayTwo.text = [self.displayTwo.text stringByAppendingString:operation]; // adds the operator to the display

    double result = [self.brain performOperation:operation]; // store result of operation
    self.display.text = [NSString stringWithFormat:@"%g =", result];
    self.displayOneContainsEqualSign = YES;
}

- (IBAction)positiveNegativeToggle:(id)sender
{
    if (!self.displayOneContainsEqualSign)
    {
    double negativeOne = -1;
    double convertedDisplayOneValue = [self.display.text doubleValue];
    double numberOfCharactersToRemove = [self.display.text length];
    double startingIndex = [self.displayTwo.text length];
    NSString* displayTwoTemp = self.displayTwo.text;
    NSMutableString *mutableString = [displayTwoTemp mutableCopy];
        
    convertedDisplayOneValue = convertedDisplayOneValue * negativeOne;
    startingIndex = startingIndex - numberOfCharactersToRemove;
    self.display.text = [NSString stringWithFormat:@"%g", convertedDisplayOneValue];
    [mutableString replaceCharactersInRange: NSMakeRange(startingIndex, numberOfCharactersToRemove) withString: self.display.text];
    [NSString stringWithString: mutableString];
    self.displayTwo.text = mutableString;
    }
}






















@end
