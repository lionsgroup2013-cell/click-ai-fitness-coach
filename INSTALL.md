# Установка CLICK на iPhone

## Что важно знать

У бесплатного Apple ID сертификат разработчика живёт 7 дней. Это правило Apple нельзя отключить настройкой GitHub или самого приложения.

Есть три разных сценария:

1. **SideStore + LiveContainer** — приложение устанавливается через ваш Apple ID, а SideStore обновляет подпись автоматически на телефоне. Пользователю не нужно каждые 7 дней подключать iPhone к компьютеру.
2. **TrollStore** — постоянная установка IPA без подписи и без срока. Поддерживается только на iOS 14.0 beta 2–16.6.1 и iOS 17.0. На iPhone 18 Pro Max этот вариант не подходит.
3. **Apple Developer Program** — официальная подпись на 365 дней и больше лимитов. Требует оплаты.

Для iPhone 18 Pro Max с актуальной iOS рекомендуется первый сценарий.

## Сборка через xtool

[xtool](https://github.com/xtool-org/xtool) — самый близкий к вашему запросу вариант: он собирает SwiftPM-приложение на Windows через WSL, подписывает его Apple ID и устанавливает на подключённый iPhone без Mac.

1. Установите WSL2 и Ubuntu.
2. Настройте USB-доступ iPhone к WSL через `usbipd-win`.
3. Установите Swift 6.4, `usbmuxd` и [Xcode.xip](https://developer.apple.com/download/all/?q=Xcode).
4. Скачайте `xtool.AppImage` из официального GitHub Releases и выполните `xtool setup`.
5. В корне этого репозитория выполните `xtool dev`.

Для xtool в проекте уже есть `Package.swift` и `xtool.yml`. Для бесплатного Apple ID xtool честно использует семидневную подпись Apple; повторный `xtool dev` её продлевает.

## Если установлен iOS 27+

Используйте [SideInstaller](https://github.com/FrizzleM/SideInstaller) только с официального сайта проекта.

1. Проверьте: **Настройки → Основные → Об этом устройстве → Версия ПО**.
2. Включите **Режим разработчика**, если он ещё не включён.
3. Установите SideInstaller и затем **SideStore + LiveContainer**.
4. Войдите в свой Apple ID. Пароль и код подтверждения приложение не пересылает на сервер.
5. Разрешите нужные настройки VPN и доверьте профилю разработчика в **Настройки → Основные → VPN и управление устройством**.
6. Откройте IPA из GitHub в SideStore или передайте его в LiveContainer.

## Если установлен iOS 17.4–26.x или есть Windows

1. Установите [iLoader](https://github.com/nab138/iloader/releases/latest).
2. Поставьте официальный iTunes для Windows (версия не из Microsoft Store).
3. Подключите iPhone по кабелю и нажмите «Доверять».
4. В iLoader войдите в Apple ID и установите **SideStore + LiveContainer**.
5. Выберите IPA CLICK и установите его в SideStore.

## Если нужна только прямая установка IPA с ПК

[Impactor](https://github.com/claration/impactor/releases/latest) проще, но при бесплатном Apple ID подпись нужно продлевать вручную. Этот вариант хорош для быстрой проверки сборки, а не для повседневного использования.

## Обновления CLICK

1. Откройте GitHub → **Actions**.
2. Запустите **Build unsigned iOS IPA**.
3. После завершения скачайте артефакт `ClickAI-unsigned-ipa`.
4. В SideStore выберите новый IPA. Используйте тот же Apple ID и bundle ID, чтобы сохранить дневник и историю.

## Ограничения текущей итерации

Сейчас собираются интерфейс и локальные сценарии. Сервер FastAPI, Aggregate, PostgreSQL, Apple Health и реальные каталоги магазинов ещё не подключены. Интерфейс не показывает вымышленные ответы Vision как результат распознавания.

