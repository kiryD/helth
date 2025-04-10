# helth
A Tarkov-like health system built with Godot 4

## So what this project does?

1. Simulates individual damage for each body part (head, thorax, stomach, arms, legs, etc.)
2. Supports multiple injury types: bleeds, fractures, pain, blackouts, and more
3. Health is tracked per body part with max HP values and injury lists
4. Visual GUI with fully customizable type `(but only if it has modulate!)`
5. Bleeding and other injuries apply damage over time (tick-based system)
6. Healing system with item-specific treatment (e.g., bandages, splints, painkillers)
7. Global effects like `pain` with duration and expiration
8. Usefull functions that I will write about later
9. Text/Functions that displays current health and injury status in readable format
10. Expandable and modular, suitable for survival/realistic shooters and RPGs

## Functions
- HealthGUI Functions:
1. `health_injury_update(bodypart: ENUMS.BODYPARTS, inj: ENUMS.INJURY) -> void` - Adds injury to current Health `You can see all enums in 'enums.gd'!`
2. `health_injury_update_heal(bodypart: ENUMS.BODYPARTS, item: ENUMS.ITEMS) -> bool` - Returns if you can heal an injury. If can heal it, return true and heal it; else return false and don't heal it.
3. `health_health_update(bodypart: ENUMS.BODYPARTS, amount: int, type: bool) -> void` - That's a tuff one. So bodypart is bodypart, amount is amount to heal/deal and a type is separates heal and deal `type = 0 = deal damage; type = 1 = heal damage.`
4. `print_condition(condition: Dictionary) -> String` - Function prints and returns chunk of text that is current Health condition `Please note that it's a RichText Format!`

## Structure

- `Health.gd` – manages body part health and injuries
- `HealthGUI.gd` – updates the UI based on current conditions
- `enums.gd` – all enums (body parts(and HP), injuries, items)
- `adjacent_parts.gd` – currently WIP damage distribution
- `EffectManager.gd` *(NOT IMPLEMENTED)* – handles global effects (e.g., painkillers)

## Planned

- Infection system
- Networking support for multiplayer

## Try it out

Just run the main scene in Godot 4. All buttons for testing are there!
