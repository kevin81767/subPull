# subPull

Just a simple bash script to automate Subdomain enumeration using [subfinder](https://github.com/projectdiscovery/subfinder), [sublist3r](https://github.com/projectdiscovery/subfinder), [assetfinder](https://github.com/tomnomnom/assetfinder) and notify the findings via a [Telegram script](https://github.com/NicolasBernaerts/debian-scripts/tree/master/telegram).
The script is designed to run and generate a file with new subdomains daily. If your run the script multiple time in a day, you will not be able discover new subdomains.

---

## Requirements:

* Telegram App on your phone
* A bash script used to send Telegram messages: https://github.com/NicolasBernaerts/debian-scripts/tree/master/telegram
* subfinder : https://github.com/projectdiscovery/subfinder
* sublist3r: https://github.com/aboul3la/Sublist3r
* assetfinder : https://github.com/tomnomnom/assetfinder


## Features

* When running the script for the first time, the script notify you via telegram all the subdomains found.

    ![subdomains first scan](https://i.ibb.co/dDS3Mvq/DM-1.png)

* When running the script next time. It will notify you new subdomains found(if there are any) by comparing the subdomains found and the subdomains found of the previous day.

    ![new subdomains](https://i.ibb.co/5FhyS4B/DM-2.png)

* You can automate the script daily using cron (e.g: 0 7 * * * /home/user/dir/subPull/subPull.sh)

## Usage

* Repository ![subPull repo](https://i.ibb.co/6snyTY6/subPull.png)

* Create a bot on your Telegram App, retrieve your **user-id** and **api-key** and edit **subPull.sh** on line 15 and 16 with the correct credentials.
```bash
user_telegram="[USER_TELEGRAM_ID]"
key_telegram="[TELEGRAM_KEY]"
```

* Change the targets.txt with the domains whose subdomains you want. These should be in below format:
```
example.com
hackerone.com
yahoo.com
```
* To run the tool, simply:
```
./subPull.sh
```
---
## Bonus

Set a cron job to run the script automatically.

(e.g: Run the script every day at 8A.M)
```
0 8 * * * /home/user/dir/subPull/subPull.sh
```
