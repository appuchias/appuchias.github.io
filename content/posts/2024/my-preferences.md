---
title: My preferences
description: My opinions on some aspects. Will be updated.
author: Appuchia
date: 2024-07-21
categories:
  - EN
  - Software
  - Development
  - Opinion
  - Linux
tags:
  - Utility
draft: true
---

This post is a collection of my preferences on some aspects.
It will be updated as I explore more and have some more opinions that I want to share.

Feel free to tell me why you don't agree with me in the comments.

# Dates and times

Dates and times are really well defined in the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) standard.

Dates are represented as `YYYY-MM-DD` and times as `HH:MM:SS`.

For full timestamps, the date and time are separated by a `T` and the timezone is appended at the end.
For example, the current time in ISO 8601 format is `2024-07-10T15:04:06+02:00`.

This avoids the confusion between `MM-DD-YYYY` and `DD-MM-YYYY` formats and also the 12-hour and 24-hour time formats.
Please don't mix the month and day in the date format. Thanks!

# File naming

I like capitalized names and underscores.

I also add the date (in ISO 8601 format) at the beginning of some file names as it sorts the files automatically by date, no matter in how many systems you copy them.
This is specially useful if the program you use to sync your files doesn't update the file's creation or last modified date.

However, dashes are useful as they make the cursor stop when you press `Ctrl` + `→` or `Ctrl` + `←` in most text editors and file browsers.
So, I use dashes to separate the sections of the filenames.

# Timezones

PLEASE use UTC.

It's neutral, doesn't have daylight saving time and you can expect it when you see a timestamp.

Also, why did Windows decide to store the local time in the RTC? Store the UTC time and then see what the user's timezone is and convert it to the local time.
Come on, it isn't that hard.

# Comments

---

Thanks for reading!

Done with 🖤 by Appu.
