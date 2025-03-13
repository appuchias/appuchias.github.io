---
title: 'Getting the max speed of a way using Overpass API'
description: 'A random small project done the day before an exam'
author: Appuchia
date: 2025-01-20
categories:
    - EN
    - Linux
    - Cars
    - API
    - Development
    - OSM
tags:
    - Overpass
    - Learning
    - Utility
    - Afternoon project
# cover:
#     image: '/images/Max Speed Overpass'
---

# The idea

This video from a really nice channel I follow popped up on my YouTube feed, it was a neat idea, and I thought showing the max speed as well as the current speed would be really useful.

{{< youtube RdmgdWnIlKY >}}

The first thing I needed was to get the current location, but I know it's relatively easy to do once you have a GPS module.

So the next thing I needed was to get the max speed of the road I'm on.
I thought of using OpenStreetMap for this, I searched in the wiki for some API to use, and I found the official OSM API.
It also listed the Overpass API for read-only access to the OSM data, which was what I would use anyways, so I decided to use that.

However, here's how to get info on an OSM way once you have the way ID (this example uses London's M25):

```http
GET https://www.openstreetmap.org/api/0.6/way/27731013
```

# The Overpass API

You can access a really nice web interface here: [Overpass Turbo](https://overpass-turbo.eu/)

However, what you want is the data itself, so you can use the API that returns the data.

I'll use JSON as it's easier to parse.

Here's how to get the details of a road knowing its ID using the Overpass API:

```http
GET https://overpass-api.de/api/interpreter?data=[out:json];way['highway'](27731013);out;
```

It also works using POST requests (which I prefer even though they require a bit more work):

```http
POST https://overpass-api.de/api/interpreter

data=[out:json];way['highway'](27731013);out;
```

However, what I wanted was to get the closest way to some coords (given by the GPS module),
so I needed to use the `way` query with the `around` filter.

Here's how to get the closest road to some coords using the Overpass API:

```http
POST https://overpass-api.de/api/interpreter

data=[out:json];way['highway'](around:radius,lat,lon);out;
```

`radius` is the radius in meters, and `lat` and `lon` are the coordinates.

# What I ended up with

That's really nice, but it returns a lot of data, and I only need the max speed.

I decided to use `jq` to parse the JSON and get the max speed, stored as `maxspeed` in the way tags.

Here's the command I used:

```bash
curl -fsSL -X POST https://overpass-api.de/api/interpreter -d "data=[out:json];way['highway']['maxspeed'](around:10,lat,lon);out;" | jq -r '.elements[0].tags.maxspeed'
```

The query includes `['highway']['maxspeed']` to filter the roads that have a `maxspeed` tag.

I added the `-fsSL` flags to `curl` to make it silent and follow redirects, and the `-r` flag to `jq` to make it return the raw string.

# Conclusion

I think this is a really nice project, and I'll probably do it after my exams.

Also, I created a ZSH function to store this research mid-term until I actually do it:

```zsh
getmaxspeed() {
    export lat=$argv[1]
    export lon=$argv[2]
    export radius=$argv[3]

    if [ -z $lat ] || [ -z $lon ]; then
        echo "Usage: getmaxspeed <lat> <lon> [radius]"
        return 1
    fi

    # Default radius
    if [ -z $radius ]; then
        radius=10
    fi


    curl -fsSL -X POST 'https://overpass-api.de/api/interpreter' \
        -d "data=[out:json][timeout:5];way['highway']['maxspeed'](around:$radius,$lat,$lon);out;" \
    | jq -r ".elements[0].tags.maxspeed"
}
```

---

Thanks for reading!

Done with 🖤 by Appu.
