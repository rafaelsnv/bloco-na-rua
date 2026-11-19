import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No internet connection or socket error
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your Wi-Fi.'**
  String get network;

  /// Connection timeout
  ///
  /// In en, this message translates to:
  /// **'Slow connection. Check your internet or try again.'**
  String get timeout;

  /// Server temporarily unavailable (503)
  ///
  /// In en, this message translates to:
  /// **'Server temporarily unavailable. Try again later.'**
  String get server503;

  /// Generic 5xx server errors
  ///
  /// In en, this message translates to:
  /// **'Server error. Try again later.'**
  String get server5xx;

  /// Authentication expired (401)
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get authExpired;

  /// Authorization forbidden (403)
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this action.'**
  String get authForbidden;

  /// Resource not found (404)
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get notFound;

  /// Validation error (400)
  ///
  /// In en, this message translates to:
  /// **'Invalid data. Check the information.'**
  String get validation;

  /// Unknown or unexpected error
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Try again.'**
  String get unknown;

  /// App name shown in the app bar of the auth screens
  ///
  /// In en, this message translates to:
  /// **'Bloco na Rua'**
  String get authAppTitle;

  /// Back button tooltip and semantics label of the auth screens
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get authBackButton;

  /// Confirmation shown after account creation
  ///
  /// In en, this message translates to:
  /// **'Account created. Please log in.'**
  String get authAccountCreated;

  /// Confirmation shown after requesting a password recovery e-mail
  ///
  /// In en, this message translates to:
  /// **'Recovery email sent!'**
  String get authRecoveryEmailSent;

  /// Login screen headline
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get loginTitle;

  /// Login screen subtitle under the headline
  ///
  /// In en, this message translates to:
  /// **'Log in to organize your block'**
  String get loginSubtitle;

  /// Login e-mail field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// Validation error when the login e-mail field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get loginEmailRequired;

  /// Validation error when the login e-mail is malformed
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get loginInvalidCredentials;

  /// No description provided for @signupEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get signupEmailInUse;

  /// Login password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// Validation error when the login password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get loginPasswordRequired;

  /// Tooltip and semantics label that reveal the password
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// Tooltip and semantics label that hide the password
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// Login submit button label
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginEnterButton;

  /// Button that starts Google OAuth sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get loginGoogleButton;

  /// Forgot password link and dialog title
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// Password recovery dialog message naming the e-mail
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a recovery link to {email}'**
  String loginRecoveryMessage(String email);

  /// Confirm button of the password recovery dialog
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get loginSendButton;

  /// Cancel button of the password recovery dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get loginCancel;

  /// Link from the login screen to the sign-up screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get loginRegisterLink;

  /// Sign-up screen headline
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signupTitle;

  /// Sign-up screen subtitle under the headline
  ///
  /// In en, this message translates to:
  /// **'Join the party'**
  String get signupSubtitle;

  /// Sign-up name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get signupNameLabel;

  /// Validation error when the sign-up name field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get signupNameRequired;

  /// Sign-up e-mail field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signupEmailLabel;

  /// Validation error when the sign-up e-mail field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get signupEmailRequired;

  /// Validation error when the sign-up e-mail is malformed
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get signupEmailInvalid;

  /// Sign-up password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signupPasswordLabel;

  /// Validation error when the sign-up password field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get signupPasswordRequired;

  /// Validation error when the sign-up password is too short
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 8 characters long'**
  String get signupPasswordMinLength;

  /// Helper text under the sign-up password field
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get signupPasswordHelper;

  /// Sign-up phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get signupPhoneLabel;

  /// Validation error when the sign-up phone field is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get signupPhoneRequired;

  /// Validation error when the sign-up phone is too short
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get signupPhoneInvalid;

  /// Sign-up submit button label
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signupSubmitButton;

  /// Link from the sign-up screen to the login screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get signupLoginLink;

  /// Logout button label and logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to access the app.'**
  String get logoutMessage;

  /// Logout confirmation dialog confirm button label
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutConfirm;

  /// Logout confirmation dialog cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logoutCancel;

  /// Profile screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Profile screen appearance section header
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearanceSection;

  /// Profile screen information section header
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get profileInformationSection;

  /// Profile screen account section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileAccountSection;

  /// Profile information row title for the phone number
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhoneLabel;

  /// Profile error shown when there is no authenticated user
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get profileNotAuthenticated;

  /// Profile information row value when the member did not inform it
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get profileNotInformed;

  /// Profile information row title for the membership date
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// Profile information row value when the date is unknown
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get profileNotAvailable;

  /// Dark mode switch title
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get profileDarkMode;

  /// Semantics label of the profile picture edit button
  ///
  /// In en, this message translates to:
  /// **'Change profile picture'**
  String get profileChangePhotoLabel;

  /// Snackbar shown when the profile edit button is tapped
  ///
  /// In en, this message translates to:
  /// **'Profile editing coming soon'**
  String get profileEditSoon;

  /// Settings screen app bar title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings screen account section header
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// App bar title of the blocks list screen
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get blocksListTitle;

  /// Loading message of the blocks list screen
  ///
  /// In en, this message translates to:
  /// **'Loading blocks...'**
  String get blocksLoadingList;

  /// Title of the empty state of the blocks list
  ///
  /// In en, this message translates to:
  /// **'No blocks yet'**
  String get blocksEmptyTitle;

  /// Message of the empty state of the blocks list
  ///
  /// In en, this message translates to:
  /// **'Create a block to start organizing your carnival'**
  String get blocksEmptyMessage;

  /// Call to action of the empty state of the blocks list
  ///
  /// In en, this message translates to:
  /// **'Create block'**
  String get blocksCreateAction;

  /// App bar title of the create block screen
  ///
  /// In en, this message translates to:
  /// **'Create block'**
  String get blocksCreateTitle;

  /// Headline of the create block screen
  ///
  /// In en, this message translates to:
  /// **'Create your block'**
  String get blocksCreateHeadline;

  /// Subtitle of the create block screen
  ///
  /// In en, this message translates to:
  /// **'Name your street block and start organizing!'**
  String get blocksCreateSubtitle;

  /// Generic create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get blocksCreate;

  /// Snackbar shown after a block is created
  ///
  /// In en, this message translates to:
  /// **'Block created successfully!'**
  String get blocksCreateSuccess;

  /// App bar title of the edit block screen
  ///
  /// In en, this message translates to:
  /// **'Edit block'**
  String get blocksEditTitle;

  /// Snackbar shown after a block is updated
  ///
  /// In en, this message translates to:
  /// **'Block updated successfully'**
  String get blocksUpdateSuccess;

  /// Snackbar shown after a block is deleted
  ///
  /// In en, this message translates to:
  /// **'Block deleted successfully'**
  String get blocksDeleteSuccess;

  /// Title of the delete block dialog and label of the delete button
  ///
  /// In en, this message translates to:
  /// **'Delete block'**
  String get blocksDeleteTitle;

  /// Message of the delete block confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this block? This action cannot be undone.'**
  String get blocksDeleteConfirmMessage;

  /// Confirm button label of the delete block dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get blocksDeleteConfirm;

  /// Cancel button label of the block dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get blocksCancel;

  /// Loading message of the edit block screen
  ///
  /// In en, this message translates to:
  /// **'Loading block...'**
  String get blocksLoadingBlock;

  /// Save button label of the edit block screen
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get blocksSaveChanges;

  /// Caption under the block image in the edit block screen
  ///
  /// In en, this message translates to:
  /// **'Block image'**
  String get blocksImageLabel;

  /// Caption under the block image placeholder in the edit block screen
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get blocksNoImage;

  /// Label of the block name field
  ///
  /// In en, this message translates to:
  /// **'Block name'**
  String get blockNameLabel;

  /// Hint of the block name field in the create block screen
  ///
  /// In en, this message translates to:
  /// **'e.g.: Saudade Block'**
  String get blockNameHint;

  /// Validation error when the block name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the block'**
  String get blockNameRequired;

  /// Validation error when the block name is too short
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get blockNameTooShort;

  /// Validation error when the block name is too long
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get blockNameTooLong;

  /// Hint of the block name field in the edit block screen
  ///
  /// In en, this message translates to:
  /// **'e.g: Neighborhood Block'**
  String get blockEditNameHint;

  /// App bar title of the join block screen
  ///
  /// In en, this message translates to:
  /// **'Join a block'**
  String get blocksJoinTitle;

  /// Headline of the join block screen
  ///
  /// In en, this message translates to:
  /// **'Join a block'**
  String get blocksJoinHeadline;

  /// Subtitle of the join block screen
  ///
  /// In en, this message translates to:
  /// **'Ask the block owner for the invite code to join.'**
  String get blocksJoinSubtitle;

  /// Label of the invite code field
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get blocksInviteCodeLabel;

  /// Hint of the invite code field
  ///
  /// In en, this message translates to:
  /// **'Paste the code here'**
  String get blocksInviteCodeHint;

  /// Validation error when the invite code is empty
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code'**
  String get blocksInviteCodeRequired;

  /// Validation error when the invite code is too short
  ///
  /// In en, this message translates to:
  /// **'Code is too short'**
  String get blocksInviteCodeTooShort;

  /// Submit button label of the join block screen
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get blocksJoinSubmit;

  /// Snackbar shown after joining a block
  ///
  /// In en, this message translates to:
  /// **'You joined the block!'**
  String get blocksJoinSuccess;

  /// Error shown when the invite code is empty
  ///
  /// In en, this message translates to:
  /// **'The invite code cannot be empty.'**
  String get blocksEmptyInviteCode;

  /// Error shown when the block id cannot be parsed
  ///
  /// In en, this message translates to:
  /// **'Invalid block ID'**
  String get blocksInvalidId;

  /// Error shown when the block does not exist
  ///
  /// In en, this message translates to:
  /// **'Block not found'**
  String get blocksNotFound;

  /// Message of the empty state of the block details screen
  ///
  /// In en, this message translates to:
  /// **'This block is not available.'**
  String get blocksNotFoundMessage;

  /// Error shown when the current user cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load the user data: {message}'**
  String blocksUserDataError(String message);

  /// Error shown when an unexpected failure happens
  ///
  /// In en, this message translates to:
  /// **'Unexpected error: {message}'**
  String blocksUnexpectedError(String message);

  /// Error shown when joining a block fails
  ///
  /// In en, this message translates to:
  /// **'Could not join the block: {message}'**
  String blocksJoinFailed(String message);

  /// App bar title of the add member screen
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get blocksAddMemberTitle;

  /// Hint of the member search field
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get blocksMemberSearchHint;

  /// Title of the empty state of the member search
  ///
  /// In en, this message translates to:
  /// **'No member found'**
  String get blocksMemberNotFoundTitle;

  /// Message of the empty state of the member search
  ///
  /// In en, this message translates to:
  /// **'Try searching for another name or email.'**
  String get blocksMemberNotFoundMessage;

  /// Title of the empty state of the add member screen
  ///
  /// In en, this message translates to:
  /// **'No members available'**
  String get blocksNoMemberTitle;

  /// Message of the empty state of the add member screen
  ///
  /// In en, this message translates to:
  /// **'There are no members to add to this block.'**
  String get blocksNoMemberMessage;

  /// Tooltip of the button that adds a member to the block
  ///
  /// In en, this message translates to:
  /// **'Add {name} to the block'**
  String blocksAddMemberTooltip(String name);

  /// Snackbar shown after a member is added
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get blocksMemberAddedSuccess;

  /// App bar title of the block details screen
  ///
  /// In en, this message translates to:
  /// **'Block details'**
  String get blocksDetailsTitle;

  /// Semantics label and tooltip of the create meeting button
  ///
  /// In en, this message translates to:
  /// **'Create meeting'**
  String get blocksCreateMeeting;

  /// Semantics label and tooltip of the edit block button
  ///
  /// In en, this message translates to:
  /// **'Edit block'**
  String get blocksEditBlock;

  /// Label of the add member section action
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get blocksAdd;

  /// Title of the meetings section of the block details screen
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get blocksMeetingsSection;

  /// Title of the members section of the block details screen and of the regular members group
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get blocksMembersSection;

  /// Title of the invite code card
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get blocksInviteCodeTitle;

  /// Title of the manager code card
  ///
  /// In en, this message translates to:
  /// **'Manager code'**
  String get blocksManagerCodeTitle;

  /// Snackbar shown after copying a block code
  ///
  /// In en, this message translates to:
  /// **'Code copied!'**
  String get blocksCodeCopied;

  /// Tooltip of the button that reveals a hidden code
  ///
  /// In en, this message translates to:
  /// **'Show {title}'**
  String blocksShowCode(String title);

  /// Tooltip of the button that hides a visible code
  ///
  /// In en, this message translates to:
  /// **'Hide {title}'**
  String blocksHideCode(String title);

  /// Tooltip of the button that copies a code
  ///
  /// In en, this message translates to:
  /// **'Copy {title}'**
  String blocksCopyCode(String title);

  /// Loading message of the meetings section
  ///
  /// In en, this message translates to:
  /// **'Loading meetings...'**
  String get blocksLoadingMeetings;

  /// Empty message of the meetings section
  ///
  /// In en, this message translates to:
  /// **'No meetings yet'**
  String get blocksNoMeetingsYet;

  /// Fallback title of a meeting without a name
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get blocksNoTitle;

  /// Loading message of the members section
  ///
  /// In en, this message translates to:
  /// **'Loading members...'**
  String get blocksLoadingMembers;

  /// Empty message of the members section
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get blocksNoMembersYet;

  /// Title of the admins group in the members section
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get blocksAdminsGroup;

  /// Title of the moderators group in the members section
  ///
  /// In en, this message translates to:
  /// **'Moderators'**
  String get blocksModeratorsGroup;

  /// Title of a member group with the number of members
  ///
  /// In en, this message translates to:
  /// **'{title} ({count})'**
  String blocksGroupCount(String title, int count);

  /// Fallback name of a member whose data could not be loaded
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get blocksMemberFallback;

  /// Tooltip of the button that removes a member from the block
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the block'**
  String blocksRemoveMemberTooltip(String name);

  /// Title of the remove member confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get blocksRemoveMemberTitle;

  /// Message of the remove member confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Remove this member from the block?'**
  String get blocksRemoveMemberConfirm;

  /// Confirm button label of the remove member dialog
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get blocksRemoveMemberAction;

  /// Snackbar shown after a member is removed
  ///
  /// In en, this message translates to:
  /// **'Member removed successfully'**
  String get blocksRemoveMemberSuccess;

  /// Snackbar shown when a member cannot be removed
  ///
  /// In en, this message translates to:
  /// **'Could not remove the member: {message}'**
  String blocksRemoveMemberError(String message);

  /// Snackbar shown when some member data could not be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load data for {count} member(s)'**
  String blocksMembersLoadFailed(int count);

  /// Label of the admin role
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get blocksRoleAdmin;

  /// Label of the moderator role
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get blocksRoleModerator;

  /// Label of the regular member role
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get blocksRoleMember;

  /// App bar title of the meetings list screen
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get meetingsListTitle;

  /// Hint of the meetings search field
  ///
  /// In en, this message translates to:
  /// **'Search meetings...'**
  String get meetingsSearchHint;

  /// Empty state title of the meetings list
  ///
  /// In en, this message translates to:
  /// **'No meetings'**
  String get meetingsNoMeetingTitle;

  /// Empty state message of the meetings list
  ///
  /// In en, this message translates to:
  /// **'You have no scheduled meetings yet'**
  String get meetingsNoMeetingMessage;

  /// Empty state title when a meeting search returns nothing
  ///
  /// In en, this message translates to:
  /// **'No meeting found'**
  String get meetingsNoMeetingFoundTitle;

  /// Empty state message when a meeting search returns nothing
  ///
  /// In en, this message translates to:
  /// **'Try searching with other terms'**
  String get meetingsNoMeetingFoundMessage;

  /// App bar title of the create meeting screen
  ///
  /// In en, this message translates to:
  /// **'New meeting'**
  String get meetingsCreateTitle;

  /// App bar title of the edit meeting screen
  ///
  /// In en, this message translates to:
  /// **'Edit meeting'**
  String get meetingsEditTitle;

  /// App bar title of the meeting details screen
  ///
  /// In en, this message translates to:
  /// **'Meeting details'**
  String get meetingsDetailsTitle;

  /// Label of the meeting title field
  ///
  /// In en, this message translates to:
  /// **'Meeting title'**
  String get meetingsTitleLabel;

  /// Hint of the meeting title field
  ///
  /// In en, this message translates to:
  /// **'E.g.: Full rehearsal'**
  String get meetingsTitleHint;

  /// Validation error when the meeting title is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a name for the meeting'**
  String get meetingsTitleRequired;

  /// Validation error when the meeting title is empty while editing
  ///
  /// In en, this message translates to:
  /// **'The meeting title is required'**
  String get meetingsEditTitleRequired;

  /// Label of the meeting description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get meetingsDescriptionLabel;

  /// Hint of the meeting description field
  ///
  /// In en, this message translates to:
  /// **'Details about the meeting (optional)'**
  String get meetingsDescriptionHint;

  /// Label of the meeting date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get meetingsDateLabel;

  /// Label of the meeting time field
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get meetingsTimeLabel;

  /// Label of the meeting date and time field
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get meetingsDateTimeLabel;

  /// Hint of the date and time pickers
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get meetingsSelectHint;

  /// Validation error when no meeting date was picked
  ///
  /// In en, this message translates to:
  /// **'Select the date'**
  String get meetingsSelectDate;

  /// Validation error when no meeting time was picked
  ///
  /// In en, this message translates to:
  /// **'Select the time'**
  String get meetingsSelectTime;

  /// Accessibility label of the meeting date picker
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get meetingsSelectDateSemantics;

  /// Accessibility label of the meeting time picker
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get meetingsSelectTimeSemantics;

  /// Accessibility label of the meeting date and time picker
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get meetingsSelectDateTimeSemantics;

  /// Label of the meeting location field
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get meetingsLocationLabel;

  /// Hint of the meeting location field
  ///
  /// In en, this message translates to:
  /// **'E.g.: Main square'**
  String get meetingsLocationHint;

  /// Validation error when the meeting location is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a location for the meeting'**
  String get meetingsLocationRequired;

  /// Submit button of the create meeting screen
  ///
  /// In en, this message translates to:
  /// **'Create meeting'**
  String get meetingsCreateButton;

  /// Submit button of the edit meeting screen
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get meetingsSaveButton;

  /// Snackbar shown after a meeting is created
  ///
  /// In en, this message translates to:
  /// **'Meeting created successfully'**
  String get meetingsCreateSuccess;

  /// Snackbar shown when the meeting could not be created
  ///
  /// In en, this message translates to:
  /// **'Error while creating the meeting. Please try again.'**
  String get meetingsCreateError;

  /// Snackbar shown after a meeting is updated
  ///
  /// In en, this message translates to:
  /// **'Meeting updated successfully!'**
  String get meetingsUpdateSuccess;

  /// Snackbar shown when the block id of the meeting form is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid block ID'**
  String get meetingsInvalidBlockId;

  /// Snackbar shown when the meeting id is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid meeting ID'**
  String get meetingsInvalidMeetingId;

  /// Fallback error message of the meeting screens
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get meetingsUnknownError;

  /// Snackbar shown after a presence was updated
  ///
  /// In en, this message translates to:
  /// **'Presence updated successfully!'**
  String get meetingsPresenceUpdated;

  /// Snackbar shown when the meeting could not be deleted
  ///
  /// In en, this message translates to:
  /// **'Error while deleting the meeting'**
  String get meetingsDeleteError;

  /// Title and tooltip of the delete meeting action
  ///
  /// In en, this message translates to:
  /// **'Delete meeting'**
  String get meetingsDeleteTitle;

  /// Message of the delete meeting confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this meeting? This action cannot be undone.'**
  String get meetingsDeleteConfirmMessage;

  /// Confirm button of the delete meeting dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get meetingsDeleteAction;

  /// Cancel button of the meeting dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get meetingsCancel;

  /// Confirm button of the meeting dialogs
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get meetingsConfirm;

  /// Title of the presence section of the meeting details screen
  ///
  /// In en, this message translates to:
  /// **'Presence list'**
  String get meetingsPresenceListTitle;

  /// Button that confirms the presence of the current user
  ///
  /// In en, this message translates to:
  /// **'Confirm presence'**
  String get meetingsConfirmPresence;

  /// Status chip of an upcoming meeting
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get meetingsStatusUpcoming;

  /// Status chip of a meeting that already happened
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get meetingsStatusDone;

  /// Status chip of a meeting that starts within the hour
  ///
  /// In en, this message translates to:
  /// **'Starting soon'**
  String get meetingsStatusSoon;

  /// Accessibility label of the present badge of a member
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get meetingsPresent;

  /// Accessibility label of the absent badge of a member
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get meetingsAbsent;

  /// Fallback name of a member without a known name
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get meetingsMemberFallback;

  /// Fallback name of a member identified only by its id
  ///
  /// In en, this message translates to:
  /// **'Member #{id}'**
  String meetingsMemberNumber(int id);

  /// Loading message of the presence list
  ///
  /// In en, this message translates to:
  /// **'Loading presences...'**
  String get meetingsLoadingPresences;

  /// Empty state message of the presence list
  ///
  /// In en, this message translates to:
  /// **'Nobody confirmed presence yet'**
  String get meetingsNoPresenceYet;

  /// Empty state message when no member matches the search
  ///
  /// In en, this message translates to:
  /// **'No member found'**
  String get meetingsNoMemberFound;

  /// Hint of the member search field of the presence list
  ///
  /// In en, this message translates to:
  /// **'Search member...'**
  String get meetingsSearchMemberHint;

  /// Accessibility label of the action that marks the presence of a member
  ///
  /// In en, this message translates to:
  /// **'Mark presence of {name}'**
  String meetingsMarkPresenceOf(String name);

  /// Title of the dialog that changes the presence of a member
  ///
  /// In en, this message translates to:
  /// **'Change presence'**
  String get meetingsChangePresenceTitle;

  /// Message of the dialog that marks a member as present
  ///
  /// In en, this message translates to:
  /// **'Mark {name} as present?'**
  String meetingsMarkPresent(String name);

  /// Message of the dialog that marks a member as absent
  ///
  /// In en, this message translates to:
  /// **'Mark {name} as absent?'**
  String meetingsMarkAbsent(String name);

  /// Tooltip of the presence sort and filter menu
  ///
  /// In en, this message translates to:
  /// **'Sort and filter'**
  String get meetingsSortFilterTooltip;

  /// Header of the sort section of the presence menu
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get meetingsSortHeader;

  /// Sort option that orders the members by name
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get meetingsSortByName;

  /// Sort option that lists the present members first
  ///
  /// In en, this message translates to:
  /// **'Present first'**
  String get meetingsSortPresentFirst;

  /// Sort option that lists the absent members first
  ///
  /// In en, this message translates to:
  /// **'Absent first'**
  String get meetingsSortAbsentFirst;

  /// Header of the filter section of the presence menu
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get meetingsFilterHeader;

  /// Filter option that keeps every member
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get meetingsFilterAll;

  /// Filter option that keeps only the present members
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get meetingsFilterPresent;

  /// Filter option that keeps only the absent members
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get meetingsFilterAbsent;

  /// Empty state message of the meeting details screen
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get meetingsNoData;

  /// App bar title of the home screen
  ///
  /// In en, this message translates to:
  /// **'Bloco na Rua'**
  String get homeAppTitle;

  /// Greeting headline of the home screen
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get homeGreeting;

  /// Subtitle of the home screen under the greeting
  ///
  /// In en, this message translates to:
  /// **'See your blocks and meetings'**
  String get homeSubtitle;

  /// Title of the blocks section of the home screen
  ///
  /// In en, this message translates to:
  /// **'My blocks'**
  String get homeMyBlocks;

  /// Action that opens the full list of a home section
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// Empty state message of the blocks section of the home screen
  ///
  /// In en, this message translates to:
  /// **'No blocks yet'**
  String get homeNoBlocks;

  /// Empty state action that creates a block
  ///
  /// In en, this message translates to:
  /// **'Create block'**
  String get homeCreateBlock;

  /// Empty state action that joins a block
  ///
  /// In en, this message translates to:
  /// **'Join a block'**
  String get homeJoinBlock;

  /// Title of the meetings section of the home screen
  ///
  /// In en, this message translates to:
  /// **'Upcoming meetings'**
  String get homeUpcomingMeetings;

  /// Empty state message of the meetings section of the home screen
  ///
  /// In en, this message translates to:
  /// **'No meetings this week'**
  String get homeNoMeetingsThisWeek;

  /// App bar title of the error screen
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Default message of the error screen
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnexpected;

  /// App bar title of the not found screen
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// Message of the not found screen
  ///
  /// In en, this message translates to:
  /// **'The page you are looking for does not exist.'**
  String get notFoundMessage;

  /// Back button of the error and not found screens
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get coreBack;

  /// Default title of the error state widget
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get coreErrorTitle;

  /// Default label of the retry button of the error state widget
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get coreRetry;

  /// Default loading message of the loading widget
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get coreLoading;

  /// Default hint of the search field
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get coreSearchHint;

  /// Accessibility label of the clear button of the search field
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get coreClearSearch;

  /// Accessibility label of the block floating action button
  ///
  /// In en, this message translates to:
  /// **'Create or join a block'**
  String get coreFabCreateOrJoinBlock;

  /// Label of the create block action of the floating action button
  ///
  /// In en, this message translates to:
  /// **'Create Block'**
  String get coreFabCreateBlock;

  /// Label of the join block action of the floating action button
  ///
  /// In en, this message translates to:
  /// **'Join Block'**
  String get coreFabJoinBlock;

  /// Fallback shown by the meeting card when the meeting has no date
  ///
  /// In en, this message translates to:
  /// **'Date not set'**
  String get coreDateNotSet;

  /// Fallback name of a meeting without a known name
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get coreMeetingFallback;

  /// Chip of the meeting card showing the presence counter
  ///
  /// In en, this message translates to:
  /// **'{confirmed}/{total} presences'**
  String corePresencesCount(int confirmed, int total);

  /// Presence chip of a fully confirmed meeting
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get corePresenceConfirmed;

  /// Presence chip of a meeting without any confirmed presence
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get corePresencePending;

  /// Presence chip of a partially confirmed meeting
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get corePresencePartial;

  /// Live indicator of the block card
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get coreLive;

  /// Fallback name of a member without a known name
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get coreNoName;

  /// Label of the home destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Tooltip of the home destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get navHomeTooltip;

  /// Label of the blocks destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get navBlocks;

  /// Tooltip of the blocks destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'View the blocks'**
  String get navBlocksTooltip;

  /// Label of the meetings destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Meetings'**
  String get navMeetings;

  /// Tooltip of the meetings destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'View the meetings'**
  String get navMeetingsTooltip;

  /// Label of the profile destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Tooltip of the profile destination of the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Open the profile'**
  String get navProfileTooltip;

  /// Headline of the first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'What is a block?'**
  String get onboarding1Title;

  /// Body of the first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'A carnival block is a group of people who come together to celebrate during the carnival season. Each block has its own identity, music and tradition.'**
  String get onboarding1Body;

  /// Headline of the second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Create or join a block'**
  String get onboarding2Title;

  /// Body of the second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Join an existing block or create your own. Invite friends and family to join the fun!'**
  String get onboarding2Body;

  /// Headline of the third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Confirm your presence at the meetings'**
  String get onboarding3Title;

  /// Body of the third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'See your block\'s meetings and confirm your presence. Never miss a meeting again!'**
  String get onboarding3Body;

  /// Button that skips the onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Button that advances to the next onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Button of the last onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// Error shown when the current member could not be resolved
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get meetingsNotAuthenticated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
