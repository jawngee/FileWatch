#FileWatch

FileWatch is a simple macOS menubar app that allows you to:

- Watch specific files and run shell scripts when they've been changed or modified
- Create menu items that launch shell scripts or open URLs
- Create global hotkeys that trigger running shell scripts or opening URLs

I use this for:

- Monitoring the podspecs of development pods to automatically `pod update` xcode projects that use them
- Launch vagrant instances
- Run ansible deployment and provisioning scripts
- Automatically upload dsyms to crashalytics
- Clean out xcode's DerivedData with a hotkey combo



## Configuration
When you first run FileWatch it will create a `~/.filewatch/` directory and copy a sample configuration file to it, as well as some sample scripts.  The sample configuration file should be fairly easy to understand, but below describes how the config file is structured.

The configuration is built up of items, any of which could be a file to watch, a script to run, a url to launch or a collection of other items.  

### Item Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| title | string | The title of the item.  _Required._ |
| source | string | The path of the file that should be watched for changes.  _Optional._ |
| url | string | The URL to open when the file changes, the user selects the menu item or the user presses the global hotkey for the item. _Optional._ |
| script | string | The path of the script to run when the file changes, the user selects the menu item or the user presses the global hotkey for the item. _Optional._ |
| enabled | bool | Determines if the item is enabled or not. _Optional._ |
| terminal | bool | Determines if the script is run iTerm2, instead of being run in a non-visual process. _Optional._ |
| hotkey | object | The global hotkey for the item. _Optional._ |
| items | array | An array of items that are children of this item, represented as a submenu in the app.  _Optional._ |

Changes to the config are automatically reloaded.

### Hotkey Properties

| Property | Type | Description |
| -------- | ---- | ----------- |
| shift | bool | Require the shift key modifier.  _Optional._ |
| control | bool | Require the control key modifier.  _Optional._ |
| option | bool | Require the option key modifier.  _Optional._ |
| command | bool | Require the command key modifier.  _Optional._ |
| function | bool | Require the function key modifier.  Note that this will supercede any other key modifier.  _Optional._ |
| key | string | The keyboard character.  See the table below for non-ascii keys.  _Required._ |

**Known bug:** The key property is based on a US keyboard and is ultimately mapped to a virtual keycode where the physical location of that key on the keyboard is important.  For example, if you are using a non-US keyboard and the A key is in a different location, your hotkey definition for command+A might not work like you'd expect.

### Hotkey Keys

In addition to the normal alphanumeric keys, use the following strings for special keys like up arrow, etc.

| Key | String |
| --- | ------ |
| Return | return |
| Tab | tab |
| Space | space |
| Backspace | backspace |
| Delete | delete |
| Escape | esc |
| F1 | f1 |
| F2 | f2 |
| F3 | f3 |
| F4 | f4 |
| F5 | f5 |
| F6 | f6 |
| F7 | f7 |
| F8 | f8 |
| F9 | f9 |
| F10 | f10 |
| F11 | f11 |
| F12 | f12 |
| Home | home |
| End | end |
| Page Up | pgup |
| Page Down | pgdn |
| Left Arrow | left |
| Right Arrow | right |
| Down Arrow | down |
| Up Arrow | up |

## Third Party Code

This uses the following third party libraries:

- DDHotKey by Dave DeLong
- VDKQueue by Bryan D K Jones

