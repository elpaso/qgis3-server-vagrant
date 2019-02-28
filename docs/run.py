#!/usr/bin/env python3

from docutils import nodes
from docutils.parsers.rst import Directive, directives
import sys, os
import re
import hovercraft
from utils.graphviz_directive import Graphviz

directives.register_directive('graph', Graphviz)

# Need to make sure all graph images files are existing
presentation = sys.argv[1:][0]
# Relpath
rel_path = os.path.abspath(os.path.dirname(presentation))
# Make dir
graphs = []
with open(presentation, 'r') as f:
    for l in f.readlines():
        try:
            img = re.findall(r'.. graph::\s?(.*)$', l)[0]
            img_path = os.path.join(rel_path, img)
            img_dir = os.path.dirname(img_path)
            if not os.path.exists(img_dir):
                os.mkdir(img_dir)
            if not os.path.exists(img_path):
                with open(img_path, 'w+') as f:
                    pass
        except IndexError:
            pass


if __name__ == "__main__":
    cmd = sys.argv[1:]
    hovercraft.main(cmd)