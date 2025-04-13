# 🩹 `patchr.nvim`

A [neovim](https://github.com/neovim/neovim) plugin to apply git patches to
plugins loaded via [lazy.nvim](https://github.com/folke/lazy.nvim)

## State of the plugin

This is my **first plugin** for neovim, so use it with **caution**.
I only tested it with nvim 0.11.0 so far.

Things which did not make it in yet, but I would love to have:

- remote patches via https://
- commit pinning
- something like a patchr.lock to track plugins controlled by `patchr.nvim` even
  after you removed them from patchr's config

## ⚡️ Requirements

- git
- lazy.nvim

## 📦 Installation

> [!caution]
> This plugin will only work with lazy.nvim as plugin manager

> [!tip]
> It's a good idea to run `:checkhealth patchr` to see if everything is
> set up correctly.

```lua
{
  "nhu/patchr.nvim",
  ---@type patchr.config
  opts = {
    plugins = {
        ["generic_plugin.nvim"] = {
            "/path/to/you/git.patch",
            "/path/to/you/other/git.patch",
        },
    },
  },
}
```

## 🚀 Usage

If you do not turn off the `autocmds` in the options, `patchr.nvim` works
basically out of the box. You just have to either update your plugins once via
[lazy.nvim](https://github.com/folke/lazy.nvim), or execute the `:Patchr apply`
command once.

### The `:Patchr` Command

- `:Patchr reset`: will reset the repositories of the specified plugins, if no
  plugin is specified, all plugin repositories are reset
- `:Patchr apply`: will apply configured patches to the specified plugins, if no
  plugin is specified, patches for all plugin will be applied

### Examples

To apply all patches after installation:

```
:Patchr apply
```

Apply patches only for specific plugins:

```
:Patchr apply snacks.nvim mini.nvim
```

To reset all repositories:

```
:Patchr reset
```

Resetting repositories only for specific plugins:

```
:Patchr reset snacks.nvim mini.nvim
```

## ⚙️ Configuration

`patchr.nvim` comes with the following defaults:

```lua
{
    -- enable or disable registering autocmds on setup
    autocmds = true,
    plugins = {},
    ---@class patchr.config.git
    git = {
      ---@class patchr.config.git.reset
      reset = {
        -- whether or not to perform a git reset --hard on plugin repositories
        hard = true,
      },
    },
}
```

## 📡 API

Below are some of the methods you can use in your on scripts/hooks.

| function                                    | description                                                                     |
| ------------------------------------------- | ------------------------------------------------------------------------------- |
| `require("patchr").apply_patches`           | Convinience method for apply configured patches for the specified plugins names |
| `require("patchr.cmd").apply`               | Apply configured patches for the specified plugins                              |
| `require("patchr.cmd").reset`               | Apply configured patches for the specified plugins                              |
| `require("patchr.config").get_plugin_names` | Get names of the specified plugins as table                                     |

### Examples

You have turned of `patchr.nvim's` autocmds, but want to apply a patch whenever a plugin builds:

```lua
{
    "some/plugin.nvim",
    build = function()
        require("patchr.nvim").apply_patches("some/plugin.nvim", true)
    end,
    opts = {},
}
```

## How it works

`patchr.nvim` applies git patches by executing a `git apply <PATCH>` command on
the plugins repository. This is done whenever
[lazy.nvim](https://github.com/folke/lazy.nvim) invokes the `LazyInstall` or
`LazyUpdate` event.

> [!note]
> `patchr.nvim` does not commit the patch or messes in any other way with the
> repository. This also means that the repository will be in a **_dirty_**
> state, once a patch gets applied.

Whenever [lazy.nvim](https://github.com/folke/lazy.nvim) invokes the
`LazyUpdatePre` event, `patchr.nvim` will `git reset --hard` (by default) the
repositories of it's configured plugins.

## Motivation

The motivation behind this plugin is simple: A developer of one of your beloved
plugins, does not want to implement a certain feature for whatever reason and
doesn't accept PRs either - keep in mind, that is their absolute right to do
so. Nothing stops you from writing a patch your self and apply it to the local
version of the plugin.

This happend to me with [`folke's`](https://github.com/folke)
[`snacks.vim's`](https://github.com/folke/snacks.nvim) explorer
implementation.

I tried to yank and paste a file in the same directory, but the explorer has no
strategy for handling this, and responds with a "File alredy exists"
notification.

While scooping through the issues of
[`snacks.vim`](https://github.com/folke/snacks.nvim) I discovered that this
[feature](https://github.com/folke/snacks.nvim/issues/903) it is currently not
planned. At the very least for now.

Maintaining a fork for this feels like overkill to me, since it requires way to
much effort to keep up with upstream. Aside from that, it was a good excuse to
write my first nvim plugin. So keep this in mind when reading through the
sources or using this plugin.

I think it is also a good opportunity to thank
[`folke`](https://github.com/folke) for his **awesome** work. The effort and
time he puts into developing and maintaining a very respectable collection of
vital plugins for the nvim ecosystem and community is in my opinion invaluable!

> [!important]
> So thank you for your service [`folke`](https://github.com/folke)!
