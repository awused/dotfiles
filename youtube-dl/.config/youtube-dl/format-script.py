#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Script to generate preferred video formats.

# Earlier entries are prioritized over later entriess
qualifiers = [
    # Resolution
    [
        '[height>1440]',
        '[height>1080]',
        '[height>720]',
        '[height>480]',
        '[height>360]',
        '[height>240]',
        '[height=240]',
        '',
    ],
    # FPS
    ['[fps>30]', ''],
    # Codec
    ['[vcodec^=av01]', '[vcodec=vp9]', '']
]


def buildSet(prefix, i):
    if i >= len(qualifiers):
        return [prefix]

    out = []
    for f in qualifiers[i]:
        out.extend(buildSet(prefix + f, i + 1))
    return out


formats = buildSet('', 0)

print('--format \'', end='')
for f in formats:
    print('bestvideo{}+bestaudio/'.format(f), end='')

print('best\'', end='')
