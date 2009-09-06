#!/usr/bin/env python

import os
import sys

build_sys_path = "../build_sys/python/"

if os.path.isdir(build_sys_path):
    sys.path.append(build_sys_path)
else:
    print "Cannot find build system directory, exiting..."
    sys.exit(1)

from TargetBuilder import TargetBuilder

def main(argv=None):
    if argv is None:
        argv = sys.argv
    if len(argv) <= 1:
        t = TargetBuilder()
        t.help()
        sys.exit(0)
    try:
        t = TargetBuilder(argv[1])
        t.create_cmake_target()
    except TargetBuilder.UnsupportedBuildTargetError:
        t = TargetBuilder()
        t.help()
        
if __name__ == "__main__":
    sys.exit(main())

