# CLICK AI Fitness Coach

Нативное SwiftUI-приложение для персонального планирования питания и тренировок. Основная сборка подготовлена для [xtool](https://github.com/xtool-org/xtool) — кроссплатформенной замены Xcode. Дополнительно проект можно открыть в Xcode или собрать в GitHub Actions.

## Текущий этап

Это рабочая **первая итерация интерфейса и локальных сценариев**: пять основных вкладок, два независимых профиля, дневник питания, запись веса, список покупок, тренировка с таймером, график прогресса и локальный помощник. Серверная часть, Aggregate, HealthKit и интеграции магазинов подключаются следующими этапами.

Ни одна функция не считается готовой, если в интерфейсе не предусмотрена ошибка или честный локальный режим. Демо-результаты ИИ не выдаются за реальные.

## Установка на iPhone

### iOS 27+: без компьютера

Для нового iPhone с iOS 27+ самый удобный путь — [SideInstaller](https://github.com/FrizzleM/SideInstaller): он устанавливает SideStore и LiveContainer прямо на телефоне. Нужны бесплатный Apple ID, Wi-Fi, Режим разработчика и официальный сайт проекта.

После первичной настройки IPA из GitHub Actions можно передать в SideStore через файл или ссылку. SideStore автоматически обновляет подпись в фоне, поэтому вручную подключать телефон каждые 7 дней не требуется.

### Есть Windows и другая версия iOS

1. Соберите IPA во вкладке **Actions → Build unsigned iOS IPA → Run workflow**.
2. Скачайте артефакт `ClickAI-unsigned-ipa`.
3. Установите [iLoader](https://github.com/nab138/iloader/releases/latest) и его рекомендуемый комплект **SideStore + LiveContainer**.
4. Подключите iPhone кабелем один раз и доверьте компьютеру.
5. Откройте IPA в SideStore.

[Impactor](https://github.com/claration/impactor/releases/latest) остаётся простым запасным вариантом для прямой установки IPA с компьютера.

### Честное ограничение Apple

Бесплатный Apple ID всё равно выдаёт сертификат на 7 дней. SideStore скрывает это от пользователя, автоматически обновляя подпись на устройстве. Это не делает сертификат вечным.

- Постоянная установка без обновления подписи возможна через TrollStore только на iOS 14.0 beta 2–16.6.1 либо 17.0. На новых iPhone это не вариант.
- Официальный Apple Developer Program даёт подпись на 365 дней и повышает лимиты, но требует оплаты.
- Чужие корпоративные сертификаты из Telegram и «магазинов подписей» не используются: их отзывают, а установщик может получить доступ к Apple ID.

## Сборка через xtool

Проект содержит `Package.swift` и `xtool.yml`, поэтому xtool может собрать, подписать и установить его прямо на подключённый iPhone.

### Требования

- Windows: WSL2, Swift 6.4, usbmuxd и USB-доступ к iPhone.
- Linux: Swift 6.4, usbmuxd и USB-доступ к iPhone.
- Бесплатный или платный Apple ID.
- `Xcode.xip`, который xtool использует для создания iOS Swift SDK.

### Запуск

В Ubuntu/WSL:

```sh
curl -fL \
  "https://github.com/xtool-org/xtool/releases/latest/download/xtool-$(uname -m).AppImage" \
  -o xtool
chmod +x xtool
sudo mv xtool /usr/local/bin/xtool

xtool setup
```

После первичной настройки:

```sh
cd /mnt/c/Users/User/Documents/Codex/2026-11-17/new-chat/work/click-ai-fitness-coach
xtool dev
```

При запросе xtool подпишет приложение вашим Apple ID и установит его на подключённый iPhone. Для бесплатного Apple ID срок сертификата остаётся 7 дней — это ограничение Apple, а не xtool. Повторный `xtool dev` продлевает подпись; платный Apple Developer Program даёт 365 дней.

## Сборка через Xcode

Требуются macOS, Xcode 16+ и XcodeGen.

```sh
brew install xcodegen
xcodegen generate
open ClickAI.xcodeproj
```

## Источники фотографий

Фотографии в `Assets.xcassets` загружены из Unsplash и используются как лицензированные демонстрационные изображения первой итерации. Перед публикацией в App Store их следует заменить собственным фотоконтентом или зафиксировать лицензии по каждому файлу.

