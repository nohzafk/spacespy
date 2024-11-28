# SpaceSpy

SpaceSpy is a macOS utility that provides detailed information about your desktop spaces and monitors. It outputs a JSON structure containing monitor names, UUIDs, and space information that matches Mission Control's desktop numbering.

## Features

- Retrieves human-readable monitor names (e.g., "BenQ MA320U" instead of display UUIDs)
- Provides space indices that match Mission Control's Desktop numbers
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
      "spaces" : [
        {
          "index" : 1,             // Mission Control Desktop number
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

## Use Cases

- Window management scripts
- Status bar applications (like sketchybar)
- Desktop space monitoring
- Multi-monitor setups

## License

MIT License
