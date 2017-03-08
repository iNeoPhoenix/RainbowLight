//
//  MyView.h
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 29/03/09.
//  Copyright 2009 NeoPhoenix. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyView : UIImageView {
	CGFloat		m_PreviousDistance;	
	BOOL		m_ZoomInProgress;
}

- (CGFloat) distanceBetweenFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint) secondPoint;

@end
