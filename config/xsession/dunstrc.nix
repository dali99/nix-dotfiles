{pkgs, config, lib, ...}:
{

home.file.dunst = {
    target = ".config/dunst/dunstrc";

    text = ''
[global]
    monitor = 0
    follow = keyboard
    geometry = "350x5-0+24"
    indicate_hidden = yes
    shrink = yes
    transparency = 20
    notification_height = 0
    separator_height = 2
    padding = 0
    horizontal_padding = 8
    frame_width = 3
    frame_color = "#282828"

    # Define a color for the separator.
    # possible values are:
    #  * auto: dunst tries to find a color fitting to the background;
    #  * foreground: use the same color as the foreground;
    #  * frame: use the same color as the frame;
    #  * anything else will be interpreted as a X color.
    separator_color = frame

    # Sort messages by urgency.
    sort = yes

    idle_threshold = 120
    font = Monospace 11
    line_height = 0
    markup = full

    # The format of the message.  Possible variables are:
    #   %a  appname
    #   %s  summary
    #   %b  body
    #   %i  iconname (including its path)
    #   %I  iconname (without its path)
    #   %p  progress value if set ([  0%] to [100%]) or nothing
    #   %n  progress value if set without any extra characters
    #   %%  Literal %
    # Markup is allowed
    format = "%s\n%b"

    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = true
    show_indicators = yes
    icon_position = left
    max_icon_size = 40
    #icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/:/usr/share/icons/Adwaita/256x256/status/
    sticky_history = yes
    history_length = 20
    dmenu = ${pkgs.dmenu}/bin/dmenu -p dunst:
    browser = ${pkgs.firefox}/bin/firefox -new-tab

    # Always run rule-defined scripts, even if the notification is suppressed
    always_run_script = true

    title = Dunst
    class = Dunst
    startup_notification = false
    force_xinerama = false
[experimental]
    per_monitor_dpi = false

[shortcuts]
    # Needs to change to alt/super
    close = mod1+space
    close_all = mod1+shift+space
    history = mod1+bar
    context = mod1+period

[urgency_low]
    # IMPORTANT: colors have to be defined in quotation marks.
    # Otherwise the "#" and following would be interpreted as a comment.
    background = "#282828"
    foreground = "#928374"
    timeout = 5
    # Icon for notifications with low urgency, uncomment to enable
    #icon = /path/to/icon

[urgency_normal]
    background = "#458588"
    foreground = "#ebdbb2"
    timeout = 5

[urgency_critical]
    background = "#cc2421"
    foreground = "#ebdbb2"
    frame_color = "#fabd2f"
    timeout = 0

# Every section that isn't one of the above is interpreted as a rules to
# override settings for certain messages.
# Messages can be matched by "appname", "summary", "body", "icon", "category",
# "msg_urgency" and you can override the "timeout", "urgency", "foreground",
# "background", "new_icon" and "format".
# Shell-like globbing will get expanded.
#
# SCRIPTING
# You can specify a script that gets run when the rule matches by
# setting the "script" option.
# The script will be called as follows:
#   script appname summary body icon urgency
# where urgency can be "LOW", "NORMAL" or "CRITICAL".
#
# NOTE: if you don't want a notification to be displayed, set the format
# to "".
# NOTE: It might be helpful to run dunst -print in a terminal in order
# to find fitting options for rules.

#[espeak]
#    summary = "*"
#    script = dunst_espeak.sh

#[script-test]
#    summary = "*script*"
#    script = dunst_test.sh

#[ignore]
#    # This notification will not be displayed
#    summary = "foobar"
#    format = ""

#[history-ignore]
#    # This notification will not be saved in history
#    summary = "foobar"
#    history_ignore = yes

#[signed_on]
#    appname = Pidgin
#    summary = "*signed on*"
#    urgency = low
#
#[signed_off]
#    appname = Pidgin
#    summary = *signed off*
#    urgency = low
#
#[says]
#    appname = Pidgin
#    summary = *says*
#    urgency = critical
#
#[twitter]
#    appname = Pidgin
#    summary = *twitter.com*
#    urgency = normal
#
# vim: ft=cfg
    '';
  };
}
