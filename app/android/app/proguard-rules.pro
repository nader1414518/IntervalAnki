# Flutter's own engine/embedding classes are already covered by the rules
# the Flutter Gradle plugin merges in automatically. What's added here is
# just for this app's specific plugin set, in case a future update to one
# of them ever ships without its own consumer rules.

# sqlite3_flutter_libs / drift talk to the bundled native SQLite via JNI —
# keep anything under its package so R8 doesn't strip a class only ever
# referenced by name from native code.
-keep class io.requery.android.database.sqlite.** { *; }

# Play Core split-install classes are referenced reflectively by Flutter's
# deferred-components support even though this app doesn't use deferred
# components — keeping them avoids a build-time "missing class" warning
# some Flutter/AGP version combinations produce under R8.
-dontwarn com.google.android.play.core.**
