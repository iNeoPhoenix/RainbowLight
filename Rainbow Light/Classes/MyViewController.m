//
//  MyViewController.m
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 28/03/09.
//  Copyright 2009 NeoPhoenix. All rights reserved.
//

#import "MyViewController.h"
#import "MyView.h"
#import "Notification.h"

@implementation MyViewController

@synthesize window = m_Window;
@synthesize backgroundColoredView = m_BackgroundColoredView;
@synthesize playButtonImageView = m_PlayButtonImageView;
@synthesize pauseButtonImageView = m_PauseButtonImageView;
@synthesize slider = m_Slider;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil window:(UIWindow*) window {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.window = window;
		
		// State
        m_Hue = 1.;
		m_Brightness = 1.;
		m_Speed = 1.;
		
		// Cached images
		m_playButtonImage  = [UIImage imageNamed:@"playButton.png"];
		m_pauseButtonImage = [UIImage imageNamed:@"pauseButton.png"];
		m_TortleImage      = [UIImage imageNamed:@"tortue.png"];
		m_RabbitImage      = [UIImage imageNamed:@"lapin.png"];
    }
    return self;
}

- (void)dealloc {
	[animationTimer invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:playPauseNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:moreLUXNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:lessLUXNotification object:nil];
	
	[self.backgroundColoredView release];
	[self.pauseButtonImageView release];
	[self.playButtonImageView release];
	[self.slider release];

	[self.window release];

    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView* rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	
	self.backgroundColoredView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.backgroundColoredView.userInteractionEnabled = YES;
	self.backgroundColoredView.multipleTouchEnabled = YES;
	self.backgroundColoredView.backgroundColor = [UIColor colorWithHue:m_Hue saturation:1. brightness:m_Brightness alpha:1.];
	[self.backgroundColoredView release];
	
	self.pauseButtonImageView = [[UIImageView alloc] initWithImage:m_pauseButtonImage];
	self.pauseButtonImageView.frame = CGRectMake(60, 140, 200, 200);
	self.pauseButtonImageView.userInteractionEnabled = NO;
	self.pauseButtonImageView.alpha = .7;
	[self.pauseButtonImageView release];
	
	self.playButtonImageView = [[UIImageView alloc] initWithImage:m_playButtonImage];
	self.playButtonImageView.frame = CGRectMake(60, 140, 200, 200);
	self.playButtonImageView.userInteractionEnabled = NO;
	self.playButtonImageView.alpha = .7;
	[self.playButtonImageView release];
	
	CGRect frame = CGRectMake(20.0, 420.0, 280.0, 25);
	self.slider = [[UISlider alloc] initWithFrame:frame];
	self.slider.minimumValue = 0.5;
	self.slider.maximumValue = 5;
	self.slider.alpha = .7;
	self.slider.minimumValueImage = m_TortleImage;
	self.slider.maximumValueImage = m_RabbitImage;
	[self.slider setValue:m_Speed animated:NO];
	[self.slider addTarget:self action:@selector(SliderActionCB:) forControlEvents:UIControlEventValueChanged];
	[self.slider release];
	
	[rootView addSubview:self.backgroundColoredView];
	[rootView addSubview:self.pauseButtonImageView];
	[rootView addSubview:self.playButtonImageView];
	[rootView addSubview:self.slider];
	
	
	self.view = rootView;
	[rootView release];
	
	[self startAnimation];
}

- (void)viewDidLoad
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayPauseCB) name:playPauseNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoreLUXCB) name:moreLUXNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LessLUXCB) name:lessLUXNotification object:nil];
}

- (void)SliderActionCB:(id)sender
{
	m_Speed = self.slider.value;
}

- (void) PlayPauseCB
{
	m_IsPlaying = !m_IsPlaying;
	if (m_IsPlaying) {
		[self startAnimation];
	} else {
		[self stopAnimation];
	}
}

- (void) MoreLUXCB
{
	m_Brightness += 0.01;
	if (m_Brightness > 1.) m_Brightness = 1.;
	self.backgroundColoredView.backgroundColor = [UIColor colorWithHue:m_Hue saturation:1. brightness:m_Brightness alpha:1.];
}
	
- (void) LessLUXCB
{
	m_Brightness -= 0.01;
	if (m_Brightness < 0.) m_Brightness = 0.;
	self.backgroundColoredView.backgroundColor = [UIColor colorWithHue:m_Hue saturation:1. brightness:m_Brightness alpha:1.];
}
	
-(void) updateBackgroundColor
{
	m_Hue += 1./2000 * m_Speed;
	if (m_Hue > 1) m_Hue -= 1.;
	self.backgroundColoredView.backgroundColor = [UIColor colorWithHue:m_Hue saturation:1. brightness:m_Brightness alpha:1.];
}
	
- (void)startAnimation
{
	m_IsPlaying = YES;
	self.playButtonImageView.hidden = NO;
	self.pauseButtonImageView.hidden = YES;
	self.slider.hidden = YES;
	
	//fade out
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeOutDidStop:finished:context:)];
	self.playButtonImageView.alpha = 0.;
	[UIView commitAnimations];
	//
	
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateBackgroundColor) userInfo:nil repeats:YES];
}

- (void)fadeOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.playButtonImageView.hidden = YES;
	self.playButtonImageView.alpha = 0.7;
	
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)stopAnimation
{
	m_IsPlaying = NO;
	self.playButtonImageView.hidden = YES;
	self.pauseButtonImageView.hidden = NO;
	
	if (VERSION > 1) {
		self.slider.hidden = NO;
	}
	
	[animationTimer invalidate];
	animationTimer = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	self.window.backgroundColor = [UIColor colorWithHue:m_Hue saturation:1. brightness:m_Brightness-0.2 alpha:1.];
	
	if (toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		self.backgroundColoredView.frame = CGRectMake(0, -20, 320, 480);
		self.pauseButtonImageView.frame = CGRectMake(60, 140, 200, 200);
		self.playButtonImageView.frame = CGRectMake(60, 140, 200, 200);
		self.slider.frame = CGRectMake(20.0, 420.0, 280.0, 25);
	}
		
	if (toInterfaceOrientation == UIDeviceOrientationLandscapeRight || toInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
		self.backgroundColoredView.frame = CGRectMake(0, -20, 480, 320);
		if (VERSION == 1) {
			self.pauseButtonImageView.frame = CGRectMake(140, 50, 200, 200);
			self.playButtonImageView.frame = CGRectMake(140, 50, 200, 200);
			self.slider.frame = CGRectMake(20.0, 420.0, 280.0, 25);
		} else {
			self.pauseButtonImageView.frame = CGRectMake(140, 25, 200, 200);
			self.playButtonImageView.frame = CGRectMake(140, 25, 200, 200);
			self.slider.frame = CGRectMake(100.0, 260.0, 280.0, 25);
		}
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

@end
