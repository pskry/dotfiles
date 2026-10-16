// Firefox preferences, applied to every profile by run_onchange_after_firefox-prefs.
//
// user.js is re-applied at EVERY start, so anything set here cannot be changed from the
// UI: it reverts on the next launch. That is the point for settings worth pinning, and
// the reason not to put everything here.

// Compact toolbars, and the switch that makes the option visible in Customize at all.
user_pref("browser.uidensity", 1);
user_pref("browser.compactmode.show", true);

// Follow the desktop rather than picking a side, so the theme-follow script drives it.
user_pref("browser.theme.toolbar-theme", 2);
user_pref("browser.theme.content-theme", 2);

// The new tab page is a product surface by default. None of this is search or history.
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

// Straight into the downloads folder, never a save-as dialog.
user_pref("browser.download.useDownloadDir", true);
user_pref("browser.download.always_ask_before_handling_new_types", false);
