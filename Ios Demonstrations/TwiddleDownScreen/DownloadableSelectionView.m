//
//  DownloadableSelectionView.m
//  AppDataRoom
//
//  Created by Nathan Walsh on 1/12/18.
//

#import "DownloadableSelectionView.h"
#import "UIColor+hex.h"

@implementation DownloadableSelectionView
@synthesize dict,cat,logoImage,onComplete,backgroundImage,popup,headerView,sizeBeingDownloaded,runningSizeTotal,backdrop,tutorialView,titleLabel,doneButton,cancelButton,totalDownloadSizeText,totalDownloadSizeNumber,startingSizeOfSelected;

- (IBAction)Cancel:(id)sender {
    onComplete(nil);
}

- (IBAction)hidePopup:(id)sender {
    popup.hidden = YES;
}

- (IBAction)showPopup:(id)sender {
  if(tree.selectedArray.count > 0) {
    popup.hidden = NO;
    int64_t sizeOfCategories = 0;
    NSSet *mediaResources = [NSSet new];

    double totalSelectedSize = [tree sizeOfSelectNumber];
    double newMediaSize = totalSelectedSize - startingSizeOfSelected;
    if(([tree sizeOfSelectNumber]-startingSizeOfSelected)>15000000&&[SettingsManager boolForKey:@"showWarningForFifteenMbdownload"]) {
      BOOL celldata = ([AFNetworkReachabilityManager sharedManager].reachableViaWWAN && ![AFNetworkReachabilityManager sharedManager].reachableViaWiFi);
      NSString *message = celldata ? @"This content is larger than 15 Megabytes. You may want to connect to wifi before downloading. " : @"This content is larger than 15 Megabytes. ";
      [self.downloadWarningMessage setText:message];
      [sizeBeingDownloaded setText:[tree sizeOfSelected]];
      [self.contentView bringSubviewToFront:popup];
    } else {
      if([SettingsManager boolForKey:@"showWarningForFifteenMbdownload"]) {
        onComplete([tree getSelectedValue]);
      } else {
        //default is show popup
        if(newMediaSize < 0) {
          //TODO localize
          if(self.popupHeaderTextView)
            [self.popupHeaderTextView setText:@"You will be purging : "];
          
          [sizeBeingDownloaded setText:[StringHelper downloadSizeForBytes:(newMediaSize * -1)]];
        }
        else {
          //TODO localize
          if(self.popupHeaderTextView)
            [self.popupHeaderTextView setText:@"You will be downloading : "];
          [sizeBeingDownloaded setText:[StringHelper downloadSizeForBytes:newMediaSize]];
        }
        [totalDownloadSizeNumber setText:[StringHelper downloadSizeForBytes:totalSelectedSize]];
        [self.contentView bringSubviewToFront:popup];
      }
    }
  } else {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please select at least one category to download." message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.onSizeChanged = ^(NSString *newSize) {
        [runningSizeTotal setText:newSize];
    };
  if([SettingsManager stringForKey:@"statusBarBackgroundColor"])
  {
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:[SettingsManager stringForKey:@"statusBarBackgroundColor"]]];
  }
//  if([SettingsManager stringForKey:@"statusBarBackgroundColorForTwiddle"])
//  {
//    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:[SettingsManager stringForKey:@"statusBarBackgroundColorForTwiddle"]]];
//  }
  [self setNeedsStatusBarAppearanceUpdate];

}

- (void)userContentController:(WKUserContentController*)userContentController
      didReceiveScriptMessage:(WKScriptMessage*)message {


    NSDictionary *sentData = (NSDictionary *)message.body;
    NSString *methodName = [sentData valueForKey:@"methodName"];
    NSString *successCallBack = [sentData valueForKey:@"successCallback"];
    if ([methodName isEqualToString:@"getTranslations"]) {
        NSMutableArray *newlist = [NSMutableArray new];
        NSArray *data = [sentData valueForKey:@"data"];
        for(NSString *str in data) {
            [newlist addObject:[LocalizationHelper localize:str]];
        }
        NSData *setdata = [NSJSONSerialization dataWithJSONObject:newlist options:0 error:nil];
        NSString *string = [[NSString alloc] initWithData:setdata encoding:NSUTF8StringEncoding];
        NSString *jsCall = [NSString stringWithFormat:@"window.%@(%@);",successCallBack,string];
        [tutorialView evaluateJavaScript:jsCall completionHandler:nil];
    }
    if ([methodName isEqualToString:@"completeTutorial"]) {
        [tutorialView setHidden:YES];
    }
  if ([methodName isEqualToString:@"openLink"]) {
    NSString *data = [sentData valueForKey:@"data"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data]];
    [tutorialView setHidden:YES];

  }
}

