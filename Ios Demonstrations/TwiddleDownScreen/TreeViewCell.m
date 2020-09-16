//
//  TreeViewCell.m
//  TreeViewPrototype
//
//  Created by Varun Naharia on 26/08/15.
//

#import "TreeViewCell.h"
#import "UIColor+hex.h"
#define IMG_HEIGHT_WIDTH 20
#define IMG_WIDTH 20
#define CELL_HEIGHT 70
#define FEATURED_CELL_HEIGHT 110
#define SCREEN_WIDTH 320
#define LEVEL_INDENT 32
#define YOFFSET 23
#define XOFFSET 6

@interface TreeViewCell (Private)

- (UITextView *)newLabelWithPrimaryColor:(UIColor *)primaryColor
						   selectedColor:(UIColor *)selectedColor
								fontSize:(CGFloat)fontSize
									bold:(BOOL)bold;

@end


@implementation TreeViewCell

@synthesize valueLabel, arrowImage,delegate,underLine,size;
@synthesize level, expanded,isSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier level:(NSUInteger)_level expanded:(BOOL)_expanded isSelected:(BOOL)value hasChildren:(BOOL)_hasChildren size:(int64_t)size1 featured:(bool)feat {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
		int cell_height;
		if(feat) {
    		cell_height = FEATURED_CELL_HEIGHT;
    	} else {
    		cell_height = CELL_HEIGHT;
    	}
		self.level = (int)_level;
		self.featured = feat;
		if(feat) {
			self.featuredImage =  [[UIImageView alloc] initWithImage:
					[[UIImage imageNamed:@"featuredIcon"] imageWithRenderingMode:UIViewContentModeScaleAspectFill]];
      
			self.featuredText = [self newLabelWithPrimaryColor:[UIColor colorWithHexString:[SettingsManager stringForKey:@"858d97"]]
												 selectedColor:[UIColor colorWithHexString:[SettingsManager stringForKey:@"858d97"]]
													  fontSize:10.0 bold:NO];
			self.featuredText.text = @"Not Licensed To Sell";
			self.featuredText.textAlignment = NSTextAlignmentLeft;
			[self.contentView addSubview:self.featuredText];
			[self.contentView addSubview:self.featuredImage];
		}
		self.expanded = _expanded;
        self.isSelected=value;
        self.selectedView = [UIView new];
		self.subContentView = [UIView new];
		[self.selectedView  setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.subContentView];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			self.valueLabel =
					[self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor blackColor]
										  fontSize:12.0 bold:YES];
		} else {
			self.valueLabel =
					[self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor blackColor]
										  fontSize:15.0 bold:YES];
		}
		self.valueLabel.textAlignment = NSTextAlignmentLeft;

		[self.valueLabel setBackgroundColor:[UIColor clearColor]];
		self.valueLabel.clipsToBounds = YES;
	[self.contentView addSubview:self.valueLabel];
		self.size =
				[self newLabelWithPrimaryColor:[UIColor blackColor]
								 selectedColor:[UIColor blackColor]
									  fontSize:10.0 bold:YES];
		self.size.textAlignment = NSTextAlignmentRight;
		double convertedValue = (double) size1;
		int multiplyFactor = 0;

		NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];

		while (convertedValue > 1024) {
			convertedValue /= 1024;
			multiplyFactor++;
		}

		self.size.text = [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
		[self.contentView addSubview:self.size];

		self.cloudImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];

		isSelected = self.isSelected;
    self.arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.expanded ? @"DCArrowOpen" : @"DCArrowClose"]];
      [self.arrowImage setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *cornerCheck = [UIImage imageNamed:@"cornerCheckmark"];
      if([SettingsManager stringForKey:@"selectedCellColorForDCs"] || [SettingsManager boolForKey:@"useDefaultCornerImageOnDC"]) {
       self.cornerImage = [[UIImageView alloc] initWithImage:cornerCheck];
      } else {
        Session *sess = [AppDataRoomService sharedInstance].session;
        AccountInfo *acct = sess.selectedAccount;
        self.cornerImage = [[UIImageView alloc] initWithImage:[cornerCheck imageWithTint:acct.tintColor]];
      }
		if(self.isSelected) {
			[self.contentView addSubview:self.cornerImage];
		}
		if(_hasChildren) {
			[self.contentView addSubview:self.arrowImage];
		}
		[self.valueLabel setUserInteractionEnabled:YES];
		UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Checked:)];
		[singleTap setNumberOfTapsRequired:1];
        
		[self.selectedView addGestureRecognizer:singleTap];

		self.underLine =[[UIView alloc] initWithFrame:CGRectMake((self.contentView.bounds.origin.x + self.level + 2) * LEVEL_INDENT,
				cell_height-1,
				2048,
				1)];
        [self.underLine  setBackgroundColor:[UIColor blackColor]];
        if(self.expanded) {
            self.underLine.hidden = YES;
        } else {
            self.underLine.hidden = NO;
        }
			self.selectedView.frame = self.valueLabel.frame;

        self.subContentView.frame = CGRectMake((self.contentView.bounds.origin.x) * LEVEL_INDENT,
                                   0,
                                   self.contentView.frame.size.width-(self.contentView.bounds.origin.x) * LEVEL_INDENT,
                                   self.contentView.frame.size.height);
			[self.contentView addSubview:self.selectedView];
		[self.contentView addSubview:self.underLine];

    }
    return self;
}

