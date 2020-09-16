//
//  DownloadableSelectionView.h
//  AppDataRoom
//
//  Created by Nathan Walsh on 1/12/18.
//
#import <UIKit/UIKit.h>
#import "TreeView.h"
#import <WebKit/Webkit.h>

@interface DownloadableSelectionView : UIViewController <WKNavigationDelegate, WKUIDelegate>
{
    TreeView *tree;
}
@property (weak, nonatomic) IBOutlet UITextView *runningSizeTotal;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *backdrop;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *popup;
@property (weak, nonatomic) IBOutlet UITextView *sizeBeingDownloaded;
@property (strong, nonatomic) void (^onSizeChanged)(NSString *);
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *treeView;
@property (weak, nonatomic) IBOutlet UITextView *titleLabel;
@property(nonatomic,retain)NSMutableDictionary *dict;
@property (weak, nonatomic) IBOutlet UITextView *downloadWarningMessage;
@property(nonatomic,retain)NSMutableDictionary *cat;
@property double startingSizeOfSelected;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextView *popupHeaderTextView;
@property (weak, nonatomic) IBOutlet WKWebView *tutorialView;
@property (weak, nonatomic) IBOutlet UITextView *totalDownloadSizeText;
@property (weak, nonatomic) IBOutlet UITextView *totalDownloadSizeNumber;

@property(nonatomic, copy) void (^onComplete)(NSArray *categoriesForDownload);
@end
