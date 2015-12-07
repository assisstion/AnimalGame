//
//  BinarySearchTree.m
//  BinarySearchTree
//
//  Created by Markus Feng on 11/2/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import "BinaryTree.h"

@implementation BinaryTree

-(void)preorderPrint{
    NSLog(@"%@",[self arrayString:[self preorder]]);
}
-(void)inorderPrint{
    NSLog(@"%@",[self arrayString:[self inorder]]);
}
-(void)postorderPrint{
    NSLog(@"%@",[self arrayString:[self postorder]]);
}
-(NSString*)arrayString:(NSArray*)array{
    NSString * str = @"";
    for(NSNumber * number in array){
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@, ", number]];
    }
    return str;
}
-(int)maxDepth{
    return [self maxDepth:self.root];
}
-(bool)contains:(id)obj{
    return [self contains:obj inNode:self.root];
}
-(int)size{
    return [self size:self.root];
}

-(NSMutableArray *)preorder{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [self preorder:arr inNode:self.root];
    return arr;
}

-(void)preorder:(NSMutableArray *)array inNode:(TreeNode *)node{
    if(node == nil){
        return;
    }
    [array addObject: node.value];
    [self preorder:array inNode:node.left];
    [self preorder:array inNode:node.right];
}

-(NSMutableArray *)inorder{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [self inorder:arr inNode:self.root];
    return arr;
}

-(void)inorder:(NSMutableArray *)array inNode:(TreeNode *)node{
    if(node == nil){
        return;
    }
    [self inorder:array inNode:node.left];
    [array addObject: node.value];
    [self inorder:array inNode:node.right];
}

-(NSMutableArray *)postorder{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [self postorder:arr inNode:self.root];
    return arr;
}

-(void)postorder:(NSMutableArray *)array inNode:(TreeNode *)node{
    if(node == nil){
        return;
    }
    [self postorder:array inNode:node.left];
    [self postorder:array inNode:node.right];
    [array addObject:node.value];
}

-(int)size:(TreeNode *)node{
    if(node == nil){
        return 0;
    }
    return [self size:node.left] + [self size:node.right] + 1;
}

-(int)maxDepth:(TreeNode *)node{
    if(node == nil){
        return 0;
    }
    int leftDepth = [self maxDepth:node.left];
    int rightDepth = [self maxDepth:node.right];
    return leftDepth > rightDepth ? leftDepth + 1 : rightDepth + 1;
}
-(bool)contains:(id)obj inNode:(TreeNode *)node{
    if(node == nil){
        return false;
    }
    if(node.value == obj){
        return true;
    }
    return [self contains:obj inNode:node.left] ||
        [self contains:obj inNode:node.right];
}



-(instancetype)initWithString: (NSString*)string{
    self = [super init];
    if(self){
        NSMutableArray<TreeNode<NSString *> *> * stack = [[NSMutableArray alloc] init];
        
        //Node
        string = [string stringByReplacingOccurrencesOfString:@">" withString:@"|>|"];
        
        //Leaf
        string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"|<|"];
        
        NSArray * array = [string componentsSeparatedByString:@"|"];

        int i = 0;
        while(i + 1 < array.count){
            TreeNode<NSString *> * node = [[TreeNode alloc] initWithValue:array[i]];
            NSString * val = array[i + 1];
            if([val isEqualToString:@">"]){
                TreeNode<NSString *> * right = [stack lastObject];
                [stack removeLastObject];
                TreeNode<NSString *> * left = [stack lastObject];
                [stack removeLastObject];
                node.left = left;
                node.right = right;
            }
            [stack addObject:node];
            i += 2;
        }
        self.root = stack[0];
    }
    return self;
}



-(NSString *)toString{
    NSArray * array = [self postorderS];
    NSString * output = @"";
    for(NSString * s in array){
        output = [output stringByAppendingString:s];
    }
    return output;
}

-(NSMutableArray *)postorderS{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [self postorderS:arr inNode:self.root];
    return arr;
}

-(bool)postorderS:(NSMutableArray *)array inNode:(TreeNode *)node{
    bool val = false;
    if(node == nil){
        return false;
    }
    val = [self postorderS:array inNode:node.left] || val;
    val = [self postorderS:array inNode:node.right] || val;
    [array addObject:node.value];
    if(val){
        [array addObject:@">"];
    }
    else{
        [array addObject:@"<"];
    }
    return true;
}



@end
