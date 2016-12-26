//
//  MapViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/25/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate,UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,CAAnimationDelegate> {

    
    UILongPressGestureRecognizer* longPressGestureRecognizer;
    MKDirections* directions;
    UIImageView *imageView;
    
}
@end

static NSString* keyForAnnotation=@"keyforanotation";

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    self.mapData = [[MapData alloc]init];
    self.mapData.userDefault =[NSUserDefaults standardUserDefaults];
    self.mapData.locationManager = [[CLLocationManager alloc] init];
    if ([self.mapData.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.mapData.locationManager requestWhenInUseAuthorization];
    }
    [self.mapData.locationManager startUpdatingLocation];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(longPressGestureAction:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.5f];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    NSLog(@"%f long:%f", [ self.mapData.userDefault doubleForKey:@"lat"],[self.mapData.userDefault doubleForKey:@"long"]);
    self.mapData.touchMapCoordinate = CLLocationCoordinate2DMake([ self.mapData.userDefault doubleForKey:@"lat"],[ self.mapData.userDefault doubleForKey:@"long"]);
    
    [self addAnnotations: self.mapData.touchMapCoordinate  withText:nil];
    //[self.mapView addAnnotation:[userDefault objectForKey:keyForAnnotation]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) longPressGestureAction : (UILongPressGestureRecognizer*) longPressGestureRecongnizer {
    
    CGPoint touchPoint = [longPressGestureRecongnizer locationInView:self.mapView];
     self.mapData.touchMapCoordinate  = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    NSLog(@" %@", NSStringFromCGPoint(touchPoint));
    NSLog(@"%f, %f",  self.mapData.touchMapCoordinate.latitude,  self.mapData.touchMapCoordinate.longitude);
    
    
    
    if (UIGestureRecognizerStateBegan != longPressGestureRecongnizer.state)
        return;
    
    self.subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
    self.subview.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    [self.subview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.subview];
    
    
    [self fadeInAnimation:self.view];
    
    self.subview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.subview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.subview.layer.shadowOpacity = 0.45f;
    self.subview.layer.shadowRadius = 60.0f;
    self.subview.layer.cornerRadius = 10.f;
    self.subview.layer.opacity = 0.95f;


    
   //TextView
    self.textView = [[UITextView alloc] init];
    [self.subview addSubview:self.textView];
    [self.textView setFrame:CGRectMake(0, 0, 300, 145)];
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    self.textView.layer.borderWidth = 5.0f;
    self.textView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.textView setFont:[UIFont systemFontOfSize:14.f]];
    self.textView.layer.cornerRadius = 10.f;
    [self.textView becomeFirstResponder];


  //Submit button
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subview addSubview:submitButton];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton setFrame:CGRectMake(130,450, 60, 50)];
    //[submitButton setBackgroundColor:[UIColor purpleColor]];
    [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(saveAnnotation:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    //addPhotoButton
    UIButton* photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subview addSubview:photoButton];
    [photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    [photoButton setFrame:CGRectMake(100,145,90,40)];
    [photoButton setBackgroundColor:[UIColor redColor]];
    [photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];

    
 //imageView
    imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0,185,300,270)];
    [imageView setBackgroundColor:[UIColor greenColor]];
    [self.subview addSubview:imageView];
    [self.mapView removeGestureRecognizer: longPressGestureRecognizer];
}


