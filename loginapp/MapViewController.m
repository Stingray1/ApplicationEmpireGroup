//
//  MapViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/25/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SVPulsingAnnotationView.h"
#import <DXAnnotationView.h>
#import <DXAnnotationSettings.h>

//Test
#import "UserPinView.h"
#import "MainUserPinView.h"
#import "CalloutView.h"
@interface MapViewController () <MKMapViewDelegate,UIImagePickerControllerDelegate,
                                 UINavigationControllerDelegate,CAAnimationDelegate,CLLocationManagerDelegate> {

    
    UILongPressGestureRecognizer* longPressGestureRecognizer;
    MKDirections* directions;
    UIImageView *imageView;
    MKCircle *circle;
    CalloutView *mainUserCalloutView;
    CLLocationManager* locationManager;
    MKUserLocation* userLocation;
    CLLocationCoordinate2D touchMapCoordinate;
    
}
@end

static NSString* keyForAnnotation=@"keyforanotation";

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self navBarStyle];
   
    [self loadLocationManager];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                action:@selector(longPressGestureAction:)];
    [longPressGestureRecognizer setMinimumPressDuration:0.5f];
    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
    

}

-(void)navBarStyle
{
    
    UIButton *menuBar = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBar.bounds = CGRectMake( 0, 0, 21,15);
    [menuBar setImage:[UIImage imageNamed:@"burger menu.png"]
          forState:UIControlStateNormal];
    
    [menuBar addTarget:self
             action:@selector(barButtonBackPressed)
            forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBar];
    self.navigationBarItem.leftBarButtonItem = leftBarButtonItem;
    
    
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)barButtonBackPressed
{
    
}
#pragma MapDataLoad

-(void)loadLocationManager
{
    
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

#pragma mark - LongPressGestureActions

- (void) longPressGestureAction : (UILongPressGestureRecognizer*) longPressGestureRecongnizer {
    
    CGPoint touchPoint = [longPressGestureRecongnizer locationInView:self.mapView];
    touchMapCoordinate  = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    NSLog(@" %@", NSStringFromCGPoint(touchPoint));
    NSLog(@"%f, %f", touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    if (UIGestureRecognizerStateBegan != longPressGestureRecongnizer.state)
    {
        return;
    }
    else {
    
        [self addAnnotationFormView];
        [self.mapView removeGestureRecognizer: longPressGestureRecognizer];
        }
}

-(void)addAnnotationFormView
{
    
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
}

-(void)addPhotos
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
}

#pragma Control photos Delegate
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


#pragma AnnotationView

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
    [self addAnnotations: touchMapCoordinate  withText: self.textView];
    [self fadeInAnimation:self.view];
    [self.subview removeFromSuperview];
    
}

- (void) removeAnnotationAction: (UIButton*) sender {
    
        UIAlertController* removeAnnotationAlertController = [UIAlertController
                                                       alertControllerWithTitle:@"Remove annotation"
                                                       message:@"Do you really want to remove this annotation ?"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* removeAction = [UIAlertAction
                                                 actionWithTitle:@"Remove"
                                                 style:UIAlertActionStyleDestructive
                                                 handler:^(UIAlertAction * _Nonnull action) {
        [self.mapView removeAnnotation:_pointAnnotation];
        [self.mapView removeOverlays:self.mapView.overlays];
    }];
    
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                 style:UIAlertActionStyleCancel
                                                 handler:nil];
    
        [removeAnnotationAlertController addAction:removeAction];
        [removeAnnotationAlertController addAction:cancelAction];
    
        [self presentViewController:removeAnnotationAlertController animated:YES completion:nil];
    
    
}

#pragma mark - MKMapViewDelegate

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
   MKMapCamera* camera = [MKMapCamera
                          cameraLookingAtCenterCoordinate:userLocation.coordinate
                          fromEyeCoordinate:CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
                          eyeAltitude:10000];
    
   [self.mapView setCamera:camera animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    

    UIImageView *pinView = nil;
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        
          static NSString *identifier = @"currentLocation";
          SVPulsingAnnotationView*  pulsingView = [[SVPulsingAnnotationView alloc]
                                                   initWithAnnotation:annotation
                                                   reuseIdentifier:identifier];
        
            MainUserPinView *mainUserPinView = [[[ NSBundle mainBundle]
                                                  loadNibNamed:@"MainUserPinView"
                                                  owner:self
                                                  options:nil] lastObject];
            pulsingView.draggable=YES;
            UIImage *image1 =[self ChangeViewToImage:mainUserPinView];
            pulsingView.centerOffset = CGPointMake(0, -16.5f);
            [pulsingView setImage:image1];
            pulsingView.pulseColor =[UIColor redColor];
            pulsingView.canShowCallout = YES;
            return pulsingView;
    }
    else{

        CalloutView *userCalloutView = [[[NSBundle mainBundle]
                                            loadNibNamed:@"CalloutView"
                                            owner:self
                                            options:nil] lastObject];
        userCalloutView.photoObject.image = imageView.image;
        userCalloutView.infoObect.text = _pointAnnotation.subtitle;
        
        UserPinView *userPinView = [[[ NSBundle mainBundle]
                                        loadNibNamed:@"UserPinView"
                                        owner:self
                                        options:nil]lastObject];
        
        pinView =[[UIImageView alloc]initWithImage:[self ChangeViewToImage:userPinView]];
        
        DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
        if (!annotationView) {
            annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:NSStringFromClass([DXAnnotationView class])
                                                                  pinView:pinView
                                                              calloutView:userCalloutView
                                                                 settings:[DXAnnotationSettings defaultSettings]];
        }
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    _pointAnnotation = view.annotation;
    
}
#pragma ConvertorViewToImage
-(UIImage *) ChangeViewToImage : (UIView *) view{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return img;
}

#pragma renderingForOverlay
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* polylineRenderer = [[MKPolylineRenderer alloc]
                                                 initWithOverlay:overlay];
        polylineRenderer.lineWidth = 2.f;
        polylineRenderer.strokeColor = [UIColor redColor];
        return polylineRenderer;
    }
    return nil;
}
#pragma BuildPath

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

#pragma mark - Dealloc

- (void)dealloc {
    
    if([directions isCalculating])
        [directions cancel];
}

@end
