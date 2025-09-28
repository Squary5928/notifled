<div align="center" style="text-align: center;">

<h1>notifled</h1>

</div>

Blink your keyboard’s **Scroll Lock LED** in a heartbeat pattern whenever a desktop notification appears.  

Tested on **Linux Mint** (should also work on other Linux distros that use D-Bus and support `/sys/class/leds`).

---

## How it works:

- Listens to `org.freedesktop.Notifications` using `dbus-monitor`.
- On each `Notify` event, triggers a short **heartbeat blink** on the Scroll Lock LED.
- The blink pattern is implemented entirely in **Bash**.

---

## Installation:

- 1 Clone this repository:

   ```bash
   git clone https://github.com/Squary5928/notifled.git
   cd notify-heartbeat
   ```
- 2 Make the script executable:

  ```bash
  cd notifled && chmod +x notifled.sh
  ```
- 3 Run it:

  ```bash
  ./notifled.sh
  ```

Now every new desktop notification will trigger the LED heartbeat

---

## Requirements:

A keyboard with a Scroll Lock LED that is exposed under /sys/class/leds/.

bash (tested with GNU bash).

dbus-monitor (usually included with dbus package).

sudo privileges to write to /sys/class/leds.

---

## Autostart (Optional):

If you want it to run automatically on login:

Linux Mint (Cinnamon / XFCE /  :
Go to Startup Applications → Add → point it to notifled.sh.

Or copy and paste the systemd unit file that I have provided to the systemd service units folder by:

```
cd notifled
cp notifled.service ~/.config/systemd/user
```

And, if you want to activate it for all users (system-wide):

```
sudo cp notifled.service /etc/systemd/system/
```

---



## Contributing

Contributions are welcome!  
- Found a bug? Open an [issue](../../issues).  
- Want to improve the blink pattern or add support for other LEDs? Submit a pull request.  
- Tested it on another distro? Let us know so we can expand the “Tested on” section.  

---

## Final Notes

This is a small, fun project that turns your keyboard’s Scroll Lock LED into a tiny notification heartbeat.  
It started as a Bash experiment on **Linux Mint**, but with your help it can grow to support more setups and distros.  
