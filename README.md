# SpaceSpy

SpaceSpy is a macOS utility that provides detailed information about your desktop spaces and monitors. It outputs a JSON structure containing monitor names, UUIDs, display numbers, and space information that matches Mission Control's desktop numbering.

This main purpose of this utility is to to provide display and space number information to be used with [sketchybar](https://github.com/FelixKratz/sketchybar), a macOS status bar utility, when using multiple monitors with variaous arrangements.

## Features

- Retrieves human-readable monitor names (e.g., "BenQ MA320U" instead of display UUIDs)
- Provides display numbers that match physical monitor arrangement
- Provides space numbers that match Mission Control's Desktop numbers
- Includes UUIDs for both monitors and spaces
- Shows current active space for each monitor
- Outputs in a clean, well-formatted JSON structure

## Building

```bash
make
```

## Usage

```bash
./spacespy
```

## Output Format

The program outputs a JSON structure with the following format:

```json
{
  "monitors" : [
    {
      "name" : "BenQ MA320U",      // Human-readable monitor name
      "uuid" : "428093F1-...",     // Monitor UUID
      "display_number" : 1,        // Display number (starts from 1)
      "spaces" : [
        {
          "space_number" : 1,      // Mission Control Desktop number
          "id" : 3,                // Internal space ID
          "managed_id" : 3,        // Managed space ID
          "uuid" : "DAEE6C22-...", // Space UUID
          "is_current" : true      // Whether this is the active space
        }
      ]
    }
  ]
}
```

## Display Number and Space Number

Display numbers are assigned based on the physical arrangement of your monitors, starting from 1. For example:
- First display: 1
- Second display: 2
- Third display: 3
- And so on...

The numbering follows the display arrangement in Mission Control, not necessarily left-to-right order.

The `display_number` values correspond directly to sketchybar's `--display` item property.

Space numbers (`space_number` in the output) correspond to Mission Control's Desktop numbers. They are numbered sequentially starting from 1, going from left to right across all monitors.

The `space_number` values correspond directly to sketchybar's `--space` item property.

For more details on sketchybar item properties, see the [official documentation](https://felixkratz.github.io/SketchyBar/config/items).

## Use Cases

- Status bar applications (like sketchybar)
  - Configure items to show on specific displays using `--display`
  - Configure items to show on specific spaces using `--space`
- Window management scripts
- Custom desktop space indicators
- Multi-monitor workspace management tools

## License

MIT License
