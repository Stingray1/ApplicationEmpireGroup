//
//  MapData.h
//  loginapp
//
//  Created by Vadim on 9/23/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapData : NSObject

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) MKUserLocation* userLocation;
@property (assign, nonatomic) CLLocationCoordinate2D touchMapCoordinate;
@property (assign , nonatomic) NSString *text;
@property (strong,nonatomic) NSUserDefaults *userDefault;
@end