- (void)viewWillAppear:(BOOL)animated {
  AFNetworkReachabilityStatus networkStatus;
  networkStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
  BOOL isConnected = networkStatus != AFNetworkReachabilityStatusNotReachable;
  if(isConnected) {
    titleLabel.textColor = [AppDataRoomService sharedInstance].session.selectedAccount.tintColor;
    [backgroundImage setImage:[ThemeHelper blurImage:backgroundImage.image]];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    [controller addScriptMessageHandler:self name:@"modus"];
    theConfiguration.userContentController = controller;
    CGRect webViewFrame = CGRectMake(40,30,self.view.bounds.size.width-80,self.view.bounds.size.height-60);
    tutorialView = [[WKWebView alloc] initWithFrame:webViewFrame configuration:theConfiguration];
    tutorialView.navigationDelegate = self;
    tutorialView.scrollView.bounces = NO;
    tutorialView.scrollView.scrollEnabled = NO;
    [tutorialView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tutorial" ofType:@"html"];
    UIButton *tutorialToggle = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if(path) {
      [tutorialToggle addTarget:self
                         action:@selector(showHideTutorial:)
               forControlEvents:UIControlEventTouchUpInside];
      tutorialToggle.frame = CGRectMake(10.0, [[UIScreen mainScreen] bounds].size.height-40, 30.0, 30.0);
      [tutorialView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:path]]];
      if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasShownTutorial"])
      {
        [tutorialView setHidden:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasShownTutorial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      } else {
        [tutorialView setHidden:YES];
      }
    }
    tree = [[TreeView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height+headerView.frame.origin.y + 8, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-headerView.frame.size.height - headerView.frame.origin.y) andData:nil sizeChangedBlock:self.onSizeChanged onInitializedBlock:^{
      self.startingSizeOfSelected = [tree sizeOfSelectNumber];
      self.onSizeChanged([tree sizeOfSelected]);
      [self setModalBusyMessage:nil];
    }];
    [tree setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:tree];
    if(path) {
      [self.contentView addSubview:tutorialToggle];
      [self.contentView addSubview:tutorialView];
    }
    UIFont *font =[UIFont fontWithName:@"Helvetica" size:10];
    [tree setTreeViewFont:font];
  } else {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You must be connected to Wi-Fi to download or remove content" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                           [self dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
  }

}

- (void)viewDidAppear:(BOOL)animated {
  if([[NSUserDefaults standardUserDefaults] stringForKey:@"loginReminderText"]&&![[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownLoginReminderText"]) {
    [self setModalBusyMessage:[[NSUserDefaults standardUserDefaults] stringForKey:@"loginReminderText"] withCancel:YES cancelButtonText:@"Ok" showProgressSpinner:NO];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasShownLoginReminderText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
    if(tree.initialized) {
      [self setModalBusyMessage:nil];
    } else {
      [self setModalBusyMessage:@"Loading..."];
    }
  }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
//    tree.frame = CGRectMake(0, 175, size.width, size.height-175);
//  } else {
    tree.frame = CGRectMake(0, 175, size.width,  size.height-175);
//  }
  [tree reloadData];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
//  UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//    statusBar.backgroundColor = color;
//  }
}

-(IBAction)doSync:(id)sender {
    onComplete([tree getSelectedValue]);
}

-(IBAction)showHideTutorial:(id)sender {
    [tutorialView setHidden:![tutorialView isHidden]];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  if([SettingsManager boolForKey:kSettingDarkStatusBarText] || [SettingsManager boolForKey:@"darkStatusBarTextOnTwiddle"]) {
    return UIStatusBarStyleDarkContent;
  } else {
    return UIStatusBarStyleDefault;
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)btnTap
{
    NSLog(@"%@",[tree getSelectedValue]);
}


@end
