#! /usr/bin/env python
# -*- coding: utf-8 -*-
# Script to generate preferred video formats.

# Earlier entries are prioritized over later entriess
vqualifiers = [
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
    ['[vcodec^=av01]', '[vcodec=vp9]', '[vcodec^=vp09]', '']
]

aqualifiers = [
    # Format
    [
        '[acodec=opus]',
        '',
    ]
]


def buildSet(qualifiers, prefix, i):
    if i >= len(qualifiers):
        return [prefix]

    out = []
    for f in qualifiers[i]:
        out.extend(buildSet(qualifiers, prefix + f, i + 1))
    return out


vformats = buildSet(vqualifiers, '', 0)
aformats = buildSet(aqualifiers, '', 0)

print('--format \'', end='')
for vf in vformats:
    for af in aformats:
        print('bestvideo{}+bestaudio{}/'.format(vf, af), end='')

print('best\'', end='')
