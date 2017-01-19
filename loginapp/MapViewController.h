//
//  MapViewController.h
//  loginapp
//
//  Created by Mihaela Pacalau on 8/25/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TimeLineTableViewController.h"
#import <MapKit/MapKit.h>
@class MKMapView;
@class MKUserLocation;

@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarItem;


@property (strong,nonatomic) MKPointAnnotation* pointAnnotation;
@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) UIView* subview;
@property (strong, nonatomic) UITextView* textView ;
@property (strong,nonatomic) NSString *text;


- (void) buildPathAction;

@end
