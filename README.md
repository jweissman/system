# Welcome to SYSTEM

## About

System recurses over the internet using the *filesystem metaphor*.

What is the filesystem metaphor?

System simulates a shared filesystem. Directories and nodes are accessible directly by URLs.

For administrators, it can act as a generalized/arbitrary data-management solution and app-emulation layer.

## The Basics

You control content in your user's "home" directory... but nowhere else.

You can structure this content how you like. For now the only node types that are supported are plaintext.

(It may eventually be useful to support lots of differents types of structured information -- in particular images seem like they could add a lot of value.)

## The Tools

Part of the intuition which System expresses is that people will make positive use of an open structure...

can be largely expressed contextually through hierarchical relationships.

We provide a "virtual mount" tool which permits a *unified view* of the contents of the different folders...

(This is somewhat similar to union mounts in Plan9.)

The 'virtual paths' this enables can be *symbolically* analyzed by the router.

System can therefore handle the arbitrarily deeply-nested paths which reciprocal mounting makes possible.

(E.g., the recursive folder structure which results from reciprocal mounts.)

System supports navigating arbitrarily-deeply-nested (recursive) structures even at the URL level.

## The Dreams

- Visibility levels
- App emulation/theming (possibly hinted by dotfiles?)
- Books/blogs: .book instructs System to present a given folder as a manpage-ish navigable hierarchy of text docs; .blog as a weblog
- News: .stream as a 'flattened' river-of-news...
  (This could fit in with `/usr/xyz/minutes` as a conventional place for status updates to go...
   And `/usr/xyz/friends/minutes` might have a `.stream` dotfile)

## Requirements

System is built with Rails 5 and Ruby 2.3.1...

## Getting Started

`bin/setup` to get installed

`rails spec` to run tests

`rails server` to run local development server

## Credits

we use the following icons from the noun project

- Folder and File by Sergey Minkin from the Noun Project
