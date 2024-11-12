// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

export 'local_language/stub.dart'
    if (dart.library.js_util) 'local_language/web.dart'
    if (dart.library.io) 'local_language/mobile.dart';
