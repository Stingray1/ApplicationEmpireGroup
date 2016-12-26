//
//  RegisterViewController.m
//  loginapp
//
//  Created by Mihaela Pacalau on 9/2/16.
//  Copyright © 2016 Marcel Spinu. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    
    UIDatePicker* datePicker;
    UIPickerView* genderPickerView;
    NSMutableArray* genderPickerViewData;
    UITextField* activeField;
    CAGradientLayer *gradientLayer;
}

@end

@implementation RegisterViewController

- (void)createPickerToolbarAction {
    UIToolbar* pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [pickerToolbar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:spaceButtonItem, doneButtonItem, nil]];
    
    [self.genderTextField setInputAccessoryView:pickerToolbar];
    [self.dateOfBirthTextField setInputAccessoryView:pickerToolbar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTextFieldTag];
    
    [self designSketch];
    genderPickerView = [[UIPickerView alloc] init];
    genderPickerView.delegate = self;
    genderPickerViewData = [[NSMutableArray alloc] initWithObjects:@"Male", @"Female", @"It's complicated", nil];
    //    self.genderTextField.inputView = genderPickerView;
    [self.genderTextField setInputView:genderPickerView];
    
    
    
    
    self.dateOfBirthTextField.delegate = self;
    datePicker = [[UIDatePicker alloc] init];
    //    [datePicker setDate:[NSDate date]];
    
    NSString* minDateString = @"01-Jan-1966";
    //    NSString* maxDateString = @"31-Dec-2000";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    
    NSDate* theMinimumDate = [dateFormatter dateFromString:minDateString];
    //    NSDate* theMaximumDate = [dateFormatter dateFromString:maxDateString];
    
    [datePicker setMinimumDate:theMinimumDate];
    [datePicker setMaximumDate:[NSDate date]];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker addTarget:self action:@selector(updateTextFieldAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.dateOfBirthTextField setInputView:datePicker];
    
    [self createPickerToolbarAction];
    
    
    
}

-(void)viewDidLayoutSubviews
{
    gradientLayer.frame = self.singUPImage.bounds;
    
}
-(void)designSketch
{
    gradientLayer =[CAGradientLayer layer];
    gradientLayer.colors = @[(id)[[UIColor colorWithRed:(151/255.0) green:(157/255.0) blue:(183/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(146/255.0) green:(159/255.0) blue:(182/255.0) alpha:0.9] CGColor],
                             (id)[[UIColor colorWithRed:(145/255.0) green:(170/255.0) blue:(194/255.0) alpha:0.9] CGColor]];
    [self.singUPImage.layer addSublayer:gradientLayer];
    self.cornerRadiusView.layer.cornerRadius = 7;
    self.firstNameTextField.layer.cornerRadius = 7;
    self.lastNameTextField.layer.cornerRadius = 7;
    self.emailTextField.layer.cornerRadius = 7;
    self.passwordTextField.layer.cornerRadius = 7;
    self.confirmPassword.layer.cornerRadius = 7;
    self.dateViewDesign.layer.cornerRadius = 7;
    self.genderViewDesign.layer.cornerRadius = 7;
    self.signUPButton.layer.cornerRadius = 7;
    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)setTextFieldTag
{
    self.firstNameTextField.tag =1;
    self.lastNameTextField.tag=2;
    self.emailTextField.tag=3;
    self.passwordTextField.tag=4;
    self.confirmPassword.tag=5;
}
- (void)updateTextFieldAction:(id) sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString* formattedString = [dateFormatter stringFromDate:datePicker.date];
    
    self.dateOfBirthTextField.text = formattedString;
}


- (void)doneButtonAction:(id) sender {
    
    [self.genderTextField resignFirstResponder];
    [self.dateOfBirthTextField resignFirstResponder];
    
}


#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return genderPickerViewData.count;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [genderPickerViewData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.genderTextField.text = genderPickerViewData[row];
}






///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}


// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0,_scrollView.center.y) animated:YES];
        [textField resignFirstResponder];
        
        return YES;
    }
    
    return NO;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)RegisterButton:(id)sender {
    
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginView animated:YES completion:nil];
    
}
- (IBAction)backToLoginAction:(id)sender {
    
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginView animated:YES completion:nil];
    
}
@end
