//
//  KAVTrie.h
//  KAVTrie
//
//  Created by Iosef Kaver on 3/5/14.
//  Copyright (c) 2014 Iosef Kaver. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class KAVTrie
 @discussion Represents a Ternary Search Trie
 to support efficient queries on a collection of NSStrings 
 such as stringsThatMatchPattern: and longestPrefixOf:
 The asterisk (*) and dot (.) are reserved for special operations of the
 Trie so they shouldn't be used on the key's unless you don't want to use
 the objectsThatMatchPattern method.
 */
@interface KAVTrie : NSObject

/*!
 @method contains:
 @abstract Indicates if the given key is present on the Trie or not
 @discussion
 @param key The string to search on the Trie
 @result Returns YES iff the key is present on the Trie
 */
-(BOOL)contains:(NSString*)key;

/*!
 @method objectForKey:
 @abstract Returns the value associated with the key specified
 @discussion
 @param key The key of the value you're interested in
 @result Returns the value associated to the key if its present on the Trie,
 else, it returns nil.
 */
-(id)objectForKey:(NSString *)key;

/*!
 @method setObject:forKey:
 @abstract Adds the key value pair to the Trie.
 @discussion If the key is already present on the Trie, the value is overwritten.
Only the value is retained by the Trie, the key is NOT retained.
 @param key The key that will represent the object
 @param object The value to associate to the given key
 */
-(void)setObject:(id)object forKey:(NSString *)key;

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
-(NSDictionary*)objectsThatMatchPattern:(NSString *)pattern;

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
-(NSString*)longestPrefixOf:(NSString*)str;

@end
