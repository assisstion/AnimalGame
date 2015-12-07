//
//  AnimalProcessor.h
//  AnimalGame
//
//  Created by Markus Feng on 11/5/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimalProcessor : NSObject

//Modes
//
//Question: [Does it fly?] (bool)
//Question request: [What is a yes or no question that would answer yes a <Animal1> and no for a <Animal 2>? (String)
//Confirmation: [Is it a Dog?] (bool)
//Value request: [What animal is it?] (String)

-(void)textAction:(NSString *)text;
-(void)booleanAction:(bool)yes;
-(NSString *)questionText;
-(bool)textMode;
-(void)save;
-(void)load;
-(void)resetData;
-(void)sync;

@end
