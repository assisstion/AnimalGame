//
//  BinarySearchTree.h
//  BinarySearchTree
//
//  Created by Markus Feng on 11/2/15.
//  Copyright © 2015 Markus Feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"


@interface BinaryTree<__covariant ObjectType> : NSObject

@property TreeNode<ObjectType> *root;

-(void)preorderPrint;
-(void)inorderPrint;
-(void)postorderPrint;
-(int)maxDepth;
-(bool)contains:(ObjectType)obj;
-(int)size;
-(NSMutableArray*)preorder;
-(NSMutableArray*)inorder;
-(NSMutableArray*)postorder;
-(instancetype)initWithString: (NSString*)string;
-(NSString*)toString;

@end
