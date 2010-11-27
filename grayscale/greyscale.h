//
//	greyscale.h
//	greyscale
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
	IBOutlet NSView *_fullSizeView;
	IBOutlet NSSlider *_redSlider;
	IBOutlet NSTextField *_redLabel;
	IBOutlet NSSlider *_greenSlider;
	IBOutlet NSTextField *_greenLabel;
	IBOutlet NSSlider *_blueSlider;
	IBOutlet NSTextField *_blueLabel;
	IBOutlet NSSlider *_grainSlider;
	IBOutlet NSTextField *_grainLabel;
	IBOutlet NSButton *_grainButton;
	IBOutlet NSSlider *_sepiaSlider;
	IBOutlet NSTextField *_sepiaLabel;
	IBOutlet NSButton *_sepiaButton;
	IBOutlet NSSlider *_contrastSlider;
	IBOutlet NSTextField *_contrastLabel;
	IBOutlet NSSlider *_brightnessSlider;
	IBOutlet NSTextField *_brightnessLabel;
	
@private
	int _editingIndex;
	NSMutableArray *_imagePaths;
	NSMutableArray *_currentSettings;
	CIFilter *_imageFilter;
	CIFilter *_cropFilter;
	CIFilter *_blurFilter;
	CIFilter *_randomGenerator;
	CIFilter *_randomCrop;
	CIFilter *_sepiaFilter;
	CIFilter *_brightnessAndContrastFilter;
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
- (IBAction)_changeSepiaSlider:(id)sender;
- (IBAction)_changeContrastSlider:(id)sender;
- (IBAction)_changeBrightnessSlider:(id)sender;
- (IBAction)_filmGrainChanged:(id)sender;
- (IBAction)_sepiaChanged:(id)sender;

- (CIImage *)outputImage;

@end
