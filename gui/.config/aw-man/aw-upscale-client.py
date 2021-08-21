#! /usr/bin/env python

# aw-upscale-client.py attempts to upscale an image using a remote server.
# This is typically much higher latency than local upscaling, but has the advantage of not
# utilizing the GPU you're reading manga on.
# Installation: copy this script and the other python files and edit these lines.
# Requires grpcio to be installed.

# The address the remote upscaler is listening on.
# Example: r'localhost:9091'
address = r'192.168.122.238:9091'

# The fallback upscaler if the remote upscaler is not available.
# This should probably be the default waifu2x-upscale.py.
# Leave it empty to disable local upscaling.
fallback = r'/storage/src/awused/aw-upscale/waifu2x-upscale.py'

# Keep this very low if you're on a LAN, so that an unavailable server
# doesn't slow your upscaling to a crawl. 100 is the minimum value.
timeout_ms = 100

# -------------------------------------------------------------------------------
# If you are not looking to implement your own upscaler you can stop reading now.
# -------------------------------------------------------------------------------

import grpc
import os
import subprocess
import sys

import upscale_pb2
import upscale_pb2_grpc

if len(address) == 0:
    raise Exception('No valid address')

src = os.getenv('UPSCALE_SOURCE', '')
dst = os.getenv('UPSCALE_DESTINATION', '')
scale = int(os.getenv('UPSCALE_SCALING_FACTOR') or 0)
tx = int(os.getenv('UPSCALE_TARGET_WIDTH') or 0)
ty = int(os.getenv('UPSCALE_TARGET_HEIGHT') or 0)
mx = int(os.getenv('UPSCALE_MIN_WIDTH') or 0)
my = int(os.getenv('UPSCALE_MIN_HEIGHT') or 0)
denoise = bool(os.getenv('UPSCALE_DENOISE'))

if not bool(src) or not bool(dst):
    raise Exception('Source and destination must be present')

if not os.path.isfile(src):
    raise Exception('Source must be a valid file.')

if scale < 0 or tx < 0 or ty < 0 or mx < 0 or my < 0:
    raise Exception('Scale, heights, and widths cannot be negative')

if scale > 0 and (tx > 0 or ty > 0 or mx > 0 or my > 0):
    raise Exception(
        'Cannot specify scaling factor alongside widths or heights.')

with open(src, "rb") as f:
    contents = f.read()

try:
    with grpc.insecure_channel(
            address,
            options=[
                ('grpc.server_handshake_timeout_ms', timeout_ms),
                ('grpc.enable_retries', 0),
                ('grpc.initial_reconnect_backoff_ms', timeout_ms),
                ('grpc.min_reconnect_backoff_ms', timeout_ms),
                ('grpc.max_reconnect_backoff_ms', timeout_ms),
                ('grpc.max_send_message_length', 500 * 1024 * 1024),
                ('grpc.max_receive_message_length', 500 * 1024 * 1024),
            ]) as channel:
        target_res = upscale_pb2.Resolution(width=tx, height=ty)
        minimum_res = upscale_pb2.Resolution(width=mx, height=my)

        resolutions = upscale_pb2.Resolutions(target=target_res,
                                              minimum=minimum_res)

        if scale == 0:
            kwargs = {'resolutions': resolutions}
        else:
            kwargs = {'scale': scale}

        req = upscale_pb2.UpscaleRequest(
            original_ext=os.path.splitext(src)[1],
            original_file=contents,
            **kwargs,
        )

        stub = upscale_pb2_grpc.AwUpscaleStub(channel)
        resp = stub.Upscale(req)

        with open(dst, "wb") as f:
            f.write(resp.upscaled)

        print(f'{resp.res.width}x{resp.res.height}')
except Exception as e:
    with open("/home/desuwa/upout", "a") as f:
        f.write(f"{e}")
    if len(fallback) != 0:
        startupinfo = None
        # Never spawn console windows on Windows
        if os.name == 'nt':
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

        kwargs = {
            'stdout': subprocess.PIPE,
            'stderr': sys.stderr,
            'startupinfo': startupinfo,
            'encoding': 'utf-8',
        }
        cp = subprocess.run([fallback], **kwargs)
        cp.check_returncode()
        print(cp.stdout.strip())
    else:
        raise e
