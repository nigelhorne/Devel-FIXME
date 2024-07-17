# NAME

Devel::FIXME - Semi intelligent, pending issue reminder system.

# SYNOPSIS

        this($code)->isa("broken"); # FIXME this line has a bug

# DESCRIPTION

Usually we're too busy to fix things like circular refs, edge cases and so
forth when we're spewing code into the editor. This is because concentration is
usually too valuable a resource to throw to waste over minor issues. But that
doesn't mean the issues don't exist. So usually we remind ourselves they do:

        ... # FIXME I hope someone finds this comment

and then search through the source tree for occurrences of _FIXME_ every now
and then, say with `grep -ri fixme src/`.

This pretty much works until your code base grows, and you have too many FIXMEs
to prioritise them, or even visually tell them apart.

This package's purpose is to provide reminders to FIXMEs (without the user
explicitly searching), and also controlling when, or which reminders will be
displayed.

# DECLARATION INTERFACE

There are several ways to get your code fixed in the indeterminate future.

The first is a sort-of source filter like compile time fix, which does not
affect shipped code.

        $code; # FIXME broken

That's it. When [Devel::FIXME](https://metacpan.org/pod/Devel%3A%3AFIXME) is loaded, it will emit warnings for such
comments in any file that was already loaded, and subsequently loaded files as
they are required. The most reasonable way to get it to work is to set the
environment variable _PERL5OPT_, so that it contains `-MDevel::FIXME`. When
perl is then started without taint mode on, the module will be loaded
automatically.

The regex for finding FIXMEs in a line of source is returned by the `regex`
class method (thus it is overridable). It's quite crummy, really. It matches an
occurrence of a hash sign (`#`), followed by optional white space and then
`FIXME` or `XXX`. After that any white space is skipped, and whatever comes
next is the fixme message.

Given some subclassing you could whip up a format for FIXME messages with
metadata such as priorities, or whatnot. See the implementation of `readfile`.

The second interface is a compile time, somewhat more explicit way of emitting
messages.

        use Devel::FIXME "broken";

This can be repeated for additional messages as needed. This is useful if you
want your FIXMEs to ruin deployment, so you're forced to get rid of them. Make
sure you run your final tests in a perl tree that doesn't have [Devel::FIXME](https://metacpan.org/pod/Devel%3A%3AFIXME)
in it.

The third, and probably most problematic is a runtime, explicit way of emitting
messages:

        use Devel::FIXME qw/FIXME/;
        $code; FIXME("broken");

This relies on FIXME to have been imported into the current namespace, which is
probably not always the case. Provided you know FIXME is loaded _somewhere_ in
the running perl interpreter, you can use a fully qualified version:

        $code; Devel::FIXME::FIXME("broken");

or if you feel that repeating a word is clunky, do:

        $code; Devel::FIXME->msg("broken");
        # or
        $code; Devel::FIXME::msg("broken");

But do use the first FIXME declaration style. Seriously.

# OUTPUT FILTERING

## Rationale

There are some problems with simply grepping for occurrences of _FIXME_:

- It's messy - you get a bajillion lines, if your source tree is big enough.
- You need context. While grep can provide for it, that isn't necessarily simple
to read.
- You (well _I_ do anyway) forget to do it. And no, cron is not really a
solution.

The solution to the first two problems is to make the reporting smart, so that
it decides which FIXMEs are printed and which aren't.

The solution to the last problem is to have it happen automatically whenever
the source code in question is used, and furthermore, to report context too.

## Principle

The way FIXMEs are filtered is similar to how a firewall filters packets.

Each FIXME statement is considered as it is found, by iterating through some
rules, which ultimately decide whether to print the statement or not.

This may sound a bit overkill, but I think it's useful.

What it means is that you can get reminded of FIXMEs in source files that are
more than a week old, or when your release schedule reaches feature freeze, or
if your program is in the stable tree if your source management repository, or
whatever.

There are many modules that know how to parse SCM meta data, for CVS, Perforce,
SVN, and so forth. [File::Find::Rule](https://metacpan.org/pod/File%3A%3AFind%3A%3ARule) can be used in nasty ways to ask
questions about files (like _was it modified in the last week?_). The
possibilities are quite vast.

## Practice

Currently the FIXMEs are filtered by calling the class method `rules`, and
evaluating the subroutine references that are returned, as methods on the fixme
object.

The subclass [Devel::FIXME::Rules::PerlFile](https://metacpan.org/pod/Devel%3A%3AFIXME%3A%3ARules%3A%3APerlFile) is a convenient way to get rules
from a file.

# DIAGNOSIS

- FIXME's magic sub is no longer first in @INC

    When `require` is called and the @INC hook is entered, it makes sure that it's
    first in the @INC array. If it isn't, some files might be required without
    being filtered. If the global variable `$Devel::FIXME::REPAIR_INC` is set to a
    true value (it's undef by default), then the magic sub will put itself back in
    the beginning of @INC as required.

# BUGS

If I had a nickle for every bug you could find in this module, I would have
`$nickles >= 0`.

Amongst them:

- The regex for finding FIXMEs is stupid.

    It will find FIXME's in a quoted string, or other such edge cases. I don't
    care. Patches welcome.

    `$nickles++`;

# VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
[http://nothingmuch.woobling.org/Devel-FIXME/](http://nothingmuch.woobling.org/Devel-FIXME/), and use `darcs send`
to commit changes.

# AUTHOR

Original Author:
Yuval Kogman, `<nothingmuch@woobling.org>`

Current maintainer:
Nigel Horne, `<njh@bandsman.co.uk>`

# COPYRIGHT & LICENCE

        Copyright (c) 2004 Yuval Kogman. All rights reserved
        This program is free software; you can redistribute
        it and/or modify it under the same terms as Perl itself.

# SEE ALSO

[Devel::Messenger](https://metacpan.org/pod/Devel%3A%3AMessenger), [grep(1)](http://man.he.net/man1/grep)
