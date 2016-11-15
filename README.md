# Welcome to SYSTEM

## About

At a very high level, System can *act like* a number of tools.
It can behave like a blog, a group messaging tool, a wiki...
But it's a little more than that! :)

## The Filesystem Metaphor

System simulates a shared filesystem.
Directories and nodes are accessible directly by URLs.
These routes are *symbolically* analyzed.
This permits System to provide some very powerful tools
inspired by filesystems like Plan9.

One fun way to think of System (and the code definitely reflects it) is
as a kind of *recursion over the web*.

## The Basics

You control content in your user's "home" directory... but nowhere else.
You can structure this content how you like.
But there are some conventions which may help you get the most out of your System.
You may want to create a folder called `minutes`.
System will then expose a 'current status' input which creates a new status update
in `minutes`.

## The Tools

Part of the intuition which System expresses is
that the sorts of symbolic relationships that are possible within a filesystem
provide an "meta-model" which can express a variety of ontologies contextually.
(*Bring your own ontology!*)

In particular a core tool for building symbolic relationships is the "virtual mount"
tool which permits a *unified view* of the contents of different folders (in different
places in the hierarchy)...

(This is somewhat similar to union mounts in Plan9.)

Virtual mounts "overlay" different places in the hierarchy and coalesce or
superpose them.

(System can therefore handle the arbitrarily deeply-nested paths which
reciprocal mounting makes possible, e.g., the recursive folder structure
which results from reciprocal mounts.)

Note that System explicitly supports navigating these
arbitrarily-deeply-nested (recursive) *at the URL level*.

## The Dream

Let's whisper a little bit of a dream.

We should have powerful collaborative systems for building deep information
systems and ontologies that reflect the complexity of the world.

Federation is part of the vision here (remote mounts between Systems).
This permits the strange idea of a URL "tangling" between a number of different
Systems (this strikes me as a particularly curious and powerful facility.)

## Todo

### Interface

- Setup guide ("It looks like you have a new System...")
- Theming (possibly hinted by dotfiles?)
- Books/blogs: .book instructs System to present a given folder as a
  manpage-ish navigable hierarchy of text docs; .blog as a weblog
- News: .stream as a 'flattened' river-of-news...
  (This could fit in with `/usr/xyz/minutes` as a conventional place
  for status updates to go...  And `/usr/xyz/friends/minutes` might
  have a `.stream` dotfile)

### Infrastructure

- Visibility levels
- Other node types (images)
- Processes (could do long/complicated data things with workers that
             live in `/proc` -- wordcount seems like an interesting one)
- Sockets

## Requirements

System is built with Rails 5 and Ruby 2.3.1...

## Getting Started

`bin/setup` to get installed

`rails spec` to run tests

`rails server` to run local development server

## Credits

we use the following icons from the noun project

- Folder and File by Sergey Minkin from the Noun Project
