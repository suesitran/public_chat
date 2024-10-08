// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Renders a web-only SIGN IN button.
Widget buildSignInButton({required String label, VoidCallback? onPressed}) {
  // ignore: unused_local_variable
  final GoogleSignIn googleSignIn = GoogleSignIn();

  return web.renderButton();
}
