#!/usr/bin/env python
# -*- coding: utf8 -*-
# Text Wrap Gedit Plugin
#
# This file is part of the Text Wrap Plugin for Gedit
# Copyright (C) 2008-2009 Christian Hartmann <christian.hartmann@berlin.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This plugin is intended to ease the setting of Text Wrap (aka Line Wrap,
# Word Wrap) by either a Keyboard Shortcurt (currently sticked to Shift-Ctrl-B),
# a new entry in the View Menu or by an Icon in the Toolbar. The use of either 
# option works as a toggle (de- or activate text wrap). The initial setting for 
# new or new opened files is taken from the setting in the Preferences dialog 
# and remembered per file as long thew file is open. 

# Parts of this plugin are based on the work of Mike Doty <mike@psyguygames.com>
# who wrotes the infamous SplitView plugin. The rest is inspired from the Python
# Plugin Howto document and the Python-GTK documentation.

# CHANGELOG
# =========
# * 2008-10-10:
#   0.1 initial release for private use only
# * 2009-04-26:
#   0.2 changed filenames from textwrap to TextWrap as it conflicts with 
#   /usr/lib/python2.6/textwrap.py when loading the plugin. Unfortunately
#   i have no real clue what actualy is causing this conflict. This might
#   be reasoned by a change in the Gedit Python Plugin Loader, as this has
#   not been happening before upgrading gedit or a prerequisite of it through
#   an upgrade of my Ubuntu to 8.10 or 9.04. Added a couple documentst mainly
#   to ease the burdon of installation for gedit plugin beginners and made it
#   public available on my company website: http://hartmann-it-design.de/gedit




# import basic requisites
import gedit
import gtk

# for the texts in the UI elements we use gettext (do we realy?)
from gettext import gettext as _

# just a constant used in several places herein
plugin_name = "TextWrap"

# a common ui definition for menu and toolbar additions
ui_str = """<ui>
  <menubar name="MenuBar">
    <menu name="ViewMenu" action="View">
      <placeholder name="ViewOps_2">
        <menuitem name="ToggleTextWrap" action="ToggleTextWrap" />
      </placeholder>
    </menu>
  </menubar>
  <toolbar name="ToolBar">
    <separator />
    <toolitem name="ToggleTextWrap" action="ToggleTextWrap" />
  </toolbar>
</ui>
"""




