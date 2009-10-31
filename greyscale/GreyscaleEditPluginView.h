//
//  GreyscaleEditPluginView.h
//  greyscale
//
//  Created by Geoffrey Clements on 10/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FullSizeView.h"


@interface GreyscaleEditPluginView : NSView {
	IBOutlet id _datasource;
  IBOutlet FullSizeView *_fullView;
  CGPoint lastMousePosition;
}

@end
