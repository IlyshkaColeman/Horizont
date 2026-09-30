# Проект: Горизонт (Horizont)

Опыт в Roblox с Server-Authoritative архитектурой, космическим Cartoony / Sci-Fi интерфейсом и синхронизацией через **Rojo** и **GitHub**.

---

## 🛠 Быстрый старт для разработчиков

### 1. Требования:
- [Git](https://git-scm.com/)
- [Roblox Studio](https://create.roblox.com/)
- [Rojo CLI](https://rojo.space/) (версия 7.x)

### 2. Клонирование репозитория:
```bash
git clone <URL_РЕПОЗИТОРИЯ_GITHUB>
cd Gemini
```

### 3. Запуск синхронизации с Roblox Studio (для Хоста):
1. Откройте плейс **«Горизонт»** в Roblox Studio.
2. Запустите Rojo сервер:
   - Двойной клик по файлу `run_rojo.bat` (или в терминале: `rojo serve`).
3. В Roblox Studio перейдите во вкладку **Plugins** (Плагины) и нажмите кнопку **Rojo**.
4. В появившемся окне нажмите **Connect** (адрес по умолчанию `localhost:34872`).
5. Готово! Любые сохранения файлов в `src/` мгновенно обновляются в Roblox Studio.

---

## 📁 Структура проекта

```text
├── default.project.json       # Конфигурация синхронизации Rojo в DataModel Roblox
├── run_rojo.bat               # Запуск сервера Rojo в 1 клик
├── src/
│   ├── server/                # Серверные скрипты -> ServerScriptService
│   │   ├── DayNightServer.server.luau
│   │   └── ShopServer.server.luau
│   ├── client/                # Клиентские скрипты -> StarterPlayer.StarterPlayerScripts
│   │   └── DayNightClient.client.luau
│   ├── gui/                   # Скрипты интерфейса -> StarterGui.SettingsGui
│   │   └── SettingsClient.client.luau
│   └── shared/                # Общие модули -> ReplicatedStorage.Shared
├── prompts/                   # Исходные ассеты, иконки и текстуры
└── GEMINI.md                  # Свод правил дизайна, стандарты тактильности UI/UX
```

---

## 🤝 Совместная работа через GitHub

### Рабочий процесс:
1. **Друг (разработчик):**
   - Получает свежие изменения: `git pull`
   - Вносит изменения в файлы в папке `src/` в своём редакторе (VS Code / Cursor).
   - Фиксирует изменения:
     ```bash
     git add .
     git commit -m "Описание того, что изменилось"
     git push
     ```

2. **Хост (владелец плейса):**
   - Держит запущенными Roblox Studio и `run_rojo.bat`.
   - В терминале подтягивает изменения друга:
     ```bash
     git pull
     ```
   - Rojo автоматически и без перезапуска обновляет код в Roblox Studio!
