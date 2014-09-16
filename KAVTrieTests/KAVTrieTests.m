//
//  KAVTrieTests.m
//  KAVTrieTests
//
//  Created by Iosef Kaver on 3/5/14.
//  Copyright (c) 2014 Iosef Kaver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KAVTrie.h"

@interface KAVTrieTests : XCTestCase

@property (nonatomic, strong) NSMutableArray * words;
@property (nonatomic, strong) KAVTrie * trie;

@end

static NSMutableArray * testWords;

@implementation KAVTrieTests

+(void)setUp{
    testWords = [self dictionaryAsArray];
    [self shuffleArray:testWords];
}

+(NSMutableArray*)dictionaryAsArray{
    NSString* filePath = @"dictionary";
    NSString* fileRoot = [[NSBundle bundleForClass:[self class]]
                          pathForResource:filePath ofType:@"txt"];

    NSString * dictionaryStr = [NSString stringWithContentsOfFile:fileRoot
                                     encoding:NSUTF8StringEncoding
                                        error:nil];
    return [[dictionaryStr componentsSeparatedByString:@"\n"] mutableCopy];
}

+(void)shuffleArray:(NSMutableArray*)array{
    for(NSInteger i = 1; i < array.count; ++i){
        NSInteger exchangeIndex = arc4random() % i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

- (void)setUp
{
    [super setUp];
    self.words = [testWords mutableCopy];
    self.trie = [[KAVTrie alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)addAllWords{
    for(NSString * word in self.words){
        [self.trie setObject:@1 forKey:word];
    }
}


-(void)testWildcardAndAsterisk{
    //Note that over 200000 words are inserted on the Trie.
    //Test runs pretty fast actually.
    [self addAllWords];

    NSDictionary * matches = [self.trie objectsThatMatchPattern:@"zyg.n*"];
    XCTAssert([matches objectForKey:@"zygantra"], @"Missing zygantra");
    XCTAssert([matches objectForKey:@"zygantrum"], @"Missing zygantrum");
    XCTAssert([matches objectForKey:@"zygoneure"], @"Missing zygoneur");
    XCTAssert(matches.count == 3, @"Found more objects than it should be");
    matches = [self.trie objectsThatMatchPattern:@"zygan*xlolol"];
    XCTAssert([matches objectForKey:@"zygantra"], @"Missing zygantra");
    XCTAssert([matches objectForKey:@"zygantrum"], @"Missing zygantrum");
    XCTAssert(matches.count == 2, @"Found more objects than it should be");
    matches = [self.trie objectsThatMatchPattern:@"an.m..i*"];
    for(NSString * str in matches.keyEnumerator) {
        XCTAssert([[str substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"an"], @"Bad prefix match");
        XCTAssert([str characterAtIndex:3] == 'm', @"Bad 4th character");
        XCTAssert([str characterAtIndex:6] == 'i', @"Bad 7th character");
    }
}



-(void)testLongestPrefix{
    //Note that over 200000 words are inserted on the Trie.
    //Test runs pretty fast actually.
    [self addAllWords];

    XCTAssert([[self.trie longestPrefixOf:@"zygoneurlolololol"] isEqualToString:@"zygon"],
              @"zygoneurlolololol should return zygon");
    XCTAssert([[self.trie longestPrefixOf:@"zygoneure"] isEqualToString:@"zygoneure"],
              @"zygoneure should return zygoneure");
    XCTAssert([[self.trie longestPrefixOf:@"mistak"] isEqualToString:@"mist"],
              @"mistak should return mist");
    XCTAssert([[self.trie longestPrefixOf:@"mistakebro"] isEqualToString:@"mistake"],
              @"mistakebro should return mistake");
    XCTAssert([[self.trie longestPrefixOf:@"helloh"] isEqualToString:@"hello"],
              @"helloh should return hello");
    XCTAssert([[self.trie longestPrefixOf:@"abnormalololol"] isEqualToString:@"abnormal"],
              @"abnormalololol should return abnormal");
    XCTAssert(![self.trie longestPrefixOf:@"#@$"],
              @"#@$ should return nil");
}

-(void)testFindAllWords{
    //Test with voer 200 000 words.
    [self addAllWords];

    for(NSInteger i = 0; i < self.words.count; ++i){
        XCTAssert([self.trie contains:self.words[i]], @"Couldn't find word: %@", self.words[i]);
    }
}

@end
