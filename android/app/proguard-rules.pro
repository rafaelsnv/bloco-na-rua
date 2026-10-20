# Flutter default rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Supabase
-keep class io.supabase.** { *; }

# Keep Dio
-keep class dio.** { *; }

# Keep Freezed
-keep class ** { *; }
-keepclassmembers class ** {
  @com.fasterxml.jackson.annotation.JsonProperty *;
}
