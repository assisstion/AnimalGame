//
//  TreeNode.m
//  BinarySearchTree
//
//  Created by Markus Feng on 11/2/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import "TreeNode.h"

@implementation TreeNode

-(instancetype)initWithValue:(id)value{
    self = [super init];
    if(self) {
        self.value = value;
    }
    return self;
}


@end
