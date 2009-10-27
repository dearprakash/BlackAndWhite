//
//	greyscale.h
//	greyscale
//
//	Created by Geoffrey Clements on 10/19/09.
//	Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "ApertureEditPlugIn.h"
#import "ApertureEditManager.h"


@interface greyscale : NSObject <ApertureEditPlugIn>
{
	// The cached API Manager object, as passed to the -initWithAPIManager: method.
	id _apiManager; 
	
	// The cached Aperture Export Manager object - you should fetch this from the API Manager during -initWithAPIManager:
	NSObject<ApertureEditManager, PROAPIObject> *_editManager; 
		
	// Top-level objects in the nib are automatically retained - this array
	// tracks those, and releases them
	NSArray *_topLevelNibObjects;
	
	// Outlets to your plug-ins user interface
	IBOutlet NSWindow *_editWindow;
  
	// Put your stuff here
	IBOutlet NSButton *_previousButton;
	IBOutlet NSButton *_nextButton;
	IBOutlet NSButton *_revertButton;
	IBOutlet NSButton *_cancelButton;
	IBOutlet NSButton *_doneButton;
	IBOutlet NSView *_imageView;	
	IBOutlet NSSlider *_redSlider;
	IBOutlet NSSlider *_greenSlider;
	IBOutlet NSSlider *_blueSlider;
	IBOutlet NSSlider *_grainSlider;
	IBOutlet NSButton *_grainButton;
	
@private
	int _editingIndex;
	NSMutableArray *_imagePaths;
	NSMutableArray *_currentSettings;
	CIFilter *_imageFilter;
	CIFilter *_cropFilter;
	CIFilter *_blurFilter;
	CIFilter *_randomGenerator;
	CIFilter *_randomCrop;
}

- (IBAction)_cancelEditing:(id)sender;
- (IBAction)_doneEditing:(id)sender;
- (IBAction)_nextImage:(id)sender;
- (IBAction)_previousImage:(id)sender;
- (IBAction)_revertCurrentImage:(id)anArgument;
- (IBAction)_changeRedSlider:(id)sender;
- (IBAction)_changeGreenSlider:(id)sender;
- (IBAction)_changeBlueSlider:(id)sender;
- (IBAction)_changeGrainSlider:(id)sender;
- (IBAction)_filmGrainChanged:(id)sender;

- (CIImage *)outputImage;

@end
