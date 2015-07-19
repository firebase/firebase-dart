[![Build Status](https://travis-ci.org/firebase/firebase-dart.svg?branch=master)](https://travis-ci.org/firebase/firebase-dart)

A Dart wrapper for [Firebase](https://www.firebase.com).

This package uses `dart:js` to wrap functionality provided by `firebase.js`
in Dart classes.

#### Installing

Follow the instructions on the [pub page](http://pub.dartlang.org/packages/firebase#installing).

**The firebase.js library MUST be included for the wrapper to work**:

```html
<script src="https://cdn.firebase.com/js/client/2.2.7/firebase.js"></script>
```

This gist illustrates how to make very simple public chatbox using firebase:
https://gist.github.com/kasperpeulen/2d1d6184e6cb5fecdac1
