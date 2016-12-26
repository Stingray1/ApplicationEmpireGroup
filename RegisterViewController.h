//
//  RegisterViewController.h
//  loginapp
//
//  Created by Mihaela Pacalau on 9/2/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIImageView *singUPImage;
@property (weak, nonatomic) IBOutlet UIView *dateViewDesign;
@property (weak, nonatomic) IBOutlet UIView *genderViewDesign;
@property (weak, nonatomic) IBOutlet UIButton *signUPButton;
@property (weak, nonatomic) IBOutlet UIView *cornerRadiusView;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UIButton *backToLoginButton;
- (IBAction)backToLoginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)RegisterButton:(id)sender;
@end
