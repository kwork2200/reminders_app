# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# GetX - Comprehensive rules
-keep class io.getx.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-dontwarn io.getx.**
-keepclassmembers class io.getx.** { *; }
-keepclasseswithmembernames class * {
    @io.getx.annotation.* <methods>;
}
-keep @io.getx.annotation.* class * { *; }

# Keep all GetX Controller and Binding classes
-keep class * extends io.getx.GetxController { *; }
-keep class * implements io.getx.SelfResolvable { *; }
-keep class * implements io.getx.SingleGetTickerProviderMixin { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Mobile Ads - Comprehensive rules
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**
-keepclassmembers class com.google.android.gms.ads.** { *; }
-keep public class com.google.android.gms.ads.** { public *; }

# Keep all model classes and their fields
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep all enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Serialization
-keepattributes Signature
-keepattributes *Annotation*
-keep class * implements java.io.Serializable { *; }

# Native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}

# Platform Service Classes
-keep class androidx.** { *; }
-keep class android.support.** { *; }
-dontwarn androidx.**
-dontwarn android.support.**

# Keep model classes
-keep class com.reminders.reminder_app.data.models.** { *; }

# Keep storage service
-keep class com.reminders.reminder_app.data.services.** { *; }

# Keep controllers
-keep class com.reminders.reminder_app.modules.**.** { *; }

# Keep background service
-keep class com.reminders.reminder_app.data.services.BackgroundService { *; }

# Keep notification service
-keep class com.reminders.reminder_app.data.services.NotificationService { *; }

# Keep all views
-keep class com.reminders.reminder_app.modules.**.*View { *; }

# Keep all bindings
-keep class com.reminders.reminder_app.modules.**.*Binding { *; }

# Keep theme
-keep class com.reminders.reminder_app.core.theme.** { *; }

# Keep all GetX related classes
-keep class * extends androidx.lifecycle.ViewModel
-keep class * extends androidx.lifecycle.AndroidViewModel
-keep class * implements androidx.lifecycle.ViewModelProvider.Factory

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Ignore missing Play Core classes (deferred components not used)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
