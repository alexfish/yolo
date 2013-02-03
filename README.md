yolo
====

yolo is a RubyGem which provides a Ruby interface to Continuous Integration build tools. yolo is currently geared towards the Xcode toolchain and iOS development.  

yolo allows you to run a number of continuous integration tasks and is best implemented with an installation of [Jenkins](http://jenkins-ci.org/). 

Examples of tasks yolo can complete for you are:
* Building Xcode projects
* Running OCUnit & Kiwi unit tests and generating reports
* Running Calabash integration tests and generating reports
* Packaging iOS IPA files and deploying them to external services
* Sending notification emails
* Running tasks on each new git tag or commit

Hat tip to [Luke Redpath](https://github.com/lukeredpath) and his [xcodebuild-rb](https://github.com/lukeredpath/xcodebuild-rb) gem which is the foundation of this project.

## Installing yolo

It is recommended that you have [rvm](https://rvm.io/) installed and do not install yolo on system ruby as you may find a number of permissions issues.

    gem install yolo

## Getting Started

* [Quick Start](https://github.com/alexefish/yolo/wiki/Quick-Start)
* [Configuration](https://github.gcom/alexefish/yolo/wiki/Configuration)

## Release Builds

* [Generating IPAs](https://github.com/alexefish/yolo/wiki/Generating-IPAs)
* [Deployment](https://github.com/alexefish/yolo/wiki/Deployment)

## Running Tests

* [OCUnit & Kiwi](https://github.com/alexefish/yolo/wiki/OCUnit-&-Kiwi)
* [Calabash](https://github.com/alexefish/yolo/wiki/Calabashg)

## License 

    Copyright (C) 2013 by Alex Fish

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
