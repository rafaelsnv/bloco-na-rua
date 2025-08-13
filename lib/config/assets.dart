// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Configuração de assets da aplicação
class Assets {
  Assets._();

  // Imagens
  static const String _imagesPath = 'assets/images';

  // Logos
  static const String logo = '$_imagesPath/logo.png';
  static const String logoWhite = '$_imagesPath/logo_white.png';

  // Ícones
  static const String _iconsPath = 'assets/icons';
  static const String homeIcon = '$_iconsPath/home.png';
  static const String profileIcon = '$_iconsPath/profile.png';
  static const String settingsIcon = '$_iconsPath/settings.png';

  // Placeholders
  static const String placeholderImage = '$_imagesPath/placeholder.png';
  static const String defaultProfileImage = '$_imagesPath/default_profile.png';

  // Animações
  static const String _animationsPath = 'assets/animations';
  static const String loadingAnimation = '$_animationsPath/loading.json';
  static const String successAnimation = '$_animationsPath/success.json';
  static const String errorAnimation = '$_animationsPath/error.json';
}
