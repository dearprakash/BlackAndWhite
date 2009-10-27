//
//  GrayscaleCoreImagePluginPlugInLoader.h
//  GrayscaleCoreImagePlugin
//
//  Created by Geoffrey Clements on 10/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CoreImage.h>


@interface GrayscaleCoreImagePluginPlugInLoader : NSObject <CIPlugInRegistration>
{

}

-(BOOL)load:(void*)host;

@end
