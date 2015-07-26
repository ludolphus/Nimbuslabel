Nimbuslabel module for Appcelerator
===========================================

This module uses the attributed label code as available in Nimbuskit. It supports singletouch and tapandhold events on attributes.


BUILD MODULE
--------------------

1. Run `build.py` which creates your distribution
2. cd to `~/Library/Application Support/Titanium`
3. copy this zip file into the folder of your Titanium SDK

REGISTER YOUR MODULE
---------------------

Register your module with your application by editing `tiapp.xml` and adding your module.
Example:

```
<modules>
	<module>nimbus.label</module>
</modules>
```

When you run your project, the compiler will know automatically compile in your module
dependencies and copy appropriate image assets into the application.

USING YOUR MODULE IN CODE
-------------------------

To use the module in code, all you will need to do is require it.

```
var nimbuslabel = require('nimbus.label');
```

See example app.js for details.