# define the plugin helper class
class ToggleTextWrapHelper:

    def __init__(self, plugin, window):
    
        self._DEBUG = False
        
        if self._DEBUG:
            print "Plugin", plugin_name, "created for", window
        self._window = window
        self._plugin = plugin
        
        # Define default initial state for the plugin
        _initial_toggle_state_default = True
        
        # Get initial state from word wrapping in this view (not available
        # on gedit startup but if plugin is enabled during the gedit session
        # and for what ever reason we do not have an update ui signal on init)
        _active_view = self._window.get_active_view()
        try:
            _current_wrap_mode = _active_view.get_wrap_mode()
            if _current_wrap_mode == gtk.WRAP_NONE:
                self._initial_toggle_state = False
            else:
                self._initial_toggle_state = True
            if self._DEBUG:
                print "Plugin", plugin_name, "from current wrap mode using initial toggle state", self._initial_toggle_state
    	except:
            self._initial_toggle_state = _initial_toggle_state_default
            if self._DEBUG:
            	print "Plugin", plugin_name, "using _default_ initial toggle state", _initial_toggle_state_default
        
        # Add "Toggle Text Wrap" to the View menu and to the Toolbar
        self._insert_ui_items()


    def deactivate(self):
        if self._DEBUG:
            print "Plugin", plugin_name, "stopped for", self._window
        self._remove_ui_items()
        self._window = None
        self._plugin = None


    def _insert_ui_items(self):
        # Get the GtkUIManager
        self._manager = self._window.get_ui_manager()
        # Create a new action group
        self._action_group = gtk.ActionGroup("PluginActions")
        
        ## LEFT IN AS AN EXAMPLE:
        ## Create a toggle action (the classic way) ...
        #self._toggle_linebreak_action = gtk.ToggleAction(name="ToggleTextWrap", label="Text Wrap", tooltip="Toggle Current Text Wrap Setting", stock_id=gtk.STOCK_EXECUTE)
        #self._toggle_linebreak_action = gtk.ToggleAction(name="ToggleTextWrap", label="Text Wrap", tooltip="Toggle Current Text Wrap Setting", file="gtk-execute.png")
        ## connect my callback function to the action ...
        #self._toggle_linebreak_action.connect("activate", self.on_toggle_linebreak)
        ## and add the action with Ctrl+Shift+L as its keyboard shortcut
        #self._action_group.add_action_with_accel(self._toggle_linebreak_action, "<Ctrl><Shift>B")
        ## END OF EXAMPLE CODE
        
        # Create a toggle action (convenience way: see 16.1.2.2. in PyGTK Manual)
        #gtk.STOCK_INSERT_CROSS_REFERENCE
        #gtk.STOCK_INSERT-CROSS-REFERENCE
        #gtk.STOCK_INSERT_FOOTNOTE
        #None
        self._action_group.add_toggle_actions([(
                "ToggleTextWrap", 
                gtk.STOCK_OK, 
                _("Text Wrap"), 
                "<Ctrl><Shift>B", 
                _("Toggle Current Text Wrap Setting"), 
                self.on_toggle_linebreak, self._initial_toggle_state)])
        # Insert the action group
        self._manager.insert_action_group(self._action_group, -1)
        # Add my item to the "Views" menu and to the Toolbar
        self._ui_id = self._manager.add_ui_from_string(ui_str)
        # Debug merged ui
        if self._DEBUG:
        	print self._manager.get_ui()


    def _remove_ui_items(self):
        # Remove the ui
        self._manager.remove_ui(self._ui_id)
        self._ui_id = None
        # Remove action group
        self._manager.remove_action_group(self._action_group)
        self._action_group = None
        # ensure that manager updates
        self._manager.ensure_update()


    def update_ui(self):
        self._action_group.set_sensitive(self._window.get_active_document() != None)
        if self._DEBUG:
            print "Plugin", plugin_name, "called for UI update", self._window
        try:
            # Get initial state from word wrapping in this view (if any)
            _active_view = self._window.get_active_view()
            _current_wrap_mode = _active_view.get_wrap_mode()
            if self._DEBUG:
                print "Plugin", plugin_name, "current wrap mode", _current_wrap_mode
            # Get our action and set state according to current wrap mode
            _current_action = self._action_group.get_action("ToggleTextWrap")
            if _current_wrap_mode == gtk.WRAP_NONE:
                _current_action.set_active(False)
            else:
                _current_action.set_active(True)
    	except:
            return


    def on_toggle_linebreak(self, action):
        if self._DEBUG:
            print "Plugin", plugin_name, "action in", self._window
        _active_view = self._window.get_active_view()
        _current_wrap_mode = _active_view.get_wrap_mode()
        if self._DEBUG:
            print "Plugin", plugin_name, "current wrap mode", _current_wrap_mode
        _current_action = self._action_group.get_action("ToggleTextWrap")
        _is_active = _current_action.get_active()
        if self._DEBUG:
            print "Plugin", plugin_name, "current action state", _is_active
        if _is_active:
            _active_view.set_wrap_mode(gtk.WRAP_WORD)
        else:
            _active_view.set_wrap_mode(gtk.WRAP_NONE)


    def _console(self, vartext):
        if self._DEBUG:
            print "Plugin", plugin_name, vartext




# define the plugin derivate class
class ToggleTextWrapPlugin(gedit.Plugin):

    def __init__(self):
        gedit.Plugin.__init__(self)
        self._instances = {}


    def activate(self, window):
        self._instances[window] = ToggleTextWrapHelper(self, window)


    def deactivate(self, window):
        self._instances[window].deactivate()
        del self._instances[window]


    def update_ui(self, window):
        self._instances[window].update_ui()

