# TFDHelper

**AHK v2 automation script for The First Descendant**

TFDHelper is a modular automation tool designed to enhance your gameplay experience in The First Descendant. It provides character-specific automation, utility functions, and a master control system with state saving.

## Features

- 🎮 **Character Class Modules** - Mutually exclusive automation for different characters
- ⚡ **Master Control** - Global on/off switch with state saving/restoration
- 🔧 **Utility Modules** - Independent helper functions
- 💾 **State Management** - Automatically saves and restores module states
- 🎯 **Game Detection** - Only functions when The First Descendant is active

## Installation

1. Install [AutoHotkey v2](https://www.autohotkey.com/v2/)
2. Download `TFDHelper.ahk`
3. Run the script by double-clicking the file
4. The script will automatically detect when The First Descendant is running

## Hotkey Layout

### Core Controls
| Key | Function | Description |
|-----|----------|-------------|
| `Numpad0` | **Master Toggle** | Enable/disable all functions (saves state) |
| `Numpad8` | **Show Status** | Display current module status |

### Character Classes (Mutually Exclusive)
| Key | Character | Description | Controls |
|-----|-----------|-------------|----------|
| `Numpad2` | **Bunny** | Movement + Auto V + Jumping | `E` (movement), `R` (jumping), `V` (auto V) |
| `Numpad3` | **Luna** | Triple skill combo | `E` (combo: Z,V,C x2) |
| `Numpad4` | **Viessa** | Auto-click after skill | `4` or `Z` (auto-click) |
| `Numpad5` | **Freyna** | Auto C/V presser | `F3` (toggle), `C`/`V` (pause) |

### Utility Modules
| Key | Function | Description | Controls |
|-----|----------|-------------|----------|
| `Numpad1` | **Tabber** | Auto tab presser | Automatic (2s intervals) |
| `Numpad6` | **Quest Abort** | Quest abort sequence | `T` (ESC→Click→Space→F2→R) |
| `Numpad7` | **Repeat** | F2+R sequence | `T` (F2 hold→R hold) |

## Detailed Module Information

### 🎮 Character Classes

#### Bunny (Numpad2)
- **Movement System**: Cycles through W,A,S,D keys with V presses
- **Double Jump**: Automated space bar double-tap
- **Auto V**: 3-second cooldown V ability
- **Controls**:
  - `E` - Toggle movement on/off
  - `R` - Toggle jumping on/off  
  - `V` - Toggle Auto V on/off

#### Luna (Numpad3)
- **Skill Combo**: Automatically presses Z, V, C twice each with 50ms delays
- **Controls**:
  - `E` - Trigger combo (only works when Bunny is disabled)

#### Viessa (Numpad4)
- **Auto-Click**: Clicks mouse after skill activation with 400ms delay
- **Controls**:
  - `4` or `Z` - Trigger auto-click

#### Freyna (Numpad5)
- **Auto C/V**: Automated C (11s) and V (8s) ability rotation
- **Smart Pause**: Manual C or V presses pause automation
- **Controls**:
  - `F3` - Toggle auto C/V on/off
  - `C` or `V` - Pause/resume automation

### 🔧 Utility Modules

#### Tabber (Numpad1)
- Automatically presses Tab every 2 seconds
- Useful for inventory management or UI navigation

#### Quest Abort (Numpad6)
- **Sequence**: ESC → Click(217,436) → Space → F2 hold(2s) → R hold(2s)
- **Controls**: `T` - Execute quest abort sequence

#### Repeat (Numpad7)
- **Sequence**: F2 hold(1.5s) → wait(2s) → R hold(1.5s)
- **Controls**: `T` - Execute repeat sequence

## Master Control System

### Master Toggle (Numpad0)
- **OFF**: Saves current state and disables all functions
- **ON**: Restores previous state and resumes active functions
- Provides complete script control with state preservation

### Character Class Exclusivity
- Only one character class can be active at a time
- Switching characters automatically disables the previous class
- Ensures no conflicts between different character abilities

## Visual Feedback

- **Tooltips**: All actions show status tooltips in the top-right corner
- **Status Display**: Numpad8 shows detailed module information
- **State Indicators**: Clear ON/OFF status for all modules

## Game Detection

The script automatically detects when The First Descendant is running (`M1-Win64-Shipping.exe`) and only functions when the game is active, preventing accidental key presses in other applications.

## Example Usage

1. **Setup**: Press `Numpad5` to enable Freyna module
2. **Activate**: Press `F3` to start auto C/V rotation
3. **Pause**: Press `C` or `V` manually to pause automation
4. **Switch**: Press `Numpad2` to switch to Bunny (auto-disables Freyna)
5. **Movement**: Press `E` to start Bunny movement
6. **Emergency**: Press `Numpad0` to disable everything instantly
7. **Resume**: Press `Numpad0` again to restore exact previous state

## Requirements

- AutoHotkey v2.0 or higher
- The First Descendant game
- Windows operating system

## Notes

- Script only functions when The First Descendant is the active window
- All timers and states are automatically managed
- Safe to use - includes proper cleanup and exit handling
- Modular design allows easy customization

## Support

For issues, suggestions, or contributions, please visit the [GitHub repository](https://github.com/vtstv/TFDHelper).

---

**Disclaimer**: This tool is for personal use and convenience. Please ensure compliance with game terms of service.