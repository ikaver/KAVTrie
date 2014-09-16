//
//  KAVTrie.m
//  KAVTrie
//
//  Created by Iosef Kaver on 3/5/14.
//  Copyright (c) 2014 Iosef Kaver. All rights reserved.
//

#import "KAVTrie.h"
#import "KAVTrieNode.h"

#define NODE_DICTIONARY_KEY @"node"
#define STRING_DICITONARY_KEY @"str"
#define ASTERISK_UNICODE 0x002A
#define DOT_UNICODE 0x002E

/*!
 @class KAVTrie
 @discussion Represents a Ternary Search Trie
 to support efficient queries on a collection of NSStrings
 such as stringsThatMatchPattern: and longestPrefixOf:
 */
@interface KAVTrie()

/*!
@property root The root of the Trie. Will be nil on an empty Trie.
*/
@property (nonatomic, strong) KAVTrieNode * root;

@end

@implementation KAVTrie

/*!
 @method contains:
 @abstract Indicates if the given key is present on the Trie or not
 @discussion
 @param key The string to search on the Trie
 @result Returns YES iff the key is present on the Trie
 */
-(BOOL)contains:(NSString *)key
{
    return [self objectForKey:key] != nil;
}

#pragma mark objectForKey:


/*!
 @method objectForKey:
 @abstract Returns the value associated with the specified key
 @discussion
 @param key The key of the value you're interested in
 @result Returns the value associated to the key if its present on the Trie,
 else, it returns nil.
 */
-(id)objectForKey:(NSString *)key
{
    if(!key || key.length == 0) return nil;
    KAVTrieNode * node = [self nodeForKey:key withCurrentNode:self.root andStrIndex:0];
    return node ? node.value : nil;
}


-(KAVTrieNode*)nodeForKey:(NSString*)key
          withCurrentNode:(KAVTrieNode*)node
              andStrIndex:(NSUInteger)index
{
    if(!node){
        return nil;
    }
    unichar currentChar = [key characterAtIndex:index];
    if(currentChar < node.c){
        return [self nodeForKey:key withCurrentNode:node.left andStrIndex:index];
    }
    else if(currentChar > node.c){
        return [self nodeForKey:key withCurrentNode:node.right andStrIndex:index];
    }
    else if(index < key.length-1){
        return [self nodeForKey:key withCurrentNode:node.center andStrIndex:index+1];
    }
    else{
        return node;
    }
}

#pragma mark setObject:forKey:

/*!
 @method setObject:forKey:
 @abstract Adds the key value pair to the Trie.
 @discussion If the key is already present on the Trie, the value is overwritten.
 Only the value is retained by the Trie, the key is NOT retained.
 @param key The key that will represent the object
 @param object The value to associate to the given key
 */
-(void)setObject:(id)value forKey:(NSString *)key
{
    if(!key) [NSException raise:@"Invalid key" format:@"Key can't be nil"];
    if(key.length == 0) [NSException raise:@"Invalid key"
                                    format:@"Key must have length greater than zero"];
    self.root = [self setObject:value
                         forKey:key
                withCurrentNode:self.root
                    andStrIndex:0];
}

-(KAVTrieNode*)setObject:(id)object
                  forKey:(NSString *)key
         withCurrentNode:(KAVTrieNode*)node
             andStrIndex:(NSUInteger)index
{
    unichar currentChar = [key characterAtIndex:index];
    if(!node){
        //create node if we haven't yet
        node = [[KAVTrieNode alloc]
                initWithChar:currentChar
                andValue:nil];
    }
    
    if(currentChar == node.c){
        if(index == key.length-1){
            //traversed all the string already, set the value
            node.value = object;
        }
        else{
            //we matched the character, stay on the center route and advance idx
            node.center = [self setObject:object
                                   forKey:key
                          withCurrentNode:node.center
                              andStrIndex:index+1];
        }
    }
    else if(currentChar > node.c){
        //no match! go right
        node.right = [self setObject:object
                              forKey:key
                     withCurrentNode:node.right
                         andStrIndex:index];
    }
    else{
        //no match! go left
        node.left = [self setObject:object
                             forKey:key
                    withCurrentNode:node.left
                        andStrIndex:index];
    }
    return node;
}

#pragma mark Objects that match pattern

/*!
 @method objectsThatMatchPattern:
 @abstract Returns all the key value pairs on the Trie that match the given pattern.
 @discussion You can use the dot character '.' to indicate "any character" and the
 asterisk character '*' to indicate "allow anything at the end". For example,
 @"ab..i*" matches @"abolish", @"abominate", @"abominableness"
 @"abcdiLOLOLOLOMGHEY" and others.
 @param pattern The pattern to search on the Trie
 @result Returns an NSDictionary containing all the key value pairs that
 match the given pattern
 */
