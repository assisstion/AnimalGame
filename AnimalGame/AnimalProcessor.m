//
//  AnimalProcessor.m
//  AnimalGame
//
//  Created by Markus Feng on 11/5/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import "AnimalProcessor.h"
#import "BinaryTree.h"

@implementation AnimalProcessor{
    bool right;
    NSString * questionText;
    int mode;
    BinaryTree<NSString *> * questionData;
    TreeNode<NSString *> * currentParent;
    TreeNode<NSString *> * current;
    
    NSString * animalTemp;
    NSString * questionTemp;
}

-(instancetype)init{
    self = [super init];
    if(self) {
        questionData = [[BinaryTree alloc] init];
        [self load];
        [self hardReset];
    }
    return self;
}

//Right = yes
//Left = no
-(void)load{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"playerData.plist"];
    NSMutableDictionary *plistdict = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    NSString * save = [plistdict objectForKey:@"save"];
    if(save == nil){
        [self resetData];
    }
    else{
        questionData = [[BinaryTree alloc] initWithString:save];
    }
}
-(void)save{
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] init];
    [plistdict setObject:[questionData toString] forKey:@"save"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"playerData.plist"];
    [plistdict writeToFile:docfilePath atomically:true];
}

-(void)resetData{
    oldHash = 0;
    TreeNode<NSString *> * root = [[TreeNode alloc] initWithValue:@"Does it have 4 legs?"];
    TreeNode<NSString *> * rootLeft = [[TreeNode alloc] initWithValue:@"Duck"];
    root.left = rootLeft;
    TreeNode<NSString *> * rootRight = [[TreeNode alloc] initWithValue:@"Dog"];
    root.right = rootRight;
    questionData.root = root;
    [self hardReset];
}

-(void)hardReset{
    [self reset];
    questionText = @"Welcome to the Animal Game! Think of an animal and I will try to guess it. Press Yes to begin.";
    mode = -1;
}

-(void)reset{
    currentParent = nil;
    current = questionData.root;
    questionText = current.value;
    animalTemp = nil;
    questionTemp = nil;
    right = false;
}

//Modes
//
//-1: Intro [Welcome to the Animal game!] (bool)
//0: Question: [Does it fly?] (bool)
//1: Confirmation: [Is it a Dog?] (bool)
//2: Correct: [Yay, I guessed your animal correctly!] (bool)
//3: New knowledge learned: [Now I know what a <Animal1> is] (bool)
//4: Which animal: [Does this question answer yes for <Animal2>?] (bool)
//100: Value request: [What animal is it?] (String)
//101: Question request: [What is a yes or no question that would differentiate between a <Animal1> and a <Animal2>?] (String)

-(void)textAction:(NSString *)text{
    if(![self textMode]){
        return;
    }
    else if(mode == 100){
        if([text length] == 0){
            mode = 100;
        }
        else if([questionData contains:text]){
            mode = 100;
            questionText = [NSString stringWithFormat:@"That can't be right, it can't be a %@. What animal is it?", text];
        }
        else{
            mode = 101;
            animalTemp = text;
            questionText = [NSString stringWithFormat:@"What is a yes or no question that would differentiate between a %@ and a %@?", animalTemp, current.value];
        }
    }
    else if(mode == 101){
        if([text length] == 0){
            mode = 101;
        }
        mode = 4;
        questionTemp = text;
        questionText = [NSString stringWithFormat:@"Does the question answer yes for a %@?", animalTemp];
    }
}

-(void)booleanAction:(bool)yes{
    if([self textMode]){
        return;
    }
    else if(mode == -1){
        if(yes){
            mode = 0;
            [self reset];
        }
        else{
            mode = -1;
        }
    }
    else if(mode == 0){
        currentParent = current;
        if(yes){
            current = current.right;
            right = true;
        }
        else{
            current = current.left;
            right = false;
        }
        //If current is a leaf
        if(current.left == nil && current.right == nil){
            mode = 1;
            questionText = [NSString stringWithFormat:@"Is it a %@?", current.value];
        }
        else{
            mode = 0;
            questionText = current.value;
        }
    }
    else if(mode == 1){
        if(yes){
            mode = 2;
            questionText = [NSString stringWithFormat:@"Yes, I guessed your animal, %@, correctly! Press Yes to play again.", current.value];
        }
        else{
            mode = 100;
            questionText = [NSString stringWithFormat:@"If it is not a %@, what animal is it?", current.value];
        }
    }
    else if(mode == 2){
        if(yes){
            mode = 0;
            [self reset];
        }
        else{
            mode = 2;
        }
    }
    else if(mode == 3){
        if(yes) {
            mode = 0;
            [self reset];
        }
        else{
            mode = 3;
        }
    }
    else if(mode == 4){
        mode = 3;
        TreeNode * animal = [[TreeNode alloc] initWithValue:animalTemp];
        TreeNode * question = [[TreeNode alloc] initWithValue:questionTemp];
        TreeNode * old;
        if(right){
            old = currentParent.right;
        }
        else{
            old = currentParent.left;
        }
        if(yes){
            question.right = animal;
            question.left = old;
        }
        else{
            question.right = old;
            question.left = animal;
        }
        if(right){
            currentParent.right = question;
        }
        else{
            currentParent.left = question;
        }
        questionText = [NSString stringWithFormat:@"Now I know what a %@ is! Press Yes to play again.", animalTemp];
    }
}

-(NSString *)questionText{
    return questionText;
}

-(bool)textMode{
    return mode >= 100;
}

int oldHash = 0;

NSString* const path = @"http://markusfeng.com/server/animal/";
NSString* const pull = @"sync_pull.php";
NSString* const push = @"sync_push.php";

-(void)sync{
    
    NSURL *url = [NSURL URLWithString:[path stringByAppendingString:pull]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = [value rangeOfString:@"$"];
    if(range.length == 0){
        return;
    }
    NSString *hashString = [value substringToIndex:range.location];
    NSString *valueString = [value substringFromIndex:range.location + 1];
    int serverHash = [hashString intValue];
    if(serverHash == oldHash){
        //push
        int tempHash = arc4random();
        
        NSString * value = [questionData toString];
        
        value = [[[value stringByReplacingOccurrencesOfString:@"~" withString:@"-"] stringByReplacingOccurrencesOfString:@"_" withString:@"-"] stringByReplacingOccurrencesOfString:@"$" withString:@"-"];
        
        value = [[value stringByReplacingOccurrencesOfString:@"<" withString:@"~"] stringByReplacingOccurrencesOfString:@">" withString:@"_"];
        
        NSString *post = [NSString stringWithFormat:@"old_hash=%i&hash=%i&value=%@",oldHash,tempHash,[self urlencode:value]];
        NSLog(@"%@", post);
        NSData* data = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSLog(@"%i", data.length);
        NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[path stringByAppendingString:push]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }
        oldHash = tempHash;
    }
    else{
        //pull
        oldHash = serverHash;
        valueString = [[valueString stringByReplacingOccurrencesOfString:@"~" withString:@"<"] stringByReplacingOccurrencesOfString:@"_" withString:@">"];
        questionData = [[BinaryTree alloc] initWithString:valueString];
        mode = -1;
        [self hardReset];
    }
}

- (NSString *)urlencode:(NSString*)val{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[val UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


@end
