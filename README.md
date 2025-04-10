# helth
A Tarkov-like health system built with Godot 4

## So what this project does?

1. Simulates individual damage for each body part (head, thorax, stomach, arms, legs, etc.)
2. Supports multiple injury types: bleeding, fractures, pain, blackouts, and more
3. Health is tracked per body part with max HP values and injury lists
4. Visual feedback via `ColorRect` nodes that change color based on health
5. Bleeding and other injuries apply damage over time (tick-based system)
6. Healing system with item-specific treatment (e.g., bandages, splints, painkillers)
7. Global effects like `PAIN` and `ONPAINKILLERS` with duration and expiration
8. Signals for UI and gameplay integration (e.g., health_lost, injury_changed)
9. RichTextLabel displays current health and injury status in readable format
10. Expandable and modular, suitable for survival/realistic shooters and RPGs

## Structure

- `Health.gd` – manages body part health and injuries
- `HealthGUI.gd` – updates the UI based on current conditions
- `EffectManager.gd` *(optional)* – handles global effects (e.g., painkillers)
- `enums.gd` – all enums (body parts, injuries, items, global effects)
- `heal_table` – healing logic: what item treats what injury

## Planned

- Infection system
- Networking support for multiplayer

## Try it out

Just run the main scene in Godot 4. All buttons for testing are there!
