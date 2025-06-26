#!/usr/bin/env python3

import obsws_python as obs
import subprocess
import time
import os

def is_projector_running():
    # Check if there's already a projector window
    result = subprocess.run(['hs', '-c', '''
        local obsApp = hs.application.find("OBS Studio")
        if obsApp then
            for _, window in pairs(obsApp:allWindows()) do
                if string.find(window:title(), "Projector") then
                    return true
                end
            end
        end
        return false
    '''], capture_output=True, text=True)
    return result.stdout.strip() == 'true'

def setup_obs_projector():
    # Only create new projector if one doesn't exist
    if not is_projector_running():
        # Connect to OBS
        cl = obs.ReqClient(host='localhost', port=4455, password='b2xXbxsCvP506xgB')
        # Open windowed projector for the scene
        cl.open_source_projector(source_name='Ultrawide Crop', monitor_index=-1)
        cl.disconnect()

        # Wait for window to appear
        time.sleep(2)
    else:
        print("Projector window already exists")

    # Move to space 5 using Hammerspoon
    subprocess.run(['hs', '-c', 'dofile("' + os.path.join(os.path.dirname(__file__), 'move_to_space.lua') + '")'])

if __name__ == '__main__':
    setup_obs_projector()
