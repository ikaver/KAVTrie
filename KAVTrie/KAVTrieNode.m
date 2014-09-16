//
//  KAVTrieNode.m
//  KAVTrie
//
//  Created by Iosef Kaver on 3/5/14.
//  Copyright (c) 2014 Iosef Kaver. All rights reserved.
//

#import "KAVTrieNode.h"

@implementation KAVTrieNode

-(id)initWithChar:(unichar)c andValue:(id)value{
    if(self = [super init]){
        _c = c;
        _value = value;
    }
    return self;
}

@end
