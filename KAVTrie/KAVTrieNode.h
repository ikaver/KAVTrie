//
//  KAVTrieNode.h
//  KAVTrie
//
//  Created by Iosef Kaver on 3/5/14.
//  Copyright (c) 2014 Iosef Kaver. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class KAVTrieNode
 @discussion Represents a simple node of a Ternary Search Trie
 with three child nodes. The left node contains the subtrie of characters
 less than c, the center node contains the subtrie of characters equal to c
 and the right node contains the subtrie of characters greater than c.
 */
@interface KAVTrieNode : NSObject

/*!
@property The character that represents this node.
*/
@property (readonly) unichar c;
/*!
@property Value of this node. If value != nil it means that this node is 
 associated with a key given by the user.
*/
@property (nonatomic, strong) id value;
/*!
@property left node, contains the subtrie of characters less than c.
*/
@property (nonatomic, strong) KAVTrieNode * left;
/*!
 @property center node, contains the subtrie of characters equal to c.
 */
@property (nonatomic, strong) KAVTrieNode * center;
/*!
 @property right node, contains the subtrie of characters greater than c.
 */
@property (nonatomic, strong) KAVTrieNode * right;

/*!
 @method initWithChar:andValue
 @abstract Creates a KAVTrieNode with the given char and value. Sets the child
 nodes to nil as wekk.
 @discussion
 @param c the character to associate with this node.
 @result value the value to associate with this node. Should specify nil if 
 the value is not associated with any key.
 */
-(id)initWithChar:(unichar)c andValue:(id)value;

@end