- (void) addAnnotations: (CLLocationCoordinate2D) touchMapCoordinate withText: (UITextView*) notificationTextView {
    
    _pointAnnotation = [[MKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = touchMapCoordinate;
    _pointAnnotation.title = @"Notification";
    _pointAnnotation.subtitle = notificationTextView.text;
    [self.mapView addAnnotation:_pointAnnotation];
    


}


- (void)saveAnnotation:(UIButton*)sender{
    
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    [self.textView becomeFirstResponder];
    [self addAnnotations:  self.mapData.touchMapCoordinate  withText: self.textView];
    [self fadeInAnimation:self.view];
    [self.subview removeFromSuperview];
//    longPressGestureRecognizer.cancelsTouchesInView = YES;
    
    [ self.mapData.userDefault setDouble: self.mapData.touchMapCoordinate.latitude forKey:@"lat"];
    [ self.mapData.userDefault setDouble: self.mapData.touchMapCoordinate.longitude forKey:@"long"];
    [ self.mapData.userDefault setObject:self.textView.text forKey:@"text"];
    [ self.mapData.userDefault synchronize];
    
}
-(void)addPhotos
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;

}

- (void) removeAnnotationAction: (UIButton*) sender {
    
 UIAlertController* removeAnnotationAlertController = [UIAlertController alertControllerWithTitle:@"Remove annotation" message:@"Do you really want to remove this annotation ?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* removeAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView removeAnnotation:_pointAnnotation];
        [self.mapView removeOverlays:self.mapView.overlays];

    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [removeAnnotationAlertController addAction:removeAction];
    [removeAnnotationAlertController addAction:cancelAction];
    
    [self presentViewController:removeAnnotationAlertController animated:YES completion:nil];
    
    
}


- (void) buildPathAction{
    
    if ([directions isCalculating]) {
        [directions cancel];
    }
    NSLog(@"a trimis %@",self.text);
    MKDirectionsRequest* directionRequest = [[MKDirectionsRequest alloc] init];
    directionRequest.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark* placemarkDestination = [[MKPlacemark alloc] initWithCoordinate:_pointAnnotation.coordinate addressDictionary:nil];
    
    MKMapItem* destinationMapItem = [[MKMapItem alloc] initWithPlacemark:placemarkDestination];
    
    directionRequest.destination = destinationMapItem;
    
    directionRequest.transportType = MKDirectionsTransportTypeWalking;
    
    directions = [[MKDirections alloc] initWithRequest:directionRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        [self.mapView removeOverlays:[self.mapView overlays]];
        
        NSMutableArray* routesPolyline = [NSMutableArray array];
        
        for (MKRoute* route in response.routes) {
            [routesPolyline addObject:route.polyline];
        }
        
        [self.mapView addOverlays:routesPolyline level:MKOverlayLevelAboveRoads];
        
    }];
}

#pragma Controol photos Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image =[info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MKMapViewDelegate

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKMapCamera* camera = [MKMapCamera cameraLookingAtCenterCoordinate:userLocation.coordinate fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude) eyeAltitude:10000];
        [self.mapView setCamera:camera animated:YES];
    
    
//        CLLocation *lock =[[CLLocation alloc] initWithLatitude:_pointAnnotation.coordinate.latitude longitude:_pointAnnotation.coordinate.longitude];
//        CLLocationDistance dist = [self.mapView.userLocation.location distanceFromLocation:lock]/1000;
//        NSLog(@"Distanta este %f  metri",dist);
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView* pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifer"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;

//    CUSTOM PIN IMAGE
//    pinAnnotationView.image = [UIImage imageNamed:@"gps-3.png"];
//    pinAnnotationView.centerOffset = CGPointMake(0, -32);
//    pinAnnotationView.layer.shadowColor = [UIColor blackColor].CGColor;
//    pinAnnotationView.layer.shadowOffset = CGSizeMake(20, 0);
//    pinAnnotationView.layer.shadowOpacity = 0.5;
//    pinAnnotationView.layer.shadowRadius = 3.0;
    
    UIButton* removeAnnotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [removeAnnotationButton addTarget:self action:@selector(removeAnnotationAction:) forControlEvents:UIControlEventTouchUpInside];
    pinAnnotationView.leftCalloutAccessoryView = removeAnnotationButton;

//    PATH BUTTON
    UIButton* pathAnnotationButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [pathAnnotationButton addTarget:self action:@selector(buildPathAction) forControlEvents:UIControlEventTouchUpInside];
    pinAnnotationView.rightCalloutAccessoryView = pathAnnotationButton;
    
    
    return pinAnnotationView;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    _pointAnnotation = view.annotation;
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 2.f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    return nil;
}

#pragma mark - Animation

-(void)fadeInAnimation:(UIView *)aView {
    
    CATransition *transition = [CATransition animation];
    transition.type =kCATransitionFade;
    transition.duration = 0.5f;
    transition.delegate = self;
    [aView.layer addAnimation:transition forKey:nil];
    
}

#pragma mark - Keyboard Hide

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Dealloc

- (void)dealloc {
    
    if([directions isCalculating])
        [directions cancel];
}

@end