-(void)Checked:(BOOL)value {
	if(!value) {
		self.selectedView.layer.borderWidth = 2.0f;
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCellColorForDCs"]) {
      self.selectedView.layer.borderColor = [[UIColor colorWithHexString:[SettingsManager stringForKey:@"selectedCellColorForDCs"]] CGColor];
    } else {
      Session *sess = [AppDataRoomService sharedInstance].session;
      AccountInfo *acct = sess.selectedAccount;
      self.selectedView.layer.borderColor = [acct.tintColor CGColor];
    }
	} else {
		self.selectedView.layer.borderWidth = 0.0f;
	}
		BOOL *temp = [delegate CellChecked:isSelected andCell:self];
}


#pragma mark -
#pragma mark Other overrides

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.bounds;
    if (!self.editing) {
		int cell_height;
		if(self.featured) {
			cell_height = FEATURED_CELL_HEIGHT;
		} else {
			cell_height = CELL_HEIGHT;
		}
		// get the X pixel spot
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		CGRect imgFrame;
		imgFrame = CGRectMake(((boundsX + self.level + 1) * LEVEL_INDENT) - (IMG_WIDTH + XOFFSET),
            self.featured ? ((CELL_HEIGHT-IMG_HEIGHT_WIDTH)/2) + (FEATURED_CELL_HEIGHT-CELL_HEIGHT): (cell_height-IMG_HEIGHT_WIDTH)/2,
				IMG_WIDTH,
				IMG_HEIGHT_WIDTH);
		self.arrowImage.frame = imgFrame;

		frame = CGRectMake(self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width+10,
				(cell_height-(cell_height-10))/2,
				[[UIScreen mainScreen] bounds].size.width - (self.level * LEVEL_INDENT),
				cell_height-10);
		frame = self.valueLabel.frame;
		[self.size sizeToFit];
		[self.valueLabel sizeToFit];

		if(self.featured) {
			frame.origin.x = self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width+10;
			frame.origin.y = FEATURED_CELL_HEIGHT-(CELL_HEIGHT/2)-(self.valueLabel.frame.size.height/2);
		} else {
			frame.origin.x = self.arrowImage.frame.origin.x+self.arrowImage.frame.size.width+10;
			frame.size.width = contentRect.size.width - (self.level * LEVEL_INDENT) - self.size.frame.size.width - self.arrowImage.frame.size.width-25;
			frame.origin.y = (CELL_HEIGHT-self.valueLabel.frame.size.height)/2;
		}
		self.valueLabel.frame = frame;
		[self.valueLabel sizeToFit];

		if(self.isSelected) {
			self.selectedView.layer.borderWidth = 2.0f;
      if([[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCellColorForDCs"]) {
        self.selectedView.layer.borderColor = [[UIColor colorWithHexString:[SettingsManager stringForKey:@"selectedCellColorForDCs"]] CGColor];
      } else {
        Session *sess = [AppDataRoomService sharedInstance].session;
        AccountInfo *acct = sess.selectedAccount;
        self.selectedView.layer.borderColor = [acct.tintColor CGColor];
      }
		} else {
			self.selectedView.layer.borderWidth = 0.0f;
		}
        CGRect underLineFrame =  CGRectMake((boundsX + self.level+1) * LEVEL_INDENT,
				cell_height-2,
                2048,
                1);
		[self.size sizeToFit];
		frame = self.size.frame;
		if(self.isSelected) {
			frame.origin.x = contentRect.size.width - frame.size.width - 15;
		} else {
			frame.origin.x = contentRect.size.width - frame.size.width - 5;
		}

    frame.origin.y = self.featured ? ((CELL_HEIGHT-self.size.frame.size.height)/2) + (FEATURED_CELL_HEIGHT-CELL_HEIGHT): (cell_height-self.size.frame.size.height)/2;

		self.size.frame = frame;
		frame = self.cornerImage.frame;
		frame.origin.y = 15;
		frame.origin.x = contentRect.size.width - frame.size.width - 5;
		self.cornerImage.frame = frame;
		frame.size.width = contentRect.size.width - self.valueLabel.frame.origin.x-5;
		frame.origin.x = self.valueLabel.frame.origin.x;
		frame.size.height = self.valueLabel.frame.size.height;
		frame.origin.y = self.cornerImage.frame.origin.y;
        self.selectedView.frame = frame;
        self.subContentView.frame = CGRectMake(underLineFrame.origin.x,
                                             2+(cell_height-CELL_HEIGHT),
                                             contentRect.size.width - self.valueLabel.frame.origin.x,
				CELL_HEIGHT-2);
		self.underLine.frame = underLineFrame;
		CGRect featuredImageFrame = CGRectMake((boundsX + self.level+1) * LEVEL_INDENT+5,
				(cell_height-CELL_HEIGHT-16)/2,
				16,
				16);
		CGRect featuredTextFrame = CGRectMake(featuredImageFrame.origin.x+featuredImageFrame.size.width+5,
				(cell_height-CELL_HEIGHT-25)/2,
				self.valueLabel.frame.size.width + 100,
				25);
		self.featuredText.frame = featuredTextFrame;
		self.featuredImage.frame = featuredImageFrame;
	}
}

#pragma mark -
#pragma mark Private category

- (UITextView *)newLabelWithPrimaryColor:(UIColor *)primaryColor
						selectedColor:(UIColor *)selectedColor 
							 fontSize:(CGFloat)fontSize 
								 bold:(BOOL)bold {
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }

	UITextView *newLabel = [[UITextView alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = YES;
  if([SettingsManager stringForKey:@"textColorForDownloadSelectionView"]) {
    newLabel.textColor = [UIColor colorWithHexString:[SettingsManager stringForKey:@"textColorForDownloadSelectionView"]];
  } else {
    newLabel.textColor = primaryColor;
  }
	newLabel.font = font;
	newLabel.editable = NO;
	newLabel.selectable = NO;
	return newLabel;
}


@end
