#MaxHotkeysPerInterval 200
#SingleInstance force
rctrl::send {rctrl down}
rctrl up::send % (a_priorkey = "rcontrol") ? "{rctrl up}{esc}" : "{rctrl up}"
