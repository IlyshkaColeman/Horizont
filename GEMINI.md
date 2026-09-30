# Проект: Горизонт (Roblox Experience)

## Основные правила и ограничения проекта

1. **Вертикальные срезы (Vertical Slices):**
   - Не пытаться построить всю игру или сложную механику за один проход. Делать небольшие законченные срезы, тестируя каждый в Roblox Studio перед переходом к следующему.
   - Любая ценная игровая логика (валюта, инвентарь, покупки, награды) всегда валидируется на сервере (Server-Authoritative).

2. **Стандарты UI / UX Дизайна:**
   - **Стиль:** Космический сочный Cartoony / Sci-Fi интерфейс.
   - **Обводки (UIStroke):** Запрещены грубые черные обводки на кнопках, плашках и тексте. Использовать неоновые, белые или гармоничные полупрозрачные акценты в цвет темы.
   - **Тактильность кнопок:**
     - `AnchorPoint = Vector2.new(0.5, 0.5)` строго по центру, чтобы масштабирование при наведении не вызывало сдвига вправо/влево.
     - Объемная 3D подложка (bevelDepth: 4–5px).
     - При наведении (`MouseEnter`) кнопка слегка увеличивается (`Scale = 1.03`) и приподнимается на 2px вперёд к игроку (`UDim2.new(0.5, 0, 0.5, -bevelDepth - 2)`).
     - При нажатии (`MouseButton1Down`) кнопка мягко вдавливается (`UDim2.new(0.5, 0, 0.5, 0)`).
   - **Отступы и верстка:**
     - Внутри модальных окон и списков (Settings, Shop, Bestiary) отступы должны быть просторными (не менее 20–24px), чтобы контроллеры, переключатели и слайдеры не жались к границам.
     - Мобильная адаптивность (Mobile-First): крупные области нажатия, использование `UIScale` и безопасных зон.
   - **Шрифты:** `Enum.Font.FredokaOne`, крупные заголовки, четкая иерархия.

3. **Интеграция с Roblox Studio MCP:**
   - Для проверки интерфейса и кода использовать `execute_luau`, `screen_capture`, `inspect_instance`, `start_stop_play` и `get_console_output`.

---

## Roblox Skills

В проекте установлен расширенный комплекс из 70 скиллов в `.agents/skills/` (включая полный пакет `roblox-skills`, библиотеку `roblox-brain` и флагманский движковый справочник `roblox-dev-skill`):

### 1. Движок и стандарты разработки (roblox-dev-skill):
- **`roblox-dev-skill`** — полная база знаний по движку Roblox Studio, актуальному API Luau, безопасной работе с MCP (`execute_luau`, `search_game_tree`), DataStore2/ProfileService паттернам, репликации и сетевой безопасности.

### 2. Архитектура и ядро (roblox-brain Core & Tools):
- **Язык и паттерны:** `roblox-luau-core`, `roblox-luau-types`, `roblox-luau-patterns` — семантика Luau, строгая типизация, правильные жизненные циклы объектов и сигналов.
- **Архитектура и сеть:** `roblox-architecture`, `roblox-networking`, `roblox-security` — Server-Authoritative архитектура, валидация ремоутов, защита от эксплойтов.
- **Хранилище данных:** `roblox-data`, `roblox-server-data` — надежные схемы DataStore, миграции, межсерверное взаимодействие.
- **Производительность:** `roblox-performance` — профилирование памяти, инстансов, стриминг и оптимизация под слабые смартфоны.
- **Инструменты Studio MCP:** `roblox-studio-mcp`, `roblox-tooling`, `roblox-cloud`, `roblox-publish-checklist`.

### 3. Геймплей и презентация (roblox-brain Gameplay):
- **Интерфейс и ввод:** `roblox-gui`, `roblox-input` — Screen/Surface UI, адаптивность, кроссплатформенный ввод (Touch/Gamepad/Keyboard).
- **Визуал и динамика:** `roblox-animation-vfx`, `roblox-audio`, `roblox-lighting`, `roblox-camera` — спецэффекты, частицы, освещение, циклы дня/ночи, 3D-звук.
- **Мир и механики:** `roblox-building`, `roblox-physics`, `roblox-npc-ai` — процедурные и модельные постройки, физика и ИИ мобов.

### 4. Игровой дизайн и психология (roblox-brain Design & GDLC):
- **Психология и вовлечение:** `roblox-player-psychology`, `roblox-game-design`, `roblox-growth-design` — петли первого впечатления (FTUE), расписания наград, ретеншн.
- **Экономика и монетизация:** `roblox-monetization`, `roblox-analytics`, `roblox-economy-balancing` — честная монетизация, аналитика воронок.
- **Полный цикл разработки (GDLC):** `roblox-game-development-lifecycle`, `roblox-to-prd`, `roblox-to-issues`, `roblox-ui-implementation`, `roblox-playtest-qa`.
