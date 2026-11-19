// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get network => 'No internet connection. Check your Wi-Fi.';

  @override
  String get timeout => 'Slow connection. Check your internet or try again.';

  @override
  String get server503 => 'Server temporarily unavailable. Try again later.';

  @override
  String get server5xx => 'Server error. Try again later.';

  @override
  String get authExpired => 'Session expired. Please log in again.';

  @override
  String get authForbidden => 'You don\'t have permission for this action.';

  @override
  String get notFound => 'Resource not found.';

  @override
  String get validation => 'Invalid data. Check the information.';

  @override
  String get unknown => 'Something unexpected happened. Try again.';

  @override
  String get authAppTitle => 'Bloco na Rua';

  @override
  String get authBackButton => 'Back';

  @override
  String get authAccountCreated => 'Account created. Please log in.';

  @override
  String get authRecoveryEmailSent => 'Recovery email sent!';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Log in to organize your block';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailRequired => 'Please enter an email';

  @override
  String get loginEmailInvalid => 'Invalid email';

  @override
  String get loginInvalidCredentials => 'Invalid email or password.';

  @override
  String get signupEmailInUse => 'This email is already in use.';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Please enter a password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginEnterButton => 'Log in';

  @override
  String get loginGoogleButton => 'Sign in with Google';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String loginRecoveryMessage(String email) {
    return 'We\'ll send a recovery link to $email';
  }

  @override
  String get loginSendButton => 'Send';

  @override
  String get loginCancel => 'Cancel';

  @override
  String get loginRegisterLink => 'Don\'t have an account? Sign up';

  @override
  String get signupTitle => 'Create your account';

  @override
  String get signupSubtitle => 'Join the party';

  @override
  String get signupNameLabel => 'Name';

  @override
  String get signupNameRequired => 'Please enter your name';

  @override
  String get signupEmailLabel => 'Email';

  @override
  String get signupEmailRequired => 'Please enter an email';

  @override
  String get signupEmailInvalid => 'Invalid email';

  @override
  String get signupPasswordLabel => 'Password';

  @override
  String get signupPasswordRequired => 'Please enter a password';

  @override
  String get signupPasswordMinLength =>
      'The password must be at least 8 characters long';

  @override
  String get signupPasswordHelper => 'At least 8 characters';

  @override
  String get signupPhoneLabel => 'Phone';

  @override
  String get signupPhoneRequired => 'Please enter a phone number';

  @override
  String get signupPhoneInvalid => 'Invalid phone number';

  @override
  String get signupSubmitButton => 'Sign up';

  @override
  String get signupLoginLink => 'Already have an account? Log in';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutMessage => 'You\'ll need to log in again to access the app.';

  @override
  String get logoutConfirm => 'Log out';

  @override
  String get logoutCancel => 'Cancel';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAppearanceSection => 'Appearance';

  @override
  String get profileInformationSection => 'Information';

  @override
  String get profileAccountSection => 'Account';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileNotAuthenticated => 'User not authenticated';

  @override
  String get profileNotInformed => 'Not provided';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileNotAvailable => 'Not available';

  @override
  String get profileDarkMode => 'Dark mode';

  @override
  String get profileChangePhotoLabel => 'Change profile picture';

  @override
  String get profileEditSoon => 'Profile editing coming soon';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get blocksListTitle => 'Blocks';

  @override
  String get blocksLoadingList => 'Loading blocks...';

  @override
  String get blocksEmptyTitle => 'No blocks yet';

  @override
  String get blocksEmptyMessage =>
      'Create a block to start organizing your carnival';

  @override
  String get blocksCreateAction => 'Create block';

  @override
  String get blocksCreateTitle => 'Create block';

  @override
  String get blocksCreateHeadline => 'Create your block';

  @override
  String get blocksCreateSubtitle =>
      'Name your street block and start organizing!';

  @override
  String get blocksCreate => 'Create';

  @override
  String get blocksCreateSuccess => 'Block created successfully!';

  @override
  String get blocksEditTitle => 'Edit block';

  @override
  String get blocksUpdateSuccess => 'Block updated successfully';

  @override
  String get blocksDeleteSuccess => 'Block deleted successfully';

  @override
  String get blocksDeleteTitle => 'Delete block';

  @override
  String get blocksDeleteConfirmMessage =>
      'Are you sure you want to delete this block? This action cannot be undone.';

  @override
  String get blocksDeleteConfirm => 'Delete';

  @override
  String get blocksCancel => 'Cancel';

  @override
  String get blocksLoadingBlock => 'Loading block...';

  @override
  String get blocksSaveChanges => 'Save changes';

  @override
  String get blocksImageLabel => 'Block image';

  @override
  String get blocksNoImage => 'No image';

  @override
  String get blockNameLabel => 'Block name';

  @override
  String get blockNameHint => 'e.g.: Saudade Block';

  @override
  String get blockNameRequired => 'Enter a name for the block';

  @override
  String get blockNameTooShort => 'Name is too short';

  @override
  String get blockNameTooLong => 'Name is too long';

  @override
  String get blockEditNameHint => 'e.g: Neighborhood Block';

  @override
  String get blocksJoinTitle => 'Join a block';

  @override
  String get blocksJoinHeadline => 'Join a block';

  @override
  String get blocksJoinSubtitle =>
      'Ask the block owner for the invite code to join.';

  @override
  String get blocksInviteCodeLabel => 'Invite code';

  @override
  String get blocksInviteCodeHint => 'Paste the code here';

  @override
  String get blocksInviteCodeRequired => 'Enter the invite code';

  @override
  String get blocksInviteCodeTooShort => 'Code is too short';

  @override
  String get blocksJoinSubmit => 'Join';

  @override
  String get blocksJoinSuccess => 'You joined the block!';

  @override
  String get blocksEmptyInviteCode => 'The invite code cannot be empty.';

  @override
  String get blocksInvalidId => 'Invalid block ID';

  @override
  String get blocksNotFound => 'Block not found';

  @override
  String get blocksNotFoundMessage => 'This block is not available.';

  @override
  String blocksUserDataError(String message) {
    return 'Could not load the user data: $message';
  }

  @override
  String blocksUnexpectedError(String message) {
    return 'Unexpected error: $message';
  }

  @override
  String blocksJoinFailed(String message) {
    return 'Could not join the block: $message';
  }

  @override
  String get blocksAddMemberTitle => 'Add member';

  @override
  String get blocksMemberSearchHint => 'Search by name or email';

  @override
  String get blocksMemberNotFoundTitle => 'No member found';

  @override
  String get blocksMemberNotFoundMessage =>
      'Try searching for another name or email.';

  @override
  String get blocksNoMemberTitle => 'No members available';

  @override
  String get blocksNoMemberMessage =>
      'There are no members to add to this block.';

  @override
  String blocksAddMemberTooltip(String name) {
    return 'Add $name to the block';
  }

  @override
  String get blocksMemberAddedSuccess => 'Member added successfully';

  @override
  String get blocksDetailsTitle => 'Block details';

  @override
  String get blocksCreateMeeting => 'Create meeting';

  @override
  String get blocksEditBlock => 'Edit block';

  @override
  String get blocksAdd => 'Add';

  @override
  String get blocksMeetingsSection => 'Meetings';

  @override
  String get blocksMembersSection => 'Members';

  @override
  String get blocksInviteCodeTitle => 'Invite code';

  @override
  String get blocksManagerCodeTitle => 'Manager code';

  @override
  String get blocksCodeCopied => 'Code copied!';

  @override
  String blocksShowCode(String title) {
    return 'Show $title';
  }

  @override
  String blocksHideCode(String title) {
    return 'Hide $title';
  }

  @override
  String blocksCopyCode(String title) {
    return 'Copy $title';
  }

  @override
  String get blocksLoadingMeetings => 'Loading meetings...';

  @override
  String get blocksNoMeetingsYet => 'No meetings yet';

  @override
  String get blocksNoTitle => 'No title';

  @override
  String get blocksLoadingMembers => 'Loading members...';

  @override
  String get blocksNoMembersYet => 'No members yet';

  @override
  String get blocksAdminsGroup => 'Admins';

  @override
  String get blocksModeratorsGroup => 'Moderators';

  @override
  String blocksGroupCount(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get blocksMemberFallback => 'Member';

  @override
  String blocksRemoveMemberTooltip(String name) {
    return 'Remove $name from the block';
  }

  @override
  String get blocksRemoveMemberTitle => 'Remove member';

  @override
  String get blocksRemoveMemberConfirm => 'Remove this member from the block?';

  @override
  String get blocksRemoveMemberAction => 'Remove';

  @override
  String get blocksRemoveMemberSuccess => 'Member removed successfully';

  @override
  String blocksRemoveMemberError(String message) {
    return 'Could not remove the member: $message';
  }

  @override
  String blocksMembersLoadFailed(int count) {
    return 'Failed to load data for $count member(s)';
  }

  @override
  String get blocksRoleAdmin => 'Admin';

  @override
  String get blocksRoleModerator => 'Moderator';

  @override
  String get blocksRoleMember => 'Member';

  @override
  String get meetingsListTitle => 'Meetings';

  @override
  String get meetingsSearchHint => 'Search meetings...';

  @override
  String get meetingsNoMeetingTitle => 'No meetings';

  @override
  String get meetingsNoMeetingMessage => 'You have no scheduled meetings yet';

  @override
  String get meetingsNoMeetingFoundTitle => 'No meeting found';

  @override
  String get meetingsNoMeetingFoundMessage => 'Try searching with other terms';

  @override
  String get meetingsCreateTitle => 'New meeting';

  @override
  String get meetingsEditTitle => 'Edit meeting';

  @override
  String get meetingsDetailsTitle => 'Meeting details';

  @override
  String get meetingsTitleLabel => 'Meeting title';

  @override
  String get meetingsTitleHint => 'E.g.: Full rehearsal';

  @override
  String get meetingsTitleRequired => 'Please enter a name for the meeting';

  @override
  String get meetingsEditTitleRequired => 'The meeting title is required';

  @override
  String get meetingsDescriptionLabel => 'Description';

  @override
  String get meetingsDescriptionHint => 'Details about the meeting (optional)';

  @override
  String get meetingsDateLabel => 'Date';

  @override
  String get meetingsTimeLabel => 'Time';

  @override
  String get meetingsDateTimeLabel => 'Date and time';

  @override
  String get meetingsSelectHint => 'Select';

  @override
  String get meetingsSelectDate => 'Select the date';

  @override
  String get meetingsSelectTime => 'Select the time';

  @override
  String get meetingsSelectDateSemantics => 'Select date';

  @override
  String get meetingsSelectTimeSemantics => 'Select time';

  @override
  String get meetingsSelectDateTimeSemantics => 'Select date and time';

  @override
  String get meetingsLocationLabel => 'Location';

  @override
  String get meetingsLocationHint => 'E.g.: Main square';

  @override
  String get meetingsLocationRequired =>
      'Please enter a location for the meeting';

  @override
  String get meetingsCreateButton => 'Create meeting';

  @override
  String get meetingsSaveButton => 'Save changes';

  @override
  String get meetingsCreateSuccess => 'Meeting created successfully';

  @override
  String get meetingsCreateError =>
      'Error while creating the meeting. Please try again.';

  @override
  String get meetingsUpdateSuccess => 'Meeting updated successfully!';

  @override
  String get meetingsInvalidBlockId => 'Invalid block ID';

  @override
  String get meetingsInvalidMeetingId => 'Invalid meeting ID';

  @override
  String get meetingsUnknownError => 'Unknown error';

  @override
  String get meetingsPresenceUpdated => 'Presence updated successfully!';

  @override
  String get meetingsDeleteError => 'Error while deleting the meeting';

  @override
  String get meetingsDeleteTitle => 'Delete meeting';

  @override
  String get meetingsDeleteConfirmMessage =>
      'Are you sure you want to delete this meeting? This action cannot be undone.';

  @override
  String get meetingsDeleteAction => 'Delete';

  @override
  String get meetingsCancel => 'Cancel';

  @override
  String get meetingsConfirm => 'Confirm';

  @override
  String get meetingsPresenceListTitle => 'Presence list';

  @override
  String get meetingsConfirmPresence => 'Confirm presence';

  @override
  String get meetingsStatusUpcoming => 'Upcoming';

  @override
  String get meetingsStatusDone => 'Finished';

  @override
  String get meetingsStatusSoon => 'Starting soon';

  @override
  String get meetingsPresent => 'Present';

  @override
  String get meetingsAbsent => 'Absent';

  @override
  String get meetingsMemberFallback => 'Member';

  @override
  String meetingsMemberNumber(int id) {
    return 'Member #$id';
  }

  @override
  String get meetingsLoadingPresences => 'Loading presences...';

  @override
  String get meetingsNoPresenceYet => 'Nobody confirmed presence yet';

  @override
  String get meetingsNoMemberFound => 'No member found';

  @override
  String get meetingsSearchMemberHint => 'Search member...';

  @override
  String meetingsMarkPresenceOf(String name) {
    return 'Mark presence of $name';
  }

  @override
  String get meetingsChangePresenceTitle => 'Change presence';

  @override
  String meetingsMarkPresent(String name) {
    return 'Mark $name as present?';
  }

  @override
  String meetingsMarkAbsent(String name) {
    return 'Mark $name as absent?';
  }

  @override
  String get meetingsSortFilterTooltip => 'Sort and filter';

  @override
  String get meetingsSortHeader => 'Sort';

  @override
  String get meetingsSortByName => 'Name (A-Z)';

  @override
  String get meetingsSortPresentFirst => 'Present first';

  @override
  String get meetingsSortAbsentFirst => 'Absent first';

  @override
  String get meetingsFilterHeader => 'Filter';

  @override
  String get meetingsFilterAll => 'All';

  @override
  String get meetingsFilterPresent => 'Present';

  @override
  String get meetingsFilterAbsent => 'Absent';

  @override
  String get meetingsNoData => 'No data found';

  @override
  String get homeAppTitle => 'Bloco na Rua';

  @override
  String get homeGreeting => 'Hello!';

  @override
  String get homeSubtitle => 'See your blocks and meetings';

  @override
  String get homeMyBlocks => 'My blocks';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNoBlocks => 'No blocks yet';

  @override
  String get homeCreateBlock => 'Create block';

  @override
  String get homeJoinBlock => 'Join a block';

  @override
  String get homeUpcomingMeetings => 'Upcoming meetings';

  @override
  String get homeNoMeetingsThisWeek => 'No meetings this week';

  @override
  String get errorTitle => 'Error';

  @override
  String get errorUnexpected => 'An unexpected error occurred.';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundMessage => 'The page you are looking for does not exist.';

  @override
  String get coreBack => 'Back';

  @override
  String get coreErrorTitle => 'Something went wrong';

  @override
  String get coreRetry => 'Try again';

  @override
  String get coreLoading => 'Loading...';

  @override
  String get coreSearchHint => 'Search...';

  @override
  String get coreClearSearch => 'Clear search';

  @override
  String get coreFabCreateOrJoinBlock => 'Create or join a block';

  @override
  String get coreFabCreateBlock => 'Create Block';

  @override
  String get coreFabJoinBlock => 'Join Block';

  @override
  String get coreDateNotSet => 'Date not set';

  @override
  String get coreMeetingFallback => 'Meeting';

  @override
  String corePresencesCount(int confirmed, int total) {
    return '$confirmed/$total presences';
  }

  @override
  String get corePresenceConfirmed => 'Confirmed';

  @override
  String get corePresencePending => 'Pending';

  @override
  String get corePresencePartial => 'Partial';

  @override
  String get coreLive => 'Live';

  @override
  String get coreNoName => 'No name';

  @override
  String get navHome => 'Home';

  @override
  String get navHomeTooltip => 'Go to home';

  @override
  String get navBlocks => 'Blocks';

  @override
  String get navBlocksTooltip => 'View the blocks';

  @override
  String get navMeetings => 'Meetings';

  @override
  String get navMeetingsTooltip => 'View the meetings';

  @override
  String get navProfile => 'Profile';

  @override
  String get navProfileTooltip => 'Open the profile';

  @override
  String get onboarding1Title => 'What is a block?';

  @override
  String get onboarding1Body =>
      'A carnival block is a group of people who come together to celebrate during the carnival season. Each block has its own identity, music and tradition.';

  @override
  String get onboarding2Title => 'Create or join a block';

  @override
  String get onboarding2Body =>
      'Join an existing block or create your own. Invite friends and family to join the fun!';

  @override
  String get onboarding3Title => 'Confirm your presence at the meetings';

  @override
  String get onboarding3Body =>
      'See your block\'s meetings and confirm your presence. Never miss a meeting again!';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get meetingsNotAuthenticated => 'User not authenticated';
}
