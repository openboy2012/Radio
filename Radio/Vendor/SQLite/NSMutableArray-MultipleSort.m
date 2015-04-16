//
//  NSMutableArray-MultipleSort.m
//  iContractor
//
//  Created by Jeff LaMarche on 1/16/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//
// This source may be used, free of charge, for any purposes. commercial or non-
// commercial. There is no attribution requirement, nor any need to distribute
// your source code. If you do redistribute the unmodified source code, you must
// leave the original header comments, but you may add additional ones.

#import "NSMutableArray-MultipleSort.h"

@implementation NSMutableArray(MultipleSort)
- (void)sortArrayUsingSelector:(SEL)comparator withPairedMutableArrays:(NSMutableArray *)array1, ...
{
    unsigned  int   stride = 1;
    BOOL  found = NO;
    NSUInteger  count = [self count];
    unsigned  int   d;
    
    while (stride <= count)
        stride = stride * STRIDE_FACTOR + 1;
    
    while (stride > (STRIDE_FACTOR - 1))
    {
        stride = stride / STRIDE_FACTOR;
        for (unsigned int c = stride; c < count; c++)
        {
            found = NO;
            if (stride > c)
                break;
            
            d = c - stride;
            while (!found)
            {
                id      a = [self objectAtIndex: d + stride];
                id      b = [self objectAtIndex: d];
                
                NSComparisonResult  result = (*compare)(a, b, (void *)comparator);
                
                if (result < 0)
                {
#if !__has_feature(objc_arc)
                    [a retain];
#endif
                    [self replaceObjectAtIndex: d + stride withObject: b];
                    [self replaceObjectAtIndex: d withObject: a];
                    
                    id eachObject;
                    va_list argumentList;
                    if (array1)
                    {
                        id a1 = [array1 objectAtIndex:d+stride];
                        id b1 = [array1 objectAtIndex:d];
#if !__has_feature(objc_arc)
                        [a1 retain];
#endif
                        [array1 replaceObjectAtIndex: d + stride withObject:b1];
                        [array1 replaceObjectAtIndex: d withObject: a1];
#if !__has_feature(objc_arc)
                        [a1 release];
#endif
                        va_start(argumentList, array1);
                        while ((eachObject = va_arg(argumentList, id)))
                        {
                            id ax = [eachObject objectAtIndex:d+stride];
                            id bx = [eachObject objectAtIndex:d];
#if !__has_feature(objc_arc)
                            [ax retain];
#endif
                            [eachObject replaceObjectAtIndex: d + stride withObject:bx];
                            [eachObject replaceObjectAtIndex: d withObject: ax];
#if !__has_feature(objc_arc)
                            [ax release];
#endif
                        }
                        va_end(argumentList);
                    }
#if !__has_feature(objc_arc)
                    [a release];
#endif
                    if (stride > d)
                        break;
                    
                    d -= stride;  
                }
                else
                    found = YES;
            }
        }
    }
}
@end
