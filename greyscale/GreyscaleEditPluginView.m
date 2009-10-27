//
//  GreyscaleEditPluginView.m
//  greyscale
//
//  Created by Geoffrey Clements on 10/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GreyscaleEditPluginView.h"


typedef enum RectPointType
{
	UnknownRectPoint = 0,
	
	TopLeftRectPoint,
	TopCenterRectPoint,
	TopRightRectPoint,
	CenterLeftRectPoint,
	CenterRectPoint,
	CenterRightRectPoint,
	BottomLeftRectPoint,
	BottomCenterRectPoint,
	BottomRightRectPoint, 
	
	FirstRectPoint = TopLeftRectPoint,
	LastRectPoint = BottomRightRectPoint
}
RectPointType;


//==============================================================================
NSRect NSRectAlignToPoint(NSRect src, RectPointType srcRectPt, NSPoint modelPt)
{
	switch (srcRectPt)
	{
		case TopLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case TopCenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case TopRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y - NSHeight(src);
			break;
			
		case CenterLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case CenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case CenterRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y - NSHeight(src) / 2.0;
			break;
			
		case BottomLeftRectPoint:
			src.origin.x = modelPt.x;
			src.origin.y = modelPt.y;
			break;
			
		case BottomCenterRectPoint:
			src.origin.x = modelPt.x - NSWidth(src) / 2.0;
			src.origin.y = modelPt.y;			
			break;
			
		case BottomRightRectPoint:
			src.origin.x = modelPt.x - NSWidth(src);
			src.origin.y = modelPt.y;
			break;
			
		case UnknownRectPoint:
			break;
	}
	
	return(src);
}

//==============================================================================
NSPoint NSRectPoint(NSRect src, RectPointType rectPt)
{
	NSPoint	result = src.origin;
	
	switch (rectPt)
	{
		case TopLeftRectPoint:		result.x = NSMinX(src);	result.y = NSMaxY(src);	break;
		case TopCenterRectPoint:	result.x = NSMidX(src);	result.y = NSMaxY(src);	break;
		case TopRightRectPoint:		result.x = NSMaxX(src);	result.y = NSMaxY(src);	break;
			
		case CenterLeftRectPoint:	result.x = NSMinX(src);	result.y = NSMidY(src);	break;
		case CenterRectPoint:		result.x = NSMidX(src);	result.y = NSMidY(src);	break;
		case CenterRightRectPoint:	result.x = NSMaxX(src);	result.y = NSMidY(src);	break;
			
		case BottomLeftRectPoint:	result.x = NSMinX(src);	result.y = NSMinY(src);	break;
		case BottomCenterRectPoint:	result.x = NSMidX(src);	result.y = NSMinY(src);	break;
		case BottomRightRectPoint:	result.x = NSMaxX(src);	result.y = NSMinY(src);	break;
			
		case UnknownRectPoint:		result = src.origin;						break;
	}
	
	return(result);
}

//==============================================================================
NSRect NSRectAlignWithRect(NSRect src, RectPointType srcRectPt, NSRect model, RectPointType modelRectPt)
{
	return(NSRectAlignToPoint(src, srcRectPt, NSRectPoint(model, modelRectPt)));
}

static inline NSRect NSRectCenterOverRect(NSRect src, NSRect model)
{
	return(NSRectAlignWithRect(src, CenterRectPoint, model, CenterRectPoint));
}

//==============================================================================
NSRect NSRectScale(NSRect src, float scaleWidth, float scaleHeight)
{
	src.size.width *= scaleWidth;
	src.size.height *= scaleHeight;
	
	return(src);
}

//==============================================================================
NSRect NSRectUniformScale(NSRect src, float scale)
{
	return(NSRectScale(src, scale, scale));
}

//==============================================================================
NSRect NSRectScaleToFill2(NSRect src, NSRect model, float *scale)
{
	float	widthScale, heightScale, theScale;
	
	// If the model is empty, just return empty as well
	if (NSIsEmptyRect(model))
		return(NSZeroRect);
	
	// If the src is empty, just return the model
	if (NSIsEmptyRect(src))
		return(model);
	
	// Calculate the required scalings
	widthScale = model.size.width / src.size.width;
	heightScale = model.size.height / src.size.height;
	theScale = (widthScale < heightScale ? widthScale : heightScale);
	
	if (scale)
		*scale = theScale;
	
	// Choose the smaller scale and resize
	return(NSRectUniformScale(src, theScale));
}

//==============================================================================
NSRect NSRectScaleToFill(NSRect src, NSRect model)
{
	return(NSRectScaleToFill2(src, model, nil));
}

//==============================================================================
NSRect NSRectScaleToFit(NSRect src, NSRect model)
{
	// If we're already inside, we're done
	if (NSContainsRect(model, src))
		return(src);
	
	return(NSRectScaleToFill(src, model));
}

@implementation GreyscaleEditPluginView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
	CIImage *image = [_datasource valueForKey:@"outputImage"];
  
	// Draw this into my view.
	CGRect cgRect = image.extent;
	NSRect imageRect = NSMakeRect(0, 0, cgRect.size.width, cgRect.size.height);
	NSRect drawRect = NSRectCenterOverRect(NSRectScaleToFit(imageRect, rect), rect);
  
	[image drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
}

@end
