//
//  GrayscaleCoreImagePluginFilter.h
//  GrayscaleCoreImagePlugin
//
//  Created by Geoffrey Clements on 10/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface GrayscaleCoreImagePluginFilter : CIFilter
{
    CIImage      *inputImage;
    NSNumber     *red;
    NSNumber     *green;
    NSNumber     *blue;
}

@end
