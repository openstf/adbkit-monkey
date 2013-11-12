# adbkit-monkey

**adbkit-monkey** provides a [Node.js][nodejs] interface for working with the Android [`monkey` tool][monkey-site]. Albeit undocumented, they monkey program can be started in TCP mode with the `--port` argument. In this mode, it accepts a [range of commands][monkey-proto] that can be used to interact with the UI in a non-random manner. This mode is also used internally by the [`monkeyrunner` tool][monkeyrunner-site], although the documentation claims no relation to the monkey tool.

## Links

* [Monkey][monkey-site]
    - [Source code][monkey-source]
    - [Protocol][monkey-proto]
* [Monkeyrunner][monkeyrunner-site]

## License

See [LICENSE](LICENSE).

[nodejs]: <http://nodejs.org/>
[monkey-site]: <http://developer.android.com/tools/help/monkey.html>
[monkey-source]: <https://github.com/android/platform_development/blob/master/cmds/monkey/>
[monkey-proto]: <https://github.com/android/platform_development/blob/master/cmds/monkey/README.NETWORK.txt>
[monkeyrunner-site]: <http://developer.android.com/tools/help/monkeyrunner_concepts.html>
