mongoose-checkit
================

[![Build Status](https://travis-ci.org/keifukuda/mongoose-checkit.svg?branch=master)](https://travis-ci.org/keifukuda/mongoose-checkit)
[![Dependency Status](https://david-dm.org/keifukuda/mongoose-checkit.svg?theme=shields.io)](https://david-dm.org/keifukuda/mongoose-checkit)
[![devDependency Status](https://david-dm.org/keifukuda/mongoose-checkit/dev-status.svg?theme=shields.io)](https://david-dm.org/keifukuda/mongoose-checkit#info=devDependencies)

A [Checkit](https://github.com/tgriesser/checkit) plugin for [Mongoose](https://github.com/LearnBoost/mongoose)


Installation
------------

`npm install --save mongoose-checkit`


Usage
-----

```javascript
var User, checkit, mongoose, userSchema;

mongoose = require('mongoose');
checkit = require('mongoose-checkit');
mongoose.connect('mongodb://localhost/mongoose-checkit');

userSchema = new mongoose.Schema({
  username: {
    type: String,
    checkit: ['required', 'alphaDash']
  },
  email: {
    type: String,
    checkit: ['required', 'email']
  }
});

userSchema.plugin(checkit);

User = mongoose.model('User', userSchema);
```


Advanced Usage
--------------

```javascript
var Checkit, User, checkit, mongoose, userSchema;

Checkit = require('checkit');
mongoose = require('mongoose');
checkit = require('mongoose-checkit');
mongoose.connect('mongodb://localhost/mongoose-checkit');

Checkit.Validators.unused = function(value, table, column) {
  return Promise.resolve().then(function() {
    var attrs;
    attrs = {};
    attrs[column] = value;
    return api.models[table].findOne(attrs).exec(function(err, document) {
      if (err) {
        throw err;
      }
      if (document) {
        throw new Error("The " + column + " field is already in use.");
      }
    });
  });
};

userSchema = new mongoose.Schema({
  username: {
    type: String,
    unique: true,
    checkit: ['required', 'alphaDash', 'unused:User:username']
  },
  email: {
    type: String,
    unique: true,
    checkit: ['required', 'email', 'unused:User:email']
  }
});

userSchema.plugin(checkit, Checkit);

User = mongoose.model('User', userSchema);
```
