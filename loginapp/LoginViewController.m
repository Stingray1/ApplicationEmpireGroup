//
//  ViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 8/24/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController () <UITabBarDelegate>
{
    CAGradientLayer *gradientLayer;
}

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    loginDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"user", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"user", nil]];

    [self designSketch];
    
   
    
    
    


}
#pragma mark - Navigation Bar
-(void)designSketch
{
    gradientLayer =[CAGradientLayer layer];
    gradientLayer.colors = @[(id)[[UIColor colorWithRed:(151/255.0) green:(157/255.0) blue:(183/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(146/255.0) green:(159/255.0) blue:(182/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(145/255.0) green:(170/255.0) blue:(194/255.0) alpha:0.9] CGColor]];
    [self.gradientImageView.layer addSublayer:gradientLayer];
    
    self.AuthentificationDesignView.layer.cornerRadius = 7;
    self.AuthentificationDesignView.layer.masksToBounds = YES;
    self.SignInButton.layer.cornerRadius = 7;
    self.SignInButton.layer.masksToBounds = YES;
    

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
    gradientLayer.frame = self.gradientImageView.bounds;

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - Actions

- (IBAction)logInButton:(UIButton *)sender {
    
   
    if ([[loginDictionary objectForKey: self.passwordField.text] isEqualToString:self.usernameField.text]) {
        NSLog(@"Succes");
        
        UITabBarController* tabBar =  [self.storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
        [self presentViewController:tabBar animated:YES completion:nil];

        
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
