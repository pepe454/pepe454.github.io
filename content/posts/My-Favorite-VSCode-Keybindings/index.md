+++
date = '2026-06-05T17:03:24-04:00'
draft = false
title = 'My Favorite VS Code Keybindings'
+++

Everyone developer has their secret sauce for making their environment as comfortable and ergonomic as possible. Over time you will figure out which commands just *click* for you and you can map these to easy keyboard shortcuts. Over my 8 years as a developer, here are some of the commands I've built up over the years to make editing text, moving windows, navigating the editor, and running commands a breeze in VS Code. 

#### Vim Keybindings

Yes, I am a vim devotee, through and through. See my other post on [vim keybindings](../A-Love-Letter-To-Vim/index.md). However, aside from the vim keybindings, there is still a massive space for using keyboard shortcuts to save time and reduce mouse usage in vscode. What can I say? I am a simple guy. If there is a command I can use instead of the mouse, I will map that command. Here are some useful keybindings for moving around in VS Code:

#### Switching tabs, running commands, and opening files

- `CTRL+SHIFT+P` - open the command palette
- `CTRL+P`       - open a file using text search
- `CTRL+TAB`     - cycle forwards in tab group 
- `CTRL+SHIFT+TAB` - cycle backwards in tab group 
- `CTRL+SHIFT+T` - open previously closed tab

Boom. That's an instant 10% improvement if you didn't know them before. 

#### Moving Between the terminal and the editor

When you are editing code, running code, then editing again, it's extremely helpful to have a command to move back and forth. Enter terminal and editor focus: 
```json
[
    {
        "key": "ctrl+.",
        "command": "workbench.action.terminal.focus",
        "when": "editorTextFocus"
    },
    {
        "key": "ctrl+.",
        "command": "workbench.action.focusActiveEditorGroup",
        "when": "!editorTextFocus"
    }
]
```

Since there are a lot of other commands using these bindings, you may have to clear out a lot! 


#### Language Commands: Move to definition, display definition, rename variable 

`CTRL+Click` is great and all, but wouldn't it be nice if you could just navigate directly to that definition with a keybinding?

```json
[
    {
        "key": "ctrl+shift+d",
        "command": "editor.action.goToTypeDefinition"
    },
    {
        "key": "ctrl+shift+d",
        "command": "editor.action.revealDefinition"
    }
]
```

*Note* this does display references as well, and if there are multiple references, it will display them for you to navigate using your arrow keys.


Do you ever focus your mouse on a name to show the intellisense hint, only for it to dissapear and all of your dreams to fall apart? No worries. This command will show the intellisense details for the name your cursor is on:

```json
{
    "key": "f3",
    "command": "editor.action.showHover"
}
```

In order to rename a certain variable, you can click through using right-click , ... But you know what's faster? `F2`! Much easier.


#### Moving backwards

When you're switching tabs, moving between editors, jumping around to different parts of the file, ctrl+click or using the above to go to definition, you will probably want to get back to where you were before. It turns out there is also a command for this!

```json
{
    "key": "ctrl+shift+backspace",
    "command": "workbench.action.navigateBack",
    "when": "canNavigateBack"
}
```


#### Toggling Sidebars and Terminal

The first command you should know is `CTRL+~` - This will show and hide the terminal. Sometimes, you want to control the size of the terminal view. Yes, you can use the mouse , and yes that is easy. But I'm lazy? Why use mouse when command do trick? Here's how to resize the terminal using commands only: 

```json
[
    {
        "key": "ctrl+shift+up",
        "command": "workbench.action.terminal.resizePaneUp"
    },
    {
        "key": "ctrl+shift+down",
        "command": "workbench.action.terminal.resizePaneDown"
    }
]
```


However, 2 commands you may not know are toggling the primary and secondary sidebars. When I'm editing code, it's helpful to hide those pesky sidebars, especially when I have split editor mode and I'm editing test files in tandem with the source files. 

Behold:
```json
[
    {
        "key": "ctrl+j",
        "command": "workbench.action.toggleAuxiliaryBar"
    },
    {
        "key": "ctrl+k",
        "command": "workbench.action.toggleSidebarVisibility"
    }
]
```

Hiding sidebars and terminal is great. But you know what the ultimate focus mode is? Zen mode. 

Yep:
```json
{
    "key": "ctrl+z ctrl+z",
    "command": "workbench.action.toggleZenMode",
    "when": "!terminalFocus && !isAuxiliaryWindowFocusedContext && !isSessionsWindow"
}
```



#### Using the Terminal

One day, I decided I would try to do everything with the keyboard. It was quite painful, but I learned that you could do quite a lot without the mouse. One area I realized where I was using the mouse a lot was the terminal. You are constantly scrolling, highlighting text, and moving around with the mouse. Here's one command that is very useful: execute the previous command ran:


```json
{
    "key": "shift+enter",
    "command": "workbench.action.terminal.sendSequence",
    "args": {
        "text": "\u001b\r"
    },
    "when": "terminalFocus"
}
```

In plain english, that command sends the `!!` sequence to the terminal, running the previous command you ran before. This is kind of redundant, but I knew that I'd remember that command easily, since it is used for executing and running code in other places. 



Have you ever wanted to scroll the terminal using commands alone? Yes, I do! said nobody ever. But here they are anyways: 
```json
[
    {
        "key": "ctrl+pagedown",
        "command": "workbench.action.terminal.scrollDown",
        "when": "terminalFocusInAny && terminalHasBeenCreated && !terminalAltBufferActive || terminalFocusInAny && terminalProcessSupported && !terminalAltBufferActive"
    },
    {
        "key": "ctrl+pageup",
        "command": "workbench.action.terminal.scrollUp",
        "when": "terminalFocusInAny && terminalHasBeenCreated && !terminalAltBufferActive || terminalFocusInAny && terminalProcessSupported && !terminalAltBufferActive"
    },
    {
        "key": "ctrl+shift+pagedown",
        "command": "workbench.action.terminal.scrollDownPage",
        "when": "terminalFocusInAny && terminalHasBeenCreated && !terminalAltBufferActive || terminalFocusInAny && terminalProcessSupported && !terminalAltBufferActive"
    },
    {
        "key": "ctrl+shift+pageup",
        "command": "workbench.action.terminal.scrollUpPage",
        "when": "terminalFocusInAny && terminalHasBeenCreated && !terminalAltBufferActive || terminalFocusInAny && terminalProcessSupported && !terminalAltBufferActive"
    }
]
```

The last 2 commands will page up/down, allowing you to scroll vast distances without using the mouse.


## Recap 

I hope these commands were helpful to you - I've picked them up over the years using vs code every day at work. 