-(NSDictionary*)objectsThatMatchPattern:(NSString *)pattern{
    NSMutableDictionary * matchingObjects = [NSMutableDictionary dictionary];
    if(pattern && pattern.length > 0){
        [self nodesForPattern:pattern
              withCurrentNode:self.root
                 patternIndex:0
                currentString:@""
         andCollectDictionary:matchingObjects];
    }
    return matchingObjects;
}

-(void)nodesForPattern:(NSString*)pattern
       withCurrentNode:(KAVTrieNode*)node
          patternIndex:(NSUInteger)index
         currentString:(NSString*)str
       andCollectDictionary:(NSMutableDictionary*)dict
{
    if(!node || index >= pattern.length) return;
    unichar currentChar = [pattern characterAtIndex:index];
    if(currentChar == ASTERISK_UNICODE){
        //asterisk character, add all children of this node.
        [self collect:str withDictionary:dict andNode:node];
        return;
    }
    if(currentChar < node.c || currentChar == DOT_UNICODE){
        [self nodesForPattern:pattern
              withCurrentNode:node.left
                 patternIndex:index
                currentString:str
              andCollectDictionary:dict];
    }
    if(currentChar > node.c || currentChar == DOT_UNICODE){
        [self nodesForPattern:pattern
              withCurrentNode:node.right
                 patternIndex:index
                currentString:str
         andCollectDictionary:dict];
    }
    if(currentChar == node.c || currentChar == DOT_UNICODE){
        NSString * newString = [str stringByAppendingFormat:@"%c", node.c];
        [self nodesForPattern:pattern
              withCurrentNode:node.center
                 patternIndex:index+1
                currentString:newString
         andCollectDictionary:dict];
        if(index >= pattern.length-1 && node.value){
            //found a word that matches the pattern, add.
            [dict setObject:node.value forKey:newString];
        }
    }
}

-(void)collect:(NSString*)prefix
withDictionary:(NSMutableDictionary*)dictionary
       andNode:(KAVTrieNode*)node
{
    if(node){
        NSString * newPrefix = [prefix stringByAppendingFormat:@"%c", node.c];
        if(node.value){
            //we are on a value node, save the key value pair
            [dictionary setObject:node.value forKey:newPrefix];
        }
        [self collect:prefix withDictionary:dictionary andNode:node.left];
        [self collect:newPrefix withDictionary:dictionary andNode:node.center];
        [self collect:prefix withDictionary:dictionary andNode:node.right];
    }
}

#pragma mark Longest prefix

/*!
 @method longestPrefixOf:
 @abstract Returns the string that has the longest prefix matching str
 @discussion For example, if your Trie contains the word @"hello" and the given
 prefix is @"helloh", then the method returns @"hello", and if the given prefix
 is @"!@#$" and your Trie contains only alphanumeric characters, the method will
 return nil.
 @param str The prefix to match
 @result Returns the string that has the longest prefix matching str, or nil if a
 string with the given prefix does not exist in the Trie.
 */
-(NSString*)longestPrefixOf:(NSString *)str
{
    if(!str || str.length == 0) return nil;
    NSInteger longestSubstring = [self longestPrefixForString:str
                                              withCurrentNode:self.root
                                                     strIndex:0
                                         andCurrentBestLength:0];
    return longestSubstring == 0 ? nil : [str substringToIndex:longestSubstring];
}

-(NSInteger)longestPrefixForString:(NSString*)str
                   withCurrentNode:(KAVTrieNode*)node
                          strIndex:(NSUInteger)index
              andCurrentBestLength:(NSInteger)bestLength
{
    if(!node){
        return bestLength;
    }
    
    unichar currentChar = [str characterAtIndex:index];
    if(currentChar < node.c){
        return [self longestPrefixForString:str
                            withCurrentNode:node.left
                                   strIndex:index
                       andCurrentBestLength:bestLength];
    }
    else if(currentChar > node.c){
        return [self longestPrefixForString:str
                            withCurrentNode:node.right
                                   strIndex:index
                       andCurrentBestLength:bestLength];
    }
    else if(index < str.length-1){
        NSInteger longest = bestLength;
        if(node.value){
            longest = MAX(index+1, bestLength);
        }
        return [self longestPrefixForString:str
                            withCurrentNode:node.center
                                   strIndex:index+1
                       andCurrentBestLength:longest];
    }
    else{
        return node.value ? str.length : bestLength;
    }
}

@end
