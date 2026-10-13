# ⭐ Star

[![Type](https://img.shields.io/badge/type-assignment-blueviolet)](#)
[![iOS](https://img.shields.io/badge/iOS-16%2B-black?logo=apple&logoColor=white)](#)
[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift&logoColor=white)](#)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-1575F9?logo=xcode&logoColor=white)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Year](https://img.shields.io/badge/year-2025-lightgrey)](#)

Тестовое задание на **SwiftUI** с поддержкой тёмной и светлой темы, анимацией переходов, локализацией и бесшовной авторизацией через **silent push**.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Readme/DarkEn.gif">
  <source media="(prefers-color-scheme: light)" srcset="Readme/LightEn.gif">
  <img alt="Region En" src="Readme/LightEn.gif" width="300">
</picture>
&nbsp;&nbsp;&nbsp;
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Readme/DarkRu.gif">
  <source media="(prefers-color-scheme: light)" srcset="Readme/LightRu.gif">
  <img alt="Region Ru" src="Readme/LightRu.gif" width="300">
</picture>

## ⚙️ Требования
- Разработать форму ввода телефона с автоматической вставкой `+7` в начале
- Анимация движения звезды при переходе на следующий экран
- Отображение ошибки при вводе неверного кода
- Поддержка тёмного оформления

## 🛠 Технологии
- **SwiftUI** — декларативный UI-фреймворк, весь интерфейс приложения построен на нём
- **Swift** — язык разработки, активно используются современные возможности
- **MVVM** — разделение UI и бизнес-логики: View рендерит состояние, ViewModel (`ObservableObject`) управляет логикой и отдаёт готовые данные через `@Published`
- **Matched Geometry Effect** — плавные переходы между экранами с сохранением геометрии элементов
- **Silent Push** — тихая доставка SMS-кода в приложение без подтверждения пользователя
- **Localization** — поддержка нескольких языков через строковый каталог `Localizable.xcstrings`
- **Logging** — централизованное логирование для отладки сетевых запросов и жизненного цикла экранов
- **Combine** — реактивные потоки: таймеры обратного отсчёта, обработка событий и связывание `@Published`-свойств с UI
- **async / await** — все сетевые запросы на структурированной конкурентности: `Task`, `TaskGroup`, отмена при уходе с экрана
- **Tinted Icon** — иконка с поддержкой tint color: корректно перекрашивается под тему и акцентный цвет системы
- **Dark Mode** — поддержка светлой и тёмной темы: цвета заданы через ассеты с Any/Dark Appearance, UI перестраивается автоматически

## 📦 Установка
```bash
git clone https://github.com/your-org/star-project.git
cd star-project
open StarProject.xcodeproj
