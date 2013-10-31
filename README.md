UIClock
=======

This is an example project showing an implementation of a `UICollectionView` custom layout.  Being the beginnings of a worked example for "Pro UITableView & UICollectionView" which I'm supposed to be writing RIGHT NOW...

### Overview

This app is an iPad-based single-view project, and displays a working analogue clock as a `UICollectionView` with a custom layout.

![Screenshot](https://raw.github.com/timd/UIClock/master/screenshot-after.png)

### Architecture

The collection view is managed by a single view controller (`ClockViewController`) that also acts as data source and delegate.

The data model consists of an `NSArray` with two elements, each themselves containing an `NSArray`. At index path `0` the array contains twelve elements containing `NSStrings` that act as labels for the clock face's numerals.

At index path `1`, there are three elements containing `NSStrings` that act as markers for the hour, minutes and second hands.  The presence of an element will cause the collection view to attempt to display the hands (ie removing the "seconds" element will suppress the display of the seconds hand).

The clock face's numerals are displayed in views derived from the `HourLabelView.xib`, while the hands are created as custom subclasses of `UICollectionViewCell` into which a `UIImageView` containing the hand image is inserted.

The collection view layout should be self-explanatory - the two main methods are `calculateAttributesForHourLabelAtIndexPath:` and `calculateAttributesForHandCellAtIndexPath:`.  These calculate the position and/or transform required for each numeral or hand based on the rotation derived from the time value passed into the layout.
