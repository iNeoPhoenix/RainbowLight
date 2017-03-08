//
//  Rainbow_LightAppDelegate.m
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 28/03/09.
//  Copyright NeoPhoenix 2009. All rights reserved.
//

#import "Rainbow_LightAppDelegate.h"
#import "MyViewController.h"

@implementation Rainbow_LightAppDelegate

@synthesize window;
@synthesize myViewController = m_MyViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	UIApplication* sharedApp = [UIApplication sharedApplication];
	sharedApp.idleTimerDisabled = YES;
	
	self.myViewController = [[MyViewController alloc] initWithNibName:nil bundle:nil window:window]; 
	[self.myViewController release];
	
    window.rootViewController = self.myViewController;
    
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
