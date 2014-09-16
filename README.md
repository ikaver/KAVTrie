KAVTrie
=======

Ternary Search Trie implementation for Objective-C

##Insert/Update

Inserting and updating elements is pretty easy:

```objc
KAVTrie * trie = [KAVTrie new];
[trie setObject:@"Wbatever you like" forKey:@"Your key string"];
[trie setObject:@"Thing that you want to associate with key" forKey:@"Another key"];
[trie setObject:@"This will overwrite first insertion" forKey: @"Your key string"];
```

##Pattern matching

In your queries, you can use a dot character '.' to specify "any character" and a asterisk '*' to specify "all of the matching strings with this prefix".

```objc
KAVTrie * trie = [KAVTrie new];
//insert elements here
NSDictionary * matches = [trie objectsThatMatchPattern:@"an.m..i*"];
//matches will contain words such as @"animative", @"animalization", @"anemosis", @"anomalistically" and more.
```

##Longest prefix queries

These types of queries simply returns the NSString key that matches the most characters of the given prefix.

```objc
KAVTrie * trie = [KAVTrie new];
//insert elements here
NSString * longestPrefix = [self.trie longestPrefixOf:@"helloBro"]; 
//returns @"hello", assuming @"hello" is a key of your trie and that you don't have another key such as @"helloB" inserted.
```

The contains operation is also supported.
