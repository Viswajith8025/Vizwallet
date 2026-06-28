# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Play Core is referenced by Flutter's deferred-components support but is not
# bundled in this app. Don't fail the R8 build over the missing classes.
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Home screen widgets
-keep class com.viswajith.rupee_track.widget.** { *; }
-keep class es.antonborri.home_widget.** { *; }
