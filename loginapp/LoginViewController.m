//
//  ViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/24/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UtilitiesGradient.h"
#import "MapViewController.h"
@interface LoginViewController () <UITabBarDelegate>


@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    loginDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"user", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"user", nil]];
    
   
     [UtilitiesGradient designSketch:self.signInImage];
   
    
    
    


}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(void)viewDidLayoutSubviews
{
   

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Actions

- (IBAction)logInButton:(UIButton *)sender {
    
   
    if ([[loginDictionary objectForKey: self.passwordField.text] isEqualToString:self.usernameField.text]) {
        NSLog(@"Succes");
        
        MapViewController* mapView =  [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self presentViewController:mapView animated:YES completion:nil];

    } else {
        NSLog(@"Unsucces");
        NSLog(@"%@", self.usernameField.text);
        NSLog(@"%@", self.passwordField.text);
        
        UIAlertController* loginErrorAlertController = [UIAlertController alertControllerWithTitle:@"Error Signing In"
                                                                                 message:@"The user name or password is incorrect"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* loginErrorAlertAction = [UIAlertAction actionWithTitle:@"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction* _Nonnull action) {
                                                                      }];
        
        [loginErrorAlertController addAction:loginErrorAlertAction];
        [self presentViewController:loginErrorAlertController animated:YES completion:nil];
    }
}

- (IBAction)registerButtonAction:(UIButton *)sender {
    
    RegisterViewController *registerView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self presentViewController:registerView animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
