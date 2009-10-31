//
//  grayscaleimageunitFilter.m
//  grayscaleimageunit
//
// Copyright (c) 2009 Geoffrey Clements
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "grayscaleimageunitFilter.h"
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation grayscaleimageunitFilter

static CIKernel *_grayscaleimageunitFilterKernel = nil;
static CIKernel *_noisygrayscaleimageunitFilterKernel = nil;

- (id)init
{
  if(_grayscaleimageunitFilterKernel == nil)
  {
		NSBundle    *bundle = [NSBundle bundleForClass:NSClassFromString(@"grayscaleimageunitFilter")];
		NSStringEncoding encoding = NSUTF8StringEncoding;
		NSError     *error = nil;
		NSString    *code = [NSString stringWithContentsOfFile:[bundle pathForResource:@"grayscaleimageunitFilterKernel" ofType:@"cikernel"] encoding:encoding error:&error];
		NSArray     *kernels = [CIKernel kernelsWithString:code];
    
		_grayscaleimageunitFilterKernel = [[kernels objectAtIndex:0] retain];
		_noisygrayscaleimageunitFilterKernel = [[kernels objectAtIndex:1] retain];
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
           [NSNumber numberWithDouble:  0.59], kCIAttributeDefault,
           [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
           kCIAttributeTypeScalar,             kCIAttributeType,
           nil],                               @"inputRedFactor",
          
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
           [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
           [NSNumber numberWithDouble:  0.30], kCIAttributeDefault,
           [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
           kCIAttributeTypeScalar,             kCIAttributeType,
           nil],                               @"inputGreenFactor",
          
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
           [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
           [NSNumber numberWithDouble:  0.11], kCIAttributeDefault,
           [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
           kCIAttributeTypeScalar,             kCIAttributeType,
           nil],                               @"inputBlueFactor",
          
          [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:  0.00], kCIAttributeMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeMax,
           [NSNumber numberWithDouble:  0.00], kCIAttributeSliderMin,
           [NSNumber numberWithDouble:  1.00], kCIAttributeSliderMax,
           [NSNumber numberWithDouble:  0.11], kCIAttributeDefault,
           [NSNumber numberWithDouble:  0.00], kCIAttributeIdentity,
           kCIAttributeTypeScalar,             kCIAttributeType,
           nil],                               @"inputNoiseFactor",
          
          [NSDictionary dictionaryWithObjectsAndKeys:
           @"CIImage",             kCIAttributeClass,
           nil],                               @"inputBackgroundImage",
          
          nil];
}

// called when setting up for fragment program and also calls fragment program
- (CIImage *)outputImage
{
  CISampler *src;
  CISampler *src2;
  
  src = [CISampler samplerWithImage:inputImage];
  if (inputBackgroundImage != nil) {
    src2 = [CISampler samplerWithImage:inputBackgroundImage];
    return [self apply:_noisygrayscaleimageunitFilterKernel, src, src2, inputRedFactor, inputGreenFactor, inputBlueFactor, inputNoiseFactor, nil];
  }
  return [self apply:_grayscaleimageunitFilterKernel, src, inputRedFactor, inputGreenFactor, inputBlueFactor, nil];
}

@end
