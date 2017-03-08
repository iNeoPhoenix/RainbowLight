//
//  MyViewController.h
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 28/03/09.
//  Copyright 2009 NeoPhoenix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyView;

@interface MyViewController : UIViewController {
	
	UIWindow*		m_Window;
	
	// Views
	MyView*			m_BackgroundColoredView;
	UIImageView*	m_PlayButtonImageView;
	UIImageView*	m_PauseButtonImageView;
	UISlider*		m_Slider;
	
	// Cached images
	UIImage*		m_playButtonImage;
	UIImage*		m_pauseButtonImage;
	UIImage*		m_TortleImage;
	UIImage*		m_RabbitImage;
	
	NSTimer*		animationTimer;
	
	// State
	BOOL			m_IsPlaying;
	float			m_Speed;
	CGFloat			m_Brightness;
	CGFloat			m_Hue;
}

@property (nonatomic, retain) UIWindow* window;
@property (nonatomic, retain) MyView* backgroundColoredView;
@property (nonatomic, retain) UIImageView* playButtonImageView;
@property (nonatomic, retain) UIImageView* pauseButtonImageView;
@property (nonatomic, retain) UISlider* slider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil window:(UIWindow*) window;
- (void) SliderActionCB:(id)sender;
- (void) PlayPauseCB;
- (void) MoreLUXCB;
- (void) LessLUXCB;

- (void) updateBackgroundColor;
- (void) startAnimation;
- (void) stopAnimation;


- (void) fadeOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;


@end
