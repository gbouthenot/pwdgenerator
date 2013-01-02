phpcomboloader
==============

About
-----

This is a simple combo loader written in PHP. Its primary usage is to host the [YUI library](http://yuilibrary.com/) using SSL on your site. Despite being simple, it is designed to offer high performance by using a fast cache backend and aggresive cache policies.

Yahoo, does not offer https (ssl) cdn. [Google CDN](https://developers.google.com/speed/libraries/devguide) neither. This situation is not likely to evolve, see: [YUI3 CDN over SSL](http://yuilibrary.com/forum/viewtopic.php?f=18&t=10450)



Existing solutions
------------------

Yahoo provided [phploader](http://developer.yahoo.com/yui/phploader/), but it is no more up to date, and does not work anymore on recent YUI library version. (see this [thread](http://yuilibrary.com/forum/viewtopic.php?f=96&t=9488). Also, on the [github project](https://github.com/yui/phploader) page, former YUI developper Dav Glass says:

>THE METADATA USED IN YUI 3 HAS CHANGED AS OF VERSION 3.4.0, THIS LOADER WILL NOT WORK IN IT'S CURRENT STATE WITH ANY VERSION OVER 3.3.0. IT NEEDS TO BE MODIFIED TO HANDLE THE NEW ALIAS SYSTEM IN ORDER TO FUNCTION PROPERLY.

A [more recent fork](https://github.com/dpobel/phploader) has been made from this source by Damien Pobel. It works (I tested it on YUI version 3.6.0), but since it is based on the original, it is very complicated. You need to grab the metadata from YUI, compile it in php from JSON using Node, and then it *may* be used.

Another option is to go to the [YUI configurator](http://yuilibrary.com/yui/configurator/) and let the site compute dependencies for you project. But:

* it is a pain to manually select the modules we need. If more than one developper works on the project, it is nearly impossible to get all the modules synchronised
* it does not support Gallery modules
* it does not list images used in css
* you have to restart from beginning with each new version on YUI
* it only show you **some** dependencies. Configure it with Firefox, and you are missing dependencies for Internet Explorer !
* once the dependencies are computed, you must manually download and re-assemble the files together to minimize network requests (see [Why is serving YUI3 over HTTPS so hard?](http://blog.andrewbruce.net/why-is-serving-yui3-over-https-so-hard))

The last option is to manually host the complete library, without using a combo loader, or pre-assembled seed. But it generate a huge amount of request and does not caches very well. Every page had to go to nearly a hundred of .js files.



Phpcomboloader to the rescue
----------------------------
_phpcomboloader_ is **dead simple**: it only concatenate files and send them. It does not read metadata (what for ?), it just sends back the files that the browser requests. Actually, the `css` files still need to be real-time modified, so they point to accurate image files. This is handled automatically.

To optimise bandwidth, _phpcomboloader_ **compress** the output (that is, the concatenated files). Already compressed files like images are not compressed again (it would produce *bigger* files). Only `.js` and `.css` files are compressed.

Concatenating files is a pretty simple task. Compressing the output isn't, if _phpcomboloader_ had to recompress again and again the same files, it would eats quite a few CPU cycles. So _phpcomboloader_ **caches** the compressed output, so further requests can be served way faster.

To avoid useless round-robin requests, _phpcomboloader_ **aggressively caches** the ouput on the browser, so the next time the browser ask the same files (the user go to another page, or visit the page again), it will simply uses the cached ones on its cache. Lesser requests, faster reaction time.

Should the browser requests the files again (the user F5/refresh the page), _phpcomboloader_ would still avoid to send the files again, telling the browser to **use the cached ones** instead. (`http 304 Not modified`)



Try it !
--------
You can see it working here : [https://yuidemo.atomas.com/demo/](https://yuidemo.atomas.com/demo/)

**Important:** The demos won't work if you're using Windows XP **and** Internet Explorer. This is a limitation of my host provider, not of phpcomboloader. Windows XP and Firefox will work, as will Windows 7/Vista and Internet Explorer.



Usage
-----
To you your own-served YUI library, just replace the standard YUI base seed by these lines:

    <script type="text/javascript" src="https://YOURDOMAIN/YOURPATH/combo.php?3.7.3/build/yui/yui-min.js"></script>
    <script>
        var YUI_config={combine:true,comboBase:'https://YOURDOMAIN/YOURPATH/combo.php?',gallery:'yui3-gallery'};
    </script>

This example will dynamicly load YUI 3.7.3, using the loader. You can go to the demo and show source code in your browser to have a real life example.

Please do not use the files hosted on the demo-site in your project. I do not have enough bandwidth, and it may run you into legal trouble (your lawyers would probably not appreciate you use external-hosted resources on your SSL certified corporate page). Plus it won't work on Windows XP + Internet Explorer (see previous paragraph).



Requirements
------------
* `apache2` (or other web server)
* `php5` >= 5.2.0
* `php-apc` (the cache engine) (recommended)
* an offline version of `YUI library` : [download](http://yuilibrary.com/download/yui3/)
* an offline version of `YUI galery library` (optional)



Installation
------------

### Configuration
Go into the `ini/` directory. Copy `conf.php.dist` to `conf.php`.
Content of this file:

    // the full URL to combo.php
    define("COMBO_URL", 'https://host/path/combo.php');

    // change "true" to "false" to disable caching
    define("USE_APC", true && function_exists("apc_fetch"));

    // the prefix used for caching objects
    define("APC_PREFIX", "pcl-");

    // the maximum time (in seconds) the cache is allowed to keep data
    define("TTL_APC", 7200);

    // WELCOME_VERBOSE: set the verbosity for the welcome screen.
    // the welcome screen is displaying by going at your COMBO_URL
    //  0: won't display anything
    //  1: only "phpcomboloader"
    //  2: add version information
    //  3: show last version (TODO)
    //  9: recommended level for very general information
    // 10: display some information (COMBO_URL test)
    // 15: display availability of cache (apc)
    // 17: check if yui3-gallery is available
    // 19: recommended level for displaying all the tests without sensible information
    // 20: check if extlib/ exists and is not empty
    // 21: check if yui3-gallery is available
    // 23: check for build/ directory under each served directory
    // 25: display all the served directories in extlib/
    // 29: recommended level for displaying some sensible informations, like served directories in extlib/
    // 99: display all informations, including debugging (may disclose sensible data like full paths of your server)
    //
    // Recommendation : use 29 while installing, and when everything is ok lower it to 9
    define("WELCOME_VERBOSE", 29);

Edit the file. The most important parameter is `COMBO_URL`. It is the real URL where your installation can be reached.


### Directory structure
Download the YUI library and YUI library into the `extlib/` directory:

    extlib/ (here)
        3.8.0/
            build/
                align-plugin
                (...)
                yui
                yui-base
                yui-throttle
        yui3-gallery/
            build/
                gallery-a11ychecker-base
                gallery-a11ychecker-ui
                gallery-accordion
                (...)


### Script to download the libraries
    cd extlib/

    wget http://yui.zenfs.com/releases/yui3/yui_3.8.0.zip
    unzip yui_3.8.0.zip "yui/build/*"
    rm yui_3.8.0.zip
    mv "yui" "3.8.0"

    wget https://github.com/yui/yui3-gallery/archive/master.zip
    unzip master.zip "yui3-gallery-master/build/*"
    rm master.zip
    mv "yui3-gallery-master" "yui3-gallery"


### Test
In your browser, go to the URL you put into `COMBO_URL`. It should display:

    phpcomboloader v1.0.0 project homepage
    COMBO_URL seems ok
    apc is available, and will be used.
    scanning extlib/
    * 3.7.3 seems ok
    * yui3-gallery seems ok
    yui3-gallery found.
    6 test(s) terminated with 0 error(s) and 0 warning(s).



### Finalize
Once everything is working, remember to lower `WELCOME_VERBOSE` in `ini/conf.php`



External resources
------------------
* [Why loading JavaScript over SSL from a third-party CDN is a bad idea](http://www.wonko.com/post/javascript-ssl-cdn)
* [YUI3 CDN over SSL](http://yuilibrary.com/forum/viewtopic.php?f=18&t=10450)
