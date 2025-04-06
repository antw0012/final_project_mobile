# Keep required annotations
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.concurrent.** { *; }

# Tink crypto (used in flutter_secure_storage)
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Prevent removing annotations that might be referenced by reflection
-keepattributes *Annotation*
