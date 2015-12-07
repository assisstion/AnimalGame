//
//  TreeNode.h
//  BinarySearchTree
//
//  Created by Markus Feng on 11/2/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeNode<__covariant ObjectType> : NSObject

@property ObjectType value;
@property TreeNode<ObjectType> *left;
@property TreeNode<ObjectType> *right;

-(instancetype)initWithValue:(ObjectType)value;

@end
