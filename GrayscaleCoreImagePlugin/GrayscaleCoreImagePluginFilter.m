//
//  GrayscaleCoreImagePluginFilter.m
//  GrayscaleCoreImagePlugin
//
//  Created by Geoffrey Clements on 10/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GrayscaleCoreImagePluginFilter.h"
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation GrayscaleCoreImagePluginFilter

static CIKernel *_GrayscaleCoreImagePluginFilterKernel = nil;

- (id)init
{
    if(_GrayscaleCoreImagePluginFilterKernel == nil) {
      NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"GrayscaleCoreImagePluginFilter")];
      NSStringEncoding encoding = NSUTF8StringEncoding;
      NSError     *error = nil;
      NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"GrayscaleCoreImagePluginFilterKernel" ofType:@"cikernel"] encoding:encoding error:&error];
      NSArray     *kernels = [CIKernel kernelsWithString:code];

      _GrayscaleCoreImagePluginFilterKernel = [[kernels objectAtIndex:0] retain];
    }
    return [super init];
}


- (CGRect)regionOf: (int)sampler  destRect: (CGRect)rect  userInfo: (NSNumber *)radius
{
  return CGRectInset(rect, -[radius floatValue], 0);
}


- (NSDictionary *)customAttributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:

            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
             [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
             [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
             [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
             [NSNumber numberWithDouble:  0.30], kCIAttributeDefault,
             [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
             kCIAttributeTypeScalar,           kCIAttributeType,
             nil],                               @"red",
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
             [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
             [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
             [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
             [NSNumber numberWithDouble:  0.59], kCIAttributeDefault,
             [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
             kCIAttributeTypeScalar,           kCIAttributeType,
             nil],                               @"green",
            
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
          [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
            [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
            [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
            [NSNumber numberWithDouble:  0.11], kCIAttributeDefault,
            [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
            kCIAttributeTypeScalar,           kCIAttributeType,
            nil],                               @"blue",

        nil];
}

// called when setting up for fragment program and also calls fragment program
- (CIImage *)outputImage
{
    CISampler *src = [CISampler samplerWithImage:inputImage];
    return [self apply:_GrayscaleCoreImagePluginFilterKernel, src,
        red,
        green,
        blue, kCIApplyOptionDefinition, [src definition], nil];
}

@end
