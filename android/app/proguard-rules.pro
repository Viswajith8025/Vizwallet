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

# AndroidX Startup + WorkManager (home_widget / background work — stripped by R8
# causes instant crash: Failed to create WorkDatabase)
-keep class androidx.startup.** { *; }
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.work.Worker
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

# Room (WorkManager persists jobs via WorkDatabase)
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class *
-keep @androidx.room.Dao class *
-keepclassmembers class * {
    @androidx.room.* <methods>;
}
-keep class androidx.sqlite.** { *; }
-dontwarn androidx.room.paging.**

# Supabase / networking reflection
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Kotlin metadata for reflection-based serializers
-keepattributes *Annotation*, InnerClasses, EnclosingMethod, Signature
-keep class kotlin.Metadata { *; }
