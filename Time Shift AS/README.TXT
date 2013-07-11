TODO:

 - determine next steps for app store
 - re-edit pier tides to fade in/out, or shorter whiteout at the end
 - create version of project for github+download

 - MED: investigate performance issues w/ rounded corners + borders are implemented in collectin cell.
    (Currently disabled. Maybe will be ok w/ static map images and lighter weight formatted text)
 - MED: better play button?
 - MED: provide images for all resolutions?
 - MED: consider replacing maps in detail views with static images (performance,no net required)
 - MED: consider lightweight alternative to uiwebview for displaying text
 - MED: better play button?
 - MED: disable maps if no network? does this happen automatically
 - MED: external monitor / airplay functionality - does this come automagically?
 - MED: loop mode
 - MED: radom play mode
 - MED: better thumbnail: thumbOak1.png
 - MED: Consider lighter-weight app w/ option to download addit'l movies
 - MED: revisit dynamic layout of video detail scene. currently disabled by changing portrait video detail scene's view controller from PortraitVideoDetailViewController back to VideoDetailViewController. 
 - MED: make player controllers not initially appear, but still appear upon tap. or disappear sooner?
 - MED: investigate video control difference issues between iphone and ipad
 
 - LOW: better icon?
 - LOW: splash screen?
 - LOW: SFO Night: tilted?
 - LOW: move some map functionality into view sublcass (from view controller)?
 - LOW: get animation working in MapViewController/updateShowAllButtonWithVisibleAnnotations

 - clean up code / refactor / comment to be presentable
    - at some point create a fresh repository w/o movies to put on github?
    - create single placeholder movie (very short) that plays if movie file not found
 - set up public git repository as portfolio
        xcode git should place nice w/ github? http://twoshotsofcocoa.com/?p=35

NOTES
- disabled drop shadow as it has a big performance impact. possible different strategies: http://www.omnigroup.com/blog/entry/ipad_drop_shadow_performance_test