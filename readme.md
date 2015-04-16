## Textadept-ooc
A basic [ooc](http://ooc-lang.org/) lexer for the [textadept](http://foicica.com/textadept/) editor.

### Installation
1. Copy `ooc.lua` to the `~/.textadept/lexers` directory
2. Add the following to your `~/.textadept/init.lua` script:

```lua
-- file associations
textadept.file_types.extensions.ooc = "ooc"
textadept.file_types.extensions.use = "ooc"

-- support for ctrl+/ to comment out lines
textadept.editing.comment_string.ooc = '//' 
```