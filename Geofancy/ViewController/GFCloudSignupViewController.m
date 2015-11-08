//
//  GFCloudSignupViewController.m
//  Geofancy
//
//  Created by Marcus Kida on 07.12.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import "GFCloudSignupViewController.h"
#import <PSTAlertController/PSTAlertController.h>

@interface GFCloudSignupViewController () {
    IBOutlet UITextField *_usernameTextField;
    IBOutlet UITextField *_emailTextField;
    IBOutlet UITextField *_passwordTextField;
    
    GFAppDelegate *_appDelegate;
}
@end

@implementation GFCloudSignupViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _appDelegate = (GFAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_usernameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction) signupAccount:(id)sender {
    if ([[_usernameTextField text] length] > 4 ||
        [[_emailTextField text] length] > 4 ||
        [[_passwordTextField text] length] > 4) {
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

        [[_appDelegate cloudManager] signupAccountWithUsername:[_usernameTextField text] andEmail:[_emailTextField text] andPassword:[_passwordTextField text] onFinish:^(NSError *error, GFCloudManagerSignupError gfcError) {
            
            [SVProgressHUD dismiss];
            
            if (!error) {
                // Account created successfully!
                
                [[_appDelegate cloudManager] loginToAccountWithUsername:[_usernameTextField text] andPassword:[_passwordTextField text] onFinish:^(NSError *error, NSString *sessionId) {
                    if (!error) {
                        [[GFSettings sharedSettings] setApiToken:sessionId];
                        [[GFSettings sharedSettings] persist];
                        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Note", nil)
                                                                                                   message:NSLocalizedString(@"Your account has been created successfully! You have been logged in automatically.", nil)
                                                                                            preferredStyle:PSTAlertControllerStyleAlert];
                        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) handler:^(PSTAlertAction *action) {
                            [[self navigationController] popViewControllerAnimated:YES];
                        }]];
                        [alertController showWithSender:sender controller:self animated:YES completion:nil];
                        
                    } else {
                        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Note", nil)
                                                                                                   message:NSLocalizedString(@"Your account has been created successfully! You may now sign in using the prvoided credentials.", nil)
                                                                                            preferredStyle:PSTAlertControllerStyleAlert];
                        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) handler:^(PSTAlertAction *action) {
                            [[self navigationController] popViewControllerAnimated:YES];
                        }]];
                        [alertController showWithSender:sender controller:self animated:YES completion:nil];
                    }
                }];
                
                
            } else if (gfcError == GFCloudManagerSignupErrorUserExisting) {
                // User already existing
                PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                                           message:NSLocalizedString(@"A user with the same Username / E-Mail address ist already existing. Please choose another one..", nil)
                                                                                    preferredStyle:PSTAlertControllerStyleAlert];
                [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) handler:nil]];
                [alertController showWithSender:sender controller:self animated:YES completion:nil];
            }
        }];
    } else {
        PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Note", nil)
                                                                                   message:NSLocalizedString(@"Please enter a Username and a Password which have a minimum of 5 chars.", nil)
                                                                            preferredStyle:PSTAlertControllerStyleAlert];
        [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) handler:nil]];
        [alertController showWithSender:sender controller:self animated:YES completion:nil];
    }
}

- (IBAction) readTos:(id)sender {
    PSTAlertController *alertController = [PSTAlertController alertControllerWithTitle:NSLocalizedString(@"Note", nil)
                                                                               message:NSLocalizedString(@"This will open up Safari and lead to our TOS. Sure?", nil)
                                                                        preferredStyle:PSTAlertControllerStyleAlert];
    [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"No", nil) style:PSTAlertActionStyleCancel handler:nil]];
    [alertController addAction:[PSTAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil) style:PSTAlertActionStyleDefault handler:^(PSTAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://my.geofancy.com/tos"]];
    }]];
    [alertController showWithSender:sender controller:self animated:YES completion:nil];
}

@end
