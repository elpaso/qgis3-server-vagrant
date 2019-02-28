# -*- coding: utf-8 -*-
"""
    Allow graphviz-formatted graphs to be included in rst
    documents inline.

    :copyright: Copyright 2010 by the ItOpen
    :copyright: Copyright 2007-2010 by the Sphinx team
    :license: BSD, see LICENSE for details.
"""


import sys
from docutils import nodes, utils
from docutils.parsers.rst import directives, states
from docutils.parsers.rst.directives.images import Image

import errno

from os import path, makedirs
from subprocess import Popen, PIPE


# Errnos that we need.
EEXIST = getattr(errno, 'EEXIST', 0)
ENOENT = getattr(errno, 'ENOENT', 0)
EPIPE  = getattr(errno, 'EPIPE', 0)


def ensuredir(path):
    """Ensure that a path exists."""
    try:
        makedirs(path)
    except OSError as err:
        # 0 for Jython/Win32
        if err.errno not in [0, EEXIST]:
            raise

class Graphviz(Image):
    """
    Directive to insert arbitrary dot markup.
    """
    has_content = True


    def run(self):
        # Raise an error if the directive does not have contents.
        self.assert_has_content()
        dotcode = '\n'.join(self.content)
        if not dotcode.strip():
            return [self.state_machine.reporter.warning(
                'Ignoring "graphviz" directive without content.',
                line=self.lineno)]
        reference = directives.uri(self.arguments[0])
        self.render_dot(dotcode, reference, self.options)
        return super(Graphviz, self).run()


    def render_dot(self, code, outfn, options):
        """
        Render graphviz code into a PNG or PDF output file.
        """

        ensuredir(path.dirname(outfn))

        format = path.splitext(outfn)[1][1:]

        if format not in ('png', 'svg'):
            raise self.error('Format must be png or svg (instead of: %s)' % format)

        dot_args = ['dot']
        dot_args.extend(['-T' + format, '-o' + outfn])
        if format == 'png':
            dot_args.extend(['-Tcmapx', '-o%s.map' % outfn])

        try:
            p = Popen(dot_args, stdout=PIPE, stdin=PIPE, stderr=PIPE)
        except OSError as err:
            if err.errno != ENOENT:   # No such file or directory
                raise
            return None, None
        try:
            # Graphviz may close standard input when an error occurs,
            # resulting in a broken pipe on communicate()
            stdout, stderr = p.communicate(code.encode('utf8'))
        except OSError as err:
            if err.errno != EPIPE:
                raise
            # in this case, read the standard output and standard error streams
            # directly, to get the error message(s)
            stdout, stderr = p.stdout.read(), p.stderr.read()
            p.wait()
        if p.returncode != 0:
            raise self.error('dot exited with error:\n[stderr]\n%s\n'
                                '[stdout]\n%s' % (stderr, stdout))


