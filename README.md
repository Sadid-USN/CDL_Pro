# CDL Pro

# flutter_native_splash comand
flutter pub run flutter_native_splash:create

# watch build script comand
> dart run build_runner watch --delete-conflicting-outputs

# run build script comand
> dart run build_runner build --delete-conflicting-outputs

# Description
>For now this project has only base templates 

>when building or running application use `--release` or `--debug` tags

## ⚠️ run project with flavors `dev`, `prod`
```
flutter run --release -t lib/main_prod.dart --flavor prod
```
```
flutter run --release -t lib/main_dev.dart --flavor dev
```

## ⚠️ build APK with flavors `dev`, `prod`
```
flutter build apk --release -t lib/main_prod.dart --flavor prod  
```
```
flutter build apk --release -t lib/main_dev.dart --flavor dev  
```

## ⚠️ build APPBUNDLE with flavors `dev`, `prod`
```
flutter build appbundle --release -t lib/main_prod.dart --flavor prod  
```
```
flutter build appbundle --release -t lib/main_dev.dart --flavor dev  
```

### run localize gen script
> dart run easy_localization:generate -S assets/translations -O lib/generated -f json && dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart



### run flutter launcher icons
>dart run flutter_launcher_icons

### run flutter launcher icons
>dart run flutter_native_splash:create



