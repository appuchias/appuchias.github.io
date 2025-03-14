---
title: 'Creating my own "OBD-II reader" to access the CAN bus of a car'
description: "Because I wanted to and many interesting things can be done with it."
author: Appuchia
date: 2024-01-20
lastmod: 2024-07-21
categories:
    - EN
    - Hardware
    - Software
    - Products
    - Cars
tags:
    - Learning
    - Utility
    - CAN-OBD
cover:
    image: '/images/2024-01-20_CAN-OBD/kumpan-electric-sNQ4EnbT980-unsplash.jpg'
    caption: "Photo by [Kumpan Electric](https://unsplash.com/@kumpan_electric) on [Unsplash](https://unsplash.com/photos/white-and-blue-charger-adapter-sNQ4EnbT980)"
---

This post will cover my attempt of building a completely open way to read the
OBD2 messages sent through the CAN bus of a car, and communicating with the ECU
(Electronic Control Unit), basically "the brain" of the car.

More will be coming :)

> # Update on 2024-07-10
>
> I've been working in this project since before writing this post, and there's more info to share than I initially thought.
> I think a better way to share this is to write a series of posts, showing my progress and what I've learned so far.
>
> I'll be updating this post with links to the new ones as I write them.
> You can also follow the [`CAN-OBD` tag](/tags/can-obd/) to see all the posts in this series.
>
> There will be a final post with the complete project, but I don't know when that will be ready and can't promise anything.
>
> Stay tuned!

## Posts in this series

> This list will be updated as new posts are published.
>
> Posts marked as [TODO] are not yet published.
> They may change, merge or be split.

1. [Announcement](/posts/2024/01/can-obd/) (this post)
1. [\[TODO\] What's OBD2 and the CAN bus?]()
1. [\[TODO\] OBD2 reading]()
1. [\[TODO\] CAN bus reading and reverse engineering]()
1. [\[TODO\] My car and the hardware I use]()
1. [\[TODO\] The software]()
1. [\[TODO\] Final setup]()

## References

Where I will leave ALL the links I found useful and kept while researching and building this project.

Each post will have its own references, but they'll all be here too.

- [OBD-II PIDs](https://en.wikipedia.org/wiki/OBD-II_PIDs) on Wikipedia
