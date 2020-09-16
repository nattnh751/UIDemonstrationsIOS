//
//  TreeNode.m
//  TreeNodePrototype
//
//  Created by Varun Naharia on 26/08/15.
//

#import "TreeNode.h"

@implementation TreeNode

@synthesize index, value,backgroundColor;
@synthesize parent, children;
@synthesize inclusive,size,parent_id,category_id,isSelected;

#pragma mark -
#pragma mark Initializers

- (id)initWithValue:(NSString *)_value showMe:(BOOL)show {
	self = [super init];
	if (self) {
		value = _value;
		inclusive = show;
        isSelected=NO;
	}
	
	return self;
}

#pragma mark -
#pragma mark Custom Properties

- (NSMutableArray *)children {
	if (!children) {
		children = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return children;
}

#pragma mark -
#pragma mark Methods

- (NSUInteger)descendantCount {
	NSUInteger cnt = 0;
	
	for (TreeNode *child in self.children) {
		if (self.inclusive) {
			cnt++;
			if (child.children.count > 0) {
				cnt += [child descendantCount];
			}
		}
	}
	
	return cnt;
}

- (NSArray *)flattenElements {
	return [self flattenElementsWithCacheRefresh:NO];
}

- (NSArray *)flattenElementsWithCacheRefresh:(BOOL)invalidate {
	if (!flattenedTreeCache || invalidate) {
		//if there was a previous cache and due for invalidate, release resources first
		if (flattenedTreeCache) {
			flattenedTreeCache = nil;
		}
		
		NSMutableArray *allElements = [[NSMutableArray alloc] initWithCapacity:[self descendantCount]] ;
		[allElements addObject:self];
		
		if (inclusive) {
			for (TreeNode *child in self.children) {
				[allElements addObjectsFromArray:[child flattenElementsWithCacheRefresh:invalidate]];
			}
		}
		
		flattenedTreeCache = [[NSArray alloc] initWithArray:allElements];
	}
	
	return flattenedTreeCache;
}

- (void)addChild:(TreeNode *)newChild {
	newChild.parent = self;
	[self.children addObject:newChild];
}

- (NSUInteger)levelDepth {
	if (!parent) return 0;
	
	NSUInteger cnt = 0;
	cnt++;
	cnt += [parent levelDepth];
	
	return cnt;
}

- (BOOL)isRoot {
	return (!parent);
}

- (NSArray *)unselectParents {
  TreeNode *runNode = self;
  NSMutableArray *arr = [NSMutableArray new];
  while (!runNode.isRoot) {
    if(runNode.parent.isGroup) {
      runNode.parent.isSelected = nil;
      [arr addObject:parent];
    }
    runNode = runNode.parent;
  }
  return [arr copy];
}

- (BOOL)hasChildren {
	return (self.children.count > 0);
}
@end

