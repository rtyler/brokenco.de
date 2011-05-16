--- 
layout: post
title: IronWatin; mind the gap
tags: 
- Mono
- Slide
- Software Development
- Hudson
created: 1255471069
---
Last week <a id="aptureLink_UJbJnwQvgk" href="http://twitter.com/admc">@admc,</a> despite being a big proponent of <a id="aptureLink_mV2RK9dLaN" href="http://twitter.com/windmillproject">Windmill</a>, needed to use WatiN for a change. <a id="aptureLink_sf9oXnu3uF" href="http://watin.sourceforge.net/">WatiN</a> has the distinct capability of being able to work with Internet Explorer's HTTPS support as well as frames, a requirement for the task at hand. As adorable as it was to watch <a id="aptureLink_zccUSsrvlx" href="http://twitter.com/admc">@admc,</a> a child of the dynamic language revolution, struggle with writing in C# with Visual Studio and the daunting "Windows development stack," the prospect of a language shift at Slide towards C# on Windows is almost laughable. Since <a id="aptureLink_oR2hGjfmlx" href="http://www.crunchbase.com/company/slide">Slide</a> is a Python shop, IronPython became the obvious choice.

Out of an hour or so of "extreme programming" which mostly entailed Adam watching as I wrote IronPython in his Windows VM, <a href="http://github.com/rtyler/IronWatin"><strong>IronWatin</strong></a> was born. IronWatin itself is a <strong>very</strong> simple test runner that hooks into Python's <a id="aptureLink_SpWkHjDZgq" href="http://en.wikipedia.org/wiki/PyUnit">"unittest"</a> for creating integration tests with WatiN in a familiar environment. 

I intended IronWatin to be as easy as possible for "native Python" developers, by abstracting out updates to `sys.path` to include the Python standard lib (adds the standard locations for Python 2.5/2.6 on Windows) as well as adding `WatiN.Core.dll` via `clr.AddReference()` so developers can simply `import IronWatin; import WatiN.Core` and they're ready to start writing integration tests. When using IronWatin, you create test classes that subclass from `IronWatin.BrowserTest` which takes care of setting up a browser (WatiN.Core.IE/WatiN.Core.FireFox) instance to a specified URL, this leaves your `runTest()` method to actually execute the core of your test case. 

Another "feature"/design choice with IronWatin, was to implement a `main()` method specifically for running the tests on a per-file basis (similar to `unittest.main()`). This main method allows for passing in an `optparse.OptionParser` instance to add arguments to the script such as "--server" which are passed into your test classes themselves and exposed as "self.server" (for example). Which leaves you with a fairly straight-forward framework with which to start writing tests for the browser itself:

<code lang="python">
#!/usr/bin/env ipy

# The import of IronWatin will add a reference to WatiN.Core.dll
# and update `sys.path` to include C:\Python25\Lib and C:\Python26\Lib
# so you can import from the Python standard library
import IronWatin

import WatiN.Core as Watin
import optparse

class OptionTest(IronWatin.BrowserTest):
    url = 'http://www.github.com'

    def runTest(self):
        # Run some Watin commands
        assert self.testval

if __name__ == '__main__':
    opts = optparse.OptionParser()
    opts.add_option('--testval', dest='testval', help='Specify a value')
    IronWatin.main(options=opts)
</code>

Thanks to IronPython, we can make use of our developers' and QA engineers' Python knowledge to get the up and running with writing integration tests using WatiN rapidly instead of trying to overcome the hump of teaching/training with a new language.

<strong>Deployment Notes:</strong> We're using IronPython 2.6rc1 and building WatiN from trunk in order to take advantage of some recent advances in their Firefox/frame support. We've not tested IronWatin, or WatiN at all for that matter, anywhere other than Windows XP.

