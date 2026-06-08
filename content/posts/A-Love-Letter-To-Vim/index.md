+++
date = '2026-06-05T16:12:16-04:00'
draft = false
title = 'A Love Letter to Vim'
tags = ['Tools', 'Programming']
+++


I love Vim. I seriously do. So much so, in fact, that going back to regular text editing on coworker's machines feels like I am 50% as productive otherwise. What makes Vim so effective? The answer is natural keybindings for the most common tasks while writing text. You can use it for writing any text, whether it be code, config files, markdown files, or any plain text you're working on. When you first start out, it will be awkward. There's no getting around that. However, once you've built up the muscle memory after a couple of days, using Vim will feel like second nature. 

This post is not about learning how to use Vim, but explaining the value behind learning it. Instead, you should run the vimtutor to learn and practice:
```sh
$ vimtutor
```
This will teach you everything you need to know about using Vim and give you practice on using it. Even after using Vim for about 8 years, I still have more things to learn about using Vim.

## Vim is a modal editor

Before you use Vim, know that Vim is a modal text editor. This is a very powerful concept that will be a bit new, since virtually all text editors simply use one mode with commands executed via `CTRL-C`, `CTRL-B`, ...

When you open a new file with vim, for example: 
```sh
$ vim ~/example-file.txt
```
This will begin to edit the `~/example-file.txt` in the *command* mode. This mode allows you to execute commands easily, without having to reach for the `CTRL`, `ALT` keys. Instead of holding said keys down, all you have to is type keys that are sitting on the home row: `h,j,k,l,b,w,gg` for navigation, `d,c` for deleting text, `dd,yy,p,o,O` for working with lines of text, and much more!

_A word of caution_: when using Vim the first time (which I assume, since you're reading this post), you can exit the file using these commands:
```sh
:wq    # write and quit
:w     # write file (do not quit)
:q     # quit
:q!    # quit without saving 
```

To begin editing text, simply press `i` - this will enter the *insert* mode. Here you can edit text, enter text, and use the keyboard as you always have. In order to go back to the command mode, press `ESC` - this will exit insert mode and bring you back into the command mode. You will commonly be moving back and forth between these 2 modes, so some users will remap `ESC` to another key like `CAPSLK`, which is a bit more ergonomic.

## Common Tasks, Natural Movements

The philosophy of Vim is ease of motion and fluidity of movement. If you become very proficient with Vim, you can type and edit text as fast as you can think. When you execute a command, it will be modify the text where your cursor is positioned. Yes, they are case sensitive! Here are some of the most common operations I use on a daily basis: 
- `dd` - delete line and copy to clipboard
- `D`  - delete text from your cursor to the end of the line.
- `yy` - copy line
- `p`  - paste a line that you yanked OR deleted previously 
- `C`  - delete all text on the line after your cursor and enter insert mode.
- `P`  - paste a line *ABOVE* the line you're working on
- `o`  - open a new line below your current line and start editing
- `O`  - open a new line above your current line.
- `u`  - undo last edit
- `r`  - replace single character
- `I`  - begin editing at the start of a line
- `A`  - being editing at the end of a line
- `CTRL-R` - redo last edit, like CTRL-Y.
- `/<search text>` - search for text, followed by `n` to move to the next found text or `N` for previous.
- `<<` - left indent current line
- `>>` - right indent current line

These command are great, but do they really leave to a 2x improvement in editing capability? I would guess not. One of the superpowers in Vim is navigation. This will skyrocket you to the next level when you become comfortable using them. Why? When you are writing text, the natural thing is to scroll along with the mouse, click around, highlight text, and navigate. Notice how much time it takes for you to move your right (or left) hand back and forth between the keyboard and the mouse. This is inefficient! There is a better way. Enter, Vim navigation!

These navigational commands sit right in the home row of the keyboard, leading to extremely ergonomic movements:
- `k`  - move up
- `j`  - move down
- `l`  - move right
- `h`  - move left
- `w`  - move ahead to the start of next word (can be on the next line)
- `b`  - move back to the start of previous word (can be on the previous line.)
- `gg` - navigate to the top of the document
- `G`  - navigate to the bottom of the document
- `CTRL+F` - move _forwards_ one page
- `CTRL+B` - move _backwards_ one page
- `CTRL+D` - move _down_ half page
- `CTRL+B` - move _up_ one page

Sometimes, it be just plain faster to use your mouse to get to a specific line or word, but using these navigational commands should greatly reduce your dependence on using the mouse for navigation.

There you go! Not too bad, right? Well, there is a lot there. You will learn these commands over time, but using a cheatsheet is not very helpful. Instead, you should use vimtutor: 
```sh
$ vimtutor
```

## Vim Setup in VS Code

Fortunately, using Vim in VS Code is very easy. All you have to do is install the Vim extension: 
![](./VSCode-Vim-Extension.png "VSCode Vim Extension")


*Note*: You may have to remap some keys in order to use VS Code and/or Vim bindings. Using the keyboard shortcut editor in VS Code you can easily disable some of the vim bindings. These are the *Vim* bindings I disabled to allow VS Code keybindings:
- `CTRL+p`  - open file by name
- `CTRL+k`  - show/hide sidebar.
- `CTRL+i`  - open LLM prompt 
- `CTRL+w`  - close the window

These are the VS Code bindings I disabled to allow Vim commands to work:
- `CTRL+f`  - bound to find text but I remapped it to `CTRL+SHIFT+F`
- `CTRL+b`  - bound to toggle sidebar visibility, but i remapped it to `CTRL+K` 


Here are some commands I added that made movement in vscode feel naturally like Vim:
```json
[
    {
        "key": "ctrl+shift+h",
        "command": "workbench.action.focusLeftGroup"
    },
    {
        "key": "ctrl+shift+l",
        "command": "workbench.action.focusRightGroup",
        "when": "editorFocus"
    }
]
```

When you have 2 editors open in split view side by side, you can move between them using these keys, similar to h and l for left and right movement.