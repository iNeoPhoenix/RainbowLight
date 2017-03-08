//
//  Rainbow_LightAppDelegate.h
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 28/03/09.
//  Copyright NeoPhoenix 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyViewController;

@interface Rainbow_LightAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MyViewController* m_MyViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MyViewController* myViewController;

@end

