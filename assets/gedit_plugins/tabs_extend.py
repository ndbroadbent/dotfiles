# -*- coding: utf-8 -*-
#
# Copyright © 2008, Éverton Ribeiro <nuxlli@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51
# Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

import gtk
import gedit

# Find widget by name
def lookup_widget(base, widget_name):
  widgets = []

  for widget in base.get_children():
    if widget.get_name() == widget_name:
      widgets.append(widget)
    if isinstance(widget, gtk.Container):
      widgets += lookup_widget(widget, widget_name)

  return widgets

# UI Manager XML
ACTIONS_UI = """
<ui>
  <menubar name="MenuBar">
    <menu name="FileMenu" action="File">
      <placeholder name="FileOps_2">
        <menuitem name="UndoClose" action="UndoClose"/>
      </placeholder>
    </menu>
  </menubar>

  <popup name="NotebookPopup" action="NotebookPopupAction">
    <placeholder name="NotebookPupupOps_1">
      <menuitem name="UndoClose" action="UndoClose"/>
      <menuitem name="CloseAll" action="CloseAll"/>
      <menuitem name="CloseOthers" action="CloseOthers"/>
    </placeholder>
  </popup>
</ui>
"""

class TabsExtendWindowHelper:
  handler_ids = []
  tabs_closed = []

  def __init__(self, plugin, window):
    """Activate plugin."""
    self.window   = window
    self.notebook = self.get_notebook()

    self.add_all()
    self.handler_ids.append((self.notebook, self.notebook.connect("tab_added", self.tab_added_handler)))
    self.handler_ids.append((self.notebook, self.notebook.connect("tab_removed", self.tab_removed_handler)))
    self.add_actions()

  def add_actions(self):
    undoclose = (
      'UndoClose', # name
      'gtk-undo', # icon stock id
      'Undo close', # label
      '<Ctrl><Shift>T',# accelerator
      'Open the folder containing the current document', # tooltip
      self.on_undo_close # callback
    )

    closeall = (
      'CloseAll', # name
      'gtk-close', # icon stock id
      'Close all', # label
      '<Ctrl><Shift>W',# accelerator
      'Open the folder containing the current document', # tooltip
      self.on_close_all # callback
    )

    closeothers = (
      'CloseOthers', # name
      'gtk-close', # icon stock id
      'Close others', # label
      '<Ctrl><Shift>O',# accelerator
      'Open the folder containing the current document', # tooltip
      self.on_close_outher # callback
    )

    action_group = gtk.ActionGroup(self.__class__.__name__)
    action_group.add_actions([undoclose, closeall, closeothers])

    ui_manager = self.window.get_ui_manager()
    ui_manager.insert_action_group(action_group, 0)
    ui_id = ui_manager.add_ui_from_string(ACTIONS_UI)

    data = { 'action_group': action_group, 'ui_id': ui_id }
    self.window.set_data(self.__class__.__name__, data)
    self.update_ui()

  def deactivate(self):
    """Deactivate plugin."""
    # disconnect
    for (handler_id, widget) in self.handler_ids:
      widget.disconnect(handler_id)

    data = self.window.get_data(self.__class__.__name__)
    ui_manager = self.window.get_ui_manager()
    ui_manager.remove_ui(data['ui_id'])
    ui_manager.remove_action_group(data['action_group'])
    ui_manager.ensure_update()
    self.window.set_data(self.__class__.__name__, None)

    self.window   = None
    self.notebook = None
    self.handles  = None

  def update_ui(self):
    """Update the sensitivities of actions."""
    pass
    windowdata = self.window.get_data(self.__class__.__name__)
    windowdata['action_group'].get_action('UndoClose').set_sensitive(len(self.tabs_closed) > 0)
    windowdata['action_group'].get_action('CloseAll').set_sensitive(self.notebook.get_n_pages() > 0)
    windowdata['action_group'].get_action('CloseOthers').set_sensitive(self.notebook.get_n_pages() > 1)

  def get_notebook(self):
    return lookup_widget(self.window, 'GeditNotebook')[0]

  def add_all(self):
    for x in range(self.notebook.get_n_pages()):
      tab = self.notebook.get_nth_page(x)
      self.add_middle_click_in_tab(tab)

  def add_middle_click_in_tab(self, tab):
    eventbox   = self.notebook.get_tab_label(tab).get_children()[0]
    handler_id = eventbox.connect("button-press-event", self.middle_click_handler, tab)
    self.handler_ids.append([eventbox, handler_id])

  def middle_click_handler(self, widget, event, tab):
    if event.type == gtk.gdk.BUTTON_PRESS and event.button == 2:
      if self.notebook.get_n_pages():
        self.notebook.prev_page()
      self.window.close_tab(tab)

  def tab_added_handler(self, widget, tab):
    self.add_middle_click_in_tab(tab)

  def tab_removed_handler(self, widget, tab):
    self.save_tab_to_undo(tab)
    self.update_ui()
    for (handler_id, widget) in self.handler_ids:
      if widget == tab:
        widget.disconnect(handler_id)
        self.handler_ids.remove(handler_id)
        break

  def get_current_line(self, document):
    """ Get current line for documento """
    return document.get_iter_at_mark(document.get_insert()).get_line() + 1

  # TODO: Save position tab
  def save_tab_to_undo(self, tab):
    """ Save close tabs """

    document = tab.get_document()
    if document.get_uri() != None:
      self.tabs_closed.append((
        document.get_uri(),
        self.get_current_line(document)
      ))

  def on_undo_close(self, action):
    if len(self.tabs_closed) > 0:
      uri, line = tab = self.tabs_closed[-1:][0]

      if uri == None:
        self.window.create_tab(True)
      else:
        self.window.create_tab_from_uri(uri, None, line, True, True)

      self.tabs_closed.remove(tab)
    self.update_ui()

  def on_close_all(self, action):
    if self.notebook.get_n_pages() > 0:
      self.window.close_all_tabs()
      self.update_ui()

  def on_close_outher(self, action):
    if self.notebook.get_n_pages() > 1:
      dont_close = self.window.get_active_tab()

      tabs = []
      for x in range(self.notebook.get_n_pages()):
        tab = self.notebook.get_nth_page(x)
        if tab != dont_close:
          tabs.append(tab)

      tabs.reverse()
      for tab in tabs:
        self.window.close_tab(tab)

      self.update_ui()

class TabsExtendPlugin(gedit.Plugin):
    def __init__(self):
        gedit.Plugin.__init__(self)
        self._instances = {}

    def activate(self, window):
        self._instances[window] = TabsExtendWindowHelper(self, window)

    def deactivate(self, window):
        self._instances[window].deactivate()
        del self._instances[window]

    def update_ui(self, window):
        self._instances[window].update_ui()
