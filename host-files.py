#! /usr/bin/python2
# http://louistiao.me/posts/python-simplehttpserver-recipe-serve-specific-directory/

import posixpath
import argparse
import urllib
import os

from SimpleHTTPServer import SimpleHTTPRequestHandler
from BaseHTTPServer import HTTPServer


class RootedHTTPServer(HTTPServer):

    def __init__(self, base_path, *args, **kwargs):
        HTTPServer.__init__(self, *args, **kwargs)
        self.RequestHandlerClass.base_path = base_path


class RootedHTTPRequestHandler(SimpleHTTPRequestHandler):

    def translate_path(self, path):
        path = posixpath.normpath(urllib.unquote(path))
        words = path.split('/')
        words = filter(None, words)
        path = self.base_path
        for word in words:
            drive, word = os.path.splitdrive(word)
            head, word = os.path.split(word)
            if word in (os.curdir, os.pardir):
                continue
            path = os.path.join(path, word)
        return path


def test(HandlerClass=RootedHTTPRequestHandler, ServerClass=RootedHTTPServer):

    host_path='/root/host-files'
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', '-p', default=8000, type=int)
    parser.add_argument('--dir', '-d', default=host_path, type=str)
    args = parser.parse_args()

    if args.dir != host_path:
        if os.path.isdir(host_path + '/pwd'):
            os.unlink(host_path + '/pwd')
        os.symlink(os.getcwd(), host_path + '/pwd')

    server_address = ('', args.port)

    httpd = ServerClass(args.dir, server_address, HandlerClass)

    sa = httpd.socket.getsockname()
    print "Serving HTTP on", sa[0], "port", sa[1], "..."
    httpd.serve_forever()

if __name__ == '__main__':
    test()
