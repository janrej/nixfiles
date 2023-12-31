
from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess
import psutil

# @hook.subscribe.startup
# def autostart():
#     script = "/home/jannik/.config/qtile/autostart.sh"
#     subprocess.run([script])

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen on the focused window"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.spawn("/home/jannik/.config/scripts/shutdownnow.sh"), desc="Shutdown"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod], "f1", lazy.spawn("codium"), desc="Launch VSCodium"),
    Key([mod], "f2", lazy.spawn("chromium-browser"), desc="Launch Chromium Browser"),
    # Key([mod], "f3", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f4", lazy.spawn("****"), desc=" **** "),

    # Key([mod], "f5", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f6", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f7", lazy.spawn("****"), desc=" **** "),
    Key([mod], "f8", lazy.spawn("steam"), desc="Launch Steam GUI"),

    # Key([mod], "f9", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f10", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f11", lazy.spawn("****"), desc=" **** "),
    # Key([mod], "f12", lazy.spawn("/home/jannik/vm/scripts/win11.sh"), desc="Start/stop Windows 11 Virtual Machine"),

]

groups = [
        Group("1", label='term', matches=[Match(wm_class=["kitty"])],layout="spiral"),
        Group("2", label='code', matches=[Match(wm_class=["codium"])], layout="monadtall"),
        Group("3", label='web', matches=[Match(wm_class=["chromium"])], layout="max"),
        Group("4", label='vid', matches=[Match(wm_class=["mpv"])], layout="max"),
        # Group("5", label='', matches=[Match(wm_class=[""])]),
        # Group("6", label='', matches=[Match(wm_class=[""])]),
        # Group("7", label='', matches=[Match(wm_class=[""])]),
        Group("8", label='steam', matches=[Match(wm_class=["steam"])], layout="spiral"),
        Group("9", label='game', matches=[Match(wm_class=["DiRT Rally 2.0"])], exclusive=True, layout="max"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Spiral(main_pane="left", clockwise=True),
    layout.MonadTall(align=MonadTall._left),
    #layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [

    Screen(
        wallpaper='/home/jannik/.config/wallpapers/nixosdarkish.png',
        wallpaper_mode='fill',
    ),

    Screen(
        wallpaper='/home/jannik/.config/wallpapers/nixosdarkish.png',
        wallpaper_mode='fill',
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                # widget.Chord(
                #     chords_colors={
                #         "launch": ("#ff0000", "#ffffff"),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                # widget.TextBox("default config", name="default"),
                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Memory(measure_mem='G', format='RAM {Meed:.1f}/{MemTotal:.0f}G'),
                widget.TextBox('|'),
                widget.ThermalSensor(tag_sensor='CPUTIN', format='CPU {temp:.0f}{unit}', threshold=60.0),
                widget.CPUGraph(),
                widget.TextBox('|'),
                widget.Systray(),
                widget.Clock(format="%a %I:%M %p"),
                # widget.QuickExit(),
                
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),

]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wmname = "LG3D"
