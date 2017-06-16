#!/usr/bin/env bash

hexo g && hexo d && git add . && git commit -m 'update blog' && git push coding && git push origin