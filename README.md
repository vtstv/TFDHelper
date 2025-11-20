# TFDHelper

**AHK v2 automation script for The First Descendant**

TFDHelper is a modular automation tool designed to enhance your gameplay experience in The First Descendant. It provides character-specific automation, utility functions, and a master control system with state saving.

## Features

- 🎮 **Character Class Modules** - Mutually exclusive automation for different characters
- ⚡ **Master Control** - Global on/off switch with state saving/restoration
- 🔧 **Utility Modules** - Independent helper functions
- 🏔️ **Ascend Module** - Automated and manual Ascend sequences with auto-repeat functionality
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
| `Numpad2` | **Bunny** | Movement + Auto V + Jumping | `F4` (movement), `R` (jumping), `V` (auto V), `F5` (auto C) |
| `Numpad3` | **Luna** | Triple skill combo | `E` (combo: Z,V,C x2) |
| `Numpad4` | **Viessa** | Auto-click after skill | `4` or `Z` (auto-click) |
| `Numpad5` | **Freyna** | Auto C/V presser | `C`/`V` (pause/resume) |
| `Numpad9` | **Hailey** | Auto Q presser | Automatic (2s intervals) |
| `F6` | **Ascend** | Auto/manual Ascend sequences | `LClick` (auto), `R` (manual), `E` (auto-repeat) |

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
- **Auto C**: 60-second cooldown C ability
- **Controls**:
  - `F4` - Toggle movement on/off
  - `R` - Toggle jumping on/off  
  - `V` - Toggle Auto V on/off
  - `F5` - Toggle Auto C on/off

#### Luna (Numpad3)
- **Skill Combo**: Automatically presses Z, V, C twice each with 50ms delays
- **Controls**:
  - `E` - Trigger combo

#### Viessa (Numpad4)
- **Auto-Click**: Clicks mouse after skill activation with 400ms delay
- **Controls**:
  - `4` or `Z` - Trigger auto-click

#### Freyna (Numpad5)
- **Auto C/V**: Automated C (11s) and V (8s) ability rotation
- **Smart Pause**: Manual C or V presses pause/resume automation
- **Controls**:
  - `F3` - Toggle auto C/V on/off
  - `C` or `V` - Pause/resume automation

#### Hailey (Numpad9)
- **Auto Q**: Automatically presses Q every 2 seconds when enabled
- **Smart Pause**: Manual Q press pauses/resumes automation
- **Controls**:
  - `Q` - Pause/resume automation

#### Ascend (F6)
- **Auto Left-Click Sequence**: Automatically performs R press and jump after left-click with configurable delays
- **Manual R Sequence**: Press R to manually trigger Ascend jump sequence
- **Auto-Repeat Mode**: Automatically repeats the full Ascend sequence every 10 seconds
- **Mutual Exclusion**: Prevents conflicts between auto and manual sequences
- **Controls**:
  - `F6` - Toggle Ascend module on/off
  - `Left Click` - Trigger auto R+Jump sequence (2.5s delay to R, 2s delay to jump)
  - `R` - Manual Ascend (2s delay to jump)
  - `E` - Toggle auto-repeat mode (immediate first execution, then every 10s)

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

### Ascend Usage Examples

1. **Auto Ascend**: Press `F6` to enable Ascend, then left-click to automatically perform R+Jump sequence
2. **Manual Ascend**: Press `F6` to enable Ascend, then press `R` for manual Ascend jump
3. **Auto-Repeat**: Press `F6` to enable Ascend, then press `E` to start auto-repeating Ascend sequences every 10 seconds
4. **Stop Auto-Repeat**: Press `E` again while Ascend is enabled to stop the auto-repeat mode

## Requirements

- AutoHotkey v2.0 or higher
- The First Descendant game
- Windows operating system

## Notes

- Script only functions when The First Descendant is the active window
- All timers and states are automatically managed
- Ascend module includes mutual exclusion between auto and manual sequences
- Safe to use - includes proper cleanup and exit handling
- Modular design allows easy customization

## Support

For issues, suggestions, or contributions, please visit the [GitHub repository](https://github.com/vtstv/TFDHelper).

---

**Disclaimer**: This tool is for personal use and convenience. Please ensure compliance with game terms of service.