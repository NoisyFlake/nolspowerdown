BOOL onLockscreen;

%group iOS10
	%hook SpringBoard
	-(void)frontDisplayDidChange:(id)newDisplay {
	  %orig(newDisplay);

		if ([newDisplay isKindOfClass:%c(SBDashBoardViewController)] ||
			[newDisplay isKindOfClass:%c(SBLockScreenViewController)]) {
			onLockscreen = YES;
		} else {
			onLockscreen = NO;
		}
	}
	%end
%end

%group iOS12
	%hook SBDashBoardViewController
	-(void)viewWillAppear:(BOOL)arg1 {
		%orig;
		onLockscreen = YES;
	}
	-(void)viewWillDisappear:(BOOL)arg1 {
		%orig;
		onLockscreen = NO;
	}
	%end
%end

%hook SBPowerDownController
-(void)orderFront {
	if (!onLockscreen) %orig;
}
%end

%ctor {
	// iOS 11 and up
	if (kCFCoreFoundationVersionNumber > 1400) {
		%init(iOS12);
	} else {
		%init(iOS10);
	}
	%init(_ungrouped);
}
