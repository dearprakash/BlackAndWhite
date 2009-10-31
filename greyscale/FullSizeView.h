//
//  FullSizeView.h
//  greyscale
//
//  Created by Geoffrey Clements on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FullSizeView : NSView {
	IBOutlet id _datasource;
  CGPoint lastMousePosition;
}

-(void)setLastMousePosition:(CGPoint)pt;

@end
