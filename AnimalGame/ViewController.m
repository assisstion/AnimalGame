//
//  ViewController.m
//  AnimalGame
//
//  Created by Markus Feng on 11/5/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import "ViewController.h"
#import "AnimalProcessor.h"
#import "BinaryTree.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *questionText;
@property AnimalProcessor * processor;
@property (weak, nonatomic) IBOutlet UITextView *submitText;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.processor = [[AnimalProcessor alloc] init];
    [self.processor sync];
    [self updateData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)yesPressed:(id)sender {
    [self.processor booleanAction:true];
    [self updateData];
}
- (IBAction)resetPressed:(id)sender {
    [self.processor resetData];
    [self updateData];
}

- (IBAction)noPressed:(id)sender {
    [self.processor booleanAction:false];
    [self updateData];
}
- (IBAction)submitPressed:(id)sender {
    NSString * text = self.submitText.text;
    self.submitText.text = @"";
    [self.processor textAction:text];
    [self updateData];
}
-(void)updateData{
    self.questionText.text = [self.processor questionText];
    if([self.processor textMode]){
        self.yesButton.enabled = false;
        self.noButton.enabled = false;
        self.submitText.editable = true;
        self.submitButton.enabled = true;
    }
    else{
        self.yesButton.enabled = true;
        self.noButton.enabled = true;
        self.submitText.editable = false;
        self.submitButton.enabled = false;
    }
    [self.processor save];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (IBAction)syncPressed:(id)sender {
    [self.processor sync];
    [self updateData];
}

@end
