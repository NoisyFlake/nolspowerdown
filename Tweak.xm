BOOL onLockscreen;

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

%hook SBPowerDownController
-(void)orderFront {
	if (!onLockscreen) %orig;
}
%end